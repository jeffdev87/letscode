select *, 1 as Test
from order_details
where discount::numeric(10,2) > 0.20
order by unit_price, quantity;

-- Se title = Owner, Prioridade 1
select 
customer_id,
company_name,
contact_name,
case 
	when contact_title = 'Owner' then 'Prioridade 1'
	when contact_title = 'Sales Manager' then 'Prioridade 2' 
	when contact_title = 'Marketing Manager' then 'Prioridade 3'  
	else 'X'
end as prioridade
from customers
where contact_title = 'Owner';

SELECT CURRENT_DATE;
SELECT NOW();
SELECT DATE_PART('MONTH', Now());
SELECT * FROM EMPLOYEES;
select *, NOW() as maythe4thbewithu from customers;

-- Retornar a o dia de nasc dos empregados
Select 
employee_id, 
first_name, date_part('year', birth_date)
from employees
where date_part('year', birth_date) BETWEEN 1960 AND 2000;

SELECT * FROM EMPLOYEES
WHERE date_part('year', hire_date) >= 1993;

select 
employee_id, 
first_name, 
birth_date,
extract('doy' from current_date) - extract('doy' from birth_date),
to_date('31/12/22', 'DD/MM/YY')::date - date_part('doy',birth_date)
from employees;

select 
to_date('31/12/22', 'DD/MM/YY');


- date_part('doy', current_date);

select date_trunc('day', current_date);

select current_date + 35;

select
first_name, birth_date, date_part('day',age(birth_date))
from employees;


SELECT first_name, birth_date, 

CAST(current_date - birth_date AS FLOAT)/365 AS IDADE,  

(current_date - birth_date)/365 AS Q, 

1 - (CAST(current_date - birth_date AS FLOAT)/365 - (current_date - birth_date)/365) as ss,

(1 - (CAST(current_date - birth_date AS FLOAT)/365 - (current_date - birth_date)/365))*365 as qnt_falta
FROM 
employees;


select 'Jose' || ' dos Santos' || ' Silva';

Select 
upper(title_of_courtesy), 
lower(first_name),
last_name,
title_of_courtesy || ' ' || first_name || ' ' || last_name as full_name 
from employees
where lower(first_name) LIKE 'a%';


select distinct first_name from employees;


select Trim(first_name) from employees;

SELECT '         test        ' as original,
trim('         test        ') as trim_total,
ltrim('         test        ') as ltrim_total,
rtrim('         test        ') as rtrim_total;


select right('Hello', 2), 
left('Test', 2), 
position('es' in 'test'),
replace('Abacaxi', 'xi', 'te');

select birth_date, date_trunc('day', birth_date) from employees;

select 
years,
date '2001-09-28' + years
from (
Select 
date_part('year', current_date) - date_part('year', date '2001-09-28') As years) as bla;


select
birth_date, 
current_bd,
today,
case 
	when current_bd - today > 0 then current_bd - today
	else 365 + (current_bd - today)
end
from
(select 
birth_date,
current_date as today,
make_date(date_part('year', current_date)::int, date_part('month', birth_date)::int, date_part('day', birth_date)::int) as current_bd
from employees) as date_table;

select 'dfdfd';

concat(, ' year')
select 
concat((date_part('year', current_date) - date_part('year', date '2001-09-28')), ' year');
		  
		  + nterval date_part('year')'year';
date '2001-09-28' + interval;

------
Sistema Bancario
Agencia - N, M - Cliente

Ag: id, nome, endereco, telefone
------

Cadastro_Id, Ag, Cliente, ....
1, 1, Jose
2, 1, Jose
3, 1, Maria
4, 2, Jose

-- Criar chave composta
-- Criar chave estrangeira - OK
CREATE TABLE cadastra_ag_cliente (
	cadastro_id SERIAL PRIMARY KEY,
	agencia_id_fk int references agencia(agencia_id),
	cliente_id_fk int references cliente(cliente_id),
	data_conta DATE,
	conta TEXT,
	--UNIQUE(agencia_id_fk, cliente_id_fk)
	CONSTRAINT ag_cliente_unique UNIQUE (agencia_id_fk, cliente_id_fk)
);

select * from agencia_2;

INSERT INTO agencia_2(nome, cidade, endereco, telefone) 
VALUES 
('Maria', 'SP', 'Moema', '0000'),
('Augusto', 'SP', 'Vila Olimpia', '0000'),
('Josefino', 'SP', 'Diadema', '0000');

-- 1:N
CREATE TABLE agencia_2(
	nome varchar(100) NOT NULL,
	cidade varchar(100) NOT NULL,
	endereco varchar(200),
	telefone text,
	constraint agencia_pk primary key (nome, cidade)
);

--Cliente:
nome, conta, endereco, rg, renda, data_nasc

cliente -(n) possui (1)- agencia

CREATE TABLE cliente2 (
	cliente_id SERIAL PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	rg TEXT UNIQUE NOT NULL,
	conta TEXT,
	endereco TEXT,
	renda NUMERIC,
	data_nasc DATE,
	nome_ag varchar(100),
	cidade_ag varchar(100),
	--agencia_id_fk INT REFERENCES agencia(agencia_id)
	constraint cliente2_agencia2_fk
		foreign key (nome_ag, cidade_ag)
			references agencia_2(nome, cidade)
);


-- notacao simplificada sem definir constraint
-- sem lista de colunas a pk da relacao referenciada sera usada
CREATE TABLE cliente3 (
	nome text,
	cidade text,
	primary key(nome, cidade),
	nome_ag text,
	cidade_ag text,
	--foreign key (nome_ag, cidade_ag) references agencia_2
	--foreign key (nome_ag) references agencia_2 --erro pq?
	foreign key (nome_ag, cidade_ag) references agencia_2
		on delete cascade
		on update cascade
);	

drop table cliente3;

- Tinha FK, tentamos inserir agencia q nao existe => Erro
- Removeu a FK, tentamos inserir uma cliente com agencia q n existe => Deixou, OK
- Tentando reinserir a FK na tabela cleinte2 => Erro
- Removemos o problema - ag n existe
- Tentamos reinserir a fk => ok
- 





select * from agencia_2;
select * from cliente2;

cliente2 -> agencia2 

ERROR:  insert or update on table "cliente2" violates 
foreign key constraint "cliente2_agencia2_fk"
DETAIL:  Key (nome_ag, cidade_ag)=(dfdfdfd, dfdfdf) is not present in table "agencia_2".
SQL state: 23503

alter table cliente2
add constraint cliente2_agencia2_fk
foreign key (nome_ag, cidade_ag)
	references agencia_2(nome, cidade)
		on delete cascade;

delete from agencia_2
where nome = 'Maria' and cidade = 'SP';

update cliente2
set renda = '10000000000'
where cliente_id = 1;

select * from agencia_2;

insert into cliente2(nome, rg)
values('leticia', '3333'), ('jose', '222');

select * from cliente2;

alter table cliente2
drop constraint cliente2_agencia2_fk;



select * from cliente2;

alter table cliente2 
add column test3 text not null default 'test';

alter table cliente2
alter column nome type int;

select * from agencia_2;
select * from cliente2;

delete from agencia_2
where nome = 'Augusto' and cidade = 'SP';

delete from cliente2
where cliente_id = 6;

ERROR:  update or delete on table "agencia_2" violates foreign key constraint "cliente2_agencia2_fk" 
on table "cliente2"
DETAIL:  Key (nome, cidade)=(Augusto, SP) is still referenced from table "cliente2".
SQL state: 23503

insert into cliente2(nome, rg, renda, conta, nome_ag, cidade_ag)
values          ('suellen', '2222', 102, '1', 'Augusto', 'SP');

ERROR:  insert or update on table "cliente2" violates foreign key constraint "cliente2_agencia2_fk"
DETAIL:  Key (nome_ag, cidade_ag)=(dfdfd, dfdfdf) is not present in table "agencia_2".
SQL state: 23503



CREATE TABLE receita (
    id SERIAL PRIMARY KEY,
    tipo TEXT CHECK (tipo IN ('sobremesa', 'salgado', 'massa')),
    nome TEXT NOT NULL,
	tmp_prep TEXT NOT NULL,
	modo TEXT,
	n_porcao INT
);

insert into receita(nome, tipo, tmp_prep, n_porcao)
values ('omelete', 'salgado', '5min', 1), ('bolo', 'sobremesa', '1h', 8);

insert into receita(nome, tipo, tmp_prep, n_porcao)
values ('gelatina', 'gosma', '1h', 8);

select * from receita;

DROP TABLE receita;

select * from ingredient;

CREATE TABLE ingrediate (
	id SERIAL PRIMARY KEY,
	nome TEXT NOT NULL,
	medida TEXT,
	tipo TEXT DEFAULT 'default',
	estado TEXT
);

select nextval('ingrediente_id_seq');

insert into ingrediente (nome, medida)
values ('Ovo', 'uni'), ('Sal', 'pitadas'), ('Tomate', 'uni');

insert into ingrediente (nome, medida)
values ('Xuxa', 'uni');

select * from ingrediente;

CREATE TABLE receita_ing (
	id INT PRIMARY KEY,
	receita_id INT REFERENCES receita(id) 
		ON DELETE CASCADE,
	ingr_id INT REFERENCES ingrediente(id)
		ON DELETE CASCADE,
	qte INT NOT NULL,
	UNIQUE(receita_id, ingr_id)
);

CREATE INDEX receitaIdx ON receita_ing(qte);

insert into receita_ing(id, receita_id, qte) 
values(100, 3232, 32);
drop table receita cascade;

delete from receita
where id = 1;

select * from receita_ing;



select * from receita_ing;

insert into receita_ing(id, receita_id, ingr_id, qte)
values(1, 1, 6, 2), 
      (2, 1, 7, 10), 
	  (3, 1, 8, 1), 
	  (4, 2, 6, 1);

select * from receita;
select * from ingrediente;

ALTER TABLE Ingrediate
RENAME TO ingrediente;

ALTER SEQUENCE ingrediate_id_seq
RENAME TO ingrediente_id_seq;





SELECT * FROM ingrediente;

insert into ingrediente (nome, medida)
values ('cEBOLAFGFGsdfsdfsdfdfsd', 'uni');

CREATE OR REPLACE VIEW lista_ingredientes AS (
	SELECT nome, medida FROM ingrediente
);

CREATE MATERIALIZED VIEW lista_ingredientes_mat AS (
	SELECT nome, medida FROM ingrediente
);

DROP MATERIALIZED VIEW lista_ingredientes_mat;

REFRESH MATERIALIZED VIEW lista_ingredientes_mat;

-- visao materializada
SELECT * FROM lista_ingredientes_mat;

-- visao simples
SELECT * FROM lista_ingredientes;




COPY (SELECT * FROM aluno) TO 'C:\Users\Public\db-copy-test\aluno_nome.csv' DELIMITER ',' CSV HEADER;



-- Quais alunos fazem parte da turma de BD
-- Tabelas: alunos, turmas, turma_aluno

select id_aluno from turma_aluno where id_turma = 1;


select * from turma_aluno;
select * from turmas;

-- Cross Join
select * from turma_aluno, turmas
;

-- Cross Join corrigido
select 
--t1.id_turma as id_turma_t1, 
--t2.id_turma as id_turma_t2, 
--t2.descricao, 
--t2.professor,
t1.id_aluno
from turma_aluno as t1, turmas as t2
where t1.id_turma = t2.id_turma and 
lower(descricao) LIKE 'banco de dados%';

-- Por id
select id_aluno from turma_aluno where id_turma = 1;

-- Por descricao
select 
--t1.id_turma as id_turma_t1, 
--t2.id_turma as id_turma_t2, 
--t2.descricao, 
--t2.professor,
t1.id_aluno
from turma_aluno as t1, turmas as t2
where t1.id_turma = t2.id_turma and 
lower(descricao) LIKE 'banco de dados%';


-- Nome dos alunos da turma de BD
-- select * from alunos;
select a.id_aluno, a.nome, ta.id_turma
from turma_aluno as ta, alunos as a
where a.id_aluno = ta.id_aluno and ta.id_turma = 1;

-- Nome dos alunos e nome das turmas em que estao matriculados

select a.nome, t.descricao
from turma_aluno as ta, alunos as a, turmas as t
where ta.id_turma = t.id_turma and 
      ta.id_aluno = a.id_aluno;
	  
-- Turmas em que joao esta matriculado
select t.descricao
from turma_aluno as ta, alunos as a, turmas as t
where ta.id_turma = t.id_turma and 
      ta.id_aluno = a.id_aluno and
	  a.nome = 'João';

-- Cross Join
-- Inner Join

-- Nome dos alunos matriculados nas disciplinas
SELECT *
FROM 
turma_aluno as ta 
INNER JOIN alunos as a ON ta.id_aluno = a.id_aluno 
INNER JOIN turmas as t ON ta.id_turma = t.id_turma;

select * from alunos;
select distinct id_turma from turma_aluno;

select * from
alunos a JOIN turma_aluno ta 
ON a.id_aluno = ta.id_aluno;

select * from
alunos a full JOIN turma_aluno ta 
ON a.id_aluno = ta.id_aluno;

-- Copy
select * from ingrediente;

copy (select nome, medida from ingrediente) to 'C:\Users\Public\copy-csv\ing.csv' 
delimiter ',' csv header;

delete from ingrediente_test;

create table ingrediente_test(
	nome text,
	medida text
);

copy ingrediente_test from 'C:\Users\Public\copy-csv\ing.csv' 
delimiter ',' csv;

select * from ingrediente_test;

-- Create table com select

CREATE TABLE ingrediente_test_4
AS
Select nome as nome_test_3, tipo as tipo_test3 from ingrediente;

select * from ingrediente_test_4




select * from ingrediente;
select * from receita_ing;


-- Uniao dos ingredientes das duas tabelas
select * from ingrediente_test;
select * from ingrediente;

select nome, medida from ingrediente_test
union
select nome, medida from ingrediente
order by nome;

-- Funcoes de agregacao
select count(*) from ingrediente where tipo is null;

select count(estado) from ingrediente;
insert into ingrediente(nome, medida, tipo, estado) values ('dfd', 'fdfd', 'dfd', 'dfd');
select * from ingrediente;

select avg(unit_price), sum(unit_price), min(unit_price) from products;

select * from order_details order by order_id;

-- Group by
select order_id, count(product_id), sum(unit_price) from 
order_details
group by order_id
order by order_id;



select * from order_details;

-- Select aninhado -- qtos alunos fazem mais de 1 curso

-- Group by + Join



-- Qtde de alunos matriculados em cada turma
select * from alunos;
select * from turma_aluno order by id_turma;

select result_1.c, t2.id_turma, t2.descricao
from
(select ta.id_turma, count(id_aluno) as c
from turma_aluno ta JOIN turmas t ON ta.id_turma = t.id_turma
group by ta.id_turma
order by ta.id_turma) as result_1 join turmas t2 ON result_1.id_turma = t2.id_turma;

--selecionar as turmas com mais de 2 alunos
select ta.id_turma, count(id_aluno) as c
from turma_aluno ta
where id_aluno != 1
group by ta.id_turma
having count(id_aluno) >= 2
order by c;


select * from turma_aluno
where id_aluno != 1;



