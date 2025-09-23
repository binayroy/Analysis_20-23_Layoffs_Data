# Analysis_20-23_Layoffs_Data
## Cleaning and Analyzing World wide layoffs data from 2020 to 2023
### Data Source:
This [`layoffs.csv`](https://github.com/binayroy/Analysis_20-23_Layoffs_Data/blob/main/layoffs.csv) file holds the data we need to analyze. We will import it to MySQL to start analyzing.
### Data Cleaning:
Here, the [`Layoffs_Data_Cleaning.sql`](https://github.com/binayroy/Analysis_20-23_Layoffs_Data/blob/main/Layoffs_Data_Cleaning.sql) file contains the code used to clean the data and prepare it for analysis.
### Steps:
- Select Database & import into a table.
- Remove Duplicates.
- **Standardize Data** - Validates all the columns for:
  - Datatype.
  - Different name for the same thing. (Crypto, Crypto Currency)
  - Spelling. (Malmo)
  - Unwanted spaces.
  - Unwanted characters such as "."
  - proper formatting for date.
- Deal with `NULL` Values. Populate `NULL` values where possible.
  - (Ex. Airbnb's industry was missing in some rows) So, pulled data from available rows and put them into the missing rows
- Finally, the cleaned data was moved to the `layoff_clean` table.

### Exploratory Data Analysis:
The file [`EDA.sql`](https://github.com/binayroy/Analysis_20-23_Layoffs_Data/blob/main/EDA.sql) contains the code for this analysis. In this step, we tried to explore the dataset and checked if everything was going fine here.
#### Key Analyses Performed:
- **Industry and Country Analysis:** Which industry has the highest layoffs for each particular country
- **Company-Level Analysis:** Total layoffs and Frequency of Layoff activity.
- **Layoff Trends by Stage:** At which Stage are layoffs the highest?
- **Time-Series Analysis:** top 5 companies with the most layoffs each year, Rolling sum (Overall, monthly for each year).
