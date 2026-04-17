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



-- Qual é o objetivo da tabela contas neste cenário prático?
-- Apresentar os titulares, assim como registrar seus id e saldos

-- Quais são os saldos iniciais de cada titular antes da execução das transações?
-- 1000,500,300,800

START TRANSACTION;
UPDATE contas
SET saldo = saldo - 100
WHERE id = 1;
UPDATE contas
SET saldo = saldo + 100
WHERE id = 2;
COMMIT;

-- O que aconteceu com os saldos após o COMMIT?
-- Houve transação do saldo de id 1 e 2, em 100 reais.

--Por que as duas instruções `UPDATE` devem fazer parte da mesma transação?
-- Pois cada uptade se refere a uma atualização de um termo especifico na tabela.


START TRANSACTION;
UPDATE contas
SET saldo = saldo - 50
WHERE id = 2;
UPDATE contas
SET saldo = saldo + 50
WHERE id = 3;
ROLLBACK;

-- Por que os valores não foram alterados ao final?
-- Pq eu dei o rooljhonson

--Em quais situações reais o uso de ROLLBACK seria essencial?
-- EM operaçoes por engano, ous eja, erros ceometidos


START TRANSACTION;
UPDATE contas
SET saldo = saldo - 2000
WHERE id = 3;
SELECT * FROM contas WHERE id = 3;
ROLLBACK;

-- Por causa do roolback
--Qual problema de integridade poderia ocorrer se essa transação fosse confirmada?
--Saldo negativo


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

--Qual conta foi debitada e quais contas foram creditadas?
-- A 4 foi debitada e a 1 e 2 foi creditada

-- Por que esse conjunto de operações também deve ser tratado como uma única transação?
-- Pra não gerar um estado fraturado no sistema

START TRANSACTION;
UPDATE contas
SET saldo = saldo - 150
WHERE id = 1;
ROLLBACK;
COMMIT;

-- Qual era o objetivo de observar o valor da conta em outra sessão antes do COMMIT?
-- Para não dar conflito com a tabela original

-- Como esse teste se relaciona com o conceito de isolamento?
-- Se relaciona, pois estamos tratando essa operação em outra seção minimizabdo o conflito

START TRANSACTION;
SELECT * FROM contas WHERE id = 1 FOR UPDATE;
UPDATE contas
SET saldo = saldo - 200
WHERE id = 1;
COMMIT;

-- O que aconteceu com a segunda transação?
-- Pq ela ficou em aguardo

-- Por que ela precisou esperar?
-- POis outra sessão estava utilizando o mesmo aspecto de tratatmento

-- Qual a função do FOR UPDATE?
-- bloqueia sa linhas retornadas pelo select até o fim da transação, evitando conflito de concorrencia

