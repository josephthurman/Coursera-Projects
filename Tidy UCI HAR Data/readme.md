# Tidying the UCI HAR Dataset

The code in this repository gives one way to process and tidy the data in the UCI HAR Dataset. It contains the following files:

* `run_analysis.R` -- An R script that does the main data processing on the raw dataset

* `UCI_HAR_tidy.txt` -- The tidy data set produced by the above script.

* `codebook.md` -- The codebook for the `UCI_HAR_tidy.txt` data set

* `readme.md` -- this file

## Using this script

### Running the `run_analysis.R` script. 

To use this script:

1. Obtain the UCI HAR Dataset, available in a `.zip` file through the course webpage or from [this link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

2. Unzip the data set, to a folder titled "UCI HAR Dataset", and place that folder in the same directory as the `run_analysis.R` file. 

3. Open R (or RStudio or similar), set the working directory to the directory that contains both the "UCI HAR Dataset" folder and the `run_analysis.R` file, and then run the script using the command `source("run_analysis.R")`

4. The script will process the raw data from the UCI HAR Dataset and produce a tidy data set, saved to the file `UCI_HAR_tidy.txt`.

### Using the `UCI_HAR_tidy.txt` data set

Once the data has been tidied using the `run_analysis.R` script, the resulting `UCI_HAR_tidy.txt` data set can be reloaded into R for further analysis by using the following command.

```R
tidy <- read.table("UCI_HAR_tidy.txt", header = TRUE)
```

This imports the data set into a dataframe named `tidy`. Alternatively, after running the `run_analysis.R` file as described in the previous section, the same data set will be in the environment, again as a dataframe named `tidy`.
