DROP TABLE IF EXISTS Aluno CASCADE;
DROP TABLE IF EXISTS Turma CASCADE;
DROP TABLE IF EXISTS Aluno_Turma;
/*
Aluno (m) - pertence - (n) Turma 
*/
CREATE TABLE Aluno (
    Id_Aluno SERIAL PRIMARY KEY,
    Nome VARCHAR(255)
);
/*
IdA1, Aluno1
IdA2, Aluno2
...
*/
CREATE TABLE Turma (
    Id_Turma SERIAL PRIMARY KEY,
    Nome VARCHAR(255)
);
/*
IdT1, Turma1
IdT2, Turma2
...
*/
CREATE TABLE Aluno_Turma (
    Id_Aluno INT REFERENCES Aluno(Id_Aluno), 
    Id_Turma INT REFERENCES Turma(Id_Turma),
    CONSTRAINT aluno_turma_pk 
        PRIMARY KEY(Id_Aluno, Id_Turma)
);
/*
IdA1, IdT1
IdA1, IdT2
IdA2, IdT1
IdA2, IdT2
...
*/

SELECT *
FROM agencia_comp;

INSERT INTO agencia_comp(nome_ag, cidade)
VALUES 
('AGENCIA_1', 'LEME'), 
('AGENCIA_2', 'SAO CARLOS'), 
('AGENCIA_3', 'SAO PAULO');

INSERT INTO agencia_comp(nome_ag)
VALUES 
('AGENCIA_1'), 
('AGENCIA_2');

INSERT INTO agencia_comp(nome_ag, cidade)
VALUES 
('AGENCIA_4', 'RIO CLARO'), 
('AGENCIA_6', 'RIBEIRAO PRETO'), 
('AGENCIA_5', 'BELO HORIZONTE');

SELECT * FROM agencia_comp;

INSERT INTO ALUNO(Nome) VALUES ('Burla mesmo')

ALTER SEQUENCE aluno_id_aluno_seq RESTART WITH 6;

INSERT INTO aluno(nome)
SELECT nome
FROM aluno;

SELECT * FROM aluno;

/*
Cliente (Ja#o, Maria, Jose) -> AgenciaSP (Cliente-FK) -> Ja#o
                            -> AgenciaRJ (Cliente-FK) -> Joao
C1, A1
C1, A2
*/

SELECT * FROM ALUNO;

ALTER TABLE ALUNO
ADD COLUMN Data_Matricula DATE DEFAULT NOW();

insert into aluno(nome, data_matricula)
values('josefina2', to_date('05 Dec 2000', 'DD Mon YYYY'));

select *
from aluno where nome = 'josefina2';


/* alterar o status da matricula de todos os alunos jose para 
not ok*/
UPDATE aluno
SET matricula = 'NOT OK'
WHERE nome = 'Jose';

/*alterar o status da matricula para 'OK' de todos os alunos
jose que sao not ok*/
UPDATE aluno
SET matricula = 'OK-2'
WHERE nome = 'Jose' AND matricula = 'NOT OK';


INSERT INTO aluno(nome, endereco) 
VALUES ('Jose', 'Endereco Jose 2');

UPDATE aluno
SET endereco = 'Endereco Jose'
WHERE nome = 'Jose'

/*remover todos os alunos com Jose*/
DELETE FROM aluno
WHERE nome = 'Jose' and matricula = 'OK-2';
