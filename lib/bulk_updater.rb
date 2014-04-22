require "bulk_updater/version"

# BulkUpdater generates and executes SQL like
# UPDATE apps
#   set name = case
#     when app_id = 1 and is_adult = 1 then 'Adult name 1'
#     when app_id = 2 and is_adult = 1 then 'Adult name 2'
#   end
#  where app_id in (1,2) and is_adult in (1)
#
# Input params:
# model - model which table must be updated
# columns_to_find - array of columns for when condition.
#                   Must be array of symbols
# columns_to_update - array of columns for updating.
#                     Must be array of symbols
# data - array with all required data. Must be array of hashes
#         Must contain all columns_to_find and required columns to update
# Example:
# data = [{app_id: 1, is_adult: 1, name 'Adult name 1'},
#         {app_id: 2, is_adult: 1, name 'Adult name 2'}]
# BulkUpdater.update!(App, [:app_id, :is_adult], [name], data)
# Generated SQL is shown above

class BulkUpdater
  attr_reader :model, :columns_to_find, :columns_to_update, :data
  
  def self.update!(model, columns_to_find, columns_to_update, data)
    new(model, columns_to_find, columns_to_update, data).update!
  end

  private

  def initialize(model, columns_to_find, columns_to_update, data)
    @model = model
    @columns_to_update = columns_to_update
    @columns_to_find = columns_to_find
    @data = data
  end

  def update!
    table = model.table_name
    statement = update_statement
    condition = update_condition
    if statement.present?
      sql= "UPDATE #{table} SET #{statement}  where #{condition}"
      model.connection.execute(sql)
    end
  end

  private

  def update_condition
    columns_to_find.map do |column|
      values = data.map do |data_unit|
        value = data_unit[column]
        quote_value(value)
      end.compact.join(', ')
      "#{column.to_s} IN (#{values})"
    end.join(' AND ')
  end

  def update_statement
    columns_to_update.map do |column|
      case_conditions = data.map do |data_unit|
        case_condition = when_then(column, data_unit)
      end.compact.join(' ')
      if case_conditions.present?
        "#{column.to_s} = case #{case_conditions} else #{column.to_s} end"
      end
    end.compact.join(', ')
  end

  def when_then(column_to_update, data_unit)
    one_record_condition = columns_to_find.map do |column_to_find|
      value = data_unit[column_to_find]
      value = quote_value(value)
      "#{column_to_find.to_s} = #{value}"
    end.compact.join(' and ')
    update_value = data_unit[column_to_update]
    if update_value.present?
      update_value = quote_value(update_value)
      "when #{one_record_condition} then #{update_value}" 
    end
  end

  def quote_value(value)
    if value.is_a?(Integer)
      value.to_s
    else
      ActiveRecord::Base.connection.quote(value)
    end
  end

end

