SELECT * FROM nashville_housing;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* ADDING A NEW COLUMN AS STANDARD DATE FORMET*/

SELECT saledate, CONVERT(saledate,DATE) 
FROM nashville_housing;

ALTER TABLE nashville_housing 
ADD new_saledate DATE;
SELECT * FROM nashville_housing;
SET SQL_SAFE_UPDATES = 0;
UPDATE nashville_housing
SET new_saledate = CONVERT(saledate,DATE);

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*POPULATE BLANK PROPERTY ADDRESS DATA*/

Select A.parcelID, A.propertyAddress, B.parcelID, B.propertyAddress
From nashville_housing A
JOIN nashville_housing B
	on A.parcelID = B.parcelID
	AND A.uniqueID  <> B.uniqueID 
Where a.propertyaddress is null;

  UPDATE nashville_housing A
JOIN nashville_housing B
ON A.parcelID = B.parcelID
AND A.uniqueID <> B.uniqueID
SET A.propertyaddress = CONCAT(A.propertyaddress, ' ', B.propertyaddress)
WHERE A.propertyaddress = '';

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS(ADDRESS, CITY, STATE)*/

SELECT propertyaddress,
SUBSTRING(propertyAddress, 1, CHARINDEX(',', propertyAddress) -1 ) as property_address
, SUBSTRING(propertyAddress, CHARINDEX(',', propertyAddress) + 1 , LEN(PropertyAddress)) as property_city
From nashville_housing;

 ALTER TABLE nashville_housing
 ADD property_address VARCHAR(100);
 UPDATE nashville_housing
 SET property_address = SUBSTRING(propertyaddress,1,LOCATE(',',propertyaddress)-1);
 
 ALTER TABLE nashville_housing
 ADD property_city VARCHAR(100);
 UPDATE nashville_housing
 SET property_city = SUBSTRING(propertyaddress,LOCATE(',',propertyaddress)+1,LENGTH(propertyaddress));
 
 
 /* FOR OWNER ADDRESS*/
 
 SELECT owneraddress, SUBSTRING_INDEX(owneraddress,',',1) AS owener_address,
 SUBSTRING_INDEX(SUBSTRING_INDEX(owneraddress,',',2),',',-1) AS owner_city,
 SUBSTRING_INDEX(owneraddress,',',-1) AS owner_state
 FROM nashville_housing;
 
 ALTER TABLE nashville_housing
 ADD owner_address VARCHAR(100),
 ADD owner_city VARCHAR(100),
 ADD owner_state VARCHAR(100);
 
 UPDATE nashville_housing
 SET owner_address = SUBSTRING_INDEX(owneraddress,',',1),
 owner_city = SUBSTRING_INDEX(SUBSTRING_INDEX(owneraddress,',',2),',',-1),
 owner_state = SUBSTRING_INDEX(owneraddress,',',-1);
 
 ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
/* CHANGING Y AND N TO YES AND NO IN soldASvacant FIELD*/

Select soldasvacant, Count(soldasvacant)
From nashville_housing
Group by soldasvacant
order by 2;

UPDATE nashville_housing
SET soldasvacant = CASE WHEN soldasvacant = 'Y' THEN 'Yes'
				   WHEN soldasvacant = 'N' THEN 'No'
				   ELSE soldasvacant END;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* DELETE UNUSED COLUMNS*/

ALTER TABLE nashville_housing
DROP COLUMN PropertyAddress,
DROP COLUMN SaleDate,
DROP COLUMN OwnerAddress;
