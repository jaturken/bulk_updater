require "bulk_updater/version"

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
      sql= "UPDATE #{table} SET #{statement} WHERE #{condition}"
      model.connection.execute(sql)
    end
  end

  private

  def update_condition
    columns_to_find.map do |column|
      values = data.map do |data_unit|
        value = data_unit[column]
        quote_value(value)
      end.compact.uniq.join(', ')
      "#{column.to_s} IN (#{values})"
    end.join(' AND ')
  end

  def update_statement
    columns_to_update.map do |column|
      case_conditions = data.map do |data_unit|
        case_condition = when_then(column, data_unit)
      end.compact.join(' ')
      if case_conditions.present?
        "#{column.to_s} = CASE #{case_conditions} ELSE #{column.to_s} end"
      end
    end.compact.join(', ')
  end

  def when_then(column_to_update, data_unit)
    one_record_condition = columns_to_find.map do |column_to_find|
      value = data_unit[column_to_find]
      value = quote_value(value)
      "#{column_to_find.to_s} = #{value}"
    end.compact.join(' AND ')
    update_value = data_unit[column_to_update]
    if update_value.present?
      update_value = quote_value(update_value)
      "WHEN #{one_record_condition} THEN #{update_value}" 
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

