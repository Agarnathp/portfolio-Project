/*

Cleaning Data in SQl Queries

*/
Select*
From [Portfolio project].Dbo.Nashvillehousing

--Standardize in Date Format

Select SaleDate, CONVERT(Date,saleDate)
From [Portfolio project].Dbo.Nashvillehousing

Update Nashvillehousing
Set SaleDate = CONVERT(date,Saledate)

Alter Table Nashvillehousing
Add SaleDateConverted Date;

Update Nashvillehousing
Set SaleDateConverted  = CONVERT(Date,saleDate)

---- Populate Property Address data

Select *
From [Portfolio project].Dbo.Nashvillehousing
Where PropertyAddress is null


Select a.ParcelID, a.ParcelID, b.ParcelID,b.PropertyAddress , ISNULL(a.propertyAddress, B.PropertyAddress)
From [Portfolio project].Dbo.Nashvillehousing a
join [Portfolio project].Dbo.Nashvillehousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


update a
Set PropertyAddress =  ISNULL(a.propertyAddress, B.PropertyAddress)
From [Portfolio project].Dbo.Nashvillehousing a
join [Portfolio project].Dbo.Nashvillehousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]

--- Breaking out Address into Individual coloumn ( Address, City, State)

Select  PropertyAddress
From Nashvillehousing


Select 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address,
SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress) +1, Len(PropertyAddress)) as Address

From Nashvillehousing


Alter Table Nashvillehousing
Add PropertSplitaddress Nvarchar(255)


Update Nashvillehousing
Set  PropertSplitaddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)
 
 Alter Table Nashvillehousing
Add PropertSplitcity Nvarchar(255)

Update Nashvillehousing
Set PropertSplitcity  = SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress) +1, Len(PropertyAddress))



Select Owneraddress
from dbo.Nashvillehousing


Select
PARSENAME(Replace(OwnerAddress, ',','.'), 3),
PARSENAME(Replace(OwnerAddress, ',','.'), 2),
PARSENAME(Replace(OwnerAddress, ',','.'), 1)
from dbo.Nashvillehousing 
 

 Alter Table Nashvillehousing
Add ownerSplitaddress Nvarchar(255)


Update Nashvillehousing
Set  ownerSplitaddress  = PARSENAME(Replace(OwnerAddress, ',','.'), 3)

 Alter Table Nashvillehousing
Add ownerSplitcity Nvarchar(255)


Update Nashvillehousing
Set  ownerSplitcity  = PARSENAME(Replace(OwnerAddress, ',','.'), 2)

 Alter Table Nashvillehousing
Add ownerSplitstate Nvarchar(255)


Update Nashvillehousing
Set  ownerSplitstate  = PARSENAME(Replace(OwnerAddress, ',','.'), 1)


---- Change Y and N to Yes in and No in "Sold as Vacant" Field

Select Distinct(SoldAsVacant), COUNT(Soldasvacant)
From [Portfolio project].Dbo.Nashvillehousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant,
Case when SoldAsVacant = 'Y' Then 'yes'
     when SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 end
From [Portfolio project].Dbo.Nashvillehousing

Update Nashvillehousing
Set SoldAsVacant = Case when SoldAsVacant = 'Y' Then 'yes'
     when SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 end
From [Portfolio project].Dbo.Nashvillehousing 



--- Removing Duplicates
With RowNumCTE As (
Select*,
ROW_NUMBER() over( Partition by ParcelID, PropertyAddress, Saleprice, SaleDate, LegalReference 
Order By UniqueID) Row_num

From [Portfolio project].Dbo.Nashvillehousing
)

Select *
From RowNumCTE
where Row_num >1
order by propertyAddress


---- Delect Duplicates

Select*
From [Portfolio project].Dbo.Nashvillehousing

Alter Table [Portfolio project].Dbo.Nashvillehousing
Drop Column Owneraddress, TaxDistrict, Propertyaddress

Alter Table [Portfolio project].Dbo.Nashvillehousing
Drop Column SaleDate

