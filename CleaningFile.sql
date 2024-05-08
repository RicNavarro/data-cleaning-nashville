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

-- Realizando uma convers�o para vizualisar como SaleDate fica ao ser convertida
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

--		 Populando os dados de endere�o de cada im�vel (PropretyAddress)

-- Realizando uma primeira vizualiza��o e vendo que muitas entradas t�m o endere�o
-- da propriedade definido como nulo
Select *
From PortifolioProject..NashvilleHousing
Where PropertyAddress is Null

-- Algo que podemos fazer � observar o ParcelID, pois este indica
-- um �nico endere�o, isto �, um �nico PropertyAddress
Select ParcelID, PropertyAddress
From PortifolioProject..NashvilleHousing
ORDER BY ParcelID

-- Usando um Join da tabela com ela mesma (entre 'a' e 'b'), verificamos as
-- entradas distintas(UniqueID distintos) onde os ParcelID s�o os mesmos. Tamb�m
-- selecionamos os endere�os(PropertyAddress) para vizualizar os locais onde h� um 'Null'
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From PortifolioProject..NashvilleHousing a
JOIN PortifolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS Null

-- Ulilizando 'ISNULL' na query acima, podemos selecionar o que vir� a
-- popular as entradas com PropertyAddress = Null, ao fazer equival�ncia
-- entre o que temos em a.PropertyAddress com o campo correto de b.PropertyAddress
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortifolioProject..NashvilleHousing a
JOIN PortifolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS Null

-- Atualizando a tabela pr�priamente dita.
-- Agora nenhuma entrada tem PropertyAddress como Null
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortifolioProject..NashvilleHousing a
JOIN PortifolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS Null


-----------------------------------------------------------------

-- Divivindo o campo de endere�o (PropertyAddress) em colunas individuais (Address, City, State)






-----------------------------------------------------------------

-- Mudar o Y e N no campo "SoldAsVacant" para Yes e No






-----------------------------------------------------------------

-- Remover duplicatas






-----------------------------------------------------------------

-- Deletar colunas n�o usadas






-----------------------------------------------------------------

