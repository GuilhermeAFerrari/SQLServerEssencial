/*
 * Esta seção é apenas para criação das tabelas para este capítulo
 * É feito primeiro o DROP da(s) tabela(s) caso ela já exista
 * Após é feita a criação da tabela no contexto do capítulo
 * Por fim a população da tabela com o contexto do capítulo
 *
 * Recomenda-se executar esta parte inicial a cada capítulo
 */

-- ***************************************************************
-- ***************************************************************
-- ***************************************************************
-- ***************************************************************
IF EXISTS(SELECT * FROM sys.tables WHERE name = 'Pessoa')  
BEGIN 
	DROP TABLE dbo.Pessoa 
END 
GO

CREATE TABLE dbo.Pessoa 
(
	PessoaId INTEGER IDENTITY(1, 1) NOT NULL, 
	PessoaNome VARCHAR(150) NOT NULL, 
	PessoaIdade TINYINT NOT NULL, 
	PessoaEndereco VARCHAR(250) NOT NULL, 
	PessoaCidade VARCHAR(250) NOT NULL, 
	PessoaEstado VARCHAR(50) NOT NULL, 
	PessoaEmail VARCHAR(250) NULL, 
	CONSTRAINT PK_Pessoa PRIMARY KEY CLUSTERED (PessoaId) 
) 

/*
Inserção de linhas de exemplo na tabela
*/

INSERT INTO dbo.Pessoa (PessoaNome, PessoaIdade, PessoaEndereco, PessoaCidade, PessoaEstado, PessoaEmail) 
VALUES ('Pessoa 1',  10, 'Rua 1, Cidade A',  'Santo André', 'São Paulo', 'pessoa_1@email.com'),
       ('Pessoa 2',  15, 'Rua 2, Cidade A',  'Santo André', 'São Paulo', 'pessoa_2@email.com'),
       ('Pessoa 3',  20, 'Rua 3, Cidade A',  'Santo André', 'São Paulo', 'pessoa_3@email.com'),
       ('Pessoa 4',  25, 'Rua 4, Cidade A',  'Duque de Caxias', 'Rio de Janeiro', 'pessoa_4@email.com'),
       ('Pessoa 5',  30, 'Rua 5, Cidade A',  'Duque de Caxias', 'Rio de Janeiro', 'pessoa_5@email.com'),
       ('Pessoa 6',  35, 'Rua 6, Cidade A',  'Duque de Caxias', 'Rio de Janeiro', 'pessoa_6@email.com'),
       ('Pessoa 7',  40, 'Rua 7, Cidade A',  'Duque de Caxias', 'Rio de Janeiro', 'pessoa_7@email.com'),
       ('Pessoa 8',  45, 'Rua 8, Cidade A',  'Uberlândia', 'Minas Gerais', 'pessoa_8@email.com'),
       ('Pessoa 9',  50, 'Rua 9, Cidade A',  'Uberlândia', 'Minas Gerais', 'pessoa_9@email.com'),
       ('Pessoa 10', 55, 'Rua 10, Cidade A', 'Uberlândia', 'Minas Gerais', 'pessoa_10@email.com')

GO

-- ***************************************************************
-- ***************************************************************
-- ***************************************************************
-- ***************************************************************

SELECT PessoaId, PessoaNome, PessoaIdade FROM dbo."Pessoa" 
SELECT PessoaId, PessoaNome, PessoaIdade FROM dbo.[Pessoa] 
SELECT PessoaId, PessoaNome, PessoaIdade FROM dbo.Pessoa WHERE PessoaIdade <> 30 
SELECT PessoaId, PessoaNome, PessoaIdade FROM dbo.Pessoa WHERE PessoaIdade != 30 
SELECT PessoaId, PessoaNome, CAST(PessoaIdade AS FLOAT) AS IdadeCast, CONVERT(FLOAT, PessoaIdade) AS IdadeConvert FROM dbo.Pessoa 
SELECT CURRENT_TIMESTAMP AS DataAtualCurrentTimestamp, GETDATE() AS DataAtualGetDate 

/*
Selecionando todas as colunas e todas as linhas da tabela
*/

SELECT * 
  FROM dbo.Pessoa 

/*
Selecionando todas as colunas e filtrando as linhas para trazer apenas às que possuírem valor da coluna PessoaIdade maior ou igual a 30
*/

SELECT * 
  FROM dbo.Pessoa 
 WHERE PessoaIdade >= 30 

/*
Selecionando as colunas PessoaNome e PessoaIDade, filtrando as linhas para trazer apenas às que possuírem valor da coluna PessoaIdade maior ou igual a 30
*/

SELECT PessoaNome, PessoaIdade  
  FROM dbo.Pessoa 
 WHERE PessoaIdade >= 30 

/*
Selecionando as colunas PessoaNome e PessoaIDade, filtrando as linhas para trazer apenas às que possuírem valor da coluna PessoaIdade maior ou igual a 30
Ordenando a exibição das linhas pela coluna PessoaIdade em ordem decrescente de valor
*/

SELECT PessoaNome, PessoaIdade  
  FROM dbo.Pessoa 
 WHERE PessoaIdade >= 30 
 ORDER BY PessoaIdade DESC 

/*
Selecionando as colunas PessoaNome e PessoaIDade, filtrando as linhas para trazer apenas às que possuírem valor da coluna PessoaIdade maior ou igual a 30
A coluna PessoaNome é exibida com um apelido chamado "Nome" e a coluna PessoaIdade é exibida com um apelido chamado "Idade"
Ordenando a exibição das linhas pela coluna PessoaIdade em ordem decrescente de valor
*/

SELECT PessoaNome AS Nome, PessoaIdade AS Idade 
  FROM dbo.Pessoa 
 WHERE PessoaIdade >= 30 
 ORDER BY PessoaIdade DESC 

/*
Selecionando as colunas PessoaNome e PessoaIDade, filtrando as linhas para trazer apenas às que possuírem valor da coluna PessoaIdade maior ou igual a 30
A coluna PessoaNome é exibida com um apelido chamado "Nome" e a coluna PessoaIdade é exibida com um apelido chamado "Idade"
Ordenando a exibição das linhas pela coluna PessoaIdade utilizando-se do apelido "Idade" em ordem decrescente de valor
*/

SELECT PessoaNome AS Nome, PessoaIdade AS Idade 
  FROM dbo.Pessoa 
 WHERE PessoaIdade >= 30 
 ORDER BY Idade DESC 

/*
Atenção: no exemplo abaixo não podemos usar o apelido "Idade" referente à coluna PessoaIdade como filtro na cláusula WHERE!!!
*/

/*
SELECT PessoaNome AS Nome, PessoaIdade AS Idade 
  FROM dbo.Pessoa 
 WHERE Idade >= 30 
 ORDER BY Idade DESC 
*/

/*
Selecionando as colunas PessoaEstado, filtrando as linhas para trazer apenas às que possuírem valor da coluna PessoaIdade maior ou igual a 30
Agrupando as linhas cuja coluna PessoaEstado possua o mesmo valor, à fim de trazer o valor máximo da coluna PessoaIdade agrupada pelo PessoaEstado
A coluna PessoaEstado é exibida com um apelido chamado "Estado" e a função de agregação MAX da coluna PessoaIdade é exibida com um apelido chamado "Idade"
Ordenando a exibição das linhas pela coluna PessoaIdade utilizando-se do apelido "Idade" em ordem decrescente de valor
*/

SELECT PessoaEstado AS Estado, MAX(PessoaIdade) AS Idade
  FROM dbo.Pessoa 
 WHERE PessoaIdade >= 30 
 GROUP BY PessoaEstado
 ORDER BY Idade DESC 

/*
Selecionando as colunas PessoaEstado, filtrando as linhas para trazer apenas às que possuírem valor da coluna PessoaIdade maior ou igual a 30
Agrupando as linhas cuja coluna PessoaEstado possua o mesmo valor, à fim de trazer o valor máximo da coluna PessoaIdade agrupada pelo PessoaEstado
A coluna PessoaEstado é exibida com um apelido chamado "Estado" e a função de agregação MAX da coluna PessoaIdade é exibida com um apelido chamado "Idade"
Há um filtro sobre as linhas já agrupadas para trazer apenas os agrupamentos cujo MAX da PessoaIdade seja menor que o valor 50
Ordenando a exibição das linhas pela coluna PessoaIdade utilizando-se do apelido "Idade" em ordem decrescente de valor
*/

SELECT PessoaEstado AS Estado, MAX(PessoaIdade) AS Idade
  FROM dbo.Pessoa 
 WHERE PessoaIdade >= 30 
 GROUP BY PessoaEstado 
HAVING MAX(PessoaIdade) < 50 
 ORDER BY Idade DESC 

/*
Atenção: no exemplo abaixo não podemos usar o apelido "Idade" referente à coluna PessoaIdade como filtro de agrupamento na cláusula HAVING!!!
*/

/*
SELECT PessoaEstado AS Estado, MAX(PessoaIdade) AS Idade
  FROM dbo.Pessoa 
 WHERE PessoaIdade >= 30 
 GROUP BY PessoaEstado 
HAVING MAX(Idade) < 50 
 ORDER BY Idade DESC 
*/