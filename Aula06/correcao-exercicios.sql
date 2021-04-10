SET SQL_SAFE_UPDATES=0;

from clientes 
		inner join contas_receber on clientes.id = contas_receber.id_cliente


create table produtos
(
	id int not null auto_increment primary key, 
    codbar varchar(15), 
    descricao varchar(70) not null, 
    valor decimal(18,2) default 0
);

insert into produtos (codbar,descricao, valor) 
	values 
		('78912341234', 'Abacaxi', 12),
        ('78912341234', 'Abacaxi', 13),
        ('78912341234', 'Abacaxi', 14),
        ('78912341000', 'laranja', 5),
        ('78912341588', 'abacate', 2),
        ('123456', 'limão', 22),
        ('123456', 'limão', 32),
        ('12345689', 'uva', 6),
        ('wer13555', 'goiaba',2.99),
        ('45', 'kiwi',5),
        ('656565', 'mamao',6.5),
        ('656565', 'mamao',6.5),
        ('656565', 'mamao',6.5),
        ('656565', 'mamao',6.5),
        ('656565', 'melao',7);

select * from produtos;

-- incluir o campo quant_estoque na tablea produtos.. tipo decimal com 3 casas decimais

alter table produtos add column quantidade_estoque decimal(12,3) default 0;
alter table produtos add column ponto_pedido decimal(12,3) default 0;

update produtos set quantidade_estoque = 0

/*a)*/
 
select codbar, count(codbar) as quantos_tem
from  produtos
where valor>10
group by codbar
having quantos_tem>1;   

/*b)
Todos os alunos postam tarefas das disciplinas em que estão cursando. A coordenação do curso quer dar um presente para os 
10 alunos que mais postam tarefas nas suas disciplinas. Liste esses alunos mostrando quantas tarefas eles postaram.
*/ 
select 	alunos.nome as nome_aluno, count(tarefas.id_aluno) as quantas_tarefas	
from 	alunos inner join  tarefas on alunos.id = tarefas.id_aluno
group by alunos.id
having quantas_tarefas >0
order by quantas_tarefas desc
limit 3;

Joana	22
Lucas	15
Jr		10
Cassio 	5
Alice	1
Amanda	0

/*
c) Aproveite também e liste as disciplinas que tem mais que 50 tarefas postadas pelos alunos no semestre 2021-1. 
*/


select 		disciplinas.nome as nome_disciplina, count(tarefas.id) as quantidade_tarefas
from 		disciplinas 
				inner join tarefas 
					on disciplinas.id = tarefas.id_disciplina
where 		tarefas.data_tarefa >= '2021-01-01' and tarefas.data_tarefa <= '2021-06-30'
group by 	disciplinas.nome
having 		count(tarefas.id) > 50
order by 	quantidade_tarefas desc

select 		disciplina.nome as disciplina, alunos.nome as aluno, tarefas.reposta
from 		disciplinas 
				inner join tarefas 
					on disciplinas.id = tarefas.id_disciplina 
                right join alunos 
					on alunos.id = tarefas.id_aluno

from 		disciplinas d
				inner join alunos a
					on d.id = t.id_disc

/*testando case e */


select codbar, descricao, valor, quantidade_estoque, 
		case
			when quantidade_estoque<0 then 'estoque negativo, verifique!'
            when quantidade_estoque>=1 and quantidade_estoque<=5 then 'preocupe-se, ta quase'
            else 'ta tranquilo' 
		end as status_do_estoque
from produtos

select codbar, descricao, valor, quantidade_estoque, ponto_pedido,
			case 
				when quantidade_estoque = ponto_pedido then 'ops, chegou no ponto de comprar'
                when quantidade_estoque < ponto_pedido then 'tem que comprar mais, urgente'
                else ' ta tranquilo'
			end as status
from produtos


/* testa union e union all*/

create table contas_receber
(
	id int not null auto_increment primary key, 
    cliente varchar(70) not null,
    valor decimal(18,2)
);

create table contas_pagar
(
	id int not null auto_increment primary key, 
    fornecedor varchar(70) not null,
    valor decimal(18,2)
);

insert into contas_receber (cliente, valor)
	values 
		('x',250),
        ('y',250),
        ('z',250),
        ('a',250),
        ('b',250),
        ('c',250);

insert into contas_pagar(fornecedor, valor)
	values 
		('xa',250),
        ('yb',350),
        ('zc',550),
        ('ad',6250),
        ('be',550),
        ('cf',650);



alter table contas_pagar add column data_vencimento date;
alter table contas_receber add column data_vencimento date;
select * from contas_pagar;
select * from contas_receber;

/* relatório das contas a receber e a pagar */
select 	'E' as tipo, id, cliente as pessoa, data_vencimento, valor,
			case
				when data_vencimento = current_date then 'VENCENDO_HOJE'
				when data_vencimento < current_date then 'EM_ATRASO'
				else
					'A_VENCER'
			end as situacao,
            case
				when data_vencimento < current_date then valor * 1.10
            else valor 
        end as valor_final
	from 	contas_receber
    
	UNION ALL
select 	'S' as tipo, id, fornecedor as pessoa, data_vencimento, valor * (-1) as valor,
		case
			when data_vencimento = current_date then 'VENCENDO_HOJE'
			when data_vencimento < current_date then 'EM_ATRASO'
			else
				'A_VENCER'
		end as situacao,
		case
			when data_vencimento < current_date then (valor * 1.10) * (-1)
			else valor *(-1)
        end as valor_final
from 	contas_pagar;


-- saldo do receber vs a pagar
SELECT SUM(valor_final) as saldo 
FROM(
	select 	'E' as tipo, id, cliente as pessoa, data_vencimento, valor,
			case
				when data_vencimento = current_date then 'VENCENDO_HOJE'
				when data_vencimento < current_date then 'EM_ATRASO'
				else
					'A_VENCER'
			end as situacao,
            case
				when data_vencimento < current_date then valor * 1.10
            else valor 
        end as valor_final
	from 	contas_receber
    
	UNION ALL
select 	'S' as tipo, id, fornecedor as pessoa, data_vencimento, valor * (-1) as valor,
		case
			when data_vencimento = current_date then 'VENCENDO_HOJE'
			when data_vencimento < current_date then 'EM_ATRASO'
			else
				'A_VENCER'
		end as situacao,
		case
			when data_vencimento < current_date then (valor * 1.10) * (-1)
			else valor *(-1)
        end as valor_final
from 	contas_pagar
) as consulta

-- vamos encapsular essa consulta numa view 

CREATE VIEW fluxo_de_caixa 
AS
select 	'E' as tipo, id, cliente as pessoa, data_vencimento, valor,
			case
				when data_vencimento = current_date then 'VENCENDO_HOJE'
				when data_vencimento < current_date then 'EM_ATRASO'
				else
					'A_VENCER'
			end as situacao,
            case
				when data_vencimento < current_date then valor * 1.10
            else valor 
        end as valor_final
	from 	contas_receber
    
	UNION ALL
select 	'S' as tipo, id, fornecedor as pessoa, data_vencimento, valor * (-1) as valor,
		case
			when data_vencimento = current_date then 'VENCENDO_HOJE'
			when data_vencimento < current_date then 'EM_ATRASO'
			else
				'A_VENCER'
		end as situacao,
		case
			when data_vencimento < current_date then (valor * 1.10) * (-1)
			else valor *(-1)
        end as valor_final
from 	contas_pagar;

SELECT * from fluxo_de_caixa where situacao='EM_ATRASO' AND tipo ='S' and pessoa ='cf'

insert into fluxo_caixa (pessoa, data_vencimento, valor)
values (




select * from produtos where  codbar =  '12345689'produtos_resumidos

create view produtos_resumidos
as
select codbar, descricao, valor
from produtos 



select * from produtos_resumidos

update produtos_resumidos set valor = 7.99 where codbar='12345689'






        