## Script to read the NEI pollution data and produce a plot to answer question 
## 3, namely:
##
## Of the four types of sources indicated by the type (point, nonpoint, onroad,
## nonroad) variable, which of these four sources have seen decreases in 
## emissions from 1999–2008 for Baltimore City? Which have seen increases in 
## emissions from 1999–2008? Use the ggplot2 plotting system to make a plot 
## answer this question.
##
## Assumes that unzipped directory containing the data, a folder with the name
## "NEI_data", is in the current working directory.
##
## Requires the dplyr package
## Requires the ggplot2 package

suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(ggplot2))

# Read data
NEI <- readRDS("NEI_data/summarySCC_PM25.rds")

# Select and summarize relevant data for Baltimore
baltimore <- subset(NEI, fips == "24510")
baltimore$type <- as.factor(baltimore$type)
totaled <- group_by(baltimore, year, type) %>%
        summarise(total = sum(Emissions))

# Make the plot
png("plot3.png", height = 480, width = 480)
q <- qplot(year, total,  data= totaled, color = type, geom = "line")
q + labs(x = "Year", y = "PM2.5 Emissions (tons) ", title = "Baltimore Emissions by Source", color = "Source Type")
dev.off()

