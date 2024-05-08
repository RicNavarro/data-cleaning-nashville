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

--		 Mudar o Y e N no campo "SoldAsVacant" para Yes e No

-- Grande parte do problema que o tutorial de "Alex the Analyst" teve
-- ao importar essa tabela foi resolvido simplesmente ao importar essa coluna como boolean
-- Os 'N's e 'No's viraram '0' e os 'Y's e 'Yes's viraram '1'. Logo estes campos j� foram unidos

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortifolioProject..NashvilleHousing
Group by SoldAsVacant
Order by SoldAsVacant


-- Uma nova coluna para os campos com Yes e No � criada
ALTER TABLE NashvilleHousing
ADD SoldAsVacantYN Nvarchar(3)

-- CASE WHEN para verificar o conte�do presente em cada entrada e 
-- substituir conforme apropriado.
UPDATE NashvilleHousing
SET SoldAsVacantYN =
	CASE when SoldAsVacant = '0' THEN 'No'
		 when SoldAsVacant = '1' THEN 'Yes'
	END

-----------------------------------------------------------------

-- Remover duplicatas

-- Enquanto n�o � padr�o se remover esses dados duplicados por via de SQL
-- estaremos realizando isso para praticar

-- Vamos usar RowNumber, mas existem op��es como Rank
-- Poder�amos comparar o campo UniqueID, mas vamos observar outros como
-- ParcelID SaleDate, LegalReference, em suma campos que se forem todos
-- iguais indicam uma duplicata, mesmo que UniqueID indique que s�o 2 distintos

-- Ler *** antes de +++

-- +++
-- Criamos uma CTE para manipula��o mais f�cil dessa tabela do jeito que a query foi feita
-- Fazemos ent�o uma sele��o para ver onde row_num > 1, vendo quais entradas s�o duplicatas
-- Usando Delete, removemos todas as duplicatas
With RowNumCTE as(
-- ***
-- O partition by est� dividindo as consultas em agrupamentos conforme cada um
-- dos crit�rios distintos. O Row_Number() precedendo o over, vai dar um n�mero �nico
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

-- Deletar colunas n�o usadas






-----------------------------------------------------------------

