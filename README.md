The run_analysis.R script will read files from the 'UCI HAR Dataset' directory under the present working directory.  If needed, the user can uncomment the download code to download and unzip data to this directory.

The script first reads data from the test and training files and merges the data into a single large data set.

Next the script translates the headers into descriptive text and extracts only those columns that contain the text -std() or -mean() which corresponds to measurements of the standard deviation and mean for each measurment.

The script then converts the numbers corresponding to activities into descriptive text that clarifies what activity each measurement is for.

Finally the script averages the values for each subject and each activity and creates a new data set which is saved in the working directory as the file 'Assignment Output - Tidy Data Set.txt'.

Contents of this repo:

Readme.md - explanation of script and repo contents
CodeBook.md - explanation of the data