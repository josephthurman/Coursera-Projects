## Script to read the NEI pollution data and produce a plot to answer question 
## 2, namely:
##
## Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
## (fips == "24510") from 1999 to 2008? Use the base plotting 
## system to make a plot answering this question.
##
## Assumes that unzipped directory containing the data, a folder with the name
## "NEI_data", is in the current working directory.

# Read data
NEI <- readRDS("NEI_data/summarySCC_PM25.rds")

# Select and summarize relevant data for Baltimore
baltimore <- subset(NEI, fips == "24510", select = c("Emissions", "year"))
totals <- tapply(baltimore$Emissions, baltimore$year, sum, na.rm = TRUE)

#Plot
year <- as.numeric(names(totals))
png("plot2.png", height = 480, width = 480)
plot(year, totals, type = "l", xlab = "Year", ylab = "PM2.5 Emissions (tons)", main = "Baltimore Emissions")
dev.off()

