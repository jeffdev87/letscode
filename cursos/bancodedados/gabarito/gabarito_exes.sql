--##############################################################################
--aula 04 - p1
--##############################################################################

-- Q1 Selecione os id's únicos de territórios da tabela employee_territories.
SELECT DISTINCT territory_id
FROM employee_territories;

-- Q2 - Selecione da tabela empolyees:

-- 1. Todos os nomes dos empregados;
SELECT first_name FROM employees;

-- 2. Os sobrenomes distintos dos empregados;
SELECT DISTINCT last_name FROM employees;

-- 3. Empregados que nasceram após 1970;
SELECT * FROM employees WHERE date_part('year', birth_date) > 1970;

-- 4. Empregados que foram contratados em 1993;
SELECT * FROM employees WHERE date_part('year', hire_date) = 1993;

-- 5. Empregados que nasceram entre 1980 e 1985 (inclusos);
SELECT * FROM employees WHERE date_part('year', birth_date) BETWEEN 1980 AND 1985;

-- 6. Empregados que nasceram em 1963 e foram contratados em 1993;
SELECT * FROM employees 
WHERE date_part('year', birth_date) = 1963 
AND date_part('year', hire_date) = 1993;

-- 7. Todos os empregrados que reportam o chefe de id 5;
SELECT * FROM employees WHERE reports_to = 5;

-- 8. Todos os empregados que moram em Seattle ou Kirkland.
SELECT * FROM employees WHERE lower(city) IN ('seattle', 'kirkland');

-- Q3 - Selecione da tabela order_details:

-- 1. Produtos (product_id) com mais de 50 unidades vendidas;
SELECT product_id, sum(quantity)
FROM order_details
GROUP BY product_id
HAVING sum(quantity) > 50
ORDER BY product_id;

-- 2. Produtos com mais de 0.2 de desconto;
SELECT *
FROM order_details
WHERE discount::numeric(10,1) > 0.2
ORDER BY product_id;

-- 3. Produtos com 0.05 ou menos de desconto
SELECT *
FROM order_details
WHERE discount::numeric(10,2) < 0.05
ORDER BY product_id;

-- Q4 - Selecione da tabels orders:

-- 1. Ordens realizadas antes Setembro de 1996.
SELECT * FROM orders WHERE order_date < '1996-08-31';

-- 2. Ordens enviadas em Setembro de 1996.
SELECT * FROM orders WHERE order_date between '1996-09-01' and '1996-09-30';

-- 3. Ordens que possuam o campo região preenchido.
SELECT * FROM orders WHERE ship_region is not null;

-- 4. As primeiras 5 linhas da tabela, reescrevendo o nome das colunas de data em português.
SELECT order_date as ordem, 
required_date as data_exigencia, 
shipped_date as data_envio
FROM orders 
limit 5;

-- Q5 - Selecione da tabela suppliers:

-- 1. Todos os contatos cujo nome comece com a letra M;
SELECT * FROM suppliers WHERE lower(contact_name) like 'm%';

-- 2. Todos os contatos que tenham a palavra manager no titulo;
SELECT * FROM suppliers WHERE lower(contact_title) like '%manager%';

-- 3. Todos os contatos que trabalhem com vendas e morem nos países nórdicos.
SELECT * FROM suppliers
WHERE lower(contact_title) like '%sales%' 
and country in ('Sweden', 'Germany', 'Denmark');

--##############################################################################
--aula 04 - p2
--##############################################################################

-- Q1

-- Selecione os id´s unicos de territórios da tabela employee_territories em ordem decrecente
SELECT territory_id
FROM employee_territories
ORDER BY territory_id DESC;

-- Q2 SElecione da tabela employees (Não esqueça de nomear as colunas criadas):

-- 1. O nome completo dos empregados em ordem alfabetica
SELECT CONCAT(first_name,' ',last_name) as Nome_Completo
FROM employees
ORDER BY Nome_Completo;

-- 2. O nome completo dos empregados com o respectivo titulo em ordem decrescente;
SELECT CONCAT(first_name,' ',last_name) as Nome_Completo, title
FROM employees
ORDER BY title DESC;

-- 3. Os sobrenomes distintos dos empregrados;
SELECT DISTINCT last_name
FROM employees;

-- 4. O ano de nascimento dos empregados usando funções de tempo;
SELECT first_name, date_part('year', birth_date)
FROM employees;

-- 5. O ano de nascimento dos empregados usando funções de string;
SELECT first_name, CONCAT('Dia ', date_part('day', birth_date)::text, ' do ', date_part('month', birth_date)::text, ' de ', date_part('year', birth_date)::text)
FROM employees;

-- 6. A idade atual dos empregados em ordem decrescente;
SELECT CONCAT(first_name,' ',last_name) as Nome_Completo, AGE(birth_date) -- ou pode fazer  ((current_date - birth_date) / 365.25)::integer
FROM employees
ORDER BY AGE(birth_date) DESC;

-- 7. A idade que os empregados tinham quando foram contratados em ordem crescente;
SELECT CONCAT(first_name,' ',last_name) as Nome_Completo, ((hire_date - birth_date) / 365.25)::integer as idade_inicio
FROM employees
ORDER BY idade_inicio;

-- 8. Quem é e qual a idade do empregado mais velho?
SELECT CONCAT(first_name,' ',last_name) as Nome_Completo, AGE(birth_date)
FROM employees
ORDER BY AGE(birth_date) DESC
LIMIT 1;

SELECT CONCAT(first_name, ' ', last_name) AS Nome_Completo, AGE(birth_date) AS Idade
FROM employees
WHERE AGE(birth_date) = (SELECT max(AGE(birth_date)) FROM employees);

-- 9. Qual a pessoa mais jovem que foi contratada?
SELECT CONCAT(first_name,' ',last_name) as Nome_Completo, ((hire_date - birth_date) / 365.25)::integer as idade_inicio
FROM employees
ORDER BY idade_inicio
LIMIT 1;

SELECT CONCAT(first_name, ' ', last_name) AS Nome_Completo, ((hire_date - birth_date) / 365.25)::integer AS Idade_Inicio
FROM employees
WHERE ((hire_date - birth_date) / 365.25)::integer = (SELECT min(((hire_date - birth_date) / 365.25)::integer) FROM employees);

-- 10. Crie uma coluna que mapeie os cargos dos empregados com a posição hierárquica na lista, sendo 1 o mais alto.
SELECT CONCAT(first_name,' ',last_name) as Nome_Completo, title,
CASE
WHEN title = 'Vice President, Sales' THEN 'Hierarquia 1'
WHEN title = 'Sales Manager' THEN 'Hierarquia 2'
WHEN title = 'Inside Sales Coordinator' THEN 'Hierarquia 3'
ELSE 'Hierarquia 4'
END AS Hierarquia
FROM employees
ORDER BY Hierarquia;

-- 11. O tempo de empresa dos respectivos empegados;
SELECT CONCAT(first_name,' ',last_name) as Nome_Completo, ((current_date - hire_date) / 365.25)::integer as tempo_de_empresa
FROM employees;

-- Q3 (Selecione da tabela products)

-- 1. Os três produtos mais caros com seus respectivos preços;
SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 3;

-- 2. Os 10 produtos com estoque mais baixo (diferentes de 0) com suas respectivas quantidades;
SELECT product_name, units_in_stock
FROM products
WHERE units_in_stock <> 0
ORDER BY units_in_stock
LIMIT 10;

-- 3. Os 5 produtos com maior valor agregado atualmente em estoque;
SELECT product_name, units_in_stock, unit_price, (units_in_stock * unit_price) AS Valor_Estoque
FROM products
ORDER BY Valor_Estoque DESC
LIMIT 5;

-- 4. Produtos com mais de 100 unidades no estoque ou valor unitário inferior 15;
SELECT product_name, units_in_stock, unit_price
FROM products
WHERE units_in_stock > 100 OR unit_price < 15;

-- Q4 (Selecione da Tabela orders)

-- 1. O primeiro nome do destinatário da entrega (ship_name);
SELECT SUBSTRING(ship_name, 1, POSITION (' ' in ship_name))
FROM orders;

-- 2. O tempo (em dias) entre a compra e a entrega;
SELECT order_id, order_date, shipped_date, (shipped_date - order_date) AS Dias_Entrega
FROM orders;

-- 3. Os cinco fretes mais caros ordenados pelo tempo de entrega em ordem decrescente (sem dados nulos);
SELECT * FROM (
SELECT order_id, order_date, shipped_date, (shipped_date - order_date) AS Dias_Entrega, freight
FROM orders
WHERE shipped_date IS NOT NULL AND order_date IS NOT NULL
ORDER BY freight DESC
LIMIT 5) as tab_5_fretes_mais_caros ORDER BY tab_5_fretes_mais_caros.dias_entrega DESC;

-- 4. Os cinco fretes com maior tempo de entrega ordenados pelo valor decrescente (sem dados nulos);
SELECT * FROM (
SELECT order_id, order_date, shipped_date, (shipped_date - order_date) AS Dias_Entrega, freight
FROM orders
WHERE shipped_date IS NOT NULL AND order_date IS NOT NULL
ORDER BY Dias_Entrega DESC
LIMIT 5) as tab_5_maior_tmp_entrega ORDER BY tab_5_maior_tmp_entrega.freight DESC;

-- 5. Os 3 fretes mais baratos do Brasil.
SELECT order_id, ship_country, freight
FROM orders
WHERE ship_country = 'Brazil'
ORDER BY freight
LIMIT 3;

-- 6. Uma tabela com as três primeiras letras do nome do pais, o tempo de entrega e o frete ordenados em ordem crescente.
SELECT order_id, SUBSTRING(ship_country,1,3), freight, (shipped_date - order_date) AS Dias_Entrega
FROM orders
ORDER BY freight;

--##############################################################################
--aula 05 - p1
--##############################################################################

-- Q1 - Da tabela territories:
-- 1. Quantos territórios temos ao todo?
select count(distinct territory_id)
as total_territorios
from territories;

-- 2. Quantos territórios por região?
select region_id, count(distinct territory_id)
as total_territorios
from territories
group by region_id
order by region_id;

-- Q2 - Selecione da tabela empolyees:
-- 1. Quantos empregados reportam para cada chefe?
select reports_to as chefe,
count(employee_id) as qtde_empregados
from employees
group by reports_to
order by reports_to;

-- 2. Quantos empregados em cada cidade?
select city as cidade,
count(employee_id) as qtde_empregados
from employees
group by city;

-- Q3 - Selecione da tabela order_details:
-- 1. Quantas unidades forem vendidas por ordem?
select order_id as ordem,
sum(quantity) as qtde_vendida
from order_details
group by order_id
order by order_id;

-- 2. Qual o valor total de cada ordem?
select order_id as ordem,
sum (unit_price * quantity)::numeric(20,2) as total_ordem
from order_details
group by order_id
order by order_id;

-- 3. Qual o produto mais vendido?
select product_id, 
sum(quantity) as mais_vendido
from order_details
group by product_id
order by mais_vendido desc
limit 1;

-- Retorne o id do produto e o total de items vendidos
SELECT product_id, total 
FROM (
    -- Retorna os nomes e a soma dos produtos vendidos para todos os produtos
    SELECT product_id, SUM(quantity) AS total
    FROM order_details
    GROUP BY product_id
    ORDER BY total DESC
) AS soma_por_produto
-- Utilize o where para retornar apenas o produto com o valor maximo
WHERE soma_por_produto.total = (
    -- Retornar o valor maximo dentre os produtos vendidos
    SELECT max(max_vendido.total) from (
        SELECT product_id, SUM(quantity) AS total
        FROM order_details
        GROUP BY product_id
        ORDER BY total DESC
    ) AS max_vendido
);

-- 4. Selecione ordens que tenham menos de três produtos.
select order_id,
sum(quantity) as total_produtos
from order_details
group by order_id
having sum(quantity) <= 3
order by order_id;

-- Q4. Selecione da tabels orders:
-- 1. Qual cliente realizou mais ordens?
select customer_id,
count(customer_id) as qtde_compras
from orders
group by customer_id
order by qtde_compras desc
limit 1;

-- 2. Qual cliente realizou menos ordens?
select customer_id,
count(customer_id) as qtde_compras
from orders
group by customer_id
order by qtde_compras
limit 1;

-- 3. Quantas ordems foram feitas por mês?
select date_part('month', order_date) as mes,
count(order_id) as qtde_ordens
from orders
group by date_part('month', order_date)
order by mes;

-- 4. Qual o tempo de envio por cliente?
select customer_id, (shipped_date - order_date) as tempo_envio
from orders
order by  customer_id;

-- 5. Faça uma lista ordenada dos países que receberam mais ordens.
select ship_country, 
count(ship_country) as qtde_ordens
from orders
group by ship_country
order by qtde_ordens desc;

-- 6. Qual o tempo máximo de envio por cidade?
select ship_city, 
sum(shipped_date - order_date) as qtde_dias
from orders
group by ship_city
order by qtde_dias desc;

-- 7. Quanto cada cliente gastou em frete?
select customer_id, 
sum(freight)::numeric(20,2) as total_frete
from orders
group by customer_id;

-- 8. Qual o custo total de cada tipo de frete?
select ship_via, 
sum(freight)::numeric(20,2) as custo_total
from orders
group by ship_via
order by ship_via;

-- 9. Quanto cada cliente gastou em casa tipo de frete?
select customer_id, ship_via,
sum(freight)::numeric(20,2) as total_frete
from orders
group by customer_id, ship_via
order by customer_id, ship_via;

-- Q5 - Selecione da tabela suppliers:
-- 1. Uma lista com os países que mais tem fornecedores.
select country, 
count(country) as total
from suppliers
group by country
order by total desc;

-- Q6 - Selecione da tabela products:
-- 1. Uma lista com o número de produtos por fornecedores.
select 
products.supplier_id as cod_fornecedor,
suppliers.company_name as fornecedor,
count(products.product_id) as qtde_produtos
from products
inner join suppliers on suppliers.supplier_id = products.supplier_id
group by products.supplier_id, suppliers.company_name
order by products.supplier_id;

-- 2. Oderne a lista acima em ordem decrescente.
select 
products.supplier_id as cod_fornecedor,
suppliers.company_name as fornecedor,
count(products.product_id) as qtde_produtos
from products
inner join suppliers on suppliers.supplier_id = products.supplier_id
group by products.supplier_id, suppliers.company_name
order by qtde_produtos desc;

-- 3. Uma lista com o número de produtos por fornecedors por categoria.
select 
products.supplier_id as cod_fornecedor,
suppliers.company_name as fornecedor,
count(products.product_id) as qtde_produtos,
category_id as categoria
from products
inner join suppliers on suppliers.supplier_id = products.supplier_id
group by products.supplier_id, suppliers.company_name, category_id
order by products.supplier_id;

-- 4. Quantos produtos foram descontinuados.
select count(discontinued) as produtos_descontinuados
from products
where discontinued = 1;

-- 5. Fornecedores com estoque baixo (soma de unidades < 20).
select suppliers.company_name as fornecedor
from products
inner join suppliers on suppliers.supplier_id = products.supplier_id
where units_in_stock <= 20;

-- 6. A média do valor total de cada categória.
select category_id,
avg(unit_price * units_in_stock)::numeric(20,2) as media_valor
from products
group by category_id
order by category_id;

-- 7. O valor do produto mais barato, mais caro e a média dos valores unitários por fornecedor e categoria.
select * from products
where unit_price = (select min(unit_price) from products)
UNION
select * from products
where unit_price = (select max(unit_price) from products);

select product_id, supplier_id, category_id,
avg(unit_price)::numeric(20,2) as media_valor
from products
group by product_id, supplier_id, category_id
order by supplier_id;

--##############################################################################
--aula 05 - p2
--##############################################################################

-- Q1 Faça um relatório que traga o número de cidades por estado (nome por extenso) e ordene:
-- Ordem alfabética por nome do estado;
SELECT
est.nome, COUNT (cid.id)
FROM tb_estados AS est
JOIN tb_cidades AS cid ON est.id = cid.estado
GROUP BY est.nome
ORDER BY est.nome;

-- Do maior para o menor número de municípios.
SELECT
est.nome, COUNT (cid.id) AS total
FROM tb_estados AS est
JOIN tb_cidades AS cid ON est.id = cid.estado
GROUP BY est.nome
ORDER BY total DESC;

-- Q2 Faça um relatório que gere uma lista com todas as cidades (nome por extenso) com nomes repetidos.
SELECT nome, COUNT(nome) AS repeticoes
FROM tb_cidades
GROUP BY nome
HAVING COUNT(nome) >= 2
ORDER BY repeticoes DESC;

-- Q3 Faça um relatório que gere uma lista com os municipíos repetidos por estados (nome por extenso): estado|cidade|numero.
SELECT est.nome AS estado, cid.nome AS cidade, COUNT(cid.nome) AS repeticoes
FROM tb_cidades AS cid
LEFT JOIN tb_estados AS est ON est.id = cid.estado
GROUP BY est.nome, cid.nome
HAVING COUNT(cid.nome) >= 2
ORDER BY estado;

-- Q4) No banco de dados do northwind, obtenha:
-- 1. Uma lista dos 10 clientes que realizaram o maior número de pedidos, bem como o número de
-- pedidos de cada, ordenados em ordem decrescente de nº de pedidos
SELECT customer_id, COUNT(order_id) AS num_pedidos
FROM orders
LEFT JOIN customer_id
ORDER BY num_pedidos DESC
LIMIT 10;

---2)-Uma tabela com o valor médio das vendas em cada mês, ordenando do mês com mais vendas ao mês com menos venda
SELECT DATE_PART('month', orders.order_date) as mes,
ROUND(avg(order_details.unit_price * quantity):: numeric, 2) as media
FROM orders
LEFT JOIN order_details on orders.order_id = order_details.order_id
LEFT JOIN mes
ORDER BY media DESC;

-- Q5) No banco de dados do northwind, obtenha:
-- 1. Quantos clientes fizeram mais de 10 pedidos?
SELECT COUNT(*) AS qtd_cli_mais_10_pedidos
FROM (
	SELECT customer_id, COUNT(order_id) AS qtd_pedidos
	FROM orders
	GROUP BY customer_id
	HAVING COUNT(order_id) > 10
) AS clientes_com_mais_pedidos;

-- 2. Quantos vendedores tiveram menos de 70 pedidos?
SELECT COUNT(*) AS qtd_vend_menos_70_pedidos
FROM (
	SELECT employee_id, COUNT(order_id)
	FROM orders
	GROUP BY employee_id
	HAVING COUNT(order_id) < 70
) AS vend_com_menos_pedidos;

-- 3. Qual a média dos valores por pedido de cada vendedor?
WITH tab_com_valor_pedido AS(
	SELECT ord.order_id, ord.employee_id, ord.freight,
	ROUND(SUM(odt.unit_price * odt.quantity * (1 - odt.discount))::NUMERIC, 2) AS valor_sem_frete
	FROM orders AS ord INNER JOIN order_details AS odt ON ord.order_id = odt.order_id
	GROUP BY ord.order_id
)
SELECT employee_id AS vendedor_id,
ROUND(AVG(freight + valor_sem_frete)::NUMERIC, 2) AS media_valor_pedidos
FROM tab_com_valor_pedido
GROUP BY employee_id
ORDER BY employee_id;

-- 4. Quantos vendedores tiveram menos de 300 pedidos e média superior a 700 reais por pedido?
WITH tab_com_total_sem_frete AS(
	SELECT ord.order_id, ord.employee_id, ord.freight,
	ROUND(SUM(odt.unit_price * odt.quantity * (1 - odt.discount))::NUMERIC, 2) AS total_sem_frete
	FROM orders AS ord INNER JOIN order_details AS odt ON ord.order_id = odt.order_id
	GROUP BY ord.order_id
)
SELECT employee_id, COUNT(order_id) AS qtd_pedidos, 
ROUND(AVG(freight + total_sem_frete)::NUMERIC, 2) AS valor_medio_pedido
FROM tab_com_total_sem_frete
GROUP BY employee_id
HAVING COUNT(order_id) < 300
AND ROUND(AVG(freight + total_sem_frete)::NUMERIC, 2) > 700
ORDER BY employee_id;

--##############################################################################
--aula 06
--##############################################################################

-- Q1. Crie duas tabelas: produto e categoria. Essas duas tabelas devem estar relacionadas.
-- Considere que o produto possui uma descrição, preço, frete e categoria.
-- Considere que a categoria possui apenas uma descrição.
-- Não esqueça de inserir as chaves primárias e estrangeira da forma correta, de modo a criar o relacionamento entre as tabelas.

CREATE TABLE categoria (
    categoria_id SERIAL PRIMARY KEY, 
    descricao VARCHAR(255));

CREATE TABLE produto (
    produto_id SERIAL PRIMARY KEY, 
    descricao VARCHAR(255) NOT NULL, 
    preco NUMERIC(10,2), 
	frete NUMERIC(10,2), 
    categoria INT REFERENCES categoria(categoria_id));

-- Q2. -- Adicione 3 registros em cada tabela.
INSERT INTO categoria(descricao)
VALUES ('enlatados'), ('frios'), ('gluten-free');

INSERT INTO produto(descricao, preco, frete, categoria)
VALUES ('Feijao', 0.23, 0.00, 1), ('Ervilha', 0.50, 0.00, 1), ('Presunto', 1.50, 0.00, 2);

-- Q3.  Crie duas tabelas: turmas e alunos. Essas duas tabelas devem estar relacionadas.
-- Um aluno pode pertencer a muitas turmas e uma turma deve conter muitos alunos (tabela extra).
-- Considere que o aluno possui: nome, matrícula, data de nascimento e e-mail.
-- A turma possui os atributos descrição, professor (considere apenas um), data de início, e data de término.
CREATE TABLE aluno(
    aluno_id SERIAL PRIMARY KEY, 
    nome VARCHAR(255) NOT NULL, 
    matricula INT, 
	data_nasc DATE, 
    email VARCHAR(255));

CREATE TABLE turma(
    turma_id VARCHAR(100) PRIMARY KEY, 
    descricao VARCHAR(255) NOT NULL, 
    professor VARCHAR(255),  
	data_inicio DATE, 
    data_fim DATE);

CREATE TABLE turmas(
    turma_id VARCHAR(100) REFERENCES turma(turma_id),
	aluno_id INT REFERENCES aluno(aluno_id));
	
-- Q4. Adicione 3 registros em cada tabela.
INSERT INTO aluno(nome, matricula, data_nasc, email)
VALUES 
('Joana Vieira', 1578, '12-10-2005', 'joana@email.com'), 
('Bianca Pires', 1875, '05-08-2005', 'bianca@email.com'), 
('Suelen Silva', 895, '17-10-1982', 'suelen@email.com');

INSERT INTO turma(turma_id, descricao, professor, data_inicio, data_fim)
VALUES
('I_A','Informática-A', 'José', '01-05-2021', '31-12-2021'),
('I_B','Informática-B', 'José', '01-06-2021', '31-01-2022'),
('P_A','Python - A', 'Maria', '01-07-2021', '28-02-2022');

INSERT INTO turmas(turma_id, aluno_id)
VALUES ('I_A', 1), ('I_B', 2), ('P_A', 3);

-- Q5. Copie o resultado de uma consulta qualquer para um arquivo utilizando o comando COPY.
COPY (
SELECT 
	product_id, 
	(unit_price * quantity * (1 - discount) + orders.freight) as valor_pedido 
FROM order_details
INNER JOIN orders ON order_details.order_id = orders.order_id)
TO './consulta.csv' DELIMITER ';' CSV HEADER;
