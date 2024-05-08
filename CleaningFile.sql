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






-----------------------------------------------------------------

-- Divivindo o campo de endereço (PropertyAddress) em colunas individuais (Address, City, State)






-----------------------------------------------------------------

-- Mudar o Y e N no campo "SoldAsVacant" para Yes e No






-----------------------------------------------------------------

-- Remover duplicatas






-----------------------------------------------------------------

-- Deletar colunas não usadas






-----------------------------------------------------------------

