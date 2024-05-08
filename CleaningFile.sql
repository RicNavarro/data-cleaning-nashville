/*

		Limpando os dados com SQL

*/

Select *
From PortifolioProject..NashvilleHousing

-----------------------------------------------------------------

--		Padronizando o formato das datas

-- Observando o formato de SaleDate
Select SaleDate
From PortifolioProject..NashvilleHousing

-- Realizando uma conversão para vizualisar como SaleDate fica ao ser convertida
-- pro formato Date, deixando de ser nvarchar
Select SaleDate, CONVERT(Date, SaleDate)
From PortifolioProject..NashvilleHousing

-- Atualizando a tabela com SaleDate agora com o formato Date
UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

/*
Forma alternativa de atualizar

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)
*/

-----------------------------------------------------------------

--		 Populando os dados de endereço de cada imóvel (PropretyAddress)

-- Realizando uma primeira vizualização e vendo que muitas entradas têm o endereço
-- da propriedade definido como nulo
Select *
From PortifolioProject..NashvilleHousing
Where PropertyAddress is Null

-- Algo que podemos fazer é observar o ParcelID, pois este indica
-- um único endereço, isto é, um único PropertyAddress
Select ParcelID, PropertyAddress
From PortifolioProject..NashvilleHousing
ORDER BY ParcelID

-- Usando um Join da tabela com ela mesma (entre 'a' e 'b'), verificamos as
-- entradas distintas(UniqueID distintos) onde os ParcelID são os mesmos. Também
-- selecionamos os endereços(PropertyAddress) para vizualizar os locais onde há um 'Null'
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From PortifolioProject..NashvilleHousing a
JOIN PortifolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS Null

-- Ulilizando 'ISNULL' na query acima, podemos selecionar o que virá a
-- popular as entradas com PropertyAddress = Null, ao fazer equivalência
-- entre o que temos em a.PropertyAddress com o campo correto de b.PropertyAddress
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortifolioProject..NashvilleHousing a
JOIN PortifolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS Null

-- Atualizando a tabela própriamente dita.
-- Agora nenhuma entrada tem PropertyAddress como Null
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortifolioProject..NashvilleHousing a
JOIN PortifolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS Null


-----------------------------------------------------------------

-- Divivindo o campo de endereço (PropertyAddress) em colunas individuais (Address, City, State)






-----------------------------------------------------------------

-- Mudar o Y e N no campo "SoldAsVacant" para Yes e No






-----------------------------------------------------------------

-- Remover duplicatas






-----------------------------------------------------------------

-- Deletar colunas não usadas






-----------------------------------------------------------------

