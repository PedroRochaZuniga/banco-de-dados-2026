# Aplicando conceitos de transações em banco de dados sequencial

## 1. Atividade prática

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
Qual é o objetivo da tabela `contas` neste cenário prático?
    
    Apresentar os titulares, assim como registrar seus id e saldos

**Pergunta 2**  
Quais são os saldos iniciais de cada titular antes da execução das transações?
    
    1000,500,300,800
  

---

#### Etapa 2. Testar COMMIT

Execute:

```sql
START TRANSACTION;

UPDATE contas
SET saldo = saldo - 100
WHERE id = 1;

UPDATE contas
SET saldo = saldo + 100
WHERE id = 2;

COMMIT;
```

Depois:

```sql
SELECT * FROM contas;
```

**Pergunta 3**  
O que aconteceu com os saldos após o `COMMIT`?
  
    Houve transação do saldo de id 1 e 2, em 100 reais.
  

**Pergunta 4**  
Por que as duas instruções `UPDATE` devem fazer parte da mesma transação?
    
    Pois cada uptade se refere a uma atualização de um termo especifico na tabela, caso só uma fosse executada, poderia ocorrer inconstitencia
---

#### Etapa 3. Testar ROLLBACK

Execute:

```sql
START TRANSACTION;

UPDATE contas
SET saldo = saldo - 50
WHERE id = 2;

UPDATE contas
SET saldo = saldo + 50
WHERE id = 3;

ROLLBACK;
```

Depois:

```sql
SELECT * FROM contas;
```

**Pergunta 5**  
Por que os valores não foram alterados ao final?

    Pois o comando ROLLBACK foi executado, e ele é meio que um crl + z

**Pergunta 6**  
Em quais situações reais o uso de `ROLLBACK` seria essencial?

    Em falahas do sistema, erro de calculo, saldo insuficiente, perda de conexão e ente outros

---

#### Etapa 4. Testar erro lógico antes da confirmação

Execute:

```sql
START TRANSACTION;

UPDATE contas
SET saldo = saldo - 2000
WHERE id = 3;

SELECT * FROM contas WHERE id = 3;

ROLLBACK;
```

Depois:

```sql
SELECT * FROM contas WHERE id = 3;
```

**Pergunta 7**  
Por que a transação foi desfeita neste caso?

        Pois gerou um saldo inválido

**Pergunta 8**  
Qual problema de integridade poderia ocorrer se essa transação fosse confirmada?

    Problema de inconsistência, como saldo negativo 

---

#### Etapa 5. Testar múltiplas operações na mesma transação

Execute:

```sql
START TRANSACTION;

UPDATE contas
SET saldo = saldo - 100
WHERE id = 4;

UPDATE contas
SET saldo = saldo + 60
WHERE id = 1;

UPDATE contas
SET saldo = saldo + 40
WHERE id = 2;

COMMIT;
```

Depois:

```sql
SELECT * FROM contas;
```

**Pergunta 9**  
Qual conta foi debitada e quais contas foram creditadas?

    A conta debitada foi a de id = 4, Daniela

    E as creditadas foi a de id = 1 e  id = 2, Ana e Bruno

**Pergunta 10**  
Por que esse conjunto de operações também deve ser tratado como uma única transação?

    Para não gerar um estado fraturado no sistema, já que elas fazem parte de apenas uma intenção

---

#### Etapa 6. Testar leitura durante transação

Execute:

```sql
START TRANSACTION;

UPDATE contas
SET saldo = saldo - 150
WHERE id = 1;
```

Sem executar `COMMIT` ainda, em outra sessão rode:

```sql
SELECT * FROM contas WHERE id = 1;
```

Depois volte para a primeira sessão e execute:

```sql
ROLLBACK;
```

**Pergunta 11**  
Qual era o objetivo de observar o valor da conta em outra sessão antes do `COMMIT`?

    O objetivo era visualizar se outra sessão conseguiria visualizar alterações ainda não confirmadas, para não alterar e dar conflito na tabela original

**Pergunta 12**  
Como esse teste se relaciona com o conceito de isolamento?

    Esse teste se relaciona com o conceito de isolamento, pois estamos tratando essa operação em outra seção minimizabdo o conflito entre as operações

---

#### Etapa 7. Testar lock com duas sessões

Abra duas conexões.

### Sessão 1

```sql
START TRANSACTION;

SELECT * FROM contas WHERE id = 1 FOR UPDATE;

UPDATE contas
SET saldo = saldo - 200
WHERE id = 1;
```

Não execute `COMMIT` ainda.

### Sessão 2

```sql
START TRANSACTION;

UPDATE contas
SET saldo = saldo + 300
WHERE id = 1;
```

**Observe**  
A segunda sessão pode ficar bloqueada esperando a primeira terminar.

Agora volte para a Sessão 1 e faça:

```sql
COMMIT;
```

Depois finalize a Sessão 2.

**Pergunta 13**  
O que aconteceu com a segunda transação?

        Ficou esperando a primeira transação ser confirmada

**Pergunta 14**  
Por que ela precisou esperar?

    Pois a outra transação estaca utilizando o mesmo aspecto de tratatmento de dados

**Pergunta 15**  
Qual a função do `FOR UPDATE`?

    Bloqueia as linhas retornadas pelo select até o fim da transação 

---

#### Etapa 8. Testar concorrência em registros diferentes

Abra duas conexões.

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

Depois execute `COMMIT` em ambas.

**Pergunta 16**  
Por que nesse caso as transações tendem a não disputar o mesmo recurso?

    Porque cada transação alterava registros diferentes da tabela, evitando disputa pelo mesmo lock.

**Pergunta 17**  
O que esse teste mostra sobre concorrência em linhas diferentes da tabela?

    Mostra que o banco consegue executar transações simultâneas quando elas atuam em linhas diferentes.

---

#### Etapa 9. Criar tabela de movimentações

Execute:

```sql
DROP TABLE IF EXISTS movimentacoes;

CREATE TABLE movimentacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    conta_origem INT,
    conta_destino INT,
    valor DECIMAL(10,2),
    data_movimentacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Pergunta 18**  
Qual é a importância de registrar movimentações além de atualizar os saldos?

    Pois assim voce realiza um historico de operações para conferir dados e fraudes

---

#### Etapa 10. Transferência com registro em histórico

Execute:

```sql
START TRANSACTION;

UPDATE contas
SET saldo = saldo - 120
WHERE id = 2;

UPDATE contas
SET saldo = saldo + 120
WHERE id = 3;

INSERT INTO movimentacoes (conta_origem, conta_destino, valor)
VALUES (2, 3, 120.00);

COMMIT;
```

Depois:

```sql
SELECT * FROM contas;
SELECT * FROM movimentacoes;
```

**Pergunta 19**  
Por que o `INSERT` na tabela `movimentacoes` deve estar na mesma transação dos `UPDATE`s?
    
    Porque o histórico e os saldos precisam permanecer sincronizados

**Pergunta 20**  
O que poderia acontecer se o histórico fosse gravado, mas os saldos não fossem atualizados, ou vice-versa?

    Poderia houver uma perda de informação e conflito entre dados reais e no "papel"

---

#### Etapa 11. Simular falha antes do registro da movimentação

Execute:

```sql
START TRANSACTION;

UPDATE contas
SET saldo = saldo - 80
WHERE id = 1;

UPDATE contas
SET saldo = saldo + 80
WHERE id = 4;

ROLLBACK;
```

Depois:

```sql
SELECT * FROM contas;
SELECT * FROM movimentacoes;
```

**Pergunta 21**  
O que o `ROLLBACK` garantiu nesse cenário?

    Ele garantiu que nenhuma alteração parcial contiuasse salvada no banco

**Pergunta 22**  
Como esse teste demonstra a propriedade de atomicidade?

    Esse teste demonstra atomicidade pois todas as informações da transação foram canceladas juntas

---

#### Etapa 12. Consultar estado final

Execute:

```sql
SELECT * FROM contas;
SELECT * FROM movimentacoes;
```

**Pergunta 23**  
Como verificar se o banco permaneceu consistente após todas as operações realizadas?

    Verificando o histórico de operações

**Pergunta 24**  
Por que a consistência do banco depende não apenas dos comandos SQL, mas também da forma como eles são agrupados em transações?

    Pois existe uma dependencia das operações realizadas de forma correta e completa

---

## 7. Atividade dissertativa

### Questão 25
Explique o que é uma transação em banco de dados.

    é um conjunt0 de operações determinda por consultas e buscas, tendo um início e fim, sendo obrigadas a serem concluidas

### Questão 26
Descreva a diferença entre `COMMIT` e `ROLLBACK`.

    A diferena entre commit e rollback é que o commit indica o final de uma transação e o rollback é o cancelamento das linhas selecionadas, seja ela uma transação ou operação

### Questão 27
Explique por que uma transferência bancária deve ser tratada como transação.

    Pois depende de múltiplos parámetros e operações de buscas e consultas, além de ser sucetivel a erros

### Questão 28
O que pode acontecer se duas transações alterarem o mesmo dado ao mesmo tempo sem controle de concorrência?

    Pode ocorrer um conflito de dados, perdendo alguma informação decorrente da outra

### Questão 29
Qual a relação entre transações e as propriedades ACID?

    As transações implementamn as prorpiedas acid
    

### Questão 30
Explique o significado da propriedade de atomicidade no contexto de uma operação bancária.

    Atomicidade significa que uma operação deve ocorrer 100% ou não e no banco, devem ocorrer diversas operações
    como por exemplo, crédito e débito ocorrendo juntos

### Questão 31
Explique o que significa dizer que uma transação preserva a consistência do banco de dados.
    
    Significa que uma transação respeita as regras de integridade

### Questão 32
Descreva o papel do isolamento em ambientes com múltiplos usuários acessando o mesmo banco.

    O isolamento impede que transações concorrente interfiram de forma conflituosa uma nas outras
    Assim, vários usuários tendo uma resposta confiave sobre os dados, por exemplo descnto em produto

### Questão 33
Explique a importância da durabilidade após a execução de um `COMMIT`.

    A durabilidade garatne que os dados serão salvos de forma segura após o commit, mesmo em falha do sistena

### Questão 34
O que é controle de concorrência e por que ele é necessário?

    Controle de concorrencia é a forma de tratamento entre controlar transações simultanes e evitar conflitos
    é neccesário, pois na vidad real os bancos são usados por vários usuários ao mesmo tempo

### Questão 35
Explique a função do lock em transações concorrentes.

    O lock bloqueia temporariamente acesso concorrente a dados tilizados por uma transação, ex escolher assento no avião

### Questão 36
Descreva um exemplo prático em que o `FOR UPDATE` seja necessário.

    O for uptade pode ser utilizado quando deve bloquear uma conta bancária enquanto o saldo está sendo atualizado

### Questão 37
O que é uma atualização perdida (*lost update*)?

    É quando uma atualização é perdida devido ao conflito de acesso simultaneo e sobrescreveram este dado simultaneamente

### Questão 38
Explique por que nem toda leitura concorrente gera problema, mas algumas atualizações simultâneas sim.

    Pois a leitura não impacta diretamente o banco de dados, já as atualizações podem mudar os valores de registros do banco

### Questão 39
Qual é a importância de registrar operações em uma tabela de histórico dentro da mesma transação?

    Pois garante sincronização entre os dados principais e o histórico deles

### Questão 40
Em um sistema acadêmico, cite um exemplo de operação que deveria ser tratada como transação.

    Registraruma matricla de um aluno específico em um curso exterior ao dele, mexendo na sua carga horária e notas

### Questão 41
Em um sistema de estoque, cite um exemplo de falha que poderia justificar o uso de `ROLLBACK`.

    Uma venda cancelada, ou estoque real diferente do estoque no sistema, perca de produtos

### Questão 42
Como o processamento de transações contribui para a confiabilidade de sistemas de informação?

    O processamento de transações aumenta a confiabilidade garantindo integridade, segurança e consistência dos dados.

---

### Questão 43
Considerando todos os experimentos realizados, explique de forma integrada como atomicidade, consistência, isolamento e durabilidade atuam em conjunto no processamento de transações.

    Atomicidade: garante que todas as operações sejam realizadas integralmente ou não sejam nem realizadas
    Consistencia: mantém todos os vãlidos antes e depois da transação
    Isolamento: evita interferencia entre transações simultaneas
    Durabilidade: garante guaradar os dados de forma segura após o commit

    Assim, elas tornam o banco confiável, mesmo em ambientes sujeitos a falhas

---

## Desafio

### Questão 44
Adapte o exemplo bancário para um sistema de matrícula em disciplinas, em que uma transação deva:

- verificar vaga disponível
- reduzir a quantidade de vagas
- registrar a matrícula do aluno

Explique por que essas operações devem ocorrer na mesma transação.]

    Essas operações precisam estar na mesma transação porque dependem umas das outras.
    Sem isso, poderiam ocorrer matrículas sem vaga disponível ou vagas reduzidas sem matrícula registrada.    

### Questão 45
Adapte o exemplo para um sistema de estoque e vendas, explicando quais operações devem ser agrupadas para evitar inconsistências.

    - Registrar venda
    - Reduzir estoque
    - Registrar pagamento]
    - Guardar historico
    - Emitir nota fiscal

    Elas devem ser agrupadas para evitar inconsistencias, como venda registradas sem atualização no estoque ou sem a confirmação na venda  e registro no historico, não emitindo a nota fiscal
    
