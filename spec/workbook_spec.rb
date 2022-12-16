require 'spec_helper'

require 'date'
require 'stringio'

VARIOUS_SAMPLES_PATH = TestDataFile.expand_path("various_samples.xlsx")
DATES_1904_WINDOW_XLS_PATH = TestDataFile.expand_path("1904_window_dates.xls")

describe POI::Workbook do
  it "should open a workbook and allow access to its worksheets" do
    book = POI::Workbook.open(VARIOUS_SAMPLES_PATH)
    book.worksheets.size.should == 6
    book.filename.should == VARIOUS_SAMPLES_PATH
  end

  it "should be able to create a Workbook from an IO object" do
    content = StringIO.new(open(VARIOUS_SAMPLES_PATH, 'rb'){|f| f.read})
    book = POI::Workbook.open(content)
    book.worksheets.size.should == 6
    book.filename.should =~ /spreadsheet.xlsx$/
  end

  it "should be able to create a Workbook from a Java input stream" do
    content = java.io.FileInputStream.new(VARIOUS_SAMPLES_PATH)
    book = POI::Workbook.open(content)
    book.worksheets.size.should == 6
    book.filename.should =~ /spreadsheet.xlsx$/
  end

  it "should create an HSSFWorkbook when passed a :format => :hssf option" do
    book = POI::Workbook.create('test.xls', :format => :hssf)
    book.poi_workbook.should be_kind_of(org.apache.poi.hssf.usermodel.HSSFWorkbook)
  end

  it "should create an XSSFWorkbook when passed a :format => :xssf option" do
    book = POI::Workbook.create('test.xlsx', :format => :xssf)
    book.poi_workbook.should be_kind_of(org.apache.poi.xssf.usermodel.XSSFWorkbook)
  end

  it "should create an XSSFWorkbook by default" do
    book = POI::Workbook.create('test.xlsx')
    book.poi_workbook.should be_kind_of(org.apache.poi.xssf.usermodel.XSSFWorkbook)
  end

  it "should return a column of cells by reference" do
    book = POI::Workbook.open(VARIOUS_SAMPLES_PATH)

    book["numbers!$A"].should == book['numbers'].rows.collect{|e| e[0].value}
    book["numbers!A"].should == book['numbers'].rows.collect{|e| e[0].value}
    book["numbers!C"].should == book['numbers'].rows.collect{|e| e[2].value}
    book["numbers!$D:$D"].should == book['numbers'].rows.collect{|e| e[3].value}
    book["numbers!$c:$D"].should == {"C" => book['numbers'].rows.collect{|e| e[2].value}, "D" => book['numbers'].rows.collect{|e| e[3].value}}
  end

  it "should return cells by reference" do
    book = POI::Workbook.open(VARIOUS_SAMPLES_PATH)
    book.cell("numbers!A1").value.should == 'NUM'
    book.cell("numbers!A2").to_s.should == '1.0'
    book.cell("numbers!A3").to_s.should == '2.0'
    book.cell("numbers!A4").to_s.should == '3.0'

    book.cell("numbers!A10").to_s.should == '9.0'
    book.cell("numbers!B10").to_s.should == '81.0'
    book.cell("numbers!C10").to_s.should == '729.0'
    book.cell("numbers!D10").to_s.should == '3.0'

    book.cell(%Q{'text & pic'!A10}).value.should == 'This is an Excel XLSX workbook.'
    book.cell(%Q{'bools & errors'!B3}).value.should == true
    book.cell(%Q{'high refs'!AM619}).value.should == 'This is some text'
    book.cell(%Q{'high refs'!AO624}).value.should == 24.0
    book.cell(%Q{'high refs'!AP631}).value.should == 13.0
  end

  it "should handle named cell ranges" do
    book = POI::Workbook.open(VARIOUS_SAMPLES_PATH)

    book.named_ranges.length.should == 3
    book.named_ranges.collect{|e| e.name}.should == %w{four_times_six NAMES nums}
    book.named_ranges.collect{|e| e.sheet.name}.should == ['high refs', 'bools & errors', 'high refs']
    book.named_ranges.collect{|e| e.formula}.should == ["'high refs'!$AO$624", "'bools & errors'!$D$2:$D$11", "'high refs'!$AP$619:$AP$631"]
    book['four_times_six'].should == 24.0
    book['nums'].should == (1..13).collect{|e| e * 1.0}

    # NAMES is a range of empty cells
    book['NAMES'].should == [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
    book.cell('NAMES').each do | cell |
      cell.value.should be_nil
      cell.poi_cell.should_not be_nil
      cell.to_s.should be_empty
    end
  end

  it "should return an array of cell values by reference" do
    book = POI::Workbook.open(VARIOUS_SAMPLES_PATH)
    book['dates!A2:A16'].map(&:to_date).should == (Date.parse('2010-02-28')..Date.parse('2010-03-14')).to_a
  end

  it "should return cell values by reference" do
    book = POI::Workbook.open(VARIOUS_SAMPLES_PATH)

    book[%Q{'text & pic'!A10}].should == 'This is an Excel XLSX workbook.'
    book[%Q{'bools & errors'!B3}].should == true
    book[%Q{'high refs'!AM619}].should == 'This is some text'
    book[%Q{'high refs'!AO624}].should == 24.0
    book[%Q{'high refs'!AP631}].should == 13.0
  end
end

describe POI::Worksheets do
  let(:book) { POI::Workbook.open(VARIOUS_SAMPLES_PATH) }

  it "should allow indexing worksheets by ordinal" do
    book.worksheets[0].name.should == "text & pic"
    book.worksheets[1].name.should == "numbers"
    book.worksheets[2].name.should == "dates"
    book.worksheets[3].name.should == "bools & errors"
  end

  it "should allow indexing worksheets by name" do
    book.worksheets["text & pic"].name.should == "text & pic"
    book.worksheets["numbers"].name.should == "numbers"
    book.worksheets["dates"].name.should == "dates"
  end

  it "should be enumerable" do
    book.worksheets.should be_kind_of Enumerable

    book.worksheets.each do |sheet|
      sheet.should be_kind_of POI::Worksheet
    end

    book.worksheets.count.should == 6
    book.worksheets.collect.count.should == 6
  end

  it "returns cells when passing a cell reference" do
    book['dates']['A2'].class.should == DateTime
    book['dates']['A2'].to_date.should == Date.parse('2010-02-28')
    book['dates']['a2'].to_date.should == Date.parse('2010-02-28')
    book['dates']['B2'].to_date.should == Date.parse('2010-03-14')
    book['dates']['b2'].to_date.should == Date.parse('2010-03-14')
    book['dates']['C2'].to_date.should == Date.parse('2010-03-28')
    book['dates']['c2'].to_date.should == Date.parse('2010-03-28')
  end
end

describe POI::Rows do
  it "should be enumerable" do
    book = POI::Workbook.open(VARIOUS_SAMPLES_PATH)
    sheet = book.worksheets["text & pic"]
    sheet.rows.should be_kind_of Enumerable

    sheet.rows.each do |row|
      row.should be_kind_of POI::Row
    end

    sheet.rows.count.should == 7
    sheet.rows.collect.count.should == 7
  end
end

describe POI::Cells do
  let(:book) { POI::Workbook.open(VARIOUS_SAMPLES_PATH) }

  it "should be enumerable" do
    sheet = book.worksheets["text & pic"]
    rows = sheet.rows
    cells = rows[0].cells

    cells.should be_kind_of Enumerable
    cells.count.should == 1
    cells.collect.count.should == 1
  end
end

describe POI::Cell do
  let(:book) { POI::Workbook.open(VARIOUS_SAMPLES_PATH) }

  context "1900 windowed dates" do
    it "should provide dates for date cells" do
      sheet = book.worksheets["dates"]
      rows = sheet.rows

      dates_by_column = [
        (DateTime.parse('2010-02-28')..DateTime.parse('2010-03-14')),
        (DateTime.parse('2010-03-14')..DateTime.parse('2010-03-28')),
        (DateTime.parse('2010-03-28')..DateTime.parse('2010-04-11'))
      ]
      (0..2).each do |col|
        dates_by_column[col].each_with_index do |date, index|
          row = index + 1
          c = sheet.rows[row].cells[col]
          c.value.to_date.should == date.to_date
        end
      end
    end
  end

  context "1904 windowed dates" do
    let(:book) { POI::Workbook.open(DATES_1904_WINDOW_XLS_PATH) }
    it "returns entered dates correctly" do
      c = book.worksheets[0].rows[1].cells[0]
      c.value.to_date.should == Date.parse("2012-01-01")
    end

    it "returns dates computed by a formula correctly" do
      c = book.worksheets[0].rows[1].cells[3]
      c.value.to_date.should == Date.parse("2012-01-02")
    end
  end

  it "should provide numbers for numeric cells" do
    sheet = book.worksheets["numbers"]
    rows = sheet.rows

    (1..15).each do |number|
      row = number
      rows[row][0].value.should equal_at_cell(number,            row, 0)
      rows[row][1].value.should equal_at_cell(number ** 2,       row, 1)
      rows[row][2].value.should equal_at_cell(number ** 3,       row, 2)
      rows[row][3].value.should equal_at_cell(Math.sqrt(number), row, 3)
    end

    rows[9][0].to_s.should == '9.0'
    rows[9][1].to_s.should == '81.0'
    rows[9][2].to_s.should == '729.0'
    rows[9][3].to_s.should == '3.0'
  end

  it "should handle array access from the workbook down to cells" do
    book[1][9][0].to_s.should == '9.0'
    book[1][9][1].to_s.should == '81.0'
    book[1][9][2].to_s.should == '729.0'
    book[1][9][3].to_s.should == '3.0'

    book["numbers"][9][0].to_s.should == '9.0'
    book["numbers"][9][1].to_s.should == '81.0'
    book["numbers"][9][2].to_s.should == '729.0'
    book["numbers"][9][3].to_s.should == '3.0'
  end

  it "should provide error text for error cells" do
    sheet = book.worksheets["bools & errors"]
    rows = sheet.rows

    rows[6][0].value.should == 0.0 #'~CIRCULAR~REF~'
    rows[6][0].error_value.should be_nil

    rows[7][0].value.should be_nil
    rows[7][0].error_value.should == '#DIV/0!'

    rows[8][0].value.should be_nil
    rows[8][0].error_value.should == '#N/A'

    rows[9][0].value.should be_nil
    rows[9][0].error_value.should == '#NAME?'

    rows[10][0].value.should be_nil
    rows[10][0].error_value.should == '#NULL!'

    rows[11][0].value.should be_nil
    rows[11][0].error_value.should == '#NUM!'

    rows[12][0].value.should be_nil
    rows[12][0].error_value.should == '#REF!'

    rows[13][0].value.should be_nil
    rows[13][0].error_value.should == '#VALUE!'

    lambda{ rows[14][0].value }.should_not raise_error

    rows[6][0].to_s.should == '0.0' #'~CIRCULAR~REF~'
    rows[7][0].to_s.should == '' #'#DIV/0!'
    rows[8][0].to_s.should == '' #'#N/A'
    rows[9][0].to_s.should == '' #'#NAME?'
    rows[10][0].to_s.should == '' #'#NULL!'
    rows[11][0].to_s.should == '' #'#NUM!'
    rows[12][0].to_s.should == '' #'#REF!'
    rows[13][0].to_s.should == '' #'#VALUE!'
    rows[14][0].to_s.should == ''
  end

  it "should provide booleans for boolean cells" do
    sheet = book.worksheets["bools & errors"]
    rows = sheet.rows
    rows[1][0].value.should == false
    rows[1][0].to_s.should == 'false'

    rows[1][1].value.should == false
    rows[1][1].to_s.should == 'false'

    rows[2][0].value.should == true
    rows[2][0].to_s.should == 'true'

    rows[2][1].value.should == true
    rows[2][1].to_s.should == 'true'
  end

  it "should provide the cell value as a string" do
    sheet = book.worksheets["text & pic"]
    rows = sheet.rows

    rows[0][0].value.should == "This"
    rows[1][0].value.should == "is"
    rows[2][0].value.should == "an"
    rows[3][0].value.should == "Excel"
    rows[4][0].value.should == "XLSX"
    rows[5][0].value.should == "workbook"
    rows[9][0].value.should == 'This is an Excel XLSX workbook.'


    rows[0][0].to_s.should == "This"
    rows[1][0].to_s.should == "is"
    rows[2][0].to_s.should == "an"
    rows[3][0].to_s.should == "Excel"
    rows[4][0].to_s.should == "XLSX"
    rows[5][0].to_s.should == "workbook"
    rows[9][0].to_s.should == 'This is an Excel XLSX workbook.'
  end

  it "should provide formulas instead of string-ified values" do
    sheet = book.worksheets["numbers"]
    rows = sheet.rows

    (1..15).each do |number|
      row = number
      rows[row][0].to_s(false).should == "#{number}.0"
      rows[row][1].to_s(false).should == "A#{row + 1}*A#{row + 1}"
      rows[row][2].to_s(false).should == "B#{row + 1}*A#{row + 1}"
      rows[row][3].to_s(false).should == "SQRT(A#{row + 1})"
    end

    sheet = book.worksheets["bools & errors"]
    rows = sheet.rows
    rows[1][0].to_s(false).should == '1=2'
    rows[1][1].to_s(false).should == 'FALSE'
    rows[2][0].to_s(false).should == '1=1'
    rows[2][1].to_s(false).should == 'TRUE'
    rows[14][0].to_s(false).should == 'foobar(1)'

    sheet = book.worksheets["text & pic"]
    sheet.rows[9][0].to_s(false).should == 'CONCATENATE(A1," ", A2," ", A3," ", A4," ", A5," ", A6,".")'
  end

  it "should handle getting values out of 'non-existent' cells" do
    sheet = book.worksheets["bools & errors"]
    sheet.rows[14][2].value.should be_nil
  end

  it "should notify the workbook that I have been updated" do
    book['dates!A10'].to_date.should == Date.parse('2010-03-08')
    book['dates!A16'].to_date.should == Date.parse('2010-03-14')
    book['dates!B2'].to_date.should == Date.parse('2010-03-14')

    cell = book.cell('dates!B2')
    cell.formula.should == 'A16'

    cell.formula = 'A10 + 1'
    book.cell('dates!B2').poi_cell.should === cell.poi_cell
    book.cell('dates!B2').formula.should == 'A10 + 1'.gsub(' ', '') # rm whitespace

    book['dates!B2'].to_date.should == Date.parse('2010-03-09')
  end

  it "should work with IFERROR" do
    book['newfeatures!F6'].should == 'NOT FOUND'
  end
end
