Nashville Housing Data Cleaning
Project Overview
This project focuses on cleaning the Nashville Housing Dataset using SQL. Key tasks include:

Standardizing date formats
Handling null values
Splitting concatenated columns
Modifying field values for consistency
Removing duplicates
Dropping unnecessary columns
Key Tasks
Standardized SaleDate format using CONVERT().
Filled null PropertyAddress values by joining rows with matching ParcelID.
Split address data into separate columns using SUBSTRING() and PARSENAME().
Standardized SoldAsVacant values ('Y' to 'Yes', 'N' to 'No').
Removed duplicates based on ParcelID and other fields using ROW_NUMBER() and CTE.
Dropped unnecessary columns (OwnerAddress, SaleDate, PropertyAddress).
Tools Used
SQL Server
SQL Functions: CONVERT(), ISNULL(), SUBSTRING(), CHARINDEX(), PARSENAME(), ROW_NUMBER(), CASE
How to Use
Clone this repository.
Run the SQL scripts on your database.
The NashvilleHousing table will be cleaned and ready for analysis.
