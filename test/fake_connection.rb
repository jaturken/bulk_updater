class FakeConnection
  def quote(value)
    value.to_s
  end

  def execute(sql)
    sql
  end
end
