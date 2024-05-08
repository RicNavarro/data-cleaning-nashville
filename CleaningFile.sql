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

--		Divivindo o campo de endere�o (PropertyAddress) em colunas individuais (Address, City, State)

-- Observamos como PropertyAddress t�m toda a informa��o de endere�o em
-- apenas um campo.
Select PropertyAddress
From PortifolioProject..NashvilleHousing

-- Aqui estamos selecionando especificamente uma substring de PropretyAddress
-- que come�a no primeiro caracter e vai at� a posi��o anterior (-1) da primeira
-- v�rgula de PropertyAddress.
Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address
From PortifolioProject..NashvilleHousing

-- Agora estamos selecionando a substring contento tudo imediateamente ap�s a v�rgula (+1),
-- at� o final do campo(que estamos medidndo pelo tamanho do cont�udo naquela entrada
Select
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) as Address
From PortifolioProject..NashvilleHousing

-- Inserindo as duas novas colunas, contendo o endere�o e a cidade divididos em
-- dois campos diferentes
ALTER TABLE PortifolioProject..NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

ALTER TABLE PortifolioProject..NashvilleHousing
Add PropertySplitCity Nvarchar(255);

-- Atualizando as colunas com os resultados que observamos nas substrings que
-- mencionamos anteriormente
UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))

-- Antes de avan�ar, vamos fazer o mesmo com o OwnerAddress.
-- Vamos usar ParseName ao inv�s de Substrings

-- PARSENAME procura por .s n�o por ,s ent�o temos de usar REPLACE para substituir
-- um pelo outro antes de realizar o comando. ParseName come�a do final do texto.
-- Logo o ParseName de OwnerAddress com o argumento 1 retorna a �ltima string depois
-- de um ponto(ou uma v�rgula no era nosso caso), o argumeto 2 retorna a pen�ltima, etc.

Select
ParseName(REPLACE(OwnerAddress, ',', '.'), 3), -- Endere�o
ParseName(REPLACE(OwnerAddress, ',', '.'), 2), -- Cidade
ParseName(REPLACE(OwnerAddress, ',', '.'), 1) -- Estado
From PortifolioProject..NashvilleHousing


-- Adicionando os campos respectivos para o endere�o, cidade e estado em OwnerAddress
ALTER TABLE PortifolioProject..NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

ALTER TABLE PortifolioProject..NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

ALTER TABLE PortifolioProject..NashvilleHousing
Add OwnerSplitState Nvarchar(255);

-- Populando cada um desses com as entradas que vimos na se��o de ParseName acima

UPDATE NashvilleHousing
SET OwnerSplitAddress = ParseName(REPLACE(OwnerAddress, ',', '.'), 3)

UPDATE NashvilleHousing
SET OwnerSplitCity = ParseName(REPLACE(OwnerAddress, ',', '.'), 2)

UPDATE NashvilleHousing
SET OwnerSplitState = ParseName(REPLACE(OwnerAddress, ',', '.'), 1)


-----------------------------------------------------------------

-- Mudar o Y e N no campo "SoldAsVacant" para Yes e No






-----------------------------------------------------------------

-- Remover duplicatas






-----------------------------------------------------------------

-- Deletar colunas n�o usadas






-----------------------------------------------------------------

