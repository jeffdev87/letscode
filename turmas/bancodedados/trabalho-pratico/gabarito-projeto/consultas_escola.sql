/* Consultas referentes às Tabelas do Banco de Dados 'escola' */

-- a) Criando relatório com os dados dos alunos matriculados nos cursos oferecidos pela escola
WITH aluno_curso AS(
	SELECT al.*, ma.id_curso, ma.data_matr
	FROM aluno AS al JOIN matricula_aluno AS ma ON al.cpf = ma.cpf
)
SELECT cur.id_curso AS codigo, cur.nome AS curso_nome, alc.nome, alc.cpf, alc.endereco, alc.telefone, alc.data_nasc
FROM curso AS cur JOIN aluno_curso AS alc ON cur.id_curso = alc.id_curso
ORDER BY codigo;

-- b) Criando relatório com os dados de todos os cursos com as suas respectivas disciplinas
WITH curso_iddisc AS(
	SELECT cur.*, com.id_disc
	FROM curso AS cur LEFT JOIN compoe_curso AS com ON cur.id_curso = com.id_curso
)
SELECT cdi.id_curso, cdi.nome, cdi.descricao, cdi.id_depto, di.nome AS disciplina_nome
FROM curso_iddisc AS cdi LEFT JOIN disciplina AS di ON cdi.id_disc = di.id_disc;

-- c) Criando relatório com os nomes dos alunos e a(s) disciplina(s) em que estão matriculados
WITH aluno_disc AS(
	SELECT al.nome, cd.id_disc
	FROM aluno AS al LEFT JOIN cursa_disc AS cd ON al.cpf = cd.cpf
)
SELECT ad.nome, di.nome AS disciplina_nome
FROM aluno_disc AS ad LEFT JOIN disciplina AS di ON ad.id_disc = di.id_disc
ORDER BY ad.nome;

-- d) Criando relatório com os dados dos professores e as disciplinas que os mesmos ministram
SELECT di.nome AS disciplina_nome, prO.*
FROM professor AS prO LEFT JOIN disciplina AS di ON prO.matricula_prof = di.matricula_prof
ORDER BY disciplina_nome;

-- e) Criando relatório com os nomes das disciplinas e os seus pré-requisitos
WITH dados_disc_nec AS(
	SELECT pr.id_disc, pr.id_disc_necessaria, di.nome AS disci_neces
	FROM pre_req AS pr JOIN disciplina AS di ON pr.id_disc_necessaria = di.id_disc
)
SELECT di.nome AS disciplina_nome, 
CASE WHEN ddn.disci_neces IS NULL THEN 'Nenhum'
ELSE ddn.disci_neces
END AS pre_requisito
FROM disciplina AS di LEFT JOIN dados_disc_nec AS ddn ON di.id_disc = ddn.id_disc
ORDER BY disciplina_nome;

-- f) Criando relatório com a média de idade dos alunos matriculados em cada curso
WITH aluno_matr_curso AS(
	SELECT al.*, ma.id_curso
	FROM aluno AS al JOIN matricula_aluno AS ma ON al.cpf = ma.cpf
)
SELECT cur.nome AS curso_nome, AVG(DATE_PART('year', AGE(amc.data_nasc)))::INTEGER AS media_idade
FROM aluno_matr_curso AS amc JOIN curso AS cur ON amc.id_curso = cur.id_curso
GROUP BY cur.nome
ORDER BY cur.nome;

-- g) Criando relatório com os cursos oferecidos por cada departamento
SELECT dpt.id_depto, dpt.nome AS nome_departamento,
CASE WHEN cur.nome IS NULL THEN 'Nenhum'
ELSE cur.nome
END AS curso_oferecido
FROM departamento AS dpt LEFT JOIN curso AS cur ON dpt.id_depto = cur.id_depto
ORDER BY dpt.id_depto, curso_oferecido;
