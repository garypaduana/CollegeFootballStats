package com.garypaduana.collegefootballstats

import groovy.sql.Sql

def sw = new StringWriter()
def sql = Sql.newInstance("jdbc:sqlite:./resources/data.db", "org.sqlite.JDBC")
def xml = new groovy.xml.MarkupBuilder(sw)

xml.Stadiums{
	sql.eachRow("select distinct(name), Stadium_Code, City, State, Capacity, Surface, Year_Opened " +
				"from stadiums order by name"){row ->
		def years = []
		sql.eachRow("select year from stadiums where Stadium_Code = ${row.Stadium_Code}"){yearRow ->
			years.add(yearRow.year)
		}
		xml.Stadium{
			xml."Code"(row.Stadium_Code)
			xml."Name"(row.name)
			xml."City"(row.City)
			xml."State"(row.State)
			xml."Capacity"(row.Capacity)
			xml."Surface"(row.Surface)
			xml."Year_Opened"(row.Year_Opened)
			xml."Years_With_Stats"(years.join(', '))
		}
	}
}

sql.close()

File outFile = new File("./resources/Stadiums.xml")
outFile.write(sw.toString())