setwd("C:/Users/561518/data-science-courses/Exploratory Data Analysis/CP2")
library(dplyr)
# Unzip, load and prepare data
unzip("exdata-data-NEI_data.zip")
NEI <- readRDS("summarySCC_PM25.rds")

#Find total emissions (in thousands) per year
grouped <- group_by(NEI,year)
plotdata <- summarise(grouped,sum(Emissions)/1000)

#Plot total emissions by year
png(filename="plot1.png")
plot(plotdata, 
     ylab = "Total PM2.5 Emissions (Thousands)",
     xlab = "Year",
     main = "Total Emissions by Year",
     col = "black",
     pch = 20,
     cex = 1.5
)    
lines(plotdata)
dev.off()