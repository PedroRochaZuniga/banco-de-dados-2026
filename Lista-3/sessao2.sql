SELECT * FROM contas WHERE id = 1;

START TRANSACTION;

UPDATE contas
SET saldo = saldo + 300
WHERE id = 1;
COMMIT;

START TRANSACTION;

UPDATE contas
SET saldo = saldo + 70
WHERE id = 4;
COMMIT;
