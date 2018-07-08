## Script to read the NEI pollution data and produce a plot to answer question 
## 1, namely:
##
## Have total emissions from PM2.5 decreased in the United States from 1999 to 
## 2008? Using the base plotting system, make a plot showing the total PM2.5 
## emission from all sources for each of the years 1999, 2002, 2005, and 2008
##
## Assumes that unzipped directory containing the data, a folder with the name
## "NEI_data", is in the current working directory.

# Read data
NEI <- readRDS("NEI_data/summarySCC_PM25.rds")

#Summarize data - sum emissions column, grouped by year
totals <- tapply(NEI$Emissions, NEI$year, sum, na.rm = TRUE)

# Rescale to millions of tons
totals <- totals/1000000

#Plot
year <- as.numeric(names(totals))
png("plot1.png", height = 480, width = 480)
plot(year, totals, type = "l", xlab = "Year", ylab = "PM2.5 Emissions (millions of tons)", main = "Nationwide Emissions")
dev.off()



