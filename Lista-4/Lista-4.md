# Concorrência, bloqueios e problemas clássicos em transações

## 6. Atividade prática

### Atividade: simular concorrência, bloqueios, espera e inconsistências em transações

#### Etapa 1. Criar o banco de teste

```sql
DROP TABLE IF EXISTS contas;

CREATE TABLE contas (
    id INT PRIMARY KEY,
    titular VARCHAR(100),
    saldo DECIMAL(10,2)
);

INSERT INTO contas (id, titular, saldo) VALUES
(1, 'Ana', 1000.00),
(2, 'Bruno', 500.00),
(3, 'Carlos', 300.00),
(4, 'Daniela', 800.00);

SELECT * FROM contas;
```

**Pergunta 1**  
Qual é a finalidade de manter dados iniciais conhecidos antes dos testes de concorrência?

    A finalidade de manter dados inicias conhecidos antes dos teste é para a verficação das transações, se estas foram feitas de maneira correta e desejada

**Pergunta 2**  
Por que é importante que a tabela esteja em um estado consistente antes do início dos experimentos?

    Pois os experimentos precisam começar sem incosistencias prévias. Assim, se houver algum erro, será conequencias desses dados mal inicializados

---

#### Etapa 2. Testar bloqueio com `FOR UPDATE`

Abra duas sessões.

### Sessão 1

```sql
START TRANSACTION;

SELECT * FROM contas
WHERE id = 1
FOR UPDATE;

UPDATE contas
SET saldo = saldo - 100
WHERE id = 1;
```

Não execute `COMMIT` ainda.

### Sessão 2

```sql
START TRANSACTION;

UPDATE contas
SET saldo = saldo + 50
WHERE id = 1;
```

Agora volte para a Sessão 1 e execute:

```sql
COMMIT;
```

Depois finalize a Sessão 2 com:

```sql
COMMIT;
```

**Pergunta 3**  
O que aconteceu com a operação realizada na Sessão 2?

    A sessão 2 ficou em aguarado até a finalização da sessão 1

**Pergunta 4**  
Por que a segunda sessão precisou aguardar?

     Pois ambas utlizam o mesmo dado para modificação, assim foi necessário o FOR UPTADE, para bloquear slterações simultaneas

**Pergunta 5**  
Qual é a função do comando `FOR UPDATE` nesse experimento?

    Bloquear a linha para a atualização até o fim da transação

---

#### Etapa 3. Testar acesso concorrente a registros diferentes

Abra duas sessões.

### Sessão 1

```sql
START TRANSACTION;

UPDATE contas
SET saldo = saldo - 50
WHERE id = 1;
```

### Sessão 2

```sql
START TRANSACTION;

UPDATE contas
SET saldo = saldo + 70
WHERE id = 4;
```

Finalize ambas com:

```sql
COMMIT;
```

Depois consulte:

```sql
SELECT * FROM contas;
```

**Pergunta 6**  
Por que, nesse caso, as duas transações tendem a coexistir sem espera significativa?

    Pois elas estão tratando com valores distintos na tabela, além disso não existe nenhum tratamento de segurança até o fim da transação

**Pergunta 7**  
O que esse comportamento revela sobre bloqueios em nível de linha?

    Revela que o banco realiza bloqueio em nível de linha, permitindo concorrencia quando os registros são diferentes

---

#### Etapa 4. Testar leitura durante transação não finalizada

### Sessão 1

```sql
START TRANSACTION;

UPDATE contas
SET saldo = saldo - 200
WHERE id = 2;
```

Sem confirmar ainda.

### Sessão 2

```sql
SELECT * FROM contas WHERE id = 2;
```

Depois volte para a Sessão 1 e execute:

```sql
ROLLBACK;
```

**Pergunta 8**  
Qual era o objetivo de consultar o mesmo registro em outra sessão antes do `COMMIT`?

    O objetivo era verificar se outra sessão conseguiria visualizar alterações ainda não confirmadas

**Pergunta 9**  
Como esse experimento se relaciona com o conceito de isolamento?

    O experimento se relaciona com o isolamento, já que transações não concluídas normalmente não devem afetar outras sessões

---

#### Etapa 5. Testar repetição de leitura

### Sessão 1

```sql
START TRANSACTION;

SELECT * FROM contas WHERE id = 3;
```

### Sessão 2

```sql
START TRANSACTION;

UPDATE contas
SET saldo = saldo + 100
WHERE id = 3;

COMMIT;
```

Agora volte para a Sessão 1 e repita:

```sql
SELECT * FROM contas WHERE id = 3;
```

Finalize a Sessão 1:

```sql
COMMIT;
```

**Pergunta 10**  
O valor lido na Sessão 1 permaneceu o mesmo ou mudou?

    Mudou, agora é 400

**Pergunta 11**  
Que tipo de fenômeno esse teste procura identificar?

    Leitura não repetitível

---

#### Etapa 6. Simular atualização concorrente sobre o mesmo dado

Abra duas sessões.

### Sessão 1

```sql
START TRANSACTION;

SELECT * FROM contas WHERE id = 4;

UPDATE contas
SET saldo = saldo - 100
WHERE id = 4;
```

### Sessão 2

```sql
START TRANSACTION;

SELECT * FROM contas WHERE id = 4;

UPDATE contas
SET saldo = saldo - 200
WHERE id = 4;
```

Finalize ambas com `COMMIT`, observando a ordem de execução e depois consulte:

```sql
SELECT * FROM contas WHERE id = 4;
```

**Pergunta 12**  
Por que operações concorrentes sobre o mesmo registro exigem maior controle?

    Pois caso não exista controle as informações podem ser perdidas ou escritas em cima das outras

**Pergunta 13**  
Que inconsistência pode surgir quando duas transações tentam atualizar o mesmo dado quase ao mesmo tempo?

    Podem gerar inconsostencia de sobrescrever dados e perda de informação

---

#### Etapa 7. Testar espera por lock

### Sessão 1

```sql
START TRANSACTION;

SELECT * FROM contas WHERE id = 2 FOR UPDATE;
```

Mantenha a transação aberta.

### Sessão 2

```sql
START TRANSACTION;

UPDATE contas
SET saldo = saldo + 10
WHERE id = 2;
```

Agora, depois de observar a espera, volte para a Sessão 1 e execute:

```sql
COMMIT;
```

**Pergunta 14**  
Qual evidência mostra que havia um bloqueio ativo sobre o registro?

    A evidência é que a Sessão 2 ficou parada aguardando a liberação do registro.

**Pergunta 15**  
Por que a liberação do lock depende do fim da transação?

    Porque o lock pertence à transação ativa e só é liberado quando ela termina com COMMIT

---

#### Etapa 8. Testar bloqueio com duas leituras de atualização

### Sessão 1

```sql
START TRANSACTION;

SELECT * FROM contas WHERE id = 1 FOR UPDATE;
```

### Sessão 2

```sql
START TRANSACTION;

SELECT * FROM contas WHERE id = 1 FOR UPDATE;
```

Depois finalize a Sessão 1 com:

```sql
COMMIT;
```

**Pergunta 16**  
Por que a segunda leitura com `FOR UPDATE` não pôde prosseguir imediatamente?

    Pois a primeira já havia realizado a trava do registro

**Pergunta 17**  
Em que essa situação difere de uma consulta `SELECT` comum?

    Pois um select apenas realiza uma leitura sobre os dados e um UPTADE realiza a mudança sobre um dado

---

#### Etapa 9. Simular risco de atualização perdida

Considere o seguinte cenário conceitual:

- saldo atual da conta 1 = 1000
- Transação A lê saldo 1000 e decide subtrair 100
- Transação B lê saldo 1000 e decide subtrair 200
- A grava 900
- B grava 800

**Pergunta 18**  
Qual seria o saldo correto ao final, caso ambas as operações fossem consideradas corretamente?

    Seria 700

**Pergunta 19**  
Por que o resultado 800 caracteriza uma atualização perdida?

    Pois faltou a subtração da transação A anterior, a qual foi perdida e sobrescrita

---

#### Etapa 10. Testar inserções concorrentes em outra tabela

Crie a tabela:

```sql
DROP TABLE IF EXISTS log_operacoes;

CREATE TABLE log_operacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(200)
);
```

Abra duas sessões.

### Sessão 1

```sql
START TRANSACTION;

INSERT INTO log_operacoes (descricao)
VALUES ('Operacao realizada pela sessao 1');
```

### Sessão 2

```sql
START TRANSACTION;

INSERT INTO log_operacoes (descricao)
VALUES ('Operacao realizada pela sessao 2');
```

Finalize ambas com `COMMIT` e consulte:

```sql
SELECT * FROM log_operacoes;
```

**Pergunta 20**  
Por que inserções em linhas diferentes nem sempre geram conflito direto?

    Pois elas operam em ordem de chmada de transação, sem mudar algo real já existente, apenas adicionandp

**Pergunta 21**  
O que esse experimento mostra sobre concorrência quando não há disputa pelo mesmo registro?

    Mostra que o banco consegue permitir concorrência eficiente quando não existe conflito pelo mesmo registro

---

#### Etapa 11. Simular bloqueio prolongado

### Sessão 1

```sql
START TRANSACTION;

SELECT * FROM contas WHERE id = 3 FOR UPDATE;
```

Não finalize imediatamente.

### Sessão 2

```sql
START TRANSACTION;

UPDATE contas
SET saldo = saldo + 20
WHERE id = 3;
```

**Pergunta 22**  
Quais impactos um bloqueio mantido por muito tempo pode causar em um sistema real?

    Um bloqueio mantido por muito tempo pode causar lentidão, erros, perda de dados, deadlocks e filas de espera

**Pergunta 23**  
Por que transações longas tendem a ser indesejáveis em ambientes concorrentes?

    Pois assim bloqueiam funcionalidades ou aspectos para os usuários, devido ao bloqueio de alguma informação

---

#### Etapa 12. Consultar o estado final

Depois de finalizar todos os testes, execute:

```sql
SELECT * FROM contas;
SELECT * FROM log_operacoes;
```

**Pergunta 24**  
Como verificar se o banco permaneceu consistente após todos os cenários executados?

    Verificando se os saldos estão coerentes, não houve perda de dados

**Pergunta 25**  
Por que a análise final dos dados é importante após testes de concorrência?

    Pois permite identificar inconsistencias, conflitos reais ou efeitos inesperados

---

## 7. Atividade dissertativa

### Questão 26
Explique o que é concorrência em banco de dados.

    Concorrencia em banco de dados é quando existe uma execução simultânea de múltiplas transações por diferentes usuários ou processos

### Questão 27
Descreva o papel dos bloqueios no controle de concorrência.

    Os vloqueios controlam os acessos simultaneo dos dados, evitando alterações conflitantes

### Questão 28
Explique a diferença entre acessar registros iguais e registros diferentes em transações simultâneas.

    A diferença entre acessar registros iguais e diferentes em transações simultaneas é que para registros difererentes não é necessário um bloqueio
    direto de informações, pois não se conflitam entre si. Já os iguais, geraam disputa por mudança e podem causar conflitos

### Questão 29
Por que `FOR UPDATE` é importante em determinadas operações críticas?

    Porque ele garante exclusividade temporária sobre o registro durante operações críticas, travando determina informação

### Questão 30
O que significa dizer que uma transação ficou esperando outra liberar um recurso?

    Significa que a transação não pode continuar até que outra libere o recurso bloqueado, tipo o for uptade até o commit

### Questão 31
Explique o conceito de atualização perdida.

    Atualização perdida ocorre quando uma transação sobrescreve alterações feitas por outra, tipo no caso do 800 e 700

### Questão 32
Descreva por que o isolamento é essencial em sistemas multiusuário.

    Porque vários usuários podem acessar os mesmos dados simultaneamente, exigindo proteção contra inconsistências

### Questão 33
Explique como uma leitura pode ser afetada por outra transação ainda não concluída.

    Uma leitura pode visualizar dados antigos, novos ou até alterações temporárias, caso haja alguma transação que realizou mudança sobre tal dado lido

### Questão 34
Por que transações longas podem prejudicar o desempenho de sistemas concorrentes?

    Pois elas aumentam o tempo de espera e o bloqueio por determi nadas informações, causando espera maior

### Questão 35
Qual é a relação entre concorrência e consistência dos dados?

    A relação entre concorrencia e consistencia dos dados é que controle de concorrência ajuda a preservar a consistência dos dados mesmo com múltiplas operações simultâneas

### Questão 36
Descreva um exemplo real em que duas transações possam disputar o mesmo dado.

    Dois caixas bancarios tentando mudar o mesmo saldo de uma mesma conta

### Questão 37
Explique por que nem toda operação simultânea gera conflito.

    Pois existem operações que utilizam informações diferentes e não conflitantes entre si

### Questão 38
Como o banco de dados contribui para impedir que alterações simultâneas corrompam os dados?

    O banco utiliza locks, níveis de isolamento e mecanismos de controle de concorrência para coordenar acessos simultâneos

### Questão 39
Explique o que aconteceria em um sistema bancário sem mecanismos de lock.

    Poderiam ocorrer saldos incorretos, atualização perdida e inconsistências financeiras graves, havendo perda de dinheiro
    saldo duplicado, retirada de dinheiro físico dupla, etc

### Questão 40
Qual a importância de observar a ordem de execução das transações em testes práticos?

    Porque pequenas diferenças na ordem podem alterar o resultado final das transações concorrentes

---

## 8. Atividade prática com enunciado formal

### Enunciado
Um sistema bancário multiusuário precisa permitir operações simultâneas sem comprometer a integridade dos dados. Para isso, implemente testes em SQL que demonstrem:

- bloqueio explícito de registros com `FOR UPDATE`
- espera de uma transação por outra
- diferença entre concorrência em registros iguais e em registros diferentes
- risco de atualização perdida
- análise da consistência final dos dados após execuções concorrentes

### Objetivos
Ao final da atividade, o estudante deve ser capaz de:

- compreender o conceito de concorrência
- identificar situações de bloqueio
- analisar o efeito de locks em duas sessões simultâneas
- perceber quando há disputa por recursos
- discutir riscos de inconsistência em operações concorrentes
- relacionar concorrência com integridade e desempenho

### Tarefa final
Com base nos testes realizados, produza um texto explicando:

- o que é concorrência em banco de dados
- como funcionam os locks
- por que algumas transações precisam esperar
- o que é atualização perdida
- por que o isolamento é importante
- como o banco preserva a consistência em acessos simultâneos

RESPOSTA

        Concorencia em banco de dados: ocorre quando várias transações são executadas simultaneamente por diferentes usuários ou processos
        Como funciona os locks: lock impede que duas transações alterem o mesmo registro ao mesmo tempo. O comando FOR UPDATE, por exemplo, cria um bloqueio exclusivo sobre uma linha selecionada, reservando aquele registro para a transação atual até que ela termine com commit
        Pq algumas transações preciam esperar: acontece quando ambas tentam acessar o mesmo recurso de forma conflitante. Se uma transação já possui lock sobre um registro, outra transação que tentar alterá-lo ficará aguardando a liberação do bloqueio.
        O que é atualização perdida: ocorre quando duas transações leem o mesmo valor inicial e gravam alterações diferentes (sobrescrita)
        Por quw o isolamento é importante: O isolamento é importante porque garante que transações simultâneas não interfiram inadequadamente umas nas outras
        Como o banco preserva a consistência em acessos simultaneos: utilizando transações, locks e mecanismos de controle de concorrência

---

## 9. Questão integradora

### Questão 41
Considerando todos os experimentos realizados, explique de forma integrada como concorrência, bloqueios e isolamento atuam juntos para evitar inconsistências no banco de dados.

    Concorrência permite que múltiplas transações sejam executadas simultaneamente em sistemas multiusuário. Porém, quando diferentes transações acessam o mesmo dado, podem surgir conflitos capazes de gerar inconsistências.
    Para evitar esses problemas, o banco utiliza bloqueios (locks), que controlam temporariamente o acesso aos registros. O comando FOR UPDATE, por exemplo, cria um lock exclusivo sobre uma linha, impedindo alterações concorrentes até o término da transação.
    O isolamento garante que transações não interfiram incorretamente umas nas outras. Assim, alterações ainda não confirmadas normalmente não ficam visíveis para outras sessões.
    Esses mecanismos ajudam a impedir problemas como atualização perdida, leituras inconsistentes e corrupção de dados, preservando a integridade e a consistência do banco mesmo em ambientes com muitos usuários simultâneos.

---

## 10. Desafio adicional

### Questão 42
Adapte os testes realizados para um sistema de estoque em que dois usuários tentam vender o mesmo produto simultaneamente. Explique quais riscos existem e como o banco pode evitá-los.

    Os riscos existentes caso isso ocorra seriam: estoque negativo, venda duplicada, inconsistencia do produto, assim para tratar isso o banco deveria adaptar-se aos controles dos dados, utilizando
    locks, travas, for uptade, rollback, assim bloqueando uma das vendas.

### Questão 43
Adapte os testes para um sistema de matrícula acadêmica, em que duas pessoas tentam ocupar a última vaga da mesma disciplina ao mesmo tempo.

    No sistema acadêmico, duas pessoas podem tentar ocupar simultaneamente a última vaga de uma disciplina.

    A transação deve:

    verificar vagas
    bloquear o registro da disciplina
    reduzir a quantidade de vagas
    registrar a matrícula

    Assim, bloqueando uma das transações requisitantes


### Questão 44
Explique como você organizaria um experimento prático no VS Code com duas sessões para demonstrar espera por lock a outros estudantes.

    Sessão 1: 
```sql
START TRANSACTION;
SELECT * FROM contas
WHERE id = 1
FOR UPDATE;
```

    Sessão 2:
```sql
START TRANSACTION;
UPDATE contas
SET saldo = saldo + 100
WHERE id = 1;
```

    Execute as duas depois o commit na sessão 1, e a sessao 2 finalmente saira da espera

### Questão 45
Compare um cenário com controle de concorrência e outro sem controle de concorrência, destacando os impactos sobre a confiabilidade dos dados.

    Com controle de concorrência:
    - os dados permanecem consistentes
    - alterações são coordenadas
    - conflitos são controlados
    - evita atualização perdida

    Sem controle de concorrência:
    - transações podem sobrescrever dados umas das outras
    - podem surgir inconsistências
    - há risco de corrupção de informações
    - o sistema perde confiabilidade

    O controle de concorrência é fundamental para garantir integridade e segurança em sistemas multiusuário.
