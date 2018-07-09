# Codebook for Tidy UCI HAR Dataset

Processing the UCI HAR Dataset using the `run_analysis.R` script produces a new, tidy, summarized data set, `UCI_HAR_tidy.txt`. In this document, we provide a codebook for this dataset and explain why it is tidy.


## Processing the data

### Raw Data

The raw data for this data set is the UCI HAR Dataset, obtainable as a `.zip` file from from [this link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). This zip file contains more detailed information about the collection of the data, which we briefly summarize here.

The data are measurements of acceleration and rotation recorded by a smartphone attached to subjects while they perform various simple movements (e.g., walking, sitting). The measurements taken are then processed in various ways, described in detail in the aforementioned codebook, to give a list of 561 features recording different properties of these measurements. The complete data set was then split into two sets, a training set and a test set, to be used to train and then test algorithms for taking motion input from a smartphone device to determine the activity being performed by the subject from the data recorded by a smartphone worn by the subject.


### Processing with `run_analysis.R`

The `run_analysis.R` script does the initial processing and tidying of the data, completing the 5 steps described in the assignment. From the assignment statement, these steps are:

> 1. Merges the training and the test sets to create one data set.
> 2. Extracts only the measurements on the mean and standard deviation for each measurement.
> 3. Uses descriptive activity names to name the activities in the data set
> 4. Appropriately labels the data set with descriptive variable names.
> 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The script completes these steps in a slightly different order, as follows.

1. The files `subject_train.txt`, `y_train.txt`, and `X_train.txt` are all read from the `UCI HAR Dataset/train` folder and combined to create a data frame with with columns corresponding to the subject, activity code, and various measurements obtained from each file respectively. The analogous files from the `UCI HAR Dataset/test` folder are read similarly, and the resulting data frames are combined to give a data frame with the same columns containing all testing and training observations.

2. The variable (column) names for this dataset are changed to descriptive strings. We use "Subject" and "Activity" for the first two columns, and the remaining columns are named using the feature names read from the `UCI HAR Dataset/features.txt` file. Regular expressions are used to format these names for readability.

3. Using regular expressions, we discard all columns that do not give the mean or standard deviation of the underlying measurement. We also keep the "Subject" and "Activity" columns. Note that in particular we discard all columns that give the mean frequency (meanFreq) of the underlying measurement. Although this number is itself *a* mean, it is not the mean of the underlying measurement, but rather the mean of the frequency of the underlying measurement, and the assignment asks only for the mean of the underlying measurement.

    There are 33 underlying measurements, and since we consider the mean and standard deviation of each this gives a total of 66 different measurements. See the `features_info.txt` file from the `UCI HAR Dataset` folder for more information. See also the variable descriptions below, which explicitly lists all of the measurements.

4. Each integer in the "Activity"" column is converted to a factor to replace it with a string describing the activity. The relationship between the integer and the string is read from the `UCI HAR Dataset/activity_labels.txt` file.

5. At this stage the data are tidied, but not summarized. To summarize, the data are grouped by Subject and Activity, and then the mean of each column is taken with respect to the grouping. Each row in the resulting data set is then a combination of subject and activity, with the remaining 66 columns being the (mean of) the measurements observed for that subject and activity. Since there are 30 subjects and 6 activities, this results in a data frame with 180 rows and 68 columns.

Finally, the script saves this data set as a text file `UCI_HAR_tidy.txt`, the structure of which we describe below.

## `UCI_HAR_tidy.txt`
___________________

The result of the above script is a text file containing the tidy data set. This data set has 68 variables, as described below, and 180 different observations of those variables.

### Variables in the `UCI_HAR_tidy.txt` data set

#### Subject

An integer, taking values from 1 to 30. Represents the number of the subject performing the activity.

#### Activity

A factor, describing the activity performed by the subject while the measurements are taken. The factor has 6 levels which describe the various activities performed:

```
WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
```

#### Remaining Variables

There are 66 remaining variables. Each is a floating point number.

The names of each of these variables is made up of 5 distinct parts, which encode the measurement taken to give the value in that column:

1. "t" or "f", describing whether the measurement is in the time domain or frequency domain.

2. "Body" or "Gravity", describing whether the measurement is related to the acceleration of the actual body of the subject or whether the acceleration is the acceleration due to gravity, respectively.

3. "Acc", "Gyro", "AccJerk", or "GyroJerk" describing whether the measurement is of linear acceleration, angular acceleration, linear jerk, or angular jerk respectively.

4. "X", "Y", "X", or "Mag" describing the direction of the measurement. For X, Y, Z, this means the measurement is along that axis (if linear accleration or jerk) or rotation around that axis (if angular acceleration or jerk). For "Mag", the measurement is the magnitude of the acceleration or jerk vector.

5. "Mean" or "Std", describing whether the value is the mean of the means of the underlying measurement or the mean of the standard deviation in the underlying measurement.

For example, we decode two of the strings listed below:

* "tBodyGyroXMean" measures the mean of the angular acceleration of the body around the X axis, in the time domain.
* "fBodyAccJerkZStd" measures the mean of the standard deviation of the linear jerk in the Z direction in the frequency domain.

Each of these variables is unitless - all features in the data set have been normalized and bounded to [-1,1]. However, each physical measurement will have different units (e.g., angular acceleration was presumably measured in rad/s^2, while angular jerk would have units of rad/s^3, although the original codebook does not specify the units of the original measurements. ). See the `features_info.txt` file from the `UCI HAR Dataset` folder for more information.

The full list of variables is

1. "fBodyAccJerkXMean"        
2. "fBodyAccJerkYMean"        
3. "fBodyAccJerkZMean"       
4. "fBodyAccMagMean"          
5. "fBodyAccXMean"            
6. "fBodyAccYMean"           
7. "fBodyAccZMean"            
8. "fBodyBodyAccJerkMagMean"  
9. "fBodyBodyGyroJerkMagMean"
10. "fBodyBodyGyroMagMean"     
11. "fBodyGyroXMean"           
12. "fBodyGyroYMean"          
13. "fBodyGyroZMean"           
14. "tBodyAccJerkMagMean"      
15. "tBodyAccJerkXMean"       
16. "tBodyAccJerkYMean"        
17. "tBodyAccJerkZMean"        
18. "tBodyAccMagMean"         
19. "tBodyAccXMean"            
20. "tBodyAccYMean"            
21. "tBodyAccZMean"           
22. "tBodyGyroJerkMagMean"     
23. "tBodyGyroJerkXMean"       
24. "tBodyGyroJerkYMean"      
25. "tBodyGyroJerkZMean"       
26. "tBodyGyroMagMean"         
27. "tBodyGyroXMean"          
28. "tBodyGyroYMean"           
29. "tBodyGyroZMean"           
30. "tGravityAccMagMean"      
31. "tGravityAccXMean"         
32. "tGravityAccYMean"         
33. "tGravityAccZMean"
34. "fBodyAccJerkXStd"        
35. "fBodyAccJerkYStd"        
36. "fBodyAccJerkZStd"       
37. "fBodyAccMagStd"          
38. "fBodyAccXStd"            
39. "fBodyAccYStd"           
40. "fBodyAccZStd"            
41. "fBodyBodyAccJerkMagStd"  
42. "fBodyBodyGyroJerkMagStd"
43. "fBodyBodyGyroMagStd"     
44. "fBodyGyroXStd"           
45. "fBodyGyroYStd"          
46. "fBodyGyroZStd"           
47. "tBodyAccJerkMagStd"      
48. "tBodyAccJerkXStd"       
49. "tBodyAccJerkYStd"        
50. "tBodyAccJerkZStd"        
51. "tBodyAccMagStd"         
52. "tBodyAccXStd"            
53. "tBodyAccYStd"            
54. "tBodyAccZStd"           
55. "tBodyGyroJerkMagStd"     
56. "tBodyGyroJerkXStd"       
57. "tBodyGyroJerkYStd"      
58. "tBodyGyroJerkZStd"       
59. "tBodyGyroMagStd"         
60. "tBodyGyroXStd"          
61. "tBodyGyroYStd"           
62. "tBodyGyroZStd"           
63. "tGravityAccMagStd"      
64. "tGravityAccXStd"         
65. "tGravityAccYStd"         
66. "tGravityAccZStd"

Note that the features begining with "fBodyBodyAccJerkMag", "fBodyBodyGyroJerkMag", and "BodyBodyGyroMag" have "Body" twice - this appears to be an error in the original features list.

These strings appear as part of the feature names in the `features.txt` file, but are not explained or discussed in the `features_info.txt` file. Many (but not all) of the above features appear in pairs (e.g., "tBodyAccXMean" and "fBodyAccXMean"), but that the features "tBodyAccJerkMagMean" and "fBodyBodyAccJerkMag" do not have their corresponding pair. We think that they were likely meant to represent the same measurement in the different (time and frequency) domains, but were mislabeled in the original features list, with fBoodyBody appearing instead of fBody.  Similarly arguments apply to the other features where the string "Body" is repeated.


### Tidiness of data

In this section, we justify why the dataset described above is tidy.

Given the description above, it is immediately evident that the data is tidy. There are 68 variables (Subject, activity, and the 66 recorded measurements listed above), each of which is a column.  Every observation of those variables (that is, measuring those 66 variables for every combination of subject and activity) forms a row of the table. There is only one type of observational unit (the values of various physical measurements for a given activity and subject) so the third condition of tidy data is automatically satisfied.

The only remaining justification is to explain why we picked these as variables, especially since the list of 66 measurement variables could be viewed as a collection of many other variables. For example, instead of having each of the 66 measurements be a column, we could create a new variable, called "measurement", and that would take as values the 66 strings describing the different measurements. Perhaps this column could be decomposed even further, as each measurement taken is in some sense a combination of 5 different variables (domain, body vs. gravity, etc.) as described above.

In such an arrangement, the variables might be something like "subject", "activity", "measurement", and "value" for the actual value of that measurement. A further decomposition might have variables like "subject", "activity", "domain", "type of acceleration", "direction", "statistical summary" (e.g. mean or standard deviation), and "value".

While these arrangements could also be considered tidy data sets, we think they are not appropriate for the following reasons.

1. Such an arrangement would mean that numbers in "values" variable would not be comparable or related, and that further computations or summaries with those variables would not in general be sensible. For example, taking the mean of one of the columns in the data set as we have arranged it would give a valid, if perhaps not very useful, summary statistic, e.g., the average acceleration experienced by all participants in all activities. However, taking the average of the "values" column in a data set with a further "measurement" variable would not produce a sensible number, as it would involved averaging over measurements that are completely unrelated. For example, it would average together measurements of acceleration and angular jerk, which is not a meaningful physical measurement.

2. Related to the above, the numbers in such a "values" column would be based on measurements that had inconsistent units. Although the values of the features are normalized, and hence unitless, it does not seem sensible to say that the values of acceleration, which would be measured in m/s^2, and the values of angular acceleration, which would be measure in rad/s^2, should be placed together in the same column. It seems most reasonable to have all numbers in the same column be related to the same unit, as we have in the data set in the manner in which we have arranged it.

3. In our arrangement, the experiment is [fully crossed](https://en.wikipedia.org/wiki/Factorial_experiment) - for every possible combination of subject and activity, we have measured 66 response variables. Breaking up the 66 variables into further variables like "domain", for example, would no longer produce a perfectly crossed design. For example, there is no measurement in the study for the gravity acceleration in the frequency domain, so every possible combination of "domain" and "type of acceleration" would not be observed. This is not ultimately that important, but it seems nice for the tidy data arrangement to preserve the fully crossed structure.

4. Choosing the variables as we have done in our arrangement seems the closest to the choices made by the original experimenters. In making their observations, the experimenters chose a subject and an activity, and then measured multiple physical measurements at the same time. They did not pick a subject, and activity, and a measurement to take, and then made only that measurement. Viewing an observation as a choice of subject, activity, and measurement obscures the fact that the different physical measurements are related to one another, in that they were all taken at the same time, that is, part of the same observation. Thus the observation of acceleration in different directions, say, are not truly independent observations, and so should not be put in different rows.

For these reasons, we believe our arrangement of the data, although very "wide", is tidy, while a "narrower" data set that included a "measurement" variable would not be tidy, as it would split the same observation over many rows.
