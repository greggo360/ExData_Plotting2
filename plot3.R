library(ggplot2)
require(dplyr)

# Unzip, load and prepare data
unzip("exdata-data-NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
baltcity <- subset(NEI,NEI$fips=="24510")

#Use dplyr package to group by type and year and sum emissions within each group
grouped <- group_by(baltcity,type,year)
plotdata <- summarise(grouped,sum(Emissions))

#For convenience, rename plotdata third column from "sum(Emissions)" to "Total Emissions"
names(plotdata)[3] <- "totalEmissions"

#Plot
png(filename="plot3.png")
g <- ggplot(plotdata, aes(year,totalEmissions, colour=type))
g + geom_point(size=2.75) + geom_line(size=1.25) + 
      labs(x="Year", y=expression("Total "*PM[2.5]*" Emissions"), 
           title = "Changes in Baltimore City Emissions by Type")
dev.off()