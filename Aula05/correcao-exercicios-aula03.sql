-- Soluções exercícios Aula03 - joins

/*
sequencia que o sgbd executa o SQL Select

1 - FROM 
2 - WHERE
3 - SELECT 
*/

-- TODAS as editoras QUE TEM livros cadastros



FROM editoras INNER JOIN 	livros ON editoras.id = livros.id_editora
FROM editoras RIGHT JOIN	livros ON editoras.id = livros.id_editora
-- LINHA 15 e 16 tem o mesmo resultado de tuplas. ?
/*
sim, vai mostrar todos os livros e suas editoras e 
as editoras que tem livros cadastros.
*/



-- TODAS as editoras que tem e NÃO TEM livros cadastrados.        
FROM editoras LEFT JOIN	livros ON editoras.id = livros.id_editora

FROM livros RIGHT JOIN	editoras ON editoras.id = livros.id_editora

-- todos os livros e as suas editoras
FROM livros  LEFT JOIN 	 editoras ON editoras.id = livros.id_editora



/*
Solução dos exercícios*/

-- 
-- a Monte um comando para excluir da tabela livros aqueles que possuem o código maior ou igual a 2,
-- que possuem o preço maior que R$ 50,00 e que já foram lançados.

delete FROM livros 
where id >=2 and preco>50 and data_lancamento<=current_date and 
	data_lancamento is not null -- quando é data se usa o is null (is not null)

-- b - Escreva o comando que seleciona as colunas NOME, CPF e ENDERECO, da tabela AUTOR, 
-- para aqueles que possuem a palavra ‘joão’ no nome.

SELECT 	nome, cpf, endereco
FROM autores
WHERE	nome like '%joão%' -- like com % como coringa de caracteres. no postgres, usa-se ilike


-- c Excluir o livro cujo título é ‘BANCO DE DADOS DISTRIBUÍDO’ ou ‘BANCOS DE DADOS DISTRIBUÍDOS’. 
-- Somente essas duas opções devem ser consideradas.

DELETE
FROM livros 
WHERE titulo ='BANCO DE DADOS DISTRIBUIDO_';

-- d Selecione o nome e o CPF de todos os autores que nasceram após 01 de janeiro de 1990.
select nome, cpf
from autores
where data_nascimento > '1990-01-01'

-- e - Selecione a matrícula e o nome dos autores que possuem RIO DE JANEIRO no seu endereço.
select matricula, nome
from autores
where endereco like '%rio de janeiro%'

-- f Atualize para zero o preço de todos os livros onde a data de lançamento for nula ou onde seu preço 
-- atual for inferior a R$ 55,00.

update livros set preco = 0 
where data_lancamento is null and preco <55

-- g Exclua todos os livros onde o assunto for diferente de ‘S’, ‘P’, ou ‘B’.
-- use in not in
select * from assuntos
select *
from livros
where id_assunto not in('A','B','O')

-- h Escreva o comando para contar quantos são os autores cadastrados na tabela AUTORES.

select count(matricula) as quantos
from autores



-- i Escreva o comando que apresenta qual o número médio de autores de cada livro. 
-- Você deve utilizar, novamente, a tabela AUTORes_LIVRO. 
select id_livro, avg(matricula) as media
from autores_livros
group by id_livro


-- j Apresente o comando SQL para gerar uma listagem dos códigos dos livros que possuem a menos dois autores.

select id_livro, matricula from autores_livros order by id_livro asc;

select id_livro
from autores_livros 
group by id_livro
having count(matricula) <2;

-- k Escreva o comando para apresentar o preço médio dos livros por código de editora.
--  Considere somente aqueles que custam mais de R$ 45,00.
select id_editora, avg(preco) as media
from livros
where preco >45
group by id_editora

-- l Apresente o preço máximo, o preço mínimo e o preço médio dos livros cujos assuntos são 
-- ‘S’ ou ‘P’ ou ‘B’, para cada código de editora.

select id_editora, max(preco) as maximo, min(preco) as minimo, avg(preco) as media
from livros 
where id_assunto in('A', 'I') 
group by id_editora

-- m Altere o comando do exercício anterior para só considerar os livros que já foram lançados
	-- (data de lançamento inferior a data atual) e cujo o preço máximo é inferior a R$ 100,00.

select id_editora, max(preco) as maximo, min(preco) as minimo, avg(preco) as media
from livros 
where id_assunto in('A', 'I') and data_lancamento <= current_date
group by id_editora
having max(preco)<100


-- ------------------------------------------
-- ------------------------------------------
-- 4 Nos exercícios com junções de tabelas, utilize JOINS.

/* 	Estão sendo estudados aumentos nos preços dos livros. Escreva o comando SQL que retorna uma listagem contendo o 
	titulo dos livros, e mais três colunas: uma contendo os preços dos livros acrescidos de 10% 
    (deve ser chamada de ‘Opção_1’), a segunda contendo os preços acrescidos de 15% (deve ser chamada de ‘Opção_2’) e a 
    terceira contendo os preços dos livros acrescidos de 20% (deve ser chamada de ‘Opção_3’). 
    Somente devem ser considerados livros que já tenham sido lançados.
*/

select 	titulo, 
		preco, 
        preco*1.10 as jeitao,  
		preco + ((preco * 10)/100) as dez, 
        preco * 1.15 as quinze, 
        preco * 1.20 as vinte
from livros
where data_lancamento is not null and data_lancamento < current_date

