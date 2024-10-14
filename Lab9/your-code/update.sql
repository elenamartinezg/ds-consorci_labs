UPDATE vendedores
SET TIENDA = 'Miami'
WHERE NOMBRE = 'Paige Turner' AND TIENDA = 'Mimia';


SELECT *
FROM vendedores;


UPDATE clientes SET CORREO = 'ppicasso@gmail.com' WHERE NOMBRE = 'Pablo Picasso';
UPDATE clientes SET CORREO = 'lincoln@us.gov' WHERE NOMBRE = 'Abraham Lincoln';
UPDATE clientes SET CORREO = 'hello@napoleon.me' WHERE NOMBRE = 'Napoleon Bonaparte';

SELECT *
FROM clientes;