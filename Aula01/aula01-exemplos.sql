create schema aula01;
use aula01;

-- comandos DDL - estruturas create, alter e drop


/*
	tipos de dados conhecidos
    smallint, int, bigint 
    float 899.988888888888888
    numeric(12,2), decimal(12,3)
    123456789012
    
    varchar(tamanho) varchar(10)
    char(10)
    
    
*/

create table cidades 
(
	id int primary key,
    nome varchar(50) not null, 
    uf varchar(2)
);

alter table cidades alter column uf varchar(3);


drop table clientes;
-- um cliente pertence a uma cidade
create table clientes
(
	id int primary key,
    nome varchar(100) not null,
    id_cidade int not null,
    constraint fk_cliente_pertece_cidade
		foreign key (id_cidade)
			references cidades(id)
				on delete restrict 
                on update cascade
);

/*DML
insert
update
delete
select 

*/

insert into cidades (id, nome, uf) 
	values
		(100,'Torres', 'RS'),
        (200,'Arroio do Sal', 'RS'),
        (300,'Capão', 'RS');
	
select id, nome, uf from cidades 


insert into clientes 
	values 
		(1, 'David', 100),
        (2, 'joana', 100),
        (3, 'Amanda', 200);
        
        select * from clientes
	
    delete from cidades where id=300



/*
	restrições de integridade nas foreign key
    on delete [variação]
    on update [variação]
    
    
    variação
    -----
    cascade
    restrict
    set null
    no action
*/




insert into clientes (id, nome) values (1,'Cássio');
select * from clientes;



/*
FUS que mostre os clientes e no mome da cidade que cada um mora

*/

select cli.id, cli.nome, cid.nome as cidade 
from clientes cli, cidades cid
where cli.id_cidade = cid.id

 


david 	torres
ana		arroio sal
silvia 	osorio