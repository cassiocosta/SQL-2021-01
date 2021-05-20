create database biblioteca;
use biblioteca;
SET SQL_SAFE_UPDATES=0;

-- UNSIGNED: garante que o usuário não vai conseguir inserir um id negativo,. .
CREATE TABLE editoras (
  id INT UNSIGNED  NOT NULL   AUTO_INCREMENT,
  nome VARCHAR(40)  NULL    ,
PRIMARY KEY(id));


insert into editoras (nome) 
	values ('Ulbra'), ('Saraiva'), ('Person'), ('Abril');    

CREATE TABLE autores (
  matricula INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT,
  nome VARCHAR(40)  NOT NULL  ,
  cpf VARCHAR(11),
  endereco VARCHAR(50)  NULL  ,
  data_nascimento DATE  NULL  ,
  nacionalidade VARCHAR(30)  NULL    ,
PRIMARY KEY(matricula));

insert into autores (nome)
	values ('Artur'), ('Cassio'),('Amanda'), ('Julia'), ('Digiorge');


CREATE TABLE assuntos (
  id CHAR(1)  NOT NULL,
  descricao VARCHAR(40)  NOT NULL    ,
PRIMARY KEY(id));

insert into assuntos
	values ('A','Admin'), ('I','IA'),('L','Lógica'), ('B','BD'), ('O','OO');

CREATE TABLE livros (
  id INTEGER UNSIGNED  NOT NULL   AUTO_INCREMENT primary key,
  id_assunto CHAR(1)  NOT NULL  ,
  id_editora INTEGER UNSIGNED  NOT NULL  ,
  titulo VARCHAR(80)  NULL  ,
  preco decimal(12,2)  NULL  ,
  data_lancamento DATE  NULL    ,
  FOREIGN KEY(id_editora)
    REFERENCES editoras(id)
      ON DELETE restrict
      ON UPDATE cascade,
  FOREIGN KEY(id_assunto)
    REFERENCES assuntos(id)
      ON DELETE restrict
      ON UPDATE cascade);
      
  insert into livros (id_assunto, id_editora, titulo, preco, data_lancamento)
	values ('A', 1, 'Teoria Geral', 150,null),
		   ('I', 2, 'Machine Learning', 200,'2020-01-01'),
		   ('O', 3, 'LPOO2', 50,null),
		   ('B', 4, 'Fundamentos de Bancos de dados', 200,'2022-01-01');
           
	insert into livros (id_assunto, id_editora, titulo, preco, data_lancamento)
		values ('O', 3, 'Padroes de projetos', 350,'2021-12-24');
      
CREATE TABLE autores_livros (
  matricula INTEGER UNSIGNED  NOT NULL  ,
  id_livro INTEGER UNSIGNED  NOT NULL    ,
PRIMARY KEY(matricula, id_livro)  , -- chve composta, onde u informo mais de uma coluna como primary key
  FOREIGN KEY(matricula)
    REFERENCES autores(matricula)
      ON DELETE RESTRICT
      ON UPDATE CASCADE,
  FOREIGN KEY(id_livro)
    REFERENCES livros(id)
      ON DELETE RESTRICT
      ON UPDATE CASCADE);
            
      insert into autores_livros 
		values 	(1,3),
				(2,3),
				(3,3),
				(3,4),
				(4,5);
		
