--Standardize date format

ALTER TABLE  PortfolioProject..NashvilleHousing
ADD SaleDateConverted date;

UPDATE PortfolioProject..NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate)
	--SaleDate sy Datetime format ko date format mein convert kr k SaleDateConvert mein save krdia

Select SaleDateConverted
From  PortfolioProject..NashvilleHousing

--Populating null property addresses

select *	
from PortfolioProject..NashvilleHousing
Where PropertyAddress is Null 
	--some ParcelIDs are saved twice in dataset but one row has property address, the other one has null.

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
	--ISNULL(a.PropertyAddress, b.PropertyAddress) fill null values in a with b
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ] 
		-- so that same rows repeat nah hon
Where a.PropertyAddress is null 
	-- this whole query; to check which two same parcel ids has one property address filled and other null 

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	On a.ParcelID = b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null 


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
	On a.ParcelID= b.ParcelID
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null 
	-- this query to check after update if there are any Null Property addresses having same ParcelId



-- Breaking PropertyAddress into separate columns Address, City using SUBSTRING()

Select PropertyAddress 
From PortfolioProject..NashvilleHousing -- to view the current state of address

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) City
From PortfolioProject..NashvilleHousing
	--SUBSTRING()'s 1st value: which column we're using, 
	--2nd value: start point, 3rd value: end point
	--CHARINDEX() returns integer index of specific character
	--CHARINDEX()'s 1st value: char which we want index of ,
	--2nd value: which column we're using

	--Note: We cant separate two values from one column w/o creating two new columns

ALTER TABLE  PortfolioProject..NashvilleHousing
ADD SplitedAddress nvarchar(255);

UPDATE PortfolioProject..NashvilleHousing
SET SplitedAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE  PortfolioProject..NashvilleHousing
ADD SplitedCity nvarchar(255);

UPDATE PortfolioProject..NashvilleHousing
SET SplitedCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

Select SplitedAddress, SplitedCity
From PortfolioProject..NashvilleHousing


-- Breaking OwnerAddress into separate columns Address, City, State using PARSENAME()

Select OwnerAddress
From PortfolioProject..NashvilleHousing

Select PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1),
	   PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
	   PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
From PortfolioProject..NashvilleHousing
	--PARSENAME() split string to first occurence of period/'.'
	--PARSENAME()'s 1st value: Kis column pr searching krni hai.
	--PARSENAME()'s 2nd value: Kitni '.' ki  occurence tk searching jari.
	--Occurences are counted backwards (3 ka matlab akhir sy 3).
	--Hamari String mein period nhi comma tha so we replaced it using replace function for 1st value of PARSENAME()'s parenthesis.

ALTER TABLE  PortfolioProject..NashvilleHousing
ADD OwnerAddressSplitedAddress nvarchar(255);

UPDATE PortfolioProject..NashvilleHousing
SET OwnerAddressSplitedAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE  PortfolioProject..NashvilleHousing
ADD OwnerAddressSplitedCity nvarchar(255);

UPDATE PortfolioProject..NashvilleHousing
SET OwnerAddressSplitedCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE  PortfolioProject..NashvilleHousing
ADD OwnerAddressSplitedState nvarchar(255);

UPDATE PortfolioProject..NashvilleHousing
SET OwnerAddressSplitedState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

Select OwnerAddressSplitedAddress, OwnerAddressSplitedCity, OwnerAddressSplitedState
From PortfolioProject..NashvilleHousing


--Changing Y&N to Yes&No in SoldAsVacant field using CASES

Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) 
From PortfolioProject..NashvilleHousing
Group By SoldAsVacant
Order By 2
	--This query: 
	--Distinct(): SoldAsVacant mein jitni diff values hain, this is column 1 of output
	--COUNT and GROUP BY: SoldAsVacant mein jitni different values hain unka count, this is column 2 of output


Select 
	SoldAsVacant, 
	CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		 WHEN SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
From PortfolioProject..NashvilleHousing



UPDATE PortfolioProject..NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
From PortfolioProject..NashvilleHousing


Select DISTINCT(SoldAsVacant), COUNT(SoldAsVacant) 
From PortfolioProject..NashvilleHousing
Group By SoldAsVacant
Order By 2
	--Checking again




--Removing Duplicates

WITH RowNumCTE AS(
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID,
            PropertyAddress,
            SalePrice,
            SaleDate,
            LegalReference
            ORDER BY UniqueID
        ) row_num
    FROM PortfolioProject.dbo.NashvilleHousing

)

SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress
	--Values that I'm partioning by, if they are repeating then row_number will increase
	--so all row_num =2 are repeating values
	--using CTE to remove/delete data is considered good practice


-----------------------------------------------------------------------------------------------------------------------------------------------------


WITH RowNumCTE AS(
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID,
            PropertyAddress,
            SalePrice,
            SaleDate,
            LegalReference
            ORDER BY UniqueID
        ) row_num
    FROM PortfolioProject.dbo.NashvilleHousing

)

DELETE
FROM RowNumCTE
WHERE row_num > 1
	--deleting repeated row


-----------------------------------------------------------------------------------------------------------------------------------------------



WITH RowNumCTE AS(
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID,
            PropertyAddress,
            SalePrice,
            SaleDate,
            LegalReference
            ORDER BY UniqueID
        ) row_num
    FROM PortfolioProject.dbo.NashvilleHousing

)

SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress
	--checking again



--Deleting unwanted columns

SELECT *  
FROM PortfolioProject.dbo.NashvilleHousing  

ALTER TABLE PortfolioProject.dbo.NashvilleHousing  
DROP COLUMN OwnerAddress, SaleDate, PropertyAddress 
	--Del all columns which were splited or modified earlier

