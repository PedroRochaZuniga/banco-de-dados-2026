START TRANSACTION;
UPDATE contas
SET saldo = saldo + 50
WHERE id = 1;
COMMIT;

START TRANSACTION;
UPDATE contas
SET saldo = saldo + 70
WHERE id = 4;
COMMIT;


SELECT * FROM contas WHERE id = 2;

START TRANSACTION;
UPDATE contas
SET saldo = saldo + 100
WHERE id = 3;
COMMIT;


START TRANSACTION;
SELECT * FROM contas WHERE id = 4;
UPDATE contas
SET saldo = saldo - 200
WHERE id = 4;
COMMIT;


START TRANSACTION;
UPDATE contas
SET saldo = saldo + 10
WHERE id = 2;

START TRANSACTION;
SELECT * FROM contas WHERE id = 1 FOR UPDATE;


START TRANSACTION;
INSERT INTO log_operacoes (descricao)
VALUES ('Operacao realizada pela sessao 2');
COMMIT;

START TRANSACTION;
UPDATE contas
SET saldo = saldo + 20
WHERE id = 3;
