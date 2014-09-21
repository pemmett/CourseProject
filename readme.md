## Readme file describing how the code works
The code is well commented describing each step.
The test and training data, labels and subjects were read into corresponding data sets
Only mean and standard deviation columns were retained.
The subject labels were added
The training and test data were merged using rbind()
All columns were averaged except for the subjects and activity columns
Meaningful data names were assigned from the files and they were made ‘pretty’ by removing dashes, parenthesis and the headings containing Means and Standard deviations were modified to add spaces for readability 
A tidy data set is finally written to disk.