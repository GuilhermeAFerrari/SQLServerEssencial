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
	Id BIGINT NOT NULL, 
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

		INSERT INTO dbo.Vendas (Id, Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
		VALUES ((SELECT COALESCE(MAX(Id), 0) + 1 FROM dbo.Vendas), @Pedido, 1, 1, 10, 5.65, @DataAtual), 
			   ((SELECT COALESCE(MAX(Id), 0) + 2 FROM dbo.Vendas), @Pedido, 1, 2, 10, 7.65, @DataAtual)
				
		SET @Pedido = NEWID() 

		INSERT INTO dbo.Vendas (Id, Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
		VALUES ((SELECT COALESCE(MAX(Id), 0) + 1 FROM dbo.Vendas), @Pedido, 2, 1, 20, 5.65, @DataAtual), 
			   ((SELECT COALESCE(MAX(Id), 0) + 2 FROM dbo.Vendas), @Pedido, 2, 2, 20, 7.65, @DataAtual) 
		
		SET @Pedido = NEWID() 

		INSERT INTO dbo.Vendas (Id, Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
		VALUES ((SELECT COALESCE(MAX(Id), 0) + 1 FROM dbo.Vendas), @Pedido, 3, 1, 30, 5.65, @DataAtual) 

		SET @Pedido = NEWID() 

		INSERT INTO dbo.Vendas (Id, Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
		VALUES ((SELECT COALESCE(MAX(Id), 0) + 1 FROM dbo.Vendas), @Pedido, 4, 2, 40, 7.65, @DataAtual) 

		SET @Pedido = NEWID() 

		INSERT INTO dbo.Vendas (Id, Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
		VALUES ((SELECT COALESCE(MAX(Id), 0) + 1 FROM dbo.Vendas), @Pedido, 5, 1, 50, 5.65, @DataAtual), 
			   ((SELECT COALESCE(MAX(Id), 0) + 2 FROM dbo.Vendas), @Pedido, 5, 2, 50, 7.65, @DataAtual) 
	
		SET @Pedido = NEWID() 

		INSERT INTO dbo.Vendas (Id, Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
		VALUES ((SELECT COALESCE(MAX(Id), 0) + 1 FROM dbo.Vendas), @Pedido, 6, 2, 60, 7.65, @DataAtual) 

		SET @Pedido = NEWID() 

		INSERT INTO dbo.Vendas (Id, Pedido, Id_Cliente, Id_Produto, Quantidade, "Valor Unitario", "Data Venda") 
		VALUES ((SELECT COALESCE(MAX(Id), 0) + 1 FROM dbo.Vendas), @Pedido, 7, 1, 70, 5.65, @DataAtual) 

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
Demonstração de uso de uma Sequence Object para preencher número default ao fazer Insert
*/

CREATE SEQUENCE dbo.SeqIdVendas AS BIGINT 
 START WITH 1000000 
 INCREMENT BY 10 
 MINVALUE 1000000 
 MAXVALUE 10000000 
 CYCLE 
 CACHE 100; 

SELECT NEXT VALUE FOR dbo.SeqIdVendas 

ALTER TABLE dbo.Vendas ADD CONSTRAINT DF_Vendas_Id_Sequence 
DEFAULT (NEXT VALUE FOR dbo.SeqIdVendas) FOR Id 

INSERT INTO dbo.Vendas (Pedido, Id_Produto, Id_Cliente, Quantidade, "Valor Unitario", "Data Venda")  
VALUES (NEWID(), 1, 1, 10, 5, '2050-01-01') 

SELECT Id, Pedido, Id_Produto, Id_Cliente, Quantidade, "Valor Unitario", "Data Venda"  
  FROM dbo.Vendas 
 WHERE Id >= 1000000

/*
Demonstração de uso de uma Sequence Object para preencher número sem o default constraint
*/

ALTER TABLE dbo.Vendas DROP CONSTRAINT DF_Vendas_Id_Sequence 

INSERT INTO dbo.Vendas (Id, Pedido, Id_Produto, Id_Cliente, Quantidade, "Valor Unitario", "Data Venda")  
VALUES ((NEXT VALUE FOR dbo.SeqIdVendas), NEWID(), 1, 1, 10, 5, CURRENT_TIMESTAMP), 
       ((NEXT VALUE FOR dbo.SeqIdVendas), NEWID(), 1, 1, 10, 5, CURRENT_TIMESTAMP), 
	   ((NEXT VALUE FOR dbo.SeqIdVendas), NEWID(), 1, 1, 10, 5, CURRENT_TIMESTAMP), 
	   ((NEXT VALUE FOR dbo.SeqIdVendas), NEWID(), 1, 1, 10, 5, CURRENT_TIMESTAMP), 
	   ((NEXT VALUE FOR dbo.SeqIdVendas), NEWID(), 1, 1, 10, 5, CURRENT_TIMESTAMP) 

SELECT Id, Pedido, Id_Produto, Id_Cliente, Quantidade, "Valor Unitario", "Data Venda"  
  FROM dbo.Vendas 
 WHERE Id >= 1000000 

/*
Demonstração de uso do OUTPUT Option com Insert
*/

DECLARE @Produto TABLE 
(
	Id SMALLINT NOT NULL, 
	Descricao VARCHAR(250) NOT NULL 
) 

INSERT INTO dbo.Produto (Descricao) 
  OUTPUT 
    inserted.Id, inserted.Descricao 
    INTO @Produto(Id, Descricao) 
  VALUES ('Produto D') 

SELECT Id, Descricao 
  FROM dbo.Produto 

SELECT Id, Descricao 
  FROM @Produto 

/*
Demonstração de uso do OUTPUT Option com Delete
*/

DELETE FROM dbo.Produto 
  OUTPUT deleted.Id, deleted.Descricao 
 WHERE Descricao = 'Produto D' 
 
/*
Demonstração de uso do OUTPUT Option com Update
*/

DECLARE @ProdutoAntesDepois TABLE 
(
	Id SMALLINT NOT NULL, 
	DescricaoAntes VARCHAR(250) NOT NULL, 
	DescricaoAtual VARCHAR(250) NOT NULL 
) 

SELECT Id, Descricao 
  FROM dbo.Produto 
 WHERE Id = 3 

UPDATE dbo.Produto 
   SET Descricao = 'Produto X' 
   OUTPUT inserted.Id, deleted.Descricao, inserted.Descricao 
   INTO @ProdutoAntesDepois(Id, DescricaoAntes, DescricaoAtual) 
 WHERE Id = 3 

SELECT Id, Descricao 
  FROM dbo.Produto 
 WHERE Id = 3 

SELECT Id, DescricaoAntes, DescricaoAtual 
  FROM @ProdutoAntesDepois 
  
/*
Demonstração de uso do MERGE Statement
*/

DECLARE @Cliente TABLE 
(
	Nome VARCHAR(150) NOT NULL, 
	Endereco VARCHAR(250) NOT NULL, 
	Id_Cidade SMALLINT NOT NULL, 
	Email VARCHAR(250) NOT NULL, 
	Telefone1 VARCHAR(20) NOT NULL, 
	Telefone2 VARCHAR(20) NULL, 
	Telefone3 VARCHAR(20) NULL 
) 

SELECT Id, Nome, Endereco, Id_Cidade, Email, Telefone1 
  FROM dbo.CadastroCliente 

INSERT INTO @Cliente (Nome, Endereco, Id_Cidade, Email, Telefone1) 
VALUES ('Cliente 1',  'Rua 1', 1, 'cliente_1@email.com.br',  '(11) 0000-0000'), 
       ('Cliente 2',  'Rua 2', 1, 'cliente_2@email.com.br',  '(11) 0000-0000'), 
	   ('Cliente 3',  'Rua 3', 1, 'cliente_3@email.com.br',  '(11) 0000-0000'), 
	   ('Cliente 4',  'Rua 4', 2, 'cliente_4@email.com.br',  '(11) 0000-0000'), 
	   ('Cliente 5',  'Rua 5', 2, 'cliente_5@email.com.br',  '(11) 0000-0000'), 
	   ('Cliente 6',  'Rua 6', 2, 'cliente_6@email.com.br',  '(11) 0000-0000'), 
	   ('Cliente 7',  'Rua 7', 3, 'cliente_7@email.com.br',  '(11) 0000-0000'), 
	   ('Cliente 8',  'Rua 8', 3, 'cliente_8@email.com.br',  '(11) 0000-0000'), 
	   ('Cliente 9',  'Rua 9', 3, 'cliente_9@email.com.br',  '(11) 0000-0000'), 
	   ('Cliente 10', 'Rua 10', 4, 'cliente_10@email.com', '(21) 0000-0000'), 
	   ('Cliente 11', 'Rua 11', 4, 'cliente_11@email.com', '(21) 0000-0000'), 
	   ('Cliente 12', 'Rua 12', 4, 'cliente_12@email.com', '(21) 0000-0000'), 
	   ('Cliente 13', 'Rua 13', 5, 'cliente_13@email.com', '(21) 0000-0000'), 
	   ('Cliente 14', 'Rua 14', 5, 'cliente_14@email.com', '(21) 0000-0000'), 
	   ('Cliente 15', 'Rua 15', 5, 'cliente_15@email.com', '(21) 0000-0000'), 
	   ('Cliente 16', 'Rua 16', 6, 'cliente_16@email.com', '(21) 0000-0000'), 
	   ('Cliente 17', 'Rua 17', 6, 'cliente_17@email.com', '(21) 0000-0000'), 
	   ('Cliente 18', 'Rua 18', 6, 'cliente_18@email.com', '(21) 0000-0000'), 
	   ('Cliente 19', 'Rua 19', 7, 'cliente_19@email.com', '(31) 0000-0000'), 
	   ('Cliente 20', 'Rua 20', 7, 'cliente_20@email.com', '(31) 0000-0000'), 
	   ('Cliente 21', 'Rua 21', 7, 'cliente_21@email.com', '(31) 0000-0000'), 
	   ('Cliente 22', 'Rua 22', 8, 'cliente_22@email.com', '(31) 0000-0000'), 
	   ('Cliente 23', 'Rua 23', 8, 'cliente_23@email.com', '(31) 0000-0000'), 
	   ('Cliente 24', 'Rua 24', 8, 'cliente_24@email.com', '(31) 0000-0000'), 
	   ('Cliente 25', 'Rua 25', 9, 'cliente_25@email.com', '(31) 0000-0000'), 
	   ('Cliente 26', 'Rua 26', 9, 'cliente_26@email.com', '(31) 0000-0000'), 
	   ('Cliente 27', 'Rua 27', 9, 'cliente_27@email.com', '(31) 0000-0000'), 
	   ('Cliente 28', 'Rua 28', 9, 'cliente_28@email.com', '(31) 0000-0000'), 
	   ('Cliente 29', 'Rua 29', 9, 'cliente_29@email.com', '(31) 0000-0000'), 
	   ('Cliente 30', 'Rua 30', 9, 'cliente_30@email.com', '(31) 0000-0000') 

MERGE INTO dbo.CadastroCliente AS TGT 
USING @Cliente AS SRC 
   ON SRC.Nome = TGT.Nome 
 WHEN MATCHED AND (TGT.Email <> SRC.Email) THEN 
      UPDATE SET TGT.Email = SRC.Email 
 WHEN MATCHED AND (TGT.Id_Cidade = 8) THEN DELETE 
 WHEN NOT MATCHED THEN INSERT 
      VALUES(SRC.Nome, SRC.Endereco, SRC.Id_Cidade, SRC.Email, SRC.Telefone1, SRC.Telefone2, SRC.Telefone3)
OUTPUT
  $action AS "Ação", COALESCE(inserted.Id, deleted.Id) AS Id; 

SELECT Id, Nome, Endereco, Id_Cidade, Email, Telefone1 
  FROM dbo.CadastroCliente 