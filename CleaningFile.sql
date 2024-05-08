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

--		Divivindo o campo de endereço (PropertyAddress) em colunas individuais (Address, City, State)

-- Observamos como PropertyAddress têm toda a informação de endereço em
-- apenas um campo.
Select PropertyAddress
From PortifolioProject..NashvilleHousing

-- Aqui estamos selecionando especificamente uma substring de PropretyAddress
-- que começa no primeiro caracter e vai até a posição anterior (-1) da primeira
-- vírgula de PropertyAddress.
Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address
From PortifolioProject..NashvilleHousing

-- Agora estamos selecionando a substring contento tudo imediateamente após a vírgula (+1),
-- até o final do campo(que estamos medidndo pelo tamanho do contéudo naquela entrada
Select
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) as Address
From PortifolioProject..NashvilleHousing

-- Inserindo as duas novas colunas, contendo o endereço e a cidade divididos em
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

-- Antes de avançar, vamos fazer o mesmo com o OwnerAddress.
-- Vamos usar ParseName ao invés de Substrings

-- PARSENAME procura por .s não por ,s então temos de usar REPLACE para substituir
-- um pelo outro antes de realizar o comando. ParseName começa do final do texto.
-- Logo o ParseName de OwnerAddress com o argumento 1 retorna a última string depois
-- de um ponto(ou uma vírgula no era nosso caso), o argumeto 2 retorna a penúltima, etc.

Select
ParseName(REPLACE(OwnerAddress, ',', '.'), 3), -- Endereço
ParseName(REPLACE(OwnerAddress, ',', '.'), 2), -- Cidade
ParseName(REPLACE(OwnerAddress, ',', '.'), 1) -- Estado
From PortifolioProject..NashvilleHousing


-- Adicionando os campos respectivos para o endereço, cidade e estado em OwnerAddress
ALTER TABLE PortifolioProject..NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

ALTER TABLE PortifolioProject..NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

ALTER TABLE PortifolioProject..NashvilleHousing
Add OwnerSplitState Nvarchar(255);

-- Populando cada um desses com as entradas que vimos na seção de ParseName acima

UPDATE NashvilleHousing
SET OwnerSplitAddress = ParseName(REPLACE(OwnerAddress, ',', '.'), 3)

UPDATE NashvilleHousing
SET OwnerSplitCity = ParseName(REPLACE(OwnerAddress, ',', '.'), 2)

UPDATE NashvilleHousing
SET OwnerSplitState = ParseName(REPLACE(OwnerAddress, ',', '.'), 1)


-----------------------------------------------------------------

--		 Mudar o Y e N no campo "SoldAsVacant" para Yes e No

-- Grande parte do problema que o tutorial de "Alex the Analyst" teve
-- ao importar essa tabela foi resolvido simplesmente ao importar essa coluna como boolean
-- Os 'N's e 'No's viraram '0' e os 'Y's e 'Yes's viraram '1'. Logo estes campos já foram unidos

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortifolioProject..NashvilleHousing
Group by SoldAsVacant
Order by SoldAsVacant


-- Uma nova coluna para os campos com Yes e No é criada
ALTER TABLE NashvilleHousing
ADD SoldAsVacantYN Nvarchar(3)

-- CASE WHEN para verificar o conteúdo presente em cada entrada e 
-- substituir conforme apropriado.
UPDATE NashvilleHousing
SET SoldAsVacantYN =
	CASE when SoldAsVacant = '0' THEN 'No'
		 when SoldAsVacant = '1' THEN 'Yes'
	END

-----------------------------------------------------------------

-- Remover duplicatas

-- Enquanto não é padrão se remover esses dados duplicados por via de SQL
-- estaremos realizando isso para praticar

-- Vamos usar RowNumber, mas existem opções como Rank
-- Poderíamos comparar o campo UniqueID, mas vamos observar outros como
-- ParcelID SaleDate, LegalReference, em suma campos que se forem todos
-- iguais indicam uma duplicata, mesmo que UniqueID indique que são 2 distintos

-- Ler *** antes de +++

-- +++
-- Criamos uma CTE para manipulação mais fácil dessa tabela do jeito que a query foi feita
-- Fazemos então uma seleção para ver onde row_num > 1, vendo quais entradas são duplicatas
-- Usando Delete, removemos todas as duplicatas
With RowNumCTE as(
-- ***
-- O partition by está dividindo as consultas em agrupamentos conforme cada um
-- dos critérios distintos. O Row_Number() precedendo o over, vai dar um número único
-- para cada linha onde estes elementos por onde estiver se particionando forem iguais
Select *,
ROW_NUMBER() OVER(
Partition By	ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
				UniqueID
				) row_num

From PortifolioProject..NashvilleHousing
)
DELETE
From RowNumCTE
Where row_num > 1


-----------------------------------------------------------------

-- Deletar colunas não usadas






-----------------------------------------------------------------

