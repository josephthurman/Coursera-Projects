## Script to read the NEI pollution data and produce a plot to answer question 
## 5, namely:
##
## How have emissions from motor vehicle sources changed from 1999–2008 in 
## Baltimore City?
##
## Assumes that unzipped directory containing the data, a folder with the name
## "NEI_data", is in the current working directory.

NEI <- readRDS("NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("NEI_data/Source_Classification_Code.rds")

# Find source numbers for vehicle sources
# Use regular expressions to find "vehicle" or "Vehicle" in source name. Since this is sometimes appreviated to "Veh" in the Short.Name column, we search for any row that contains "Vehicle" or "vehicle" in any of the name levels one to four.
name1.match <- grepl("[Vv]ehicle", SCC$SCC.Level.One)
name2.match <- grepl("[Vv]ehicle", SCC$SCC.Level.Two)
name3.match <- grepl("[Vv]ehicle", SCC$SCC.Level.Three)
name4.match <- grepl("[Vv]ehicle", SCC$SCC.Level.Four)
is.vehicle.row <- name1.match | name2.match | name3.match | name4.match
vehicle.source.numbers <- SCC$SCC[is.vehicle.row]

# Select and summarize relevant data for Baltimore
baltimore <- subset(NEI, (fips == "24510" & (SCC %in% vehicle.source.numbers)))
totals <- tapply(baltimore$Emissions, baltimore$year, sum, na.rm = TRUE)
year <- as.numeric(names(totals))

# Make plot
png("plot5.png", height = 480, width = 480)
plot(year, totals, type = "l", xlab = "Year", ylab = "PM2.5 Emissions (tons)", main = "Baltimore Emissions from Motor Vehicles")
dev.off()