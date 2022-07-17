# Midstory
**************
## rustBelt
Rust Belt Economy code archive (CENSUS)
- Two folders under rustBelt: R and [Stata](./rustBelt/stata/README.md)
- Dataset not included but it's accessible using https://usa.ipums.org/usa/
- Sample and variables
  - available on codebook.rtf
- Data selection
  - Rust Belt includes  Indiana, Illinois, Michigan, New York, Ohio, Wisconsin, Pennsylvania, and West Virginia
  - manufacture includes mining and construction, as well as durable and nondurable manufacture.
- [output.csv](./rustBelt/stata/output.csv) contains seven columns
  - year
  - totalEmp: total national employment
  - rb_totalEmp: total rustBelt employment
  - manu_totalEmp: national employment in manufacture
  - manu_rb_totalEmp: rustBelt employment in manufacture
  - nationalRate: (national employment in manufacture)/(total national employment)
  - rustBeltRate: (rustBelt employment in manufacture)/(national employment in manufacture)
