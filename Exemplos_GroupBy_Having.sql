/*
 * Esta seção é apenas para criação das tabelas para este capítulo
 * É feito primeiro o DROP da(s) tabela(s) caso ela já exista
 * Após é feita a criação da tabela no contexto do capítulo
 * Por fim a população da tabela com o contexto do capítulo
 *
 * Recomenda-se executar esta parte inicial a cada capítulo
 */

 /*
 * Caso tenha eventuais problemas de conversão de datas, execute o seguinte comando:
 *
 * SET DATEFORMAT ymd
 *
 * No início de cada script estou incluindo este comando, caso você retome o exercício em outro dia,
 * é só executar este comando (1 vez apenas, pois é por sessão) antes de executar as queries
 */

-- ***************************************************************
-- ***************************************************************
-- ***************************************************************
-- ***************************************************************
SET DATEFORMAT ymd 

IF EXISTS(SELECT * FROM sys.sequences WHERE name = 'SeqIdVendas')  
BEGIN 
	DROP SEQUENCE dbo.SeqIdVendas 
END 

IF EXISTS(SELECT * FROM sys.synonyms WHERE name = 'VendasSinonimo')  
BEGIN 
	DROP SYNONYM dbo.VendasSinonimo 
END 

IF OBJECT_ID('dbo.VendasProdutoQuantidadeValor', 'TF') IS NOT NULL 
BEGIN 
	DROP FUNCTION dbo.VendasProdutoQuantidadeValor 
END 

IF OBJECT_ID('dbo.VendasProduto', 'IF') IS NOT NULL 
BEGIN 
	DROP FUNCTION dbo.VendasProduto 
END 

IF OBJECT_ID('dbo.ValorTotal', 'FN') IS NOT NULL 
BEGIN 
	DROP FUNCTION dbo.ValorTotal 
END 

IF EXISTS(SELECT * FROM sys.views WHERE name = 'VendasProdutoB')  
BEGIN 
	DROP VIEW dbo.VendasProdutoB 
END 

IF EXISTS(SELECT * FROM sys.views WHERE name = 'VendasProdutoA')  
BEGIN 
	DROP VIEW dbo.VendasProdutoA 
END 

IF EXISTS(SELECT * FROM sys.triggers WHERE name = 'VendasProdutoATrigger')  
BEGIN 
	DROP TRIGGER dbo.VendasProdutoATrigger 
END 

IF EXISTS(SELECT * FROM sys.views WHERE name = 'VendasProdutoA')  
BEGIN 
	DROP VIEW dbo.VendasProdutoA 
END 

IF EXISTS(SELECT * FROM sys.triggers WHERE name = 'VendasAlteracao')  
BEGIN 
	DROP TRIGGER dbo.VendasAlteracao 
END 

IF EXISTS(SELECT * FROM sys.triggers WHERE name = 'VendasInclusao')  
BEGIN 
	DROP TRIGGER dbo.VendasInclusao 
END 

IF EXISTS(SELECT * FROM sys.tables WHERE name = 'LogVendas')  
BEGIN 
	DROP TABLE dbo.LogVendas 
END 

IF EXISTS(SELECT * FROM sys.procedures WHERE name = 'IncluiVendas')  
BEGIN 
	DROP PROCEDURE dbo.IncluiVendas 
END 

IF EXISTS(SELECT * FROM sys.procedures WHERE name = 'VendasComTotal')  
BEGIN 
	DROP PROCEDURE dbo.VendasComTotal 
END 

IF EXISTS(SELECT * FROM sys.procedures WHERE name = 'VendasInclusaoDinamico')  
BEGIN 
	DROP PROCEDURE dbo.VendasInclusaoDinamico 
END 

IF EXISTS(SELECT * FROM sys.views WHERE name = 'VendasViewIndexed')  
BEGIN 
	DROP VIEW dbo.VendasViewIndexed 
END 

IF EXISTS(SELECT * FROM sys.procedures WHERE name = 'PopularVendas')  
BEGIN 
	DROP PROCEDURE dbo.PopularVendas 
END 

IF EXISTS(SELECT * FROM sys.tables WHERE name = 'Vendas')  
BEGIN 
	DROP TABLE dbo.Vendas 
END 

IF EXISTS(SELECT * FROM sys.tables WHERE name = 'Produto')  
BEGIN 
	DROP TABLE dbo.Produto 
END 

IF EXISTS(SELECT * FROM sys.tables WHERE name = 'CadastroCliente')  
BEGIN 
	DROP TABLE dbo.CadastroCliente 
END 

IF EXISTS(SELECT * FROM sys.tables WHERE name = 'Cidade')  
BEGIN 
	DROP TABLE dbo.Cidade 
END 

IF EXISTS(SELECT * FROM sys.tables WHERE name = 'Estado')  
BEGIN 
	DROP TABLE dbo.Estado 
END 

GO 

/*
Tabela de domínio que representa os estados brasileiros
*/

CREATE TABLE dbo.Estado 
(
	Id TINYINT IDENTITY(1, 1) NOT NULL, 
	Descricao VARCHAR(150) NOT NULL, 
	CONSTRAINT PK_Estado PRIMARY KEY (Id) 
)

INSERT INTO dbo.Estado (Descricao) 
VALUES ('São Paulo'), 
       ('Rio de Janeiro'), 
	   ('Minas Gerais') 

/*
Tabela de domínio que representa as cidades brasileiras
Utiliza-se o código da tabela de domínio de Estado para identificar à qual estado pertence cada cidade
*/

CREATE TABLE dbo.Cidade 
(
	Id SMALLINT IDENTITY(1, 1) NOT NULL, 
	Id_Estado TINYINT NOT NULL, 
	Descricao VARCHAR(250) NOT NULL, 
	CONSTRAINT PK_Cidade PRIMARY KEY (Id), 
	CONSTRAINT FK_Estado_Cidade FOREIGN KEY (Id_Estado) REFERENCES Estado (Id) 
) 

INSERT INTO dbo.Cidade (Id_Estado, Descricao) 
VALUES (1, 'Santo André'), 
       (1, 'São Bernardo do Campo'), 
	   (1, 'São Caetano do Sul'), 
	   (2, 'Duque de Caxias'), 
	   (2, 'Niterói'), 
	   (2, 'Petrópolis'), 
	   (3, 'Uberlândia'), 
	   (3, 'Contagem'), 
	   (3, 'Juiz de Fora') 

/*
Representação da tabela de cadastro de clientes
Há vínculo do cliente com a tabela de domínio Cidade
Como a tabela de domínio Cidade já possui vínculo com a tabela Estado, não é necessário criar vínculo forte entre a tabela CadastroCliente e a tabela Estado
*/

CREATE TABLE dbo.CadastroCliente 
(
	Id INTEGER IDENTITY(1, 1) NOT NULL, 
	Nome VARCHAR(150) NOT NULL, 
	Endereco VARCHAR(250) NOT NULL, 
	Id_Cidade SMALLINT NOT NULL, 
	Email VARCHAR(250) NOT NULL, 
	Telefone1 VARCHAR(20) NOT NULL, 
	Telefone2 VARCHAR(20) NULL, 
	Telefone3 VARCHAR(20) NULL, 
	CONSTRAINT PK_CadastroCliente PRIMARY KEY (Id), 
	CONSTRAINT FK_Cidade_CadastroCliente FOREIGN KEY (Id_Cidade) REFERENCES Cidade (Id) 
) 

INSERT INTO dbo.CadastroCliente (Nome, Endereco, Id_Cidade, Email, Telefone1, Telefone2, Telefone3) 
VALUES ('Cliente 1',  'Rua 1',  1, 'cliente_1@email.com',  '(11) 0000-0000', NULL, NULL), 
       ('Cliente 2',  'Rua 2',  1, 'cliente_2@email.com',  '(11) 0000-0000', '(11) 1111-1111', '(11) 2222-2222'), 
	   ('Cliente 3',  'Rua 3',  1, 'cliente_3@email.com',  '(11) 0000-0000', '(11) 1111-1111', '(11) 2222-2222'), 
	   ('Cliente 4',  'Rua 4',  2, 'cliente_4@email.com',  '(11) 0000-0000', '(11) 1111-1111', NULL), 
	   ('Cliente 5',  'Rua 5',  2, 'cliente_5@email.com',  '(11) 0000-0000', '(11) 1111-1111', '(11) 2222-2222'), 
	   ('Cliente 6',  'Rua 6',  2, 'cliente_6@email.com',  '(11) 0000-0000', '(11) 1111-1111', NULL), 
	   ('Cliente 7',  'Rua 7',  3, 'cliente_7@email.com',  '(11) 0000-0000', NULL,             NULL), 
	   ('Cliente 8',  'Rua 8',  3, 'cliente_8@email.com',  '(11) 0000-0000', '(11) 1111-1111', '(11) 2222-2222'), 
	   ('Cliente 9',  'Rua 9',  3, 'cliente_9@email.com',  '(11) 0000-0000', '(11) 1111-1111', '(11) 2222-2222'), 
	   ('Cliente 10', 'Rua 10', 4, 'cliente_10@email.com', '(21) 0000-0000', '(21) 1111-1111', '(21) 2222-2222'), 
	   ('Cliente 11', 'Rua 11', 4, 'cliente_11@email.com', '(21) 0000-0000', '(21) 1111-1111', '(21) 2222-2222'), 
	   ('Cliente 12', 'Rua 12', 4, 'cliente_12@email.com', '(21) 0000-0000', '(21) 1111-1111', '(21) 2222-2222'), 
	   ('Cliente 13', 'Rua 13', 5, 'cliente_13@email.com', '(21) 0000-0000', '(21) 1111-1111', '(21) 2222-2222'), 
	   ('Cliente 14', 'Rua 14', 5, 'cliente_14@email.com', '(21) 0000-0000', '(21) 1111-1111', NULL), 
	   ('Cliente 15', 'Rua 15', 5, 'cliente_15@email.com', '(21) 0000-0000', '(21) 1111-1111', NULL), 
	   ('Cliente 16', 'Rua 16', 6, 'cliente_16@email.com', '(21) 0000-0000', '(21) 1111-1111', '(21) 2222-2222'), 
	   ('Cliente 17', 'Rua 17', 6, 'cliente_17@email.com', '(21) 0000-0000', NULL,             NULL), 
	   ('Cliente 18', 'Rua 18', 6, 'cliente_18@email.com', '(21) 0000-0000', '(21) 1111-1111', '(21) 2222-2222'), 
	   ('Cliente 19', 'Rua 19', 7, 'cliente_19@email.com', '(31) 0000-0000', '(31) 1111-1111', '(31) 2222-2222'), 
	   ('Cliente 20', 'Rua 20', 7, 'cliente_20@email.com', '(31) 0000-0000', '(31) 1111-1111', '(31) 2222-2222'), 
	   ('Cliente 21', 'Rua 21', 7, 'cliente_21@email.com', '(31) 0000-0000', '(31) 1111-1111', '(31) 2222-2222'), 
	   ('Cliente 22', 'Rua 22', 8, 'cliente_22@email.com', '(31) 0000-0000', '(31) 1111-1111', '(31) 2222-2222'), 
	   ('Cliente 23', 'Rua 23', 8, 'cliente_23@email.com', '(31) 0000-0000', '(31) 1111-1111', '(31) 2222-2222'), 
	   ('Cliente 24', 'Rua 24', 8, 'cliente_24@email.com', '(31) 0000-0000', '(31) 1111-1111', '(31) 2222-2222'), 
	   ('Cliente 25', 'Rua 25', 9, 'cliente_25@email.com', '(31) 0000-0000', NULL,             NULL), 
	   ('Cliente 26', 'Rua 26', 9, 'cliente_26@email.com', '(31) 0000-0000', '(31) 1111-1111', '(31) 2222-2222'), 
	   ('Cliente 27', 'Rua 27', 9, 'cliente_27@email.com', '(31) 0000-0000', '(31) 1111-1111', NULL) 

/*
Criação de uma tabela para cadastro simples de produtos
*/

CREATE TABLE dbo.Produto 
(
	Id SMALLINT IDENTITY(1, 1) NOT NULL, 
	Descricao VARCHAR(250) NOT NULL, 
	CONSTRAINT PK_Produto PRIMARY KEY (Id) 
) 

/*
Criação de um índice auxiliar, para filtragem à partir da coluna Descricao da tabela Produto
*/

CREATE NONCLUSTERED INDEX IDX_Produto_Descricao ON dbo.Produto (Descricao) 

INSERT INTO dbo.Produto (Descricao) 
VALUES ('Produto A'), 
       ('Produto B'), 
       ('Produto C')

/*
Criação de uma tabela de vendas que irá unir informações de clientes e produtos
*/

CREATE TABLE dbo.Vendas 
(
	Id BIGINT IDENTITY(1, 1) NOT NULL, 
	Pedido UNIQUEIDENTIFIER NOT NULL, 
	Id_Cliente INTEGER NOT NULL, 
	Id_Produto SMALLINT NOT NULL, 
	Quantidade SMALLINT NOT NULL, 
	"Valor Unitario" NUMERIC(9, 2) NOT NULL, 
	"Data Venda" SMALLDATETIME NOT NULL, 
	Observacao NVARCHAR(100) NULL, 
	CONSTRAINT PK_Vendas PRIMARY KEY (Id, Id_Cliente, Id_Produto), 
	CONSTRAINT UC_Vendas_Pedido_Cliente_Produto UNIQUE (Pedido, Id_Cliente, Id_Produto), 
	CONSTRAINT FK_CadastroCliente_Vendas FOREIGN KEY (Id_Cliente) REFERENCES CadastroCliente (Id), 
	CONSTRAINT FK_Produto_Vendas FOREIGN KEY (Id_Produto) REFERENCES Produto (Id) 
) 

/*
Criação de um índice auxiliar, para uso no JOIN através das colunas Id_Cliente (com a tabela CadastroCliente) e Id_Produto (com a tabela Produto) 
*/

CREATE NONCLUSTERED INDEX IDX_Vendas_Id_Cliente ON dbo.Vendas (Id_Cliente) 
CREATE NONCLUSTERED INDEX IDX_Vendas_Id_Produto ON dbo.Vendas (Id_Produto) 

/*
Criação de um índice auxiliar, para filtragem à partir da coluna DataVenda da tabela Vendas
*/

CREATE NONCLUSTERED INDEX IDX_Vendas_DataVenda ON dbo.Vendas("Data Venda") INCLUDE (Quantidade, "Valor Unitario") 
GO 

CREATE PROCEDURE dbo.PopularVendas 
AS 
BEGIN 
	DECLARE @DataInicial SMALLDATETIME = CAST('2000-01-01' AS SMALLDATETIME) 
	DECLARE @DataFinal SMALLDATETIME = CAST('2020-12-15' AS SMALLDATETIME) 
	DECLARE @DataAtual SMALLDATETIME = @DataInicial
	DECLARE @Bloco SMALLINT = 5000 
	DECLARE @BlocoAtual SMALLINT = 0 
	DECLARE @Pedido UNIQUEIDENTIFIER 

	BEGIN TRANSACTION 

	WHILE (@DataFinal > @DataAtual) 
	BEGIN 
		IF (@BlocoAtual >= @Bloco) 
		BEGIN 
			COMMIT TRANSACTION 
			BEGIN TRANSACTION 
			SET @BlocoAtual = 0 
		END 

		SET @Pedido = NEWID() 

		INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
		VALUES (@Pedido, 1, 1, 10, 5.65, @DataAtual), 
			   (@Pedido, 1, 2, 10, 7.65, @DataAtual)
				
		SET @Pedido = NEWID() 

		INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
		VALUES (@Pedido, 2, 1, 20, 5.65, @DataAtual), 
			   (@Pedido, 2, 2, 20, 7.65, @DataAtual) 
		
		SET @Pedido = NEWID() 

		INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
		VALUES (@Pedido, 3, 1, 30, 5.65, @DataAtual) 

		SET @Pedido = NEWID() 

		INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
		VALUES (@Pedido, 4, 2, 40, 7.65, @DataAtual) 

		SET @Pedido = NEWID() 

		INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
		VALUES (@Pedido, 5, 1, 50, 5.65, @DataAtual), 
			   (@Pedido, 5, 2, 50, 7.65, @DataAtual) 
	
		SET @Pedido = NEWID() 

		INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
		VALUES (@Pedido, 6, 2, 60, 7.65, @DataAtual) 

		SET @Pedido = NEWID() 

		INSERT INTO dbo.Vendas (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
		VALUES (@Pedido, 7, 1, 70, 5.65, @DataAtual) 

		SET @DataAtual = DATEADD(d, 1, @DataAtual)
		SET @BlocoAtual = @BlocoAtual + 10 
	END 

	IF (@BlocoAtual > 0) 
	BEGIN 
		COMMIT TRANSACTION 
	END 
END 
GO 

EXEC dbo.PopularVendas 
GO 

-- ***************************************************************
-- ***************************************************************
-- ***************************************************************
-- ***************************************************************

/*
Demonstração de como pegar informações de Vendas agrupadas por ano, para trazer informações da quantidade total somada por ano e do valor total de vendas somada por ano
*/

SELECT YEAR(V."Data Venda") AS "Ano da venda", 
       SUM(V.Quantidade) AS "Quantidade vendida", 
	   (SUM(V.Quantidade) * SUM(V."Valor Unitario")) AS "Valor total das vendas" 
  FROM dbo.Vendas AS V WITH (READUNCOMMITTED) 
 GROUP BY YEAR(V."Data Venda") 
 ORDER BY "Ano da venda" DESC 
 
SELECT V.Quantidade 
  FROM dbo.Vendas AS V WITH (READUNCOMMITTED) 
 WHERE V."Data Venda" >= CAST('2020-01-01' AS SMALLDATETIME) 
   AND V."Data Venda" < CAST('2021-01-01' AS SMALLDATETIME) 

/*
Demonstração de como pegar informações de Vendas agrupadas por cliente, para trazer informações da quantidade total somada por ano e do valor total de vendas somada por cliente
*/

SELECT Cliente.Nome AS "Cliente", 
       COALESCE(SUM(V.Quantidade), 0) AS "Quantidade vendida", 
	   (COALESCE(SUM(V.Quantidade), 0) * COALESCE(SUM(V."Valor Unitario"), 0)) AS "Valor total das vendas" 
  FROM dbo.CadastroCliente AS Cliente 
  LEFT JOIN dbo.Vendas     AS V WITH (READUNCOMMITTED) ON (Cliente.Id = V.Id_Cliente) 
 GROUP BY Cliente.Nome 
 ORDER BY Cliente.Nome 
 
SELECT Cliente.Nome AS "Cliente", 
       SUM(V.Quantidade) AS "Quantidade vendida", 
	   (SUM(V.Quantidade) * SUM(V."Valor Unitario")) AS "Valor total das vendas" 
  FROM dbo.CadastroCliente AS Cliente 
  LEFT JOIN dbo.Vendas     AS V WITH (READUNCOMMITTED) ON (Cliente.Id = V.Id_Cliente) 
 GROUP BY Cliente.Nome 
 ORDER BY Cliente.Nome 

/*
Demonstração de como pegar informações de Vendas agrupadas por ano, pode-se utilizar filtros antes do agrupamento ser processado
*/

SELECT YEAR(V."Data Venda") AS "Ano da venda", 
       SUM(V.Quantidade) AS "Quantidade vendida", 
	   (SUM(V.Quantidade) * SUM(V."Valor Unitario")) AS "Valor total das vendas" 
  FROM dbo.Vendas AS V WITH (READUNCOMMITTED) 
 WHERE V."Data Venda" >= CAST('2015-01-01' AS SMALLDATETIME) 
 GROUP BY YEAR(V."Data Venda") 
 ORDER BY "Ano da venda" DESC 

/*
Demonstração de como pegar informações de Vendas agrupadas por ano, uma vez agrupadas as linhas é possível filtrar pela coluna de agrupamento
*/

SELECT Cliente.Nome AS "Cliente", 
       COALESCE(SUM(V.Quantidade), 0) AS "Quantidade vendida", 
	   (COALESCE(SUM(V.Quantidade), 0) * COALESCE(SUM(V."Valor Unitario"), 0)) AS "Valor total das vendas" 
  FROM dbo.CadastroCliente AS Cliente 
  LEFT JOIN dbo.Vendas     AS V WITH (READUNCOMMITTED) ON (Cliente.Id = V.Id_Cliente) 
 GROUP BY Cliente.Nome 
HAVING COALESCE(SUM(V.Quantidade), 0) > 0 
 ORDER BY Cliente.Nome 

/*
Demonstração de como pegar informações de Vendas agrupadas por cliente e ano, utilizando filtro (WHERE), agrupamento por mais de uma coluna e filtro após agrupamento processado
*/

SELECT Cliente.Nome AS "Cliente", 
       YEAR(V."Data Venda") AS "Ano da venda", 
       COALESCE(SUM(V.Quantidade), 0) AS "Quantidade vendida", 
	   (COALESCE(SUM(V.Quantidade), 0) * COALESCE(SUM(V."Valor Unitario"), 0)) AS "Valor total das vendas" 
  FROM dbo.CadastroCliente AS Cliente 
  LEFT JOIN dbo.Vendas     AS V WITH (READUNCOMMITTED) ON (Cliente.Id = V.Id_Cliente) 
 WHERE V."Data Venda" >= CAST('2015-01-01' AS SMALLDATETIME) 
 GROUP BY Cliente.Nome, YEAR(V."Data Venda") 
HAVING COALESCE(SUM(V.Quantidade), 0) > 0 
 ORDER BY Cliente.Nome 

/*
Demonstração de como pegar informações de Vendas agrupadas por cliente e ano, além disso utilizando outras funções de agregação
*/

SELECT Cliente.Nome AS "Cliente", 
       YEAR(V."Data Venda") AS "Ano da venda", 
	   CAST(MIN(V."Data Venda") AS DATE) AS "Primeira venda", 
	   CAST(MAX(V."Data Venda") AS DATE) AS "Última venda", 
       COALESCE(SUM(V.Quantidade), 0) AS "Quantidade vendida", 
	   (COALESCE(SUM(V.Quantidade), 0) * COALESCE(SUM(V."Valor Unitario"), 0)) AS "Valor total das vendas" 
  FROM dbo.CadastroCliente AS Cliente 
  LEFT JOIN dbo.Vendas     AS V WITH (READUNCOMMITTED) ON (Cliente.Id = V.Id_Cliente) 
 WHERE V."Data Venda" >= CAST('2015-01-01' AS SMALLDATETIME) 
 GROUP BY Cliente.Nome, YEAR(V."Data Venda") 
HAVING COALESCE(SUM(V.Quantidade), 0) > 0 
 ORDER BY Cliente.Nome 

/*
Demonstração de como pegar informações de Vendas agrupadas por cliente e ano, utilizando COUNT como agregação para contagem de linhas do que foi agregado
*/

SELECT Cliente.Nome AS "Cliente", 
       YEAR(V."Data Venda") AS "Ano da venda", 
	   P.Descricao AS "Produto", 
       CAST(MIN(V."Data Venda") AS DATE) AS "Primeira venda", 
	   CAST(MAX(V."Data Venda") AS DATE) AS "Última venda", 
       COALESCE(SUM(V.Quantidade), 0) AS "Quantidade vendida", 
	   (COALESCE(SUM(V.Quantidade), 0) * COALESCE(SUM(V."Valor Unitario"), 0)) AS "Valor total das vendas"
  FROM dbo.CadastroCliente AS Cliente 
  LEFT JOIN dbo.Vendas     AS V WITH (READUNCOMMITTED) ON (Cliente.Id = V.Id_Cliente) 
  LEFT JOIN dbo.Produto    AS P ON (V.Id_Produto = P.Id) 
 WHERE V."Data Venda" >= CAST('2015-01-01' AS SMALLDATETIME) 
 GROUP BY Cliente.Nome, P.Descricao, YEAR(V."Data Venda") 
HAVING COALESCE(SUM(V.Quantidade), 0) > 0 
 ORDER BY Cliente.Nome, YEAR(V."Data Venda"), P.Descricao 

SELECT Cliente.Nome AS "Cliente", 
       YEAR(V."Data Venda") AS "Ano da venda", 
       CAST(MIN(V."Data Venda") AS DATE) AS "Primeira venda", 
	   CAST(MAX(V."Data Venda") AS DATE) AS "Última venda", 
       COALESCE(SUM(V.Quantidade), 0) AS "Quantidade vendida", 
	   (COALESCE(SUM(V.Quantidade), 0) * COALESCE(SUM(V."Valor Unitario"), 0)) AS "Valor total das vendas", 
	   COUNT(DISTINCT V."Data Venda") AS "Total de vendas do ano", 
	   COUNT(*) AS "Total de itens vendidos no ano" 
  FROM dbo.CadastroCliente AS Cliente 
  LEFT JOIN dbo.Vendas     AS V WITH (READUNCOMMITTED) ON (Cliente.Id = V.Id_Cliente) 
 WHERE V."Data Venda" >= CAST('2015-01-01' AS SMALLDATETIME) 
 GROUP BY Cliente.Nome, YEAR(V."Data Venda") 
HAVING COALESCE(SUM(V.Quantidade), 0) > 0 
 ORDER BY Cliente.Nome, YEAR(V."Data Venda") 
 
SELECT Cliente.Nome AS "Cliente", 
       YEAR(V."Data Venda") AS "Ano da venda", 
       CAST(MIN(V."Data Venda") AS DATE) AS "Primeira venda", 
	   CAST(MAX(V."Data Venda") AS DATE) AS "Última venda", 
       COALESCE(SUM(V.Quantidade), 0) AS "Quantidade vendida", 
	   (COALESCE(SUM(V.Quantidade), 0) * COALESCE(SUM(V."Valor Unitario"), 0)) AS "Valor total das vendas", 
	   COUNT(DISTINCT V."Data Venda") AS "Total de vendas do ano", 
	   COUNT(*) AS "Total de itens vendidos no ano" 
  FROM dbo.CadastroCliente AS Cliente 
  LEFT JOIN dbo.Vendas     AS V WITH (READUNCOMMITTED) ON (Cliente.Id = V.Id_Cliente) 
 WHERE V."Data Venda" >= CAST('2015-01-01' AS SMALLDATETIME) 
 GROUP BY Cliente.Nome, YEAR(V."Data Venda") 
HAVING COUNT(DISTINCT V."Data Venda") = 365
 ORDER BY Cliente.Nome, YEAR(V."Data Venda") 

/*
Demonstração de como pegar informações de Vendas por janelas de linhas, no exemplo abaixo é por "pedido de venda" comparando o total geral
*/
SELECT Id, Pedido, Id_Cliente, Id_Produto, "Data Venda", Quantidade, "Valor Unitario" 
  FROM dbo.Vendas 
 WHERE Pedido = CAST('E82E988A-FBF5-46DB-A1C9-93D1A6D12440' AS UNIQUEIDENTIFIER) 

SELECT V.Pedido AS "Código da venda", V.Id_Produto, 
       SUM(V.Quantidade) OVER(PARTITION BY V.Pedido) AS "Quantidade da venda", 
       SUM(V.Quantidade * V."Valor Unitario") OVER(PARTITION BY V.Pedido) AS "Valor total da venda", 
	   SUM(V.Quantidade) OVER() AS "Quantidade total geral", 
	   SUM(V.Quantidade * V."Valor Unitario") OVER() AS "Valor total geral" 
  FROM dbo.Vendas AS V WITH (READUNCOMMITTED) 
 WHERE V."Data Venda" >= CAST('2020-01-01' AS SMALLDATETIME) 
   AND V."Data Venda" < CAST('2021-01-01' AS SMALLDATETIME) 

/*
Demonstração de como pegar informações de Vendas por janelas de linhas, no exemplo abaixo várias visões de uma mesma venda
*/

SELECT Id, Pedido, Id_Cliente, Id_Produto, "Data Venda", Quantidade, "Valor Unitario" 
  FROM dbo.Vendas 
 WHERE Pedido = CAST('4E4A9B67-FF78-4611-A391-000C5048C245' AS UNIQUEIDENTIFIER) 

SELECT V.Pedido AS "Pedido", 
       Cliente.Nome AS "Cliente", 
	   P.Descricao AS "Produto", 
       SUM(V.Quantidade) OVER(PARTITION BY V.Pedido, V.Id_Cliente, V.Id_Produto) AS "Quantidade da venda por cliente e produto", 
       SUM(V.Quantidade * V."Valor Unitario") OVER(PARTITION BY V.Pedido, V.Id_Cliente, V.Id_Produto) AS "Valor da venda por cliente e produto", 
       SUM(V.Quantidade) OVER(PARTITION BY V.Pedido, V.Id_Cliente) AS "Quantidade da venda por cliente", 
       SUM(V.Quantidade * V."Valor Unitario") OVER(PARTITION BY V.Pedido, V.Id_Cliente) AS "Valor da venda por cliente", 
	   SUM(V.Quantidade) OVER() AS "Quantidade total geral", 
       SUM(V.Quantidade * V."Valor Unitario") OVER() AS "Valor total geral" 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE V."Data Venda" >= CAST('2020-01-01' AS SMALLDATETIME) 
   AND V."Data Venda" < CAST('2021-01-01' AS SMALLDATETIME) 
 ORDER BY "Pedido", "Cliente", "Produto" 

/*
Demonstração de como pegar informações de Vendas por janelas de linhas, no exemplo abaixo várias visões de uma mesma venda com as representações em percentual de cada janela de agrupamento
*/

SELECT V.Pedido AS "Pedido", 
       Cliente.Nome AS "Cliente", 
	   P.Descricao AS "Produto", 
       V.Quantidade, 
       (V.Quantidade * V."Valor Unitario") AS "Vlr cli e prod", 
       SUM(V.Quantidade) OVER(PARTITION BY V.Pedido, V.Id_Cliente) AS "Qtde cli", 
       SUM(V.Quantidade * V."Valor Unitario") OVER(PARTITION BY V.Pedido, V.Id_Cliente) AS "Vlr cli", 
	   SUM(V.Quantidade) OVER() AS "Qtde tot", 
       SUM(V.Quantidade * V."Valor Unitario") OVER() AS "Vlr tot", 
       CAST(100.0 * V.Quantidade / SUM(V.Quantidade) OVER(PARTITION BY V.Pedido, V.Id_Cliente, V.Id_Produto) AS NUMERIC(15, 9)) AS "% qtde cli e prod", 
       CAST(100.0 * V.Quantidade / SUM(V.Quantidade) OVER(PARTITION BY V.Pedido, V.Id_Cliente) AS NUMERIC(15, 9)) AS "% qtde cli", 
       CAST(100.0 * V.Quantidade / SUM(V.Quantidade) OVER() AS NUMERIC(15, 9)) AS "% qtde tot", 
       CAST(100.0 * (V.Quantidade * V."Valor Unitario") / 
			SUM((V.Quantidade * V."Valor Unitario")) OVER(PARTITION BY V.Pedido, V.Id_Cliente, V.Id_Produto) AS NUMERIC(15, 9)) AS "% vlr cli e prod", 
       CAST(100.0 * (V.Quantidade * V."Valor Unitario") / 
			SUM((V.Quantidade * V."Valor Unitario")) OVER(PARTITION BY V.Pedido, V.Id_Cliente) AS NUMERIC(15, 9)) AS "% vlr cli", 
       CAST(100.0 * (V.Quantidade * V."Valor Unitario") / 
			SUM((V.Quantidade * V."Valor Unitario")) OVER() AS NUMERIC(15, 9)) AS "% vlr tot" 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 
 WHERE V."Data Venda" >= CAST('2020-01-01' AS SMALLDATETIME) 
   AND V."Data Venda" < CAST('2021-01-01' AS SMALLDATETIME) 
 ORDER BY "Pedido", "Cliente", "Produto" 

/*
Demonstração de como pegar informações de Vendas por janelas de linhas, no exemplo abaixo a última coluna mostra o valor somado a cada item de cada pedido
*/

SELECT Id, Pedido, Id_Cliente, Id_Produto, "Data Venda", Quantidade, "Valor Unitario" 
  FROM dbo.Vendas 
 WHERE Pedido = CAST('8820855F-3AA0-43C7-9E24-0A922D762626' AS UNIQUEIDENTIFIER) 

SELECT CAST(V."Data Venda" AS DATE) AS "Data da venda", V.Pedido AS "Código do pedido", 
       P.Descricao AS "Produto", 
       SUM(V.Quantidade * V."Valor Unitario") OVER (PARTITION BY V.Pedido 
	                                                 ORDER BY V."Data Venda", V.Pedido, P.Descricao 
												      ROWS BETWEEN UNBOUNDED PRECEDING 
														       AND CURRENT ROW) AS "Vendido no pedido" 
  FROM dbo.Vendas       AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.Produto AS P ON (V.Id_Produto = P.Id) 
 WHERE V."Data Venda" >= CAST('2020-01-01' AS SMALLDATETIME) 
   AND V."Data Venda" < CAST('2021-01-01' AS SMALLDATETIME) 
 ORDER BY "Data da venda", "Código do pedido", "Produto" 

SELECT CAST(V."Data Venda" AS DATE) AS "Data da venda", V.Pedido AS "Código do pedido", 
       P.Descricao AS "Produto", 
       SUM(V.Quantidade * V."Valor Unitario") OVER (PARTITION BY V.Pedido 
	                                                 ORDER BY V."Data Venda", V.Pedido, P.Descricao 
													  ROWS UNBOUNDED PRECEDING) AS "Vendido no pedido" 
  FROM dbo.Vendas       AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.Produto AS P ON (V.Id_Produto = P.Id) 
 WHERE V."Data Venda" >= CAST('2020-01-01' AS SMALLDATETIME) 
   AND V."Data Venda" < CAST('2021-01-01' AS SMALLDATETIME) 
 ORDER BY "Data da venda", "Código do pedido", "Produto" 