# banco-de-dados-2026



Lista 01 - grupos de 03

#Questão 1
Liste todos os alunos cadastrados.

    select * from aluno


#Questão 2
Mostre apenas o nome e o curso dos alunos.

    select nome, curso from aluno

#Questão 3
Liste os alunos do curso de Computacao.
   
    select nome from aluno where curso == 'Computacao'


#Questão 4
Liste os alunos que moram em Maringa.

    select nome from aluno WHERE cidade = 'Maringa'


#Questão 5
Mostre os alunos ordenados pelo nome em ordem alfabética.

    select nome from aluno order by nome


#Questão 6
Mostre os alunos ordenados pelo ano de ingresso, do mais antigo para o mais recente.

     select nome from aluno order by ano_ingresso


#Questão 7
Liste os alunos que ingressaram a partir de 2022.

    select nome from aluno where ano_ingresso >= 2022


#Questão 8
Liste os alunos cujo nome começa com a letra A.

    select nome from aluno where nome like 'A%'


#Questão 9
Liste os alunos dos cursos Computacao ou Engenharia.

     select nome from aluno where curso = 'Computacao' or curso = 'Engenharia'



#Questão 10
Liste as disciplinas com carga horária entre 60 e 80 horas.

    select nome from disciplina where carga_horaria >= 60 and carga_horaria <= 80


#Questão 11
Conte quantos alunos existem cadastrados.

    select count(id) from aluno 


#Questão 12
Calcule a média das notas da tabela matricula.

    select avg(nota) from matricula
    
    
    

#Questão 13
Mostre a maior nota registrada.


     select max(nota) from matricula




#Questão 14
Mostre a menor nota registrada.

    select min(nota) from matricula



#Questão 15
Calcule a soma das cargas horárias de todas as disciplinas.


    select sum(carga_horaria) from disciplina






#Questão 16
Mostre a quantidade de alunos por curso.

    select aluno.curso, count(aluno.nome) FROM aluno group by curso



#Questão 17
Mostre a quantidade de alunos por cidade.

    select aluno.cidade, count(aluno.id) from aluno group by cidade


#Questão 18
Mostre a média das notas por situação da matrícula.

    select matricula.situacao, avg(matricula.nota) from matricula group by matricula.situacao



#Questão 19
Mostre quantas matrículas existem por semestre.





#Questão 20
Mostre os cursos que possuem mais de 1 aluno cadastrado.


