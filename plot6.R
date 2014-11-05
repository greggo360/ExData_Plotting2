
# Unzip, load and prepare data
unzip("exdata-data-NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#Inspect sectors in SCC dataset and subset NEI data based on those that are motor vehicle  sources
unique(SCC$EI.Sector)
#Assuming motor vehicles in question refer to gas and diesel vehicles, heavy and light, 
# but not equipment, aircraft, locomotives, etc. that are non-road.
mvsectors <- filter(SCC, SCC$EI.Sector == "Mobile - On-Road Gasoline Heavy Duty Vehicles"
                    | SCC$EI.Sector== "Mobile - On-Road Gasoline Light Duty Vehicles"
                    | SCC$EI.Sector=="Mobile - On-Road Diesel Light Duty Vehicles"
                    | SCC$EI.Sector=="Mobile - On-Road Diesel Heavy Duty Vehicles")                           )
mvSCCs <- unique(mvsectors$SCC)

#Filter NEI data for SCCs in Baltimore City (24510) and LA County (06037)
mvNEI <- filter(NEI, NEI$SCC %in% mvSCCs, fips=="24510" | fips == "06037")


#Use dplyr package to group by fips and year and sum emissions within each group
grouped <- group_by(mvNEI,fips,year)
plotdata <- summarise(grouped,sum(Emissions))

#For convenience, rename data headers
names(plotdata)[3] <- "totalEmissions"

#Label fips with names of counties
plotdata$fips <- as.factor(plotdata$fips)
levels(plotdata$fips)[levels(plotdata$fips)=="06037"] <- "L.A. County"
levels(plotdata$fips)[levels(plotdata$fips)=="24510"] <- "Baltimore City"


#Plot
png(filename="plot6.png")
g <- ggplot(plotdata, aes(year,totalEmissions, colour=fips))
g + geom_point(size=2) + geom_line(size=1) + 
      labs(x="Year", 
           y=expression("Total "*PM[2.5]*" Emissions"), 
           title = "Comparison of Changes in Emissions from Motor Vehicles"
           ) +
      theme(legend.position = c(0.5, 0.5)) +
      scale_colour_discrete(name = "U.S. County")
dev.off()
