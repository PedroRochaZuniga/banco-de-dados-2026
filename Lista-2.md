# Pedro Rocha Zuniga - Banco de Dados 2 - Lista 2


# Questão 1
Liste todos os alunos cadastrados.

    select * from aluno


# Questão 2
Mostre apenas o nome e o curso dos alunos.

    select nome, curso from aluno

# Questão 3
Liste os alunos do curso de Computacao.
   
    select nome from aluno where curso == 'Computacao'


# Questão 4
Liste os alunos que moram em Maringa.

    select nome from aluno WHERE cidade = 'Maringa'


# Questão 5
Mostre os alunos ordenados pelo nome em ordem alfabética.

    select nome from aluno order by nome


# Questão 6
Mostre os alunos ordenados pelo ano de ingresso, do mais antigo para o mais recente.

     select nome from aluno order by ano_ingresso


# Questão 7
Liste os alunos que ingressaram a partir de 2022.

    select nome from aluno where ano_ingresso >= 2022


# Questão 8
Liste os alunos cujo nome começa com a letra A.

    select nome from aluno where nome like 'A%'


# Questão 9
Liste os alunos dos cursos Computacao ou Engenharia.

     select nome from aluno where curso = 'Computacao' or curso = 'Engenharia'



# uestão 10
Liste as disciplinas com carga horária entre 60 e 80 horas.

    select nome from disciplina where carga_horaria >= 60 and carga_horaria <= 80


# Questão 11
Conte quantos alunos existem cadastrados.

    select count(id) from aluno 


# Questão 12
Calcule a média das notas da tabela matricula.

    select avg(nota) from matricula
    
    
    

# Questão 13
Mostre a maior nota registrada.


     select max(nota) from matricula




# Questão 14
Mostre a menor nota registrada.

    select min(nota) from matricula



# Questão 15
Calcule a soma das cargas horárias de todas as disciplinas.


    select sum(carga_horaria) from disciplina






# Questão 16
Mostre a quantidade de alunos por curso.

    select aluno.curso, count(aluno.nome) FROM aluno group by curso



# Questão 17
Mostre a quantidade de alunos por cidade.

    select aluno.cidade, count(aluno.id) from aluno group by cidade


# Questão 18
Mostre a média das notas por situação da matrícula.

    select matricula.situacao, avg(matricula.nota) from matricula group by matricula.situacao



# Questão 19
Mostre quantas matrículas existem por semestre.

    select semestre, count(*) as quantidade_matriculas from matricula group by semestre;  

## Questão 20
Mostre os cursos que possuem mais de 1 aluno cadastrado.

    select cursos, count(*) as quantidade_alunos 
    from aluno 
    group by curso having count(*) > 1

## Questão 21
Liste o nome dos alunos e a situação de suas matrículas.

    select aluno.nome, matricula.situacao
    from aluno
    inner join matricula
    on aluno.id = matricula.aluno_id;
    
## Questão 22
Liste o nome dos alunos e o nome das disciplinas em que estão matriculados.

    select aluno.nome, disciplina.nome
    from aluno
    inner join matricula
    on aluno.id = matricula.aluno_id
    inner join disciplina
    on disciplina.id = matricula.disciplina_id;

## Questão 23
Liste o nome do aluno, o nome da disciplina e a nota.

    select aluno.nome, disciplina.nome, matricula.nota
    from aluno
    inner join matricula
    on aluno.id = matricula.aluno_id
    inner join disciplina
    ON disciplina.id = matricula.disciplina_id

## Questão 24
Liste apenas os alunos matriculados em disciplinas do departamento Computacao.

    select distinct aluno.nome
    from aluno
    inner join matricula
    on aluno.id = matricula.aluno_id
    inner join disciplina
    on disciplina.id = matricula.disciplina_id
    where disciplina.departamento = 'Computacao';


## Questão 25
Mostre o nome dos alunos que tiveram matrícula com situação Reprovado.

    select distinct aluno.nome
    from aluno
    inner join matricula
    on aluno.id = matricula.aluno_id
    where matricula.situacao = 'Reprovado';

## Questão 26
Mostre o nome dos alunos de Computacao e as disciplinas que eles cursaram.

    select aluno.nome, disciplina.nome
    from aluno
    inner join matricula
    on aluno.id = matricula.aluno_id
    inner join disciplina
    on disciplina.id = matricula.disciplina_id
    where aluno.curso = 'Computacao';

## Questão 27
Mostre a média de notas por aluno.

    select aluno.nome, avg(matricula.nota) as media_notas
    from aluno
    inner join matricula
    on aluno.id = matricula.aluno_id
    group by aluno.nome;

## Questão 28
Mostre a quantidade de disciplinas cursadas por cada aluno.

    select aluno.nome, COUNT(matricula.disciplina_id) as quantidade_disciplinas
    from aluno
    inner join matricula
    on aluno.id = matricula.aluno_id
    group by aluno.nome;

## Questão 29
Liste os alunos cuja média de notas foi maior que 8.

    select aluno.nome, avg(matricula.nota) as media_notas
    from aluno
    inner join matricula
    on aluno.id = matricula.aluno_id
    group by aluno.nome
    having avg(matricula.nota) > 8;

## Questão 30
Mostre o departamento e a quantidade de matrículas em disciplinas de cada departamento.

    select disciplina.departamento,
    count(matricula.id) as quantidade_matriculas
    from disciplina
    inner join matricula
    on disciplina.id = matricula.disciplina_id
    group by disciplina.departamento;

