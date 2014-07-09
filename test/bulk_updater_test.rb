require "minitest/autorun"
require 'bulk_updater'
require 'fake_connection'

class BulkUpdaterTest < Minitest::Test
  def setup
    @model = Minitest::Mock.new
    @model.expect(:table_name, 'users')
    connection = Minitest::Mock.new
    connection.expect(:quote, 1, [Object])
    connection.expect(:execute, 2)
    @model.expect(:connection, connection)
  end

  def test_bulk_updater_has_update_method
    assert_equal Method, BulkUpdater.method(:update!).class
  end

end
