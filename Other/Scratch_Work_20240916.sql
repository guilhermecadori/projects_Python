-- Write your SQL SELECT statement here:
-- You are given a table 'numbers' with column 'number'
-- Return a table with column 'number' and your result in a column named 'is_even'

SELECT 
    number
  , CASE
      WHEN ABS(number) % 2 = 1 THEN 'Odd'
      ELSE 'Even'
    END AS is_even
FROM numbers


-- Tests below

/*


describe :numbers do
  it "sample tests" do
    numbers = DB[:numbers]
    numbers.delete()
    numbers.multi_insert([
      {:number => -100}, 
      {:number =>  -21}, 
      {:number =>   -2}, 
      {:number =>   -1}, 
      {:number =>    0}, 
      {:number =>    1}, 
      {:number =>    2}, 
      {:number =>   21}, 
      {:number =>  100}])
    
    result = run_sql
    actual_columns = result.columns
    expect(actual_columns).to eq([:number, :is_even]), "Columns in the returned dataset are not as expected"
    
    rows = result.to_a.sort_by { |row| row[:number] }
  
    expected = [{:number => -100, :is_even => "Even"},
                {:number =>  -21, :is_even => "Odd" },
                {:number =>   -2, :is_even => "Even"},
                {:number =>   -1, :is_even => "Odd" },
                {:number =>    0, :is_even => "Even"},
                {:number =>    1, :is_even => "Odd" },
                {:number =>    2, :is_even => "Even"},
                {:number =>   21, :is_even => "Odd" },
                {:number =>  100, :is_even => "Even"}]
    expect(rows).to eq(expected)
  end
end


*/
