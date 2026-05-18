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


START TRANSACTION;
SELECT * FROM contas
WHERE id = 1
FOR UPDATE;
UPDATE contas
SET saldo = saldo - 100
WHERE id = 1;
COMMIT;

START TRANSACTION;
UPDATE contas
SET saldo = saldo - 50
WHERE id = 1;
COMMIT;

START TRANSACTION;
UPDATE contas
SET saldo = saldo - 200
WHERE id = 2;
COMMIT;
ROLLBACK;

START TRANSACTION;
SELECT * FROM contas WHERE id = 3;
COMMIT;

START TRANSACTION;
SELECT * FROM contas WHERE id = 4;
UPDATE contas
SET saldo = saldo - 100
WHERE id = 4;
COMMIT;

SELECT * FROM contas WHERE id = 4;


START TRANSACTION;
SELECT * FROM contas WHERE id = 2 FOR UPDATE;
COMMIT;

START TRANSACTION;
SELECT * FROM contas WHERE id = 1 FOR UPDATE;
COMMIT;


DROP TABLE IF EXISTS log_operacoes;
CREATE TABLE log_operacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(200)
);

START TRANSACTION;
INSERT INTO log_operacoes (descricao)
VALUES ('Operacao realizada pela sessao 1');
COMMIT;

SELECT * FROM log_operacoes;



START TRANSACTION;
SELECT * FROM contas WHERE id = 3 FOR UPDATE;
COMMIT;

SELECT * FROM contas;
SELECT * FROM log_operacoes;
