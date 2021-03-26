/************************************************************************
Cidade (codcid, nome, uf)
Filial(codfilial, nome, endereço, codcid)
Empregado(codemp, nome, endereço, codcid,ct, rg, cpf, salário, codfilial)
Produto (codprod, descrição, preço, nomecategoria, descriçãocategoria)
Vende (codprod, codfilial)
************************************************************************/

CREATE DATABASE aula02_correcao_revisao;

USE aula02_correcao_revisao;

CREATE TABLE cidades
(
    id INT not null PRIMARY KEY auto_increment,
    nome VARCHAR(50) NOT null,
    uf CHAR(2) not null
);

INSERT INTO cidades
values (1, 'torres','rs');
INSERT INTO cidades
values (2, 'sombrio','sc');
INSERT INTO cidades
values (3, 'sao paulo','sp');

CREATE TABLE filiais
(
    id INT not null PRIMARY KEY auto_increment,
    nome VARCHAR(50) NOT null,
    endereco VARCHAR(100) not null,
    id_cidade INT not null,
    CONSTRAINT filial_cidade
        FOREIGN KEY (id_cidade)
            REFERENCES cidades(id)
            on update cascade on delete restrict
);

INSERT INTO filiais
values (1, 'filial_torres','rua joao alfredo',1);
INSERT INTO filiais
values (2, 'filial_sombrio','rua alfredo jacone',2);
INSERT INTO filiais
values (3, 'filial_sp','rua cardoso rolim',3);

CREATE TABLE empregados
(
    id INT not null PRIMARY KEY auto_increment,
    nome VARCHAR(50) not null,
    cpf VARCHAR(14) not null  UNIQUE,
    rg VARCHAR(11) not null  UNIQUE,
    endereco VARCHAR(100) not null,
    salario DECIMAL(7,2) not null,
    id_cidade INT not null,
    id_filial INT not null,
    CONSTRAINT empregado_cidade
        FOREIGN KEY (id_cidade)
            REFERENCES cidades(id)
            on update cascade on delete restrict,
    CONSTRAINT empregado_filial
        FOREIGN KEY (id_filial)
            REFERENCES filiais(id)
            on update cascade on delete restrict
);

INSERT INTO empregados
values (1, 'joao','03292001001',1111111111,'joao das flores',550,1,1);
INSERT INTO empregados
values (2, 'paulo','03292001002',1111111112,'paulo das flores',600,2,2);
INSERT INTO empregados
values (3, 'pedro','03292001003',1111111113,'pedro das flores',400,3,3);

CREATE TABLE produtos
(
    id INT NOT null PRIMARY KEY auto_increment,
    descricao VARCHAR(100) NOT null,
    preco DECIMAL(7,2) NOT null,
    nome_categoria VARCHAR(100) NOT null,
    descricao_categoria VARCHAR(100)
);

INSERT INTO produtos
values (1, 'sabao',2.5,'limpeza','sabado neutro');
INSERT INTO produtos
values (2, 'sabonete',3.5,'higiene','sabonenete de aveia');
INSERT INTO produtos
values (3, 'aroz',5.3,'alimentos','aroz branco');

CREATE TABLE vendas
(
    id_produto INT not null,
    id_filial INT not null,
    CONSTRAINT vende_produto
        FOREIGN KEY (id_produto)
            REFERENCES produtos(id)
            on update cascade on delete restrict,
    CONSTRAINT filial_vende
        FOREIGN KEY (id_filial)
            REFERENCES filiais(id)
            on update cascade on delete restrict
);

INSERT INTO vendas
values(1,1);
INSERT INTO vendas
values(2,2);
INSERT INTO vendas
values(3,3);



-- =========================

-- produto mais caro
select	max(preco) as mais_caro -- alias = apelido da coluna no sql
from	produtos;


-- produtos que custam mais que a média
select	preco
from	produtos;
where preco > (SELECT avg(preco) FROM produtos);

-- -------------------------------------------------------------


-- Listar o nome dos produtos vendidos pela filial “f3”.

-- d) Listar o nome dos produtos vendidos pela filial “f3”.
select 	p.id as id_do_produto, p.descricao as nome_do_produto, v.id_filial -- ultimo comando executado no sgbd
from	vendas v, produtos p -- primeiro comando executado
where 	v.id_produto = p.id  -- segundo comando executado
		and v.id_filial = 3;
        
-- mesma consulta usando join

-- me mostra todas as filiais que tem vendas.. me mostra o nome dos produtos vendidos.
select 	p.id as id_do_produto, p.descricao as nome_do_produto, v.id_filial -- ultimo comando executado no sgbd
from	vendas v INNER JOIN produtos p ON p.id = v.id_produto
where 	v.id_filial = 3;

-- -------------------------------------------------------------

insert into filiais (nome, endereco, id_cidade) values ('rio', 'rua x', '10')



/* join ele tem variações.. são as 3 principais. .Vamos ver 1 hoje somente.

INNER JOIN
LEFT JOIN 
RIGHT JOIN

*/ 

-- e) Listar os nomes e números de RG dos funcionários que moram no Rio Grande do Sul e tem salário superior a R$ 500,00.

select * from cidades;

-- com JOIN

SELECT 	e.nome, e.rg, e.salario, c.nome, c.uf
FROM 	empregados e inner join cidades c ON c.id = e.id_cidade
WHERE	c.uf ='rs' and salario > 500

-- sem JOIN e o mesmo resultado
SELECT 	e.nome, e.rg, e.salario, c.nome, c.uf
FROM 	empregados e , cidades c 
WHERE	c.id = e.id_cidade and 
c.uf ='rs' and salario > 500
