--https://docs.microsoft.com/pt-br/sql/t-sql/language-elements/case-transact-sql?view=sql-server-ver15

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

IF EXISTS(SELECT * FROM sys.tables WHERE name = 'VendasHistorico')  
BEGIN 
	DROP TABLE dbo.VendasHistorico 
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

CREATE TABLE dbo.VendasHistorico 
(
	Pedido UNIQUEIDENTIFIER NOT NULL, 
	Id_Cliente INTEGER NOT NULL, 
	Id_Produto SMALLINT NOT NULL, 
	Quantidade SMALLINT NOT NULL, 
	"Valor Unitario" NUMERIC(9, 2) NOT NULL, 
	"Data Venda" SMALLDATETIME NOT NULL, 
	Observacao NVARCHAR(100) NULL
) 
GO 

INSERT INTO dbo.VendasHistorico (Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
VALUES (CAST('F06F759B-09AB-4A12-AAC1-2962659E66F0' AS UNIQUEIDENTIFIER), 1, 1, 500, 5.65, CAST('1999-01-01' AS SMALLDATETIME))
GO

-- ***************************************************************
-- ***************************************************************
-- ***************************************************************
-- ***************************************************************

--CASE Simples
SELECT V.Pedido, 
       C.Nome AS Cliente, 
	   P.Descricao AS Produto, 
	   V.Quantidade, V."Valor Unitario", V."Data Venda", 
	   CASE V.Id_Produto 
			WHEN 1 THEN 'Time 1' 
			WHEN 2 THEN 'Time 2' 
			ELSE 'Sem time' 
	   END AS "Time Produto", V.Id_Produto 
  FROM dbo.Vendas AS V 
 INNER JOIN dbo.CadastroCliente AS C 
    ON (V.Id_Cliente = C.Id) 
 INNER JOIN dbo.Produto AS P 
    ON (V.Id_Produto = P.Id) 
 WHERE "Data Venda" <= CAST('2000-12-31' AS SMALLDATETIME) 

--Searched CASE
SELECT V.Pedido, 
       C.Nome AS Cliente, 
	   P.Descricao AS Produto, 
	   V.Quantidade, V."Valor Unitario", V."Data Venda", 
	   CASE WHEN V.Quantidade = 10 THEN 'Só 10' 
			WHEN V.Quantidade > 10 AND V.Quantidade <= 35 THEN 'Maior que 10, menor ou igual a 35' 
			WHEN V.Quantidade > 35 AND V.Quantidade <= 60 THEN 'Maior que 35, menor ou igual a 60' 
			ELSE 'Mensagem Quantidade' 
	   END AS "Time Produto" 
  FROM dbo.Vendas AS V 
 INNER JOIN dbo.CadastroCliente AS C 
    ON (V.Id_Cliente = C.Id) 
 INNER JOIN dbo.Produto AS P 
    ON (V.Id_Produto = P.Id) 
 WHERE "Data Venda" <= CAST('2000-12-31' AS SMALLDATETIME) 

--CASE no ORDER BY
SELECT V.Pedido, 
       C.Nome AS Cliente, 
	   P.Descricao AS Produto, 
	   V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas AS V 
 INNER JOIN dbo.CadastroCliente AS C 
    ON (V.Id_Cliente = C.Id) 
 INNER JOIN dbo.Produto AS P 
    ON (V.Id_Produto = P.Id) 
 WHERE "Data Venda" <= CAST('2000-12-31' AS SMALLDATETIME) 
 ORDER BY V.Id_Produto, 
          CASE V.Id_Produto WHEN 1 THEN V.Quantidade END, 
          CASE WHEN V.Id_Produto = 2 THEN V.Quantidade END DESC 

--CASE no UPDATE
SELECT V.Pedido, 
       C.Nome AS Cliente, 
	   P.Descricao AS Produto, 
	   V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas AS V 
 INNER JOIN dbo.CadastroCliente AS C 
    ON (V.Id_Cliente = C.Id) 
 INNER JOIN dbo.Produto AS P 
    ON (V.Id_Produto = P.Id) 
 WHERE "Data Venda" <= CAST('2000-12-31' AS SMALLDATETIME) 

UPDATE dbo.Vendas 
   SET "Valor Unitario" = CASE Id_Produto 
                               WHEN 1 THEN 15.75 
							   WHEN 2 THEN 22.35 
							   ELSE 10.00 
						  END 
 WHERE "Data Venda" <= CAST('2000-12-31' AS SMALLDATETIME) 

SELECT V.Pedido, 
       C.Nome AS Cliente, 
	   P.Descricao AS Produto, 
	   V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas AS V 
 INNER JOIN dbo.CadastroCliente AS C 
    ON (V.Id_Cliente = C.Id) 
 INNER JOIN dbo.Produto AS P 
    ON (V.Id_Produto = P.Id) 
 WHERE "Data Venda" <= CAST('2000-12-31' AS SMALLDATETIME) 

--CASE no DELETE
UPDATE dbo.Vendas 
   SET "Valor Unitario" = 50.55 
 WHERE "Data Venda" >= CAST('2020-01-01' AS SMALLDATETIME) 

SELECT V.Pedido, 
       C.Nome AS Cliente, 
	   P.Descricao AS Produto, 
	   V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas AS V 
 INNER JOIN dbo.CadastroCliente AS C 
    ON (V.Id_Cliente = C.Id) 
 INNER JOIN dbo.Produto AS P 
    ON (V.Id_Produto = P.Id) 
 WHERE "Data Venda" >= CAST('2020-01-01' AS SMALLDATETIME) 
 
DELETE FROM dbo.Vendas 
 WHERE "Data Venda" >= CAST('2020-01-01' AS SMALLDATETIME) 
   AND CASE Id_Produto 
			WHEN 1 THEN Quantidade 
			WHEN 2 THEN "Valor Unitario" 
			ELSE 0 END >= 50 

SELECT V.Pedido, 
       C.Nome AS Cliente, 
	   P.Descricao AS Produto, 
	   V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas AS V 
 INNER JOIN dbo.CadastroCliente AS C 
    ON (V.Id_Cliente = C.Id) 
 INNER JOIN dbo.Produto AS P 
    ON (V.Id_Produto = P.Id) 
 WHERE "Data Venda" >= CAST('2020-01-01' AS SMALLDATETIME) 

--CASE no SET
DECLARE @Id UNIQUEIDENTIFIER = CAST('F06F759B-09AB-4A12-AAC1-2962659E66F0' AS UNIQUEIDENTIFIER) 
--DECLARE @Id UNIQUEIDENTIFIER = NEWID() 

DECLARE @Onde AS VARCHAR(20) 

SET @Onde = 
	CASE 
		WHEN EXISTS(SELECT * FROM dbo.VendasHistorico WHERE Pedido = @Id) 
			THEN 'Vendas Histórico' 

		WHEN EXISTS(SELECT * FROM dbo.Vendas WHERE Pedido = @Id) 
			THEN 'Vendas' 

		ELSE 'Nenhum lugar' 
	END 

SELECT @Onde 

--CASE na cláusula HAVING
SELECT C.Nome AS Cliente, 
       P.Descricao AS Produto, 
	   MAX(V.Quantidade) AS Quantidade 
  FROM dbo.Vendas AS V 
 INNER JOIN dbo.CadastroCliente AS C 
    ON (V.Id_Cliente = C.Id) 
 INNER JOIN dbo.Produto AS P 
    ON (V.Id_Produto = P.Id) 
 WHERE "Data Venda" <= CAST('2000-12-31' AS SMALLDATETIME) 
 GROUP BY C.Nome, P.Descricao 
HAVING (   MAX(CASE WHEN P.Descricao = 'Produto A' 
					THEN V.Quantidade 
					ELSE NULL END) > 40 
		OR MAX(CASE WHEN P.Descricao = 'Produto B' 
					THEN V.Quantidade 
					ELSE NULL END) > 50) 
 ORDER BY Quantidade DESC 

--COALESCE
/*
CASE  
WHEN (expression1 IS NOT NULL) THEN expression1  
WHEN (expression2 IS NOT NULL) THEN expression2  
...  
ELSE expressionN  
END  
*/
DECLARE @VARUM VARCHAR(10) 
DECLARE @VARDOIS VARCHAR(10) 
DECLARE @VARTRES VARCHAR(10) 

SELECT COALESCE(@VARUM, @VARDOIS, @VARTRES, 'Nada') 

SET @VARTRES = 'Valor Três' 

SELECT COALESCE(@VARUM, @VARDOIS, @VARTRES, 'Nada') 

SET @VARDOIS = 'Valor Dois' 

SELECT COALESCE(@VARUM, @VARDOIS, @VARTRES, 'Nada') 

SET @VARUM = 'Valor Um' 

SELECT COALESCE(@VARUM, @VARDOIS, @VARTRES, 'Nada') 

SELECT ISNULL(@VARUM, 'Nada') 

SET @VARUM = NULL

SELECT ISNULL(@VARUM, 'Nada') 

SELECT Nome AS Cliente, 
       COALESCE(Telefone3, Telefone2, Telefone1, 'Sem telefone') AS Telefone, 
	   Telefone3, Telefone2, Telefone1 
  FROM dbo.CadastroCliente 

--NULLIF
/*
CASE  
WHEN (expression1 = expression2) THEN NULL 
ELSE expression1  
END  
*/
DECLARE @Quantidade INT = 40 

SELECT NULLIF(40, @Quantidade) 
SELECT NULLIF(50, @Quantidade) 
SELECT NULLIF(@Quantidade, 50) 

SELECT V.Pedido, 
       C.Nome AS Cliente, 
	   P.Descricao AS Produto, 
	   V.Quantidade, 
	   NULLIF(V.Quantidade, @Quantidade) AS "Quantidade que não quero", 
	   V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas AS V 
 INNER JOIN dbo.CadastroCliente AS C 
    ON (V.Id_Cliente = C.Id) 
 INNER JOIN dbo.Produto AS P 
    ON (V.Id_Produto = P.Id) 
 WHERE "Data Venda" <= CAST('2000-12-31' AS SMALLDATETIME) 