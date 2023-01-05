/*
 * Por ser um capítulo especial, ao final do script há a limpeza para apagar estas tabelas que não usaremos
 */

/*
Demonstração de criação de uma tabela na seção e banco de dados atual, com PRIMARY KEY, CHECK e DEFAULT constraint
*/

/*
 * Caso tenha eventuais problemas de conversão de datas, execute o seguinte comando:
 *
 * SET DATEFORMAT ymd
 *
 * No início de cada script estou incluindo este comando, caso você retome o exercício em outro dia,
 * é só executar este comando (1 vez apenas, pois é por sessão) antes de executar as queries
 */

SET DATEFORMAT ymd

CREATE TABLE dbo.TabelaUm 
(
	Id BIGINT IDENTITY(1, 1) NOT NULL, 
	Nome VARCHAR(100) NOT NULL, 
	Idade SMALLINT NOT NULL, 
	Sexo CHAR(1) NOT NULL, 
	Endereco VARCHAR(250) NULL, 
	DataNascimento DATE NULL, 
	DataCadastro SMALLDATETIME NULL, 
	DataAtual DATETIME NOT NULL, 
	Observacao VARCHAR(100) NOT NULL CONSTRAINT DFT_TabelaUm_Obervacao DEFAULT 'N/A', 
	IdEspecial UNIQUEIDENTIFIER NOT NULL CONSTRAINT DFT_TabelaUm_IdESpecial DEFAULT NEWSEQUENTIALID(), 
	CONSTRAINT PK_TabelaUm PRIMARY KEY CLUSTERED (Id), 
	CONSTRAINT CHK_TabelaUm_Idade CHECK (Idade >= 0), 
	CONSTRAINT CHK_TabelaUm_Sexo CHECK(Sexo IN ('F', 'M')) 
) 

SELECT Id, Nome, Idade, Sexo, DataNascimento, DataCadastro, DataAtual, Observacao
  FROM dbo.TabelaUm 

INSERT INTO dbo.TabelaUm (Nome, Idade, Sexo, DataNascimento, DataCadastro, DataAtual, Observacao) 
VALUES ('Everton', 35, 'M', CAST('1985-09-28' AS DATE), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'teste') 

INSERT INTO dbo.TabelaUm (Nome, Idade, Sexo, DataNascimento, DataCadastro, DataAtual, Observacao) 
VALUES ('Isabel', 35, 'F', CAST('1985-08-02' AS DATE), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'teste') 

INSERT INTO dbo.TabelaUm (Nome, Idade, Sexo, DataNascimento, DataCadastro, DataAtual, Observacao) 
VALUES ('Teste', 35, 'M', CAST('1985-09-28' AS DATE), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'teste') 

INSERT INTO dbo.TabelaUm (Nome, Idade, Sexo, DataNascimento, DataCadastro, DataAtual, Observacao) 
VALUES ('Everton', -1, 'M', CAST('1985-09-28' AS DATE), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'teste') 

INSERT INTO dbo.TabelaUm (Nome, Idade, Sexo, DataNascimento, DataCadastro, DataAtual, Observacao) 
VALUES ('Everton', 35, 'Z', CAST('1985-09-28' AS DATE), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'teste') 

INSERT INTO dbo.TabelaUm (Nome, Idade, Sexo, DataNascimento, DataCadastro, DataAtual, Observacao) 
VALUES ('Everton', 35, 'M', CAST('1985-09-28' AS DATE), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL) 

INSERT INTO dbo.TabelaUm (Nome, Idade, Sexo, DataNascimento, DataCadastro, DataAtual) 
VALUES ('Everton', 35, 'M', CAST('1985-09-28' AS DATE), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) 

SELECT Id, Nome, Idade, Sexo, Endereco, DataNascimento, DataCadastro, DataAtual, Observacao, IdEspecial 
  FROM dbo.TabelaUm 

/*
Demonstração de FOREIGN KEY, UNIQUE constraint e coluna computada
*/

CREATE TABLE dbo.TabelaDois 
(
	Id TINYINT IDENTITY(1, 1) NOT NULL CONSTRAINT PK_TabelaDois PRIMARY KEY CLUSTERED, 
	Descricao VARCHAR(100) NOT NULL 
)

INSERT INTO dbo.TabelaDois (Descricao) 
VALUES ('Produto 1'), 
       ('Produto 2') 

SELECT Id, Descricao 
  FROM dbo.TabelaDois  

CREATE TABLE dbo.TabelaTres 
(
	Id BIGINT IDENTITY(1, 1) NOT NULL, 
	Id_TabelaUm BIGINT NOT NULL, 
	Id_TabelaDois TINYINT NOT NULL, 
	Quantidade INT NOT NULL, 
	ValorUnitario NUMERIC(9, 2) NOT NULL, 
	ValorTotal AS Quantidade * ValorUnitario, 
	CONSTRAINT PK_TabelaTres PRIMARY KEY CLUSTERED (Id), 
	CONSTRAINT UC_TabelaTres UNIQUE(Id_TabelaUm, Id_TabelaDois), 
	CONSTRAINT CHK_TabelaTres_Quantidade CHECK (Quantidade > 0), 
	CONSTRAINT CHK_TabelaTres_ValorUnitario CHECK (ValorUnitario > 0.0), 
	CONSTRAINT FK_TabelaUm FOREIGN KEY (Id_TabelaUm) REFERENCES dbo.TabelaUm (Id), 
	CONSTRAINT FK_TabelaDois FOREIGN KEY (Id_TabelaDois) REFERENCES dbo.TabelaDois (Id) 
) 

INSERT INTO dbo.TabelaTres (Id_TabelaUm, Id_TabelaDois, Quantidade, ValorUnitario) 
VALUES (1, 1, 10, 20), 
       (1, 2, 15, 25), 
	   (2, 1, 20, 30), 
	   (3, 1, 25, 35), 
	   (3, 2, 40, 55) 

INSERT INTO dbo.TabelaTres (Id_TabelaUm, Id_TabelaDois, Quantidade, ValorUnitario) 
VALUES (1, 3, 10, 20)

INSERT INTO dbo.TabelaTres (Id_TabelaUm, Id_TabelaDois, Quantidade, ValorUnitario) 
VALUES (4, 1, 10, 20)

INSERT INTO dbo.TabelaTres (Id_TabelaUm, Id_TabelaDois, Quantidade, ValorUnitario) 
VALUES (1, 1, 10, 20)

SELECT Id, Id_TabelaUm, Id_TabelaDois, Quantidade, ValorUnitario, ValorTotal 
  FROM dbo.TabelaTres 

/*
Demonstração de criação de uma tabela na seção e banco de dados distinto, com CHECK e DEFAULT
*/

CREATE TABLE DBEvertonDois.dbo.TabelaUm 
(
	Id BIGINT IDENTITY(1, 1) NOT NULL, 
	Nome VARCHAR(100) NOT NULL, 
	Idade TINYINT NOT NULL, 
	Observacao VARCHAR(100) NOT NULL CONSTRAINT DFT_TabelaUm_Obervacao DEFAULT 'N/A', 
	CONSTRAINT PK_TabelaUm PRIMARY KEY CLUSTERED (Id), 
	CONSTRAINT CHK_TabelaUm_Idade CHECK (Idade >= 0) 
) 

INSERT INTO DBEvertonDois.dbo.TabelaUm (Nome, Idade, Observacao) 
VALUES ('Everton', 35, 'teste') 

INSERT INTO DBEvertonDois.dbo.TabelaUm (Nome, Idade, Observacao) 
VALUES ('Everton', -1, 'teste') 

INSERT INTO DBEvertonDois.dbo.TabelaUm (Nome, Idade, Observacao) 
VALUES ('Everton', 35, NULL) 

INSERT INTO DBEvertonDois.dbo.TabelaUm (Nome, Idade) 
VALUES ('Everton', 35) 

SELECT Id, Nome, Idade, Observacao 
  FROM DBEvertonDois.dbo.TabelaUm 

/*
Demonstração de alterações na estrutura da tabela, para remover CHECK
*/

ALTER TABLE dbo.TabelaUm DROP CONSTRAINT CHK_TabelaUm_Sexo 

INSERT INTO dbo.TabelaUm (Nome, Idade, Sexo, DataNascimento, DataCadastro, DataAtual, Observacao) 
VALUES ('Everton', 35, 'Z', CAST('1985-09-28' AS DATE), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'teste') 

SELECT Id, Nome, Idade, Sexo, Endereco, DataNascimento, DataCadastro, DataAtual, Observacao, IdEspecial 
  FROM dbo.TabelaUm 

/*
Demonstração de alterações na estrutura da tabela, para remover DEFAULT
*/

ALTER TABLE dbo.TabelaUm DROP CONSTRAINT DFT_TabelaUm_Obervacao 

INSERT INTO dbo.TabelaUm (Nome, Idade, Sexo, DataNascimento, DataCadastro, DataAtual, Observacao) 
VALUES ('Everton', 35, 'Z', CAST('1985-09-28' AS DATE), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'teste') 

INSERT INTO dbo.TabelaUm (Nome, Idade, Sexo, DataNascimento, DataCadastro, DataAtual, Observacao) 
VALUES ('Everton', 35, 'Z', CAST('1985-09-28' AS DATE), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL) 

INSERT INTO dbo.TabelaUm (Nome, Idade, Sexo, DataNascimento, DataCadastro, DataAtual) 
VALUES ('Everton', 35, 'Z', CAST('1985-09-28' AS DATE), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) 

SELECT Id, Nome, Idade, Sexo, Endereco, DataNascimento, DataCadastro, DataAtual, Observacao, IdEspecial 
  FROM dbo.TabelaUm 

/*
Demonstração de alterações na estrutura da tabela, para remover constraint de NULL
*/

ALTER TABLE dbo.TabelaUm ALTER COLUMN Observacao VARCHAR(100) NULL 

INSERT INTO dbo.TabelaUm (Nome, Idade, Sexo, DataNascimento, DataCadastro, DataAtual, Observacao) 
VALUES ('Everton', 35, 'Z', CAST('1985-09-28' AS DATE), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'teste') 

INSERT INTO dbo.TabelaUm (Nome, Idade, Sexo, DataNascimento, DataCadastro, DataAtual, Observacao) 
VALUES ('Everton', 35, 'Z', CAST('1985-09-28' AS DATE), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL) 

INSERT INTO dbo.TabelaUm (Nome, Idade, Sexo, DataNascimento, DataCadastro, DataAtual) 
VALUES ('Everton', 35, 'Z', CAST('1985-09-28' AS DATE), CURRENT_TIMESTAMP, CURRENT_TIMESTAMP) 

SELECT Id, Nome, Idade, Sexo, Endereco, DataNascimento, DataCadastro, DataAtual, Observacao, IdEspecial 
  FROM dbo.TabelaUm 

/*
Demonstração de alterações na estrutura da tabela, cuidado na conversão de valores já existentes
*/

ALTER TABLE dbo.TabelaUm ALTER COLUMN Sexo INT NULL 

/*
Demonstração de alterações na estrutura da tabela, cuidado ao tentar efetuar esta alteração sem remover o CHECK antes
*/

ALTER TABLE dbo.TabelaUm ALTER COLUMN Idade BIT NULL  

/*
Demonstração de DROP TABLE com tabelas referenciadas
*/

ALTER TABLE dbo.TabelaTres DROP CONSTRAINT FK_TabelaUm 

DROP TABLE dbo.TabelaUm 
DROP TABLE dbo.TabelaDois 
DROP TABLE dbo.TabelaTres 

/*
 * Scripts de limpeza
 */

-- ***************************************************************
-- ***************************************************************
-- ***************************************************************
-- ***************************************************************

IF EXISTS(SELECT * FROM DBEvertonDois.sys.tables WHERE name = 'TabelaUm')  
BEGIN 
	DROP TABLE DBEvertonDois.dbo.TabelaUm 
END 

IF EXISTS(SELECT * FROM sys.tables WHERE name = 'TabelaTres')  
BEGIN 
	DROP TABLE dbo.TabelaTres 
END 

IF EXISTS(SELECT * FROM sys.tables WHERE name = 'TabelaDois')  
BEGIN 
	DROP TABLE dbo.TabelaDois 
END 

IF EXISTS(SELECT * FROM sys.tables WHERE name = 'TabelaUm')  
BEGIN 
	DROP TABLE dbo.TabelaUm 
END 

GO 

-- ***************************************************************
-- ***************************************************************
-- ***************************************************************
-- ***************************************************************