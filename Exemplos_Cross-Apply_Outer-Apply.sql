--https://sqlhints.com/2016/10/23/outer-apply-in-sql-server/
--https://sqlhints.com/tag/examples-of-cross-apply/
--https://qastack.com.br/programming/9275132/real-life-example-when-to-use-outer-cross-apply-in-sql
--https://www.mssqltips.com/sqlservertip/1958/sql-server-cross-apply-and-outer-apply/

/*
 * Esta se��o � apenas para cria��o das tabelas para este cap�tulo
 * � feito primeiro o DROP da(s) tabela(s) caso ela j� exista
 * Ap�s � feita a cria��o da tabela no contexto do cap�tulo
 * Por fim a popula��o da tabela com o contexto do cap�tulo
 *
 * Recomenda-se executar esta parte inicial a cada cap�tulo
 */

 /*
 * Caso tenha eventuais problemas de convers�o de datas, execute o seguinte comando:
 *
 * SET DATEFORMAT ymd
 *
 * No in�cio de cada script estou incluindo este comando, caso voc� retome o exerc�cio em outro dia,
 * � s� executar este comando (1 vez apenas, pois � por sess�o) antes de executar as queries
 */

-- ***************************************************************
-- ***************************************************************
-- ***************************************************************
-- ***************************************************************
SET DATEFORMAT ymd

IF OBJECT_ID('dbo.ValidaQuantidadeVendas', 'TF') IS NOT NULL 
BEGIN 
	DROP FUNCTION dbo.ValidaQuantidadeVendas 
END 

IF OBJECT_ID('dbo.ValidaQuantidade', 'TF') IS NOT NULL 
BEGIN 
	DROP FUNCTION dbo.ValidaQuantidade 
END 

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
Tabela de dom�nio que representa os estados brasileiros
*/

CREATE TABLE dbo.Estado 
(
	Id TINYINT IDENTITY(1, 1) NOT NULL, 
	Descricao VARCHAR(150) NOT NULL, 
	CONSTRAINT PK_Estado PRIMARY KEY (Id) 
)

INSERT INTO dbo.Estado (Descricao) 
VALUES ('S�o Paulo'), 
       ('Rio de Janeiro'), 
	   ('Minas Gerais') 

/*
Tabela de dom�nio que representa as cidades brasileiras
Utiliza-se o c�digo da tabela de dom�nio de Estado para identificar � qual estado pertence cada cidade
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
VALUES (1, 'Santo Andr�'), 
       (1, 'S�o Bernardo do Campo'), 
	   (1, 'S�o Caetano do Sul'), 
	   (2, 'Duque de Caxias'), 
	   (2, 'Niter�i'), 
	   (2, 'Petr�polis'), 
	   (3, 'Uberl�ndia'), 
	   (3, 'Contagem'), 
	   (3, 'Juiz de Fora') 

/*
Representa��o da tabela de cadastro de clientes
H� v�nculo do cliente com a tabela de dom�nio Cidade
Como a tabela de dom�nio Cidade j� possui v�nculo com a tabela Estado, n�o � necess�rio criar v�nculo forte entre a tabela CadastroCliente e a tabela Estado
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
Cria��o de uma tabela para cadastro simples de produtos
*/

CREATE TABLE dbo.Produto 
(
	Id SMALLINT IDENTITY(1, 1) NOT NULL, 
	Descricao VARCHAR(250) NOT NULL, 
	CONSTRAINT PK_Produto PRIMARY KEY (Id) 
) 

/*
Cria��o de um �ndice auxiliar, para filtragem � partir da coluna Descricao da tabela Produto
*/

CREATE NONCLUSTERED INDEX IDX_Produto_Descricao ON dbo.Produto (Descricao) 

INSERT INTO dbo.Produto (Descricao) 
VALUES ('Produto A'), 
       ('Produto B'), 
       ('Produto C')

/*
Cria��o de uma tabela de vendas que ir� unir informa��es de clientes e produtos
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
Cria��o de um �ndice auxiliar, para uso no JOIN atrav�s das colunas Id_Cliente (com a tabela CadastroCliente) e Id_Produto (com a tabela Produto) 
*/

CREATE NONCLUSTERED INDEX IDX_Vendas_Id_Cliente ON dbo.Vendas (Id_Cliente) 
CREATE NONCLUSTERED INDEX IDX_Vendas_Id_Produto ON dbo.Vendas (Id_Produto) 

/*
Cria��o de um �ndice auxiliar, para filtragem � partir da coluna DataVenda da tabela Vendas
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
Demonstra��o de query para uso do CROSS APPLY
*/

DECLARE @DataReferencia SMALLDATETIME = CAST('2020-01-01' AS SMALLDATETIME) 

DECLARE CursorVendas CURSOR FAST_FORWARD FOR 
  SELECT Id, Quantidade, "Valor Unitario" 
    FROM dbo.Vendas 
   WHERE "Data Venda" = @DataReferencia; 

OPEN CursorVendas; 

DECLARE @Id BIGINT 
DECLARE @Quantidade SMALLINT 
DECLARE @ValorUnitario NUMERIC(9, 2) 

FETCH NEXT FROM CursorVendas INTO @Id, @Quantidade, @ValorUnitario; 

WHILE @@FETCH_STATUS = 0 
BEGIN 
	IF (@Quantidade < 40) 
	BEGIN 
		PRINT 'Menor que 40: Id = ' + CAST(@Id AS VARCHAR(MAX)) + ', Valor unit�rio: ' + CAST(@ValorUnitario AS VARCHAR(MAX)) 
	END 
	ELSE 
	BEGIN 
		PRINT 'Maior ou igual a 40: Id = ' + CAST(@Id AS VARCHAR(MAX)) + ', Valor unit�rio: ' + CAST(@ValorUnitario AS VARCHAR(MAX)) 
		--BREAK
	END 

	FETCH NEXT FROM CursorVendas INTO @Id, @Quantidade, @ValorUnitario; 
END 

CLOSE CursorVendas; 
DEALLOCATE CursorVendas; 
GO 

IF OBJECT_ID('dbo.ValidaQuantidade', 'TF') IS NOT NULL 
BEGIN 
	DROP FUNCTION dbo.ValidaQuantidade 
END 
GO 

CREATE FUNCTION dbo.ValidaQuantidade 
(
	@Id BIGINT, 
	@Quantidade INTEGER, 
	@ValorUnitario NUMERIC(9, 2) 
)
RETURNS @TabelaRetorno TABLE 
(
	Mensagem VARCHAR(150)
)
AS 
BEGIN 
	IF (@Quantidade < 40) 
	BEGIN 
		INSERT INTO @TabelaRetorno(Mensagem)
		VALUES ('Menor que 40: Id = ' + CAST(@Id AS VARCHAR(MAX)) + ', Valor unit�rio: ' + CAST(@ValorUnitario AS VARCHAR(MAX))) 
		INSERT INTO @TabelaRetorno(Mensagem)
		VALUES ('Segunda linha do Id = ' + CAST(@Id AS VARCHAR(MAX)))
	END 
	ELSE 
	BEGIN 
		INSERT INTO @TabelaRetorno(Mensagem)
		VALUES ('Maior ou igual a 40: Id = ' + CAST(@Id AS VARCHAR(MAX)) + ', Valor unit�rio: ' + CAST(@ValorUnitario AS VARCHAR(MAX))) 
	END 

	RETURN 
END 
GO 

SELECT * FROM dbo.ValidaQuantidade (1, 40, 5) 

DECLARE @DataReferencia SMALLDATETIME = CAST('2020-01-01' AS SMALLDATETIME) 

SELECT dbo.Vendas.Id, dbo.Vendas.Pedido, 
       Cliente.Nome AS "Cliente", 
	   dbo.Produto.Descricao AS "Produto", 
	   dbo.Vendas.Quantidade, 
	   MensagemQuantidade.Mensagem 
  FROM dbo.Vendas 
 INNER JOIN dbo.CadastroCliente AS Cliente 
    ON (dbo.Vendas.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto 
    ON (dbo.Vendas.Id_Produto = dbo.Produto.Id) 
 CROSS APPLY dbo.ValidaQuantidade(dbo.Vendas.Id, dbo.Vendas.Quantidade, dbo.Vendas.[Valor Unitario]) AS MensagemQuantidade 
 WHERE dbo.Vendas.[Data Venda] = @DataReferencia 

--O uso de CROSS APPLY contra uma tabela gera um plano de execu��o igual � um INNER JOIN
SELECT dbo.Vendas.Id, dbo.Vendas.Pedido, 
       Cliente.Nome AS "Cliente" 
  FROM dbo.Vendas 
 INNER JOIN dbo.CadastroCliente AS Cliente 
    ON (dbo.Vendas.Id_Cliente = Cliente.Id) 
 WHERE dbo.Vendas.[Data Venda] BETWEEN CAST('2020-01-01' AS SMALLDATETIME) AND CAST('2020-12-31' AS SMALLDATETIME) 

SELECT dbo.Vendas.Id, dbo.Vendas.Pedido, 
       Cliente.Nome AS "Cliente" 
  FROM dbo.Vendas 
 CROSS APPLY (SELECT Cliente.Nome FROM dbo.CadastroCliente AS Cliente WHERE Cliente.Id = dbo.Vendas.Id_Cliente) AS Cliente 
 WHERE dbo.Vendas.[Data Venda] BETWEEN CAST('2020-01-01' AS SMALLDATETIME) AND CAST('2020-12-31' AS SMALLDATETIME) 

/*
Demonstra��o de query para uso do OUTER APPLY
*/

IF OBJECT_ID('dbo.ValidaQuantidadeVendas', 'TF') IS NOT NULL 
BEGIN 
	DROP FUNCTION dbo.ValidaQuantidadeVendas 
END 
GO 

CREATE FUNCTION dbo.ValidaQuantidadeVendas 
(
	@Id_Cliente INT 
)
RETURNS @TabelaRetorno TABLE 
(
	Id_Cliente INT, 
	Quantidade_Vendas INT 
)
AS 
BEGIN 
	INSERT INTO @TabelaRetorno (Id_Cliente, Quantidade_Vendas) 
	SELECT Id_Cliente, COUNT(DISTINCT Pedido) AS Quantidade_Vendas
	  FROM dbo.Vendas 
	 WHERE Id_Cliente = @Id_Cliente 
	 GROUP BY Id_Cliente 

	RETURN 
END 
GO 

SELECT Clientes.Id, Clientes.Nome, VendasPorCliente.Quantidade_Vendas  
  FROM dbo.CadastroCliente AS Clientes 
 OUTER APPLY dbo.ValidaQuantidadeVendas(Clientes.Id) AS VendasPorCliente 

--O uso de OUTER APPLY contra uma tabela gera um plano de execu��o igual � um LEFT JOIN
SELECT Clientes.Id, Clientes.Nome, 
       dbo.Vendas.Pedido 
  FROM dbo.CadastroCliente AS Clientes 
  LEFT JOIN dbo.Vendas 
    ON (Clientes.Id = dbo.Vendas.Id_Cliente) 
 WHERE Clientes.Id = 10 

SELECT Clientes.Id, Clientes.Nome, 
       Vendas.Pedido 
  FROM dbo.CadastroCliente AS Clientes 
 OUTER APPLY (SELECT dbo.Vendas.Pedido FROM dbo.Vendas WHERE dbo.Vendas.Id_Cliente = Clientes.Id) AS Vendas 
 WHERE Clientes.Id = 10 