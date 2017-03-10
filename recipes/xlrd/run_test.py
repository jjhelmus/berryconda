import xlrd

wb = xlrd.open_workbook("test.xlsx")
sheet = wb.sheet_by_name("Sheet1")
cell = sheet.cell(0, 0)
print(cell.value)
assert(cell.value == "Hello, World!")
