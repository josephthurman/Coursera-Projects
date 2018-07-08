## Script to read the NEI pollution data and produce a plot to answer question 
## 4, namely:
##
## Across the United States, how have emissions from coal combustion-related 
## sources changed from 1999–2008?
##
## Assumes that unzipped directory containing the data, a folder with the name
## "NEI_data", is in the current working directory.

# Read data
NEI <- readRDS("NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("NEI_data/Source_Classification_Code.rds")

# Find source numbers for coal combustion sources. 
# Use regular expressions to find "coal" or "Coal" in source name. We search for any row that contains "coal" in either the short name or the sector.
name.match <- grepl("[Cc]oal", SCC$Short.Name)
sector.match <- grepl("[Cc]oal", SCC$EI.Sector)
is.coal.row <- name.match | sector.match
# Use regular expressions to find rows related to combustion
is.combustion.row <- grepl("[Cc]ombustion", SCC$SCC.Level.One)
# Coal combustion rows have both coal and combustion
is.coal.comb.row <- is.coal.row & is.combustion.row
coal.source.numbers <- SCC$SCC[is.coal.comb.row]

#Subset and Summarize Data
coal.data <- subset(NEI, SCC %in% coal.source.numbers, select = c("Emissions", "year"))
totals <- tapply(coal.data$Emissions, coal.data$year, sum, na.rm = TRUE)

#Plot
year <- as.numeric(names(totals))
png("plot4.png", height = 480, width = 480)
plot(year, totals, type = "l", xlab = "Year", ylab = "PM2.5 Emissions (tons)", main = "Nationwide Emissions from Coal Combustion")
dev.off()