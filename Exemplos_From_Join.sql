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
Cria��o de um �ndice auxiliar, para filtragem � partir da coluna "Data Venda" da tabela Vendas
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
Demonstra��o da jun��o das informa��es das duas tabelas de dom�nio: Estado e Cidade
*/

SELECT dbo.Estado.Id AS "C�digo do Estado", dbo.Estado.Descricao AS "Descri��o do Estado", 
       dbo.Cidade.Id AS "C�digo da Cidade", dbo.Cidade.Descricao AS "Descri��o da Cidade" 
  FROM dbo.Cidade 
 INNER JOIN dbo.Estado ON (Cidade.Id_Estado = Estado.Id) 

/*
Demonstra��o de uso de ALIAS para as tabelas
*/

SELECT E.Id AS "C�digo do Estado", E.Descricao AS "Descri��o do Estado", 
       C.Id AS "C�digo da Cidade", C.Descricao AS "Descri��o da Cidade" 
  FROM dbo.Cidade      C
 INNER JOIN dbo.Estado E ON (C.Id_Estado = E.Id) 

SELECT E.Id AS "C�digo do Estado", E.Descricao AS "Descri��o do Estado", 
       C.Id AS "C�digo da Cidade", C.Descricao AS "Descri��o da Cidade" 
  FROM dbo.Cidade      AS C
 INNER JOIN dbo.Estado AS E ON (C.Id_Estado = E.Id) 

/*
Demonstra��o de como pegar informa��es do CadastroCliente com v�nculo direto � tabela Cidade e v�nculo indireto � tabela Estado
*/

SELECT Cliente.Nome, Cliente.Endereco, 
       C.Descricao AS Cidade, 
	   E.Descricao AS Estado, 
       Cliente.Email, Cliente.Telefone1 
  FROM dbo.CadastroCliente AS Cliente WITH (READUNCOMMITTED) 
 INNER JOIN dbo.Cidade AS C ON (Cliente.Id_Cidade = C.Id) 
 INNER JOIN dbo.Estado AS E ON (C.Id_Estado = E.Id) 

/*
Exemplo de uso do INNER JOIN para jun��o de informa��es que PRECISAM estar presentes em ambas as tabelas envolvidas
*/

SELECT Cliente.Nome AS "Nome do Cliente", 
       P.Descricao AS "Produto", 
	   V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas               AS V WITH (READUNCOMMITTED) 
 INNER JOIN dbo.CadastroCliente AS Cliente ON (V.Id_Cliente = Cliente.Id) 
 INNER JOIN dbo.Produto         AS P ON (V.Id_Produto = P.Id) 

SELECT Id, Descricao 
  FROM dbo.Produto 

SELECT Id, Nome 
  FROM dbo.CadastroCliente 

SELECT Id, Id_Produto, Id_Cliente 
  FROM dbo.Vendas 
/*
Exemplo de uso do LEFT JOIN para jun��o de informa��es que PRECISA estar presente apenas na tabela que fica "� esquerda" e que PODE OU N�O existir correpondente "� direita"
*/

SELECT Cliente.Id AS "C�digo do Cliente", Cliente.Nome AS "Nome do Cliente", 
       V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.CadastroCliente AS Cliente 
  LEFT JOIN dbo.Vendas     AS V WITH (READUNCOMMITTED) ON (Cliente.Id = V.Id_Cliente) 

/*
Exemplo de uso do LEFT JOIN para jun��o de informa��es que PRECISA estar presente apenas na tabela que fica "� esquerda" e que N�O PODE existir correpondente "� direita"
*/

SELECT Cliente.Id AS "C�digo do Cliente", Cliente.Nome AS "Nome do Cliente", 
       V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.CadastroCliente AS Cliente 
  LEFT JOIN dbo.Vendas     AS V WITH (READUNCOMMITTED) ON (Cliente.Id = V.Id_Cliente) 
 WHERE V.Id IS NOT NULL 

/*
Exemplo de uso do FULL JOIN ou FULL OUTER JOIN para jun��o de informa��es que PODEM estar presentes em ambas as tabelas envolvidas
*/

SELECT P.Descricao AS Produto, 
       Cliente.Id AS "C�digo do Cliente", Cliente.Nome AS "Nome do Cliente", 
       V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.CadastroCliente    AS Cliente 
  FULL JOIN dbo.Vendas        AS V WITH (READUNCOMMITTED) ON (Cliente.Id = V.Id_Cliente) 
  FULL OUTER JOIN dbo.Produto AS P ON (V.Id_Produto = P.Id) 

/*
Exemplo de uso do FULL JOIN ou FULL OUTER JOIN para jun��o de informa��es exceto o que houver correspond�ncia em ambas as tabelas envolvidas
*/

SELECT P.Descricao AS Produto, 
       V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas             AS V WITH (READUNCOMMITTED) 
  FULL OUTER JOIN dbo.Produto AS P ON (V.Id_Produto = P.Id) 
 WHERE V.Id_Produto IS NULL OR P.Id IS NULL 

/*
Exemplo de uso do CROSS JOIN cujo resultado � um produto cartesiano, ou seja, uma combina��o de tudo com tudo entre todas as tabelas envolvidas
*/

SELECT P.Descricao AS Produto, 
       V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas       AS V WITH (READUNCOMMITTED) 
 CROSS JOIN dbo.Produto AS P 

SELECT Id_Produto, Pedido 
  FROM dbo.Vendas 
 WHERE Id_Produto = 3 

/*
Exemplo de uso do RIGHT JOIN para jun��o de informa��es que PRECISA estar presente apenas na tabela que fica "� direita" e que PODE OU N�O existir correpondente "� esquerda"
*/

SELECT P.Id AS "C�digo do Produto", P.Descricao AS "Produto", 
       V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas       AS V WITH (READUNCOMMITTED) 
 RIGHT JOIN dbo.Produto AS P ON (V.Id_Produto = P.Id) 

/*
Exemplo de uso do RIGHT JOIN para jun��o de informa��es que PRECISA estar presente apenas na tabela que fica "� direita" e que N�O PODE existir correpondente "� esquerda"
*/

SELECT P.Id AS "C�digo do Produto", P.Descricao AS "Produto", 
       V.Pedido AS "C�digo da Venda", V.Quantidade, V."Valor Unitario", V."Data Venda" 
  FROM dbo.Vendas       AS V WITH (READUNCOMMITTED) 
 RIGHT JOIN dbo.Produto AS P ON (V.Id_Produto = P.Id) 
 WHERE V.Id IS NOT NULL 
