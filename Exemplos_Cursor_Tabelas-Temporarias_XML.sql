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
Demonstração do uso de CURSOR para iteração linha-a-linha
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
		PRINT 'Menor que 40: Id = ' + CAST(@Id AS VARCHAR(MAX)) + ', Valor unitário: ' + CAST(@ValorUnitario AS VARCHAR(MAX)) 
	END 
	ELSE 
	BEGIN 
		PRINT 'Maior ou igual a 40: Id = ' + CAST(@Id AS VARCHAR(MAX)) + ', Valor unitário: ' + CAST(@ValorUnitario AS VARCHAR(MAX)) 
		--BREAK
	END 

	FETCH NEXT FROM CursorVendas INTO @Id, @Quantidade, @ValorUnitario; 
END 

CLOSE CursorVendas; 
DEALLOCATE CursorVendas; 
GO 

/*
Demonstração de uso de tabela temporária
*/

CREATE TABLE #TempUm 
(
	Id BIGINT NOT NULL, 
	Nome VARCHAR(100) NOT NULL 
);

INSERT INTO #TempUm (Id, Nome) 
VALUES (1, 'Everton') 

SELECT Id, Nome FROM #TempUm 

EXEC ('SELECT Id, Nome FROM #TempUm') 

DROP TABLE #TempUm 
GO 

SELECT Pedido, Quantidade, "Data Venda"
  INTO #TempUm 
  FROM dbo.Vendas 

SELECT Pedido, Quantidade, "Data Venda" FROM #TempUm 

EXEC ('SELECT Pedido, Quantidade, "Data Venda" FROM #TempUm') 

DROP TABLE #TempUm 
GO 

/*
Demonstração de uso de tabela temporária em memória
*/

DECLARE @TempUm TABLE 
(
	Id BIGINT NOT NULL, 
	Nome VARCHAR(100) NOT NULL 
);

INSERT INTO @TempUm (Id, Nome) 
VALUES (1, 'Everton') 

SELECT Id, Nome FROM @TempUm 

EXEC ('SELECT Id, Nome FROM @TempUm') 

GO 
--SELECT Id, Nome FROM @TempUm 

/*
Demonstração de query para transformar em XML
*/

SELECT Venda.Pedido, 
       Cliente.Nome AS Cliente, 
	   Produto.Descricao AS Produto, 
	   Venda.Quantidade, Venda."Valor Unitario" AS ValorUnitario, (Venda.Quantidade * Venda."Valor Unitario") AS ValorTotal, CAST(Venda."Data Venda" AS DATE) AS DataVenda
  FROM dbo.Vendas               AS Venda 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (Venda.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS Produto ON (Venda.Id_Produto = Produto.Id) 
 WHERE Venda.[Data Venda] = CAST('2020-01-01' AS SMALLDATETIME) 
 FOR XML RAW 

SELECT Venda.Pedido, 
       Cliente.Nome AS Cliente, 
	   Produto.Descricao AS Produto, 
	   Venda.Quantidade, Venda."Valor Unitario" AS ValorUnitario, (Venda.Quantidade * Venda."Valor Unitario") AS ValorTotal, CAST(Venda."Data Venda" AS DATE) AS DataVenda
  FROM dbo.Vendas               AS Venda 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (Venda.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS Produto ON (Venda.Id_Produto = Produto.Id) 
 WHERE Venda.[Data Venda] = CAST('2020-01-01' AS SMALLDATETIME) 
 FOR XML AUTO 

SELECT Venda.Pedido, 
       Cliente.Nome AS Cliente, 
	   Produto.Descricao AS Produto, 
	   Venda.Quantidade, Venda."Valor Unitario" AS ValorUnitario, (Venda.Quantidade * Venda."Valor Unitario") AS ValorTotal, CAST(Venda."Data Venda" AS DATE) AS DataVenda
  FROM dbo.Vendas               AS Venda 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (Venda.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS Produto ON (Venda.Id_Produto = Produto.Id) 
 WHERE Venda.[Data Venda] = CAST('2020-01-01' AS SMALLDATETIME) 
 FOR XML AUTO, ELEMENTS 

SELECT Venda.Pedido, 
       Cliente.Nome AS Cliente, 
	   Produto.Descricao AS Produto, 
	   Venda.Quantidade, Venda."Valor Unitario" AS ValorUnitario, (Venda.Quantidade * Venda."Valor Unitario") AS ValorTotal, CAST(Venda."Data Venda" AS DATE) AS DataVenda
  FROM dbo.Vendas               AS Venda 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (Venda.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS Produto ON (Venda.Id_Produto = Produto.Id) 
 WHERE Venda.[Data Venda] = CAST('2020-01-01' AS SMALLDATETIME) 
 FOR XML PATH ('Venda'), ROOT('Vendas') 

/*
Demonstração de XML para transformar em uma estrutura de tabela
*/

DECLARE @DocHandle AS INTEGER;

DECLARE @XML XML = 
'<Vendas>
  <Venda Id="5000000" Id_Cliente="1" Id_Produto="1" Quantidade="10" ValorUnitario="5" DataVenda="2050-01-01"/>
  <Venda Id="5000001" Id_Cliente="1" Id_Produto="1" Quantidade="20" ValorUnitario="5" DataVenda="2050-01-02"/>
  <Venda Id="5000002" Id_Cliente="1" Id_Produto="1" Quantidade="30" ValorUnitario="5" DataVenda="2050-01-03"/>
  <Venda Id="5000003" Id_Cliente="1" Id_Produto="1" Quantidade="40" ValorUnitario="5" DataVenda="2050-01-04"/>
  <Venda Id="5000004" Id_Cliente="1" Id_Produto="1" Quantidade="50" ValorUnitario="5" DataVenda="2050-01-05"/>
  <Venda Id="5000005" Id_Cliente="1" Id_Produto="1" Quantidade="60" ValorUnitario="5" DataVenda="2050-01-06"/>
</Vendas>';

EXEC sys.sp_xml_preparedocument @DocHandle OUTPUT, @XML;

SELECT Id, Id_Cliente, Id_Produto, Quantidade, ValorUnitario, DataVenda
  FROM OPENXML (@DocHandle, '/Vendas/Venda', 1)
          WITH (Id BIGINT, Id_Cliente INTEGER, Id_Produto SMALLINT, Quantidade INTEGER, ValorUnitario NUMERIC(9, 2), DataVenda SMALLDATETIME); 

EXEC sys.sp_xml_removedocument @DocHandle; 
GO

DECLARE @DocHandle AS INTEGER;

DECLARE @XML XML = 
'<Vendas>
  <Venda>
    <Id>5000000</Id>
	<Id_Cliente>1</Id_Cliente>
	<Id_Produto>1</Id_Produto>
	<Quantidade>10</Quantidade>
	<ValorUnitario>5</ValorUnitario>
	<DataVenda>2050-01-01</DataVenda>
  </Venda>
  <Venda>
    <Id>5000001</Id>
	<Id_Cliente>1</Id_Cliente>
	<Id_Produto>1</Id_Produto>
	<Quantidade>20</Quantidade>
	<ValorUnitario>5</ValorUnitario>
	<DataVenda>2050-01-02</DataVenda>
  </Venda>
  <Venda>
    <Id>5000002</Id>
	<Id_Cliente>1</Id_Cliente>
	<Id_Produto>1</Id_Produto>
	<Quantidade>30</Quantidade>
	<ValorUnitario>5</ValorUnitario>
	<DataVenda>2050-01-03</DataVenda>
  </Venda>
  <Venda>
    <Id>5000003</Id>
	<Id_Cliente>1</Id_Cliente>
	<Id_Produto>1</Id_Produto>
	<Quantidade>40</Quantidade>
	<ValorUnitario>5</ValorUnitario>
	<DataVenda>2050-01-04</DataVenda>
  </Venda>
  <Venda>
    <Id>5000004</Id>
	<Id_Cliente>1</Id_Cliente>
	<Id_Produto>1</Id_Produto>
	<Quantidade>50</Quantidade>
	<ValorUnitario>5</ValorUnitario>
	<DataVenda>2050-01-05</DataVenda>
  </Venda>
  <Venda>
    <Id>5000005</Id>
	<Id_Cliente>1</Id_Cliente>
	<Id_Produto>1</Id_Produto>
	<Quantidade>60</Quantidade>
	<ValorUnitario>5</ValorUnitario>
	<DataVenda>2050-01-06</DataVenda>
  </Venda>
</Vendas>';

EXEC sys.sp_xml_preparedocument @DocHandle OUTPUT, @XML;

SELECT Id, Id_Cliente, Id_Produto, Quantidade, ValorUnitario, DataVenda
  FROM OPENXML (@DocHandle, '/Vendas/Venda', 2)
          WITH (Id BIGINT, Id_Cliente INTEGER, Id_Produto SMALLINT, Quantidade INTEGER, ValorUnitario NUMERIC(9, 2), DataVenda SMALLDATETIME); 

EXEC sys.sp_xml_removedocument @DocHandle; 
GO 