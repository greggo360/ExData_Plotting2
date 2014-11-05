#How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
# Unzip, load and prepare data
unzip("exdata-data-NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
str(SCC)

#Subset NEI to Baltimore City
baltcity <- subset(NEI,NEI$fips=="24510")

#Inspect sectors in SCC dataset and subset NEI data based on those that are motor vehicle  sources
unique(SCC$EI.Sector)
#Assuming motor vehicles in question refer to gas and diesel vehicles, heavy and light, 
# but not equipment, aircraft, locomotives, etc. that are non-road.
mvsectors <- filter(SCC, SCC$EI.Sector == "Mobile - On-Road Gasoline Heavy Duty Vehicles"
                          | SCC$EI.Sector== "Mobile - On-Road Gasoline Light Duty Vehicles"
                          | SCC$EI.Sector=="Mobile - On-Road Diesel Light Duty Vehicles"
                          | SCC$EI.Sector=="Mobile - On-Road Diesel Heavy Duty Vehicles")

mvSCCs <- unique(mvsectors$SCC)
mvNEI <- filter(baltcity, baltcity$SCC %in% mvSCCs)

#Use dplyr package to group by type and year and sum emissions (thousands) within each group
grouped <- group_by(mvNEI,year)
plotdata <- summarise(grouped,sum(Emissions))

#For convenience, rename plotdata second column from "sum(Emissions)" to "Total Emissions"
names(plotdata)[2] <- "totalEmissions"

#Save plot
png(filename="plot5.png")
g <- ggplot(plotdata, aes(year,totalEmissions))
g + geom_point(size=2) + geom_line(size=1) + 
      labs(x="Year", y=expression("Total "*PM[2.5]*" Emissions"), 
           title = "Changes in Emissions from Motor Vehicles, Baltimore City") +
      scale_x_continuous(breaks=seq(1999, 2008, 3))
dev.off()
