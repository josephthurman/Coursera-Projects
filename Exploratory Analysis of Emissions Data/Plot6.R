## Script to read the NEI pollution data and produce a plot to answer question 
## 6, namely:
##
## Compare emissions from motor vehicle sources in Baltimore City with emissions
## from motor vehicle sources in Los Angeles County, California 
## (𝚏𝚒𝚙𝚜 == "𝟶𝟼𝟶𝟹𝟽"). Which city has seen greater changes over time
## in motor vehicle emissions?
##
## Assumes that unzipped directory containing the data, a folder with the name
## "NEI_data", is in the current working directory.

suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(ggplot2))

# Read data
#NEI <- radRDS("NEI_data/summarySCC_PM25.rds")
#SCC <- radRDS("NEI_data/Source_Classification_Code.rds")

# Find source numbers for vehicle sources
# Use regular expressions to find "vehicle" or "Vehicle" in source name. Since this is sometimes appreviated to "Veh" in the Short.Name column, we search for any row that contains "Vehicle" or "vehicle" in any of the name levels one to four.
name1.match <- grepl("[Vv]ehicle", SCC$SCC.Level.One)
name2.match <- grepl("[Vv]ehicle", SCC$SCC.Level.Two)
name3.match <- grepl("[Vv]ehicle", SCC$SCC.Level.Three)
name4.match <- grepl("[Vv]ehicle", SCC$SCC.Level.Four)
is.vehicle.row <- name1.match | name2.match | name3.match | name4.match
vehicle.source.numbers <- SCC$SCC[is.vehicle.row]

# Select and summarize relevant data
baltimore <- subset(NEI, 
                    (fips == "24510" & (SCC %in% vehicle.source.numbers)),
                    select = c("year", "Emissions"))
baltimore$city <- "Baltimore"
losangeles<- subset(NEI, 
                    (fips == "06037" & (SCC %in% vehicle.source.numbers)),
                    select = c("year", "Emissions"))
losangeles$city <- "Los Angeles"

vehicle.data <- rbind(baltimore, losangeles)
grouped <- group_by(vehicle.data, year, city)
totals <- summarise(grouped, total = sum(Emissions))

# Plot
png("plot6.png", height = 480, width = 480)
q <- qplot(year, total, data = totals, color = city, geom = "line")
q + labs(x = "Year", y = "PM2.5 Emissions (tons)", title = "Emissions from Motor Vehicles", color = "City")
dev.off()
