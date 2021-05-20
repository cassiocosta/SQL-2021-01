/************************************************************************
Livro(codlivro, titulo, codautor, nfolhas, editora, valor, codcat)
Categoria (codcat, nome, descrição)
Autor(codautor, nome, codcid)
Cliente(codcliente, nome, endereço, codcid)
Cidade(codcid, nome, UF)
Venda (Codlivro, codcliente, quantidade, data)
************************************************************************/
create database livraria_vendas;

USE livraria_vendas;

CREATE TABLE cidades
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR (50) not null,
    uf CHAR(2) not null
);

INSERT INTO cidades(nome,uf)
values ('torres','rs'), ('sombrio','sc'), ('curitiba','pr');


CREATE TABLE autores
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR (50) not null,
    id_cidade int not null,
    CONSTRAINT autores_pertence_a_cidade
        FOREIGN KEY (id_cidade)
            REFERENCES cidades(id)
            on update cascade on delete cascade
);

INSERT INTO autores (nome, id_cidade)
values ('paulo',1);
INSERT INTO autores (nome, id_cidade)
values ('pedro',2);
INSERT INTO autores (nome, id_cidade)
values ('jonas',3);

CREATE TABLE categorias
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR (50) not null,
    descricao VARCHAR (250) not null
);

INSERT INTO categorias (nome,descricao)
values('infantil','livros voltado para criancas...');
INSERT INTO categorias (nome,descricao)
values('adolecentes','filme de ação classificação 16 anos');
INSERT INTO categorias (nome,descricao)
values('adulto','folclore classificação 18 anos');

CREATE TABLE livros
( 
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR (50) not null,
    editora VARCHAR(100) not null,
    valor DECIMAL(12,2) not null default 0,
    n_folhas INT not null default 0,
    id_autor int not null,
    id_categoria int not null,
    CONSTRAINT livros_pertence_a_autores
        FOREIGN KEY (id_autor)
            REFERENCES autores(id)
            on update cascade on delete cascade,
    CONSTRAINT livros_pertence_a_categorias
        FOREIGN KEY (id_categoria)
            REFERENCES categorias(id)
            on update cascade on delete cascade
);

INSERT INTO livros (titulo,editora,valor,n_folhas,id_autor,id_categoria)
values('branca de neve','aurora',90.5,100,1,1);
INSERT INTO livros (titulo,editora,valor,n_folhas,id_autor,id_categoria)
values('sete segundos','sapiens',130.5,200,2,2);
INSERT INTO livros (titulo,editora,valor,n_folhas,id_autor,id_categoria)
values('a casa das sete mulheres','globo livros',200.9,300,3,3);

CREATE TABLE clientes
(
    id_cliente int AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR (50) not null,
    endereco VARCHAR (80) not null,
    id_cidade int not null,
    CONSTRAINT clientes_pertence_a_cidade
        FOREIGN KEY (id_cidade)
            REFERENCES cidades(id)
            on update cascade on delete cascade
);

INSERT INTO clientes(nome, endereco,id_cidade)
values('rodrigo','Rua oliveira',1),
('rogerio','avenida helio maggi',2),
('guilherme','rua das flores',3);

CREATE TABLE vendas
(
	id int not null auto_increment primary key, 
    quantidade INT not null,
    data_ DATE not null,
    id_cliente int not null,
    id_livro int not null,
    CONSTRAINT vendas_pertence_a_clientes
        FOREIGN KEY (id_cliente)
            REFERENCES clientes(id_cliente)
            on update cascade on delete cascade,
    CONSTRAINT vendas_pertence_a_livros
        FOREIGN KEY (id_livro)
            REFERENCES livros(id)
            on update cascade on delete cascade
);

quantidade	data			id_cliente	id_livro
1			2021-03-19		1			1
1			2021-03-19		1			1

INSERT INTO vendas(quantidade, data_, id_cliente, id_livro)
values(1,'2019-7-01',1,1),
(2,'2020-11-12',2,2),
(3,'2020-12-08',3,3);


-- a) Mostrar o número total de vendas realizadas. 
select count(id) as numero from vendas;


-- b) 	Listar os títulos e valores dos livros da categoria “infantil’. Mostra também o nome da categoria. 
-- 		mostre também o nome do autor do livro infantil

-- qual a sequencia de execução do sql select que o sgbd executa?

/*
	1 - FROM
    2 - WHERE
    3 - GROUP BY
    4 - HAVING 
    5 - SELECT (ULTIMO)
    
*/
SELECT l.titulo, l.valor,c.nome as categoria, a.nome as autor
FROM categorias c		
	INNER JOIN livros l
		ON c.id = l.id_categoria
	INNER JOIN autores a					
            ON a.id = l.id_autor
WHERE c.nome = 'infantil'
ORDER BY l.titulo ASC


-- c) 	Listar os  títulos e nome dos autores dos livros que custam mais que R$ 100,00.
-- c.1_		Listar os nomes dos clientes juntamente com o nome da cidade onde moram e UF.
	SELECT livros.titulo, autores. nome as autor, livros.valor
	FROM 	livros 				
				INNER JOIN autores
					ON autores.id = livros.id_autor
	WHERE 	livros.valor > 100
    
    SELECT	clientes.nome, cidades.nome as cidade , cidades.uf
    FROM 	cidades 
				INNER JOIN 	clientes
					ON cidades.id = clientes.id_cidade

-- d Listar os nomes dos clientes juntamente com os nomes de todos os livros comprados por ele.

SELECT 	clientes.nome, livros.titulo, vendas.data_
FROM 	livros 
			INNER JOIN vendas
				ON vendas.id_livro = livros.id
			INNER JOIN clientes
				ON clientes.id_cliente = vendas.id_cliente


-- e) Listar o código do livro, o tilulo, o nome do autor, dos livros que foram vendidos no mês de março de 2021. (join)
SELECT 	livros.id, livros.titulo, autores.nome as autor
FROM 	livros 			
			INNER JOIN autores
				ON autores.id = livros.id_autor
			INNER JOIN vendas
				ON vendas.id_livro = livros.id
WHERE 	vendas.data_ >= '2021-03-01' and vendas.data_ <= '2021-03-31' 
		vendas.data_ between '2021-03-01' and '2021-03-31' 
		
        contact(month(vendas.data_),'-',year(vendas.data)) = '3-2021'
        
	select concat(day('2021-03-01'),'/', month('2021-03-01'),'/',year('2021-03-01')) 
    select year('2021-03-01')
 


-- f) Listar o título e o autor dos 5 livros mais vendidos do mês de janeiro.

SELECT 	sum(vendas.quantidade) as total 
FROM 	livros 			
			INNER JOIN autores
				ON autores.id = livros.id_autor
			INNER JOIN vendas
				ON vendas.id_livro = livros.id
WHERE 	vendas.data_ >= '2021-01-01' and vendas.data_ <= '2021-01-31' 
group by livros.titulo, autores.nome
order by sum(vendas.quantidade) DESC
limit 1
		
titulo	sum(quantidade)
x		10
y		20
z		15
a		12	
b		21

titulo	 quantidade
x		 	5
x			2
x			3
a			10
a			10
a			1	
y			5
y			5
y			5
y			5
z			1
z			1
z			1
z			1
z			1
z			1
z			1
z			1
z			1
z			1
z			5



-- g) Mostrar o nome do cliente que comprou o livro com o título ‘Banco de dados powerful’).

SELECT 	clientes.nome as cliente
FROM	clientes 
			INNER JOIN	vendas
				ON vendas.id_cliente = clientes.id_cliente
            INNER JOIN 	livros
				ON livros.id = vendas.id_livro
WHERE	livros.titulo = 'Banco de Dados powerful'



INSERT INTO livros (titulo,editora,valor,n_folhas,id_autor,id_categoria)
values('Banco de Dados 01','ulbra',300.9,400,3,3);


-- todos os livros que foram vendidos (inner join)
SELECT 	livros.titulo, vendas.id, vendas.data_
FROM 	livros 
			INNER JOIN vendas
				ON vendas.id_livro = livros.id;
                
-- todos os livros cadastrados e os que foram vendidos
                
SELECT 	livros.titulo, vendas.id, vendas.data_
FROM 	livros 
			LEFT JOIN vendas
				ON vendas.id_livro = livros.id
where vendas.id is null;

SELECT 	livros.titulo
FROM 	livros 
where	livros.id not in(select id_livro from vendas where id_livro = livros.id)
                

