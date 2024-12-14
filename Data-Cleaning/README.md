# Nashville Housing Data Cleaning

## Project Overview
This project focuses on cleaning the **Nashville Housing Dataset** using SQL. Key tasks include:
- Standardizing date formats
- Handling null values
- Splitting concatenated columns
- Modifying field values for consistency
- Removing duplicates
- Dropping unnecessary columns

## Key Tasks
1. **Standardized `SaleDate`** format using `CONVERT()`.
2. **Filled null `PropertyAddress`** values by joining rows with matching `ParcelID`.
3. **Split address data** into separate columns using `SUBSTRING()` and `PARSENAME()`.
4. **Standardized `SoldAsVacant`** values (`'Y'` to `'Yes'`, `'N'` to `'No'`).
5. **Removed duplicates** based on `ParcelID` and other fields using `ROW_NUMBER()` and CTE.
6. **Dropped unnecessary columns** (`OwnerAddress`, `SaleDate`, `PropertyAddress`).

## Tools Used
- **SQL Server**
- **SQL Functions:** `CONVERT()`, `ISNULL()`, `SUBSTRING()`, `CHARINDEX()`, `PARSENAME()`, `ROW_NUMBER()`, `CASE`

## How to Use
1. Clone this repository.
2. Run the SQL scripts on your database.
3. The `NashvilleHousing` table will be cleaned and ready for analysis.
