
# Across the United States, how have emissions from coal combustion-related sources changed from 1999-2008?
# Unzip, load and prepare data
unzip("exdata-data-NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
str(SCC)

#Inspect sectors in SCC dataset and subset NEI data based on those that have coal combustion
unique(SCC$EI.Sector)
coalcombsectors <- filter(SCC, SCC$EI.Sector == "Fuel Comb - Electric Generation - Coal"
                          | SCC$EI.Sector== "Fuel Comb - Industrial Boilers, ICEs - Coal"
                          | SCC$EI.Sector=="Fuel Comb - Comm/Institutional - Coal")
coalSCCs <- unique(coalcombsectors$SCC)
coalNEI <- filter(NEI, NEI$SCC %in% coalSCCs)

#Use dplyr package to group by type and year and sum emissions (in thousands) within each group
grouped <- group_by(coalNEI,year)
plotdata <- summarise(grouped,sum(Emissions)/1000)

#For convenience, rename plotdata second column from "sum(Emissions).1000" to "Total Emissions"
names(plotdata)[2] <- "totalEmissions"

#Save plot
png(filename="plot4.png")
g <- ggplot(plotdata, aes(year,totalEmissions))
g + geom_point(size=2) + geom_line(size=1) + 
      labs(x="Year", y=expression("Total "*PM[2.5]*" Emissions (Thousands)"), 
           title = "Changes in Emissions from Coal Combustion-Related Sources, United States")
dev.off()
