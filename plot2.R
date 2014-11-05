library(dplyr)
# Unzip, load and prepare data
unzip("exdata-data-NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")
baltcity <- subset(NEI,NEI$fips=="24510")

#Total emissions in thousands by year for Baltimore City
grouped <- group_by(baltcity,year)
plotdata <- summarise(grouped,sum(Emissions)/1000)

#Plot 
png(filename="plot2.png")
plot(plotdata, 
     ylab = "Total PM2.5 Emissions (Thousands)",
     xlab = "Year",
     main = "Baltimore City: Total Emissions by Year",
     col = "black",
     pch = 20,
     cex = 1.5
)    
lines(plotdata)
dev.off()