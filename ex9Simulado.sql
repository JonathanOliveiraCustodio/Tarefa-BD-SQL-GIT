CREATE DATABASE ex9
GO
USE ex9
GO
CREATE TABLE editora (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
site			VARCHAR(40)		NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE autor (
codigo			INT				NOT NULL,
nome			VARCHAR(30)		NOT NULL,
biografia		VARCHAR(100)	NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE estoque (
codigo			INT				NOT NULL,
nome			VARCHAR(100)	NOT NULL	UNIQUE,
quantidade		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL	CHECK(valor > 0.00),
codEditora		INT				NOT NULL,
codAutor		INT				NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (codEditora) REFERENCES editora (codigo),
FOREIGN KEY (codAutor) REFERENCES autor (codigo)
)
GO
CREATE TABLE compra (
codigo			INT				NOT NULL,
codEstoque		INT				NOT NULL,
qtdComprada		INT				NOT NULL,
valor			DECIMAL(7,2)	NOT NULL,
dataCompra		DATE			NOT NULL
PRIMARY KEY (codigo, codEstoque, dataCompra)
FOREIGN KEY (codEstoque) REFERENCES estoque (codigo)
)
GO
INSERT INTO editora VALUES
(1,'Pearson','www.pearson.com.br'),
(2,'Civiliza  o Brasileira',NULL),
(3,'Makron Books','www.mbooks.com.br'),
(4,'LTC','www.ltceditora.com.br'),
(5,'Atual','www.atualeditora.com.br'),
(6,'Moderna','www.moderna.com.br')
GO
INSERT INTO autor VALUES
(101,'Andrew Tannenbaun','Desenvolvedor do Minix'),
(102,'Fernando Henrique Cardoso','Ex-Presidente do Brasil'),
(103,'Diva Mar lia Flemming','Professora adjunta da UFSC'),
(104,'David Halliday','Ph.D. da University of Pittsburgh'),
(105,'Alfredo Steinbruch','Professor de Matem tica da UFRS e da PUCRS'),
(106,'Willian Roberto Cereja','Doutorado em Ling  stica Aplicada e Estudos da Linguagem'),
(107,'William Stallings','Doutorado em Ci ncias da Computac o pelo MIT'),
(108,'Carlos Morimoto','Criador do Kurumin Linux')
GO
INSERT INTO estoque VALUES
(10001,'Sistemas Operacionais Modernos ',4,108.00,1,101),
(10002,'A Arte da Pol tica',2,55.00,2,102),
(10003,'Calculo A',12,79.00,3,103),
(10004,'Fundamentos de F sica I',26,68.00,4,104),
(10005,'Geometria Analatica',1,95.00,3,105),
(10006,'Gram tica Reflexiva',10,49.00,5,106),
(10007,'Fundamentos de F sica III',1,78.00,4,104),
(10008,'Calculo B',3,95.00,3,103)
GO
INSERT INTO compra VALUES
(15051,10003,2,158.00,'04/07/2021'),
(15051,10008,1,95.00,'04/07/2021'),
(15051,10004,1,68.00,'04/07/2021'),
(15051,10007,1,78.00,'04/07/2021'),
(15052,10006,1,49.00,'05/07/2021'),
(15052,10002,3,165.00,'05/07/2021'),
(15053,10001,1,108.00,'05/07/2021'),
(15054,10003,1,79.00,'06/08/2021'),
(15054,10008,1,95.00,'06/08/2021')

--Pede-se:	
--1) Consultar nome, valor unitário, nome da editora e nome do autor dos livros do estoque que foram vendidos. Não podem haver repetições.

SELECT 
 est.nome,
 est.valor,
 edi.nome,
 comp.qtdComprada,
 aut.nome
-- autor,	
FROM estoque est INNER JOIN editora edi
 ON est.codEditora = edi.codigo
 INNER JOIN compra comp
  ON comp.codEstoque = est.codigo
  INNER JOIN autor aut
  ON aut.codigo = est.codAutor
   WHERE comp.dataCompra IS NOT NULL 

--2) Consultar nome do livro, quantidade comprada e valor de compra da compra 15051	
SELECT 
 est.nome,
 comp.qtdComprada,
 comp.valor	
FROM estoque est INNER JOIN compra comp
ON est.codigo = comp.codEstoque
WHERE comp.codigo = 15051

SELECT * FROM autor  
SELECT * FROM editora  
SELECT * FROM estoque
--3) Consultar Nome do livro e site da editora dos livros da Makron books (Caso o site tenha mais de 10 dígitos, remover o www.).	
 SELECT 
  est.nome,
  CASE WHEN(LEN(ed.site) > 10) THEN
    (SUBSTRING(ed.site, 5, LEN(ed.site)))
    ELSE ed.site END,
  aut.nome
 FROM estoque est	INNER JOIN	editora ed
  ON est.codEditora = ed.codigo
   INNER JOIN autor aut
   ON aut.codigo = est.codAutor
    WHERE 
	 ed.nome LIKE 'Makron books'
    

--4) Consultar nome do livro e Breve Biografia do David Halliday	
  SELECT 
   est.nome,
   aut.nome,
   aut.biografia
  FROM estoque est INNER JOIN autor aut
   ON est.codAutor = aut.codigo
    WHERE aut.nome = 'David Halliday'

--5) Consultar código de compra e quantidade comprada do livro Sistemas Operacionais Modernos	
  SELECT 
   comp.codigo,
   comp.qtdComprada,
   est.nome,
   est.valor
  FROM compra comp INNER JOIN estoque est
   ON comp.codEstoque = est.codigo
    WHERE est.nome LIKE '%Modernos%'

--6) Consultar quais livros não foram vendidos
  SELECT 
   est.nome
  FROM estoque est LEFT OUTER JOIN compra comp
   ON est.codigo = comp.codEstoque
    WHERE comp.codigo IS NULL

	SELECT * FROM compra

--7) Consultar quais livros foram vendidos e não estão cadastrados   verificar	
     SELECT 
     est.nome
     FROM estoque est RIGHT OUTER JOIN compra comp
      ON est.codigo = comp.codEstoque
    WHERE comp.codigo IS NOT NULL
--	SELECT * FROM compra

--8) Consultar Nome e site da editora que não tem Livros no estoque (Caso o site tenha mais de 10 dígitos, remover o www.)	VERIFICAR
   SELECT 
    ed.nome,
	CASE WHEN(LEN(ed.site) > 10) THEN
    (SUBSTRING(ed.site, 5, LEN(ed.site)))
    ELSE ed.site END
   FROM editora ed LEFT OUTER JOIN estoque est
    ON ed.codigo = est.codEditora
	 WHERE est.quantidade IS NULL
 
--9) Consultar Nome e biografia do autor que não tem Livros no estoque (Caso a biografia inicie com Doutorado, substituir por Ph.D.)
SELECT 
	aut.nome,
	CASE WHEN SUBSTRING(aut.biografia, 1, 10) = 'Doutorado' THEN 'Ph.D.'
	ELSE aut.biografia
	END AS Biografia
FROM autor aut, estoque est 
WHERE aut.codigo = est.codAutor


--10) Consultar o nome do Autor, e o maior valor de Livro no estoque. Ordenar por valor descendente	
   SELECT
    aut.nome,
	MAX(est.valor) 
   FROM
    autor aut INNER JOIN estoque est 
	 ON aut.codigo = est.codAutor
	  GROUP BY aut.nome,est.valor
	  ORDER BY est.valor DESC
    
  
--11) Consultar o código da compra, o total de livros comprados e a soma dos valores gastos. Ordenar por Código da Compra ascendente.	
  SELECT 
   c.codigo,
   c.qtdComprada,
   SUM(c.valor)
  FROM compra c 
   GROUP BY c.valor,c.qtdComprada,c.codigo
  ORDER BY c.codigo ASC
 

--12) Consultar o nome da editora e a média de preços dos livros em estoque.Ordenar pela Média de Valores ascendente.	

  SELECT 
   ed.nome,
  CAST(AVG(est.valor) AS DECIMAL(4,1)) AS "Média dos Valores"
  FROM editora ed INNER JOIN estoque est
   ON ed.codigo = est.codEditora
   GROUP BY ed.nome,est.valor
   ORDER BY est.valor ASC
    
--13) Consultar o nome do Livro, a quantidade em estoque o nome da editora, o site da editora (Caso o site tenha mais de 10 dígitos, remover o www.), criar uma coluna status onde:	
	--Caso tenha menos de 5 livros em estoque, escrever Produto em Ponto de Pedido
	--Caso tenha entre 5 e 10 livros em estoque, escrever Produto Acabando
	--Caso tenha mais de 10 livros em estoque, escrever Estoque Suficiente
	--A Ordenação deve ser por Quantidade ascendente
SELECT
  liv.nome,
  est.quantidade,
  ed.nome,
  CASE WHEN est.quantidade < 5 THEN 'Produto em Ponto de Pedido'
    WHEN est.quantidade BETWEEN 5 AND 10 THEN 'Produto Acabando'
    ELSE 'Estoque Suficiente'
  END AS status,
  CASE WHEN LEN(ed.site) > 10 THEN
    RIGHT(ed.site, LEN(ed.site) - 4)
  ELSE ed.site
  END AS site
FROM estoque liv
INNER JOIN estoque est ON liv.codigo = est.codigo
INNER JOIN editora ed ON est.codEditora = ed.codigo
ORDER BY est.quantidade;


--14) Para montar um relatório, é necessário montar uma consulta com a seguinte saída: Código do Livro, Nome do Livro, Nome do Autor, Info Editora (Nome da Editora + Site) de todos os livros	
	--Só pode concatenar sites que não são nulos

	SELECT 
	 est.codigo,
	 est.nome,
	 aut.nome,
	 ed.nome + ' '+ ed.site 
	FROM estoque est INNER JOIN autor aut
	 ON est.codAutor = aut.codigo
	  INNER JOIN editora ed 
	   ON ed.codigo = est.codEditora


--15) Consultar Codigo da compra, quantos dias da compra até hoje e quantos meses da compra até hoje	
   SELECT 
     c.codigo,
	 DATEDIFF(DAY, c.dataCompra, GETDATE()) AS "Quantidade de dias",
	 DATEDIFF(MONTH, c.dataCompra, GETDATE()) AS "Quantidade de Meses"
    FROM compra c 

--16) Consultar o código da compra e a soma dos valores gastos das compras que somam mais de 200.00
 SELECT 
	comp.codigo,
	SUM(comp.valor) AS total
FROM compra comp
GROUP BY comp.codigo
HAVING SUM(comp.valor) > 200