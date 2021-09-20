DROP TABLE IF EXISTS alunos CASCADE;
DROP TABLE IF EXISTS turmas CASCADE;
DROP TABLE IF EXISTS turma_aluno CASCADE;

CREATE TABLE alunos(
	id_aluno SERIAL PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	matricula VARCHAR(20) NOT NULL UNIQUE,
	data_nascimento DATE NOT NULL,
	email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE turmas(
	id_turma SERIAL PRIMARY KEY,
	descricao VARCHAR(50) NOT NULL,
	professor VARCHAR(100) NOT NULL,
	data_inicio DATE NOT NULL,
	data_termino DATE NOT NULL
);

CREATE TABLE turma_aluno(
	id_turma_aluno SERIAL PRIMARY KEY,
	id_turma INT REFERENCES turmas(id_turma) NOT NULL,
	id_aluno INT REFERENCES alunos(id_aluno) NOT NULL
);

INSERT INTO alunos
	(nome, matricula, data_nascimento, email)
VALUES
	('João', '123', '1998-06-07', 'joao@gmail.com'),
	('Maria', '456', '1997-05-30', 'maria@hotmail.com'),
	('Ana', '789', '2000-01-11', 'ana@yahoo.com'),
	('José', '741', '2001-06-13', 'jose@qqcoisa.com'),
	('Ivy', '258', '2011-08-26', 'ivy@qqcoisa.com');

INSERT INTO turmas
	(descricao, professor, data_inicio, data_termino)
VALUES
	('Banco de Dados 785', 'Filipe', '2021-07-13', '2021-07-26'),
	('Logica e PPO 785', 'Wals', '2021-07-06', '2021-07-26'),
	('Data toolbox 785', 'Wals', '2021-07-27', '2021-08-11'),
	('Matemática Av. 785', 'Filipe', '2021-07-27', '2021-08-11');
	
INSERT INTO turma_aluno
	(id_turma, id_aluno)
VALUES
	(1, 1),
	(1, 2),
	(2, 1),
	(2, 2),
	(2, 4),
	(4, 2),
	(4, 4);
