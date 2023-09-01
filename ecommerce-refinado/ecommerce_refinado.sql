CREATE DATABASE ecommerce_refinado;

use ecommerce_refinado;

-- Clientes
CREATE TABLE clients(
    idClient INT auto_increment PRIMARY KEY,
    fullName VARCHAR(50)  NOT NULL,
    email VARCHAR(45) NOT NULL,
    password VARCHAR(32) NOT NULL,
    contact CHAR(12),
    Address VARCHAR(45) NOT NULL,
    Number VARCHAR(9),
    neighborhood VARCHAR(45),
    city VARCHAR(45) NOT NULL,
    zipCode CHAR(8) NOT NULL,
    state CHAR(2) NOT NULL
);

-- Clientes CNPJ
CREATE TABLE client_PJ(
    idClient_PJ INT auto_increment PRIMARY KEY,
	idClientPJ INT,
    socialName VARCHAR(100) NOT NULL,
    CNPJ CHAR(14) NOT NULL,
    CONSTRAINT unique_client_PJ unique(CNPJ),
    CONSTRAINT fk_pj_client FOREIGN KEY (idClientPJ) REFERENCES clients(idClient)
);

-- Clientes CPF
CREATE TABLE client_PF(
    idClient_PF INT auto_increment PRIMARY KEY,
	idClientPF INT,
    CPF CHAR(11) NOT NULL,
    CONSTRAINT unique_client_PF unique(CPF),
	CONSTRAINT fk_pf_client FOREIGN key (idClientPF) REFERENCES clients(idClient)
);

-- Pedidos
CREATE TABLE orders(
    idOrder INT auto_increment PRIMARY KEY,
    idOrderClient INT,
    orderStatus ENUM('Pagamento pendente','Pagamento Confirmado','Em Preparação','Produto enviado','Produto entregue') default 'Em preparação' NOT NULL,
    orderDate DATE NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_orders_clients FOREIGN KEY (idOrderClient) REFERENCES clients(idClient)
);
show tables;
-- Marcas
CREATE TABLE brands(
    idBrands INT auto_increment PRIMARY KEY,
    brandName VARCHAR(50) NOT NULL
);

-- Categorias
CREATE TABLE categories(
    idCategories INT auto_increment PRIMARY KEY,
    categoryName VARCHAR(45)
);

-- Produto
CREATE TABLE products(
    idProduct INT auto_increment PRIMARY KEY,
    idProductCategory INT,
    idProductBrand INT,
    productName VARCHAR(100) NOT NULL,
    Description TEXT NOT NULL,
    currentAmount DECIMAL(10, 2) NOT NULL,
    previousAmount DECIMAL(10, 2),
    newProduct TINYINT,
    bestSeller TINYINT,
    offer TINYINT,
    highlight TINYINT,
    CONSTRAINT fk_product_category_brand FOREIGN KEY(idProductCategory) REFERENCES categories(idCategories),
    CONSTRAINT fk_product_brand FOREIGN KEY(idProductBrand) REFERENCES brands(idBrands)
);

-- Boleto 
CREATE TABLE bills(
    idBill INT auto_increment PRIMARY KEY,
    amount DECIMAL(10, 2) NOT NULL,
    billNumber VARCHAR(45) NOT NULL,
    billStatus ENUM('Aguardando pagamento', 'Pagamento confirmado') default 'Aguardando pagamento' NOT NULL,
    dueDate DATE NOT NULL
);

-- Credito
CREATE TABLE creditCards(
    idCreditCard INT auto_increment PRIMARY KEY,
    cardNumber CHAR(20) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    cardExpiration DATE NOT NULL,
    installments INT NOT NULL
);

-- Pagamento
CREATE TABLE payments(
    idPayment INT auto_increment PRIMARY KEY,
    idPaymentOrder INT,
    idPaymentBill INT,
    idPaymentCreditCard INT,
    typePayment VARCHAR(25) NOT NULL,
    statusPayment ENUM('Aguardando pagamento', 'Pagamento confirmado') default 'Aguardando pagamento' NOT NULL,
    amountPayment DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_payment_order FOREIGN KEY (idPaymentOrder) REFERENCES orders(idOrder),
    CONSTRAINT fk_payment_bill FOREIGN KEY (idPaymentBill) REFERENCES bills(idBill),
    CONSTRAINT fk_payment_card FOREIGN KEY (idPaymentCreditCard) REFERENCES creditCards(idCreditCard)
);

-- Estoque
CREATE TABLE productStorage(
    idProductStorage INT auto_increment PRIMARY KEY,
    storageLocation VARCHAR(255) NOT NULL,
    quantity INT DEFAULT 0 NOT NULL
);

-- Tabela fornecedor
CREATE TABLE supplier(
    idSupplier INT auto_increment PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(14) NOT NULL,
    contact CHAR(12) NOT NULL,
    CONSTRAINT unique_supplier unique (CNPJ)
);

-- Tabela vendedor
CREATE TABLE seller(
    idSeller INT auto_increment PRIMARY KEY,
    socialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(14),
    CPF CHAR(11),
    location VARCHAR(255),
    contact CHAR(12) NOT NULL,
    CONSTRAINT unique_cnpj_seller unique (CNPJ),
    CONSTRAINT unique_cpf_seller unique (CPF)
);
 
  -- Produto por Vendedor
CREATE TABLE productSeller(
    idPseller INT,
    idPproduct INT,
    prodQuantity INT NOT NULL,
    PRIMARY KEY (idPseller, idPproduct),
    CONSTRAINT fk_product_seller FOREIGN KEY (idPseller) REFERENCES seller(idSeller),
    CONSTRAINT fk_product_product FOREIGN KEY (idPproduct) REFERENCES products(idProduct)
);

-- Relação de Produtos/Pedido
CREATE TABLE productOrder(
    idPOproduct INT,
    idPOorder INT,
    idPObrand INT,
    idPOcategory INT,
    poQuantity INT default 1,
    poStatus enum('Disponível','Sem estoque') default 'Disponível',
    PRIMARY KEY (idPOproduct, idPOorder),
    CONSTRAINT fk_productorder_seller FOREIGN KEY (idPOproduct) REFERENCES productS(idProduct),
    CONSTRAINT fk_productorder_product FOREIGN KEY (idPOorder) REFERENCES orders(idOrder),
    CONSTRAINT fk_product_PObrand FOREIGN KEY (idPObrand) REFERENCES products(idProduct),
    CONSTRAINT fk_product_POcategory FOREIGN KEY (idPOcategory) REFERENCES products(idProduct)
);

-- Produto em estoque
CREATE TABLE storageLocation(
   idLproduct INT,
   idLstorage INT,
   location CHAR(2) NOT NULL,
   PRIMARY KEY (idLproduct, idLStorage),
   CONSTRAINT fk_storage_location_product FOREIGN KEY (idLproduct) REFERENCES productS(idProduct),
   CONSTRAINT fk_storage_location_storage FOREIGN KEY (idLstorage) REFERENCES productStorage(idProductStorage)
);

CREATE TABLE productSupplier(
    idPsSupplier INT,
    idPsProduct INT,
    quantity INT NOT NULL,
    PRIMARY KEY (idPsSupplier, idPsProduct),
    CONSTRAINT fk_product_supplier_supplier FOREIGN KEY (idPsSupplier) REFERENCES supplier(idSupplier),
    CONSTRAINT fk_product_supplier_product FOREIGN KEY (idPsProduct) REFERENCES products(idProduct)
);

SHOW TABLES;
DESC clients;

-- Inserindo Clientes
INSERT INTO clients (fullName, email, password, contact, Address, Number, neighborhood, city, zipCode, state)
 VALUES ('Alberto Sales','alber@gmail.com','123456','022192525252','Rua Floriano Peixoto','142','Dois de Julho','Esperança','47757589','BA'),
	    ('Ana Paula Alves','ana@gmail.com','223456','022935252525','Rua Floriano Peixoto','143','Dois de Julho','Esperança','47757589','BA'),
	    ('Pedro Silva','pedro@gmail.com','323456','022915252525','Rua Floriano Peixoto','144','Dois de Julho','Esperança','47757589','BA'),
	    ('Thiago Sales','thy@gmail.com','423456','022945252525','Rua Floriano Peixoto','145','Dois de Julho','Esperança','47757589','BA'),
	    ('Camila Sales','camila@gmail.com','523456','022955252525','Rua Floriano Peixoto','146','Dois de Julho','Esperança','47757589','BA'),
	    ('Carlos Sales','carlos@gmail.com','723456','022965252525','Rua Floriano Peixoto','147','Dois de Julho','Esperança','47757589','BA'),
	    ('Antonio Sales','antony@gmail.com','823456','022975252525','Rua Floriano Peixoto','148','Dois de Julho','Esperança','47757589','BA'),
	    ('Felipe Novais','antony@gmail.com','823454','022985252525','Rua Floriano Peixoto','149','Dois de Julho','Esperança','47757589','BA');
        
-- Clientes CNPJ  
INSERT INTO client_PJ (socialName, CNPJ, idClientPJ)
	VALUES ('Empresa Novais', '00022222222222', 1),
		   ('Empresa Ramos', '00033333333333', 3),
		   ('Empresa Eletro', '00044444444444', 7),
		   ('Empresa Shop Prime', '00055555555555', 8);
           
  -- Clientes cpf   
INSERT INTO client_PF(idClientPF, CPF)
    VALUES (2, '14141414141'),
           (4, '15151515151'),
           (5, '17171717171'),
           (6, '18181818181');
	
-- brands   
 INSERT INTO brands( brandName) 
	VALUES('ELECTROLUX'),          
		  ('PHILCO'),
          ('KORG'),
          ('ARNO'),
          ('PANELUX'),
          ('LENOVO'),
          ('XIAOMI');
          
  -- categories   
 INSERT INTO categories(categoryName) 
	VALUES('Eletrodomésticos'),
          ('TV'),
          ('Utilidades Domésticas'),
          ('Informática'),
          ('instrumentos Musicais'),
          ('Celulares');
          
-- products          
INSERT INTO products
(idProductCategory, idProductBrand, productName, Description, currentAmount, previousAmount, newProduct, bestSeller, offer, highlight)
VALUES(3, 5, 'Panela de Pressão 4.5L', 'a Panela de Pressão 4,5L com Fechamento Externo é a combinação perfeita para sua cozinha.', 123.40, 129.90, 1, 1, 1, 1),
      (1, 1, 'Refrigerador', 'Possui um Design único e moderno', 5800.00, 7500.00, 1, 1, 1, 1),
      (6, 7, 'Smartphone', 'Possui um Design único e moderno', 3800.00, 5500.00, 1, 1, 1, 1),
      (2, 2, 'Smart TV LED 32"', 'Possui um Design único, uma ótima resolução', 2800.00, 3500.00, 1, 0, 1, 1),
      (4, 6, 'Notebook"', 'É um notebook completo com tela antirreflexo de 15.6", bateria de longa duração.', 3500.00, 2500.00, 1, 0, 1, 1),
      (5, 3, 'Teclado pa1000 arranjador"', 'Arranjador de Alta Performance.', 24881.42, 25650.95, 1, 0, 1, 1),
      (3, 4, 'Cafeteira Nescafé - Vermelha"', 'Esta é uma máquina multi-bebidas que prepara mais de 30 tipos de bebidas em cápsulas com inovações a cada ano.', 524.90, 580.48, 1, 1, 1, 1),
      (3, 5, 'Conjunto de Panelas 9 Peças com Kit Utensílios 4 peças"', 'Design moderno e prático, que facilita o manuseio e a limpeza.', 224.90, 280.48, 1, 0, 1, 1);

 -- Pedidos
 INSERT INTO orders(idOrder, orderDate, amount, orderStatus, idOrderClient)
    VALUES(1, '2023-06-29',5800.00, 'Pagamento pendente', 1),
		  (2, '2023-05-25',123.40, 'Pagamento confirmado', 1);

-- boleto
INSERT INTO bills(amount, billNumber, billStatus, dueDate)
    VALUES(5800.00, 0012345678915, 'Aguardando pagamento', '2023-06-29');  
    
 -- Crédito 
 INSERT INTO creditCards(cardNumber, amount, cardExpiration, installments)
		VALUES('xxxxyyyyzzzz4557', 123.40, '2025-08-24', 1);

-- Pagamento 
INSERT INTO payments( typePayment, statusPayment, amountPayment, idPaymentOrder)
	VALUES('Cartão de Crédito', 'Pagamento confirmado', 123.40, 2 );

-- Relação produto/pedido
INSERT INTO productOrder(idPOproduct, idPOorder, idPObrand, idPOcategory)
	VALUES(2, 1, 1, 1),
		  (1, 2, 5, 3);
		
SELECT * FROM clients;        
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM brands;
SELECT * FROM categories;
SELECT * FROM productOrder;

-- Estoque
INSERT INTO productStorage (storageLocation, quantity) 
	VALUES ('Rio de Janeiro', 1000),
		   ('Rio de Janeiro', 500),
	       ('São Paulo', 10),
	       ('São Paulo', 100),
		   ('São Paulo', 10),
	       ('Brasilia', 60);
           
-- Fornecedor
INSERT INTO supplier (socialName, CNPJ, contact) VALUES
	   ('Almeida e filhos', 12345678912345, '21985474'),
	   ('Eletrônicos Silva', 23456789123456, '21985484'),
	   ('Eletrônicos Valma', 34567891234567, '21975474');
  
-- Inserindo vendedores
INSERT INTO seller (socialName, CNPJ, CPF, location, contact)
	VALUES('EletroShop', 12121212121212, null, 'São Paulo', 119212121212),
		  ('Loja Oliveira', 222222222222, null, 'Rio Grande do Sul', 144545456457),
          ('Botique Daiane', null, 01444444444,'Rio de Janeiro', 219555555555);

INSERT INTO storageLocation (idLproduct, idLstorage, location) 
  VALUES(1,2,'RJ'),
		(2,5,'SP');							

INSERT INTO productSupplier(idPsSupplier, idPsProduct, quantity) 
	VALUES(1,1,500),
		  (1,2,400),
          (2,4,633),
          (3,3,5),
          (2,5,10);
 
 INSERT INTO productSeller(idPseller, idPproduct, prodQuantity)
		VALUES (1,6,80),
			   (2,7,10),
		       (3,5,20);

SELECT * FROM productSeller;
SELECT * FROM storageLocation;
SELECT * FROM seller;

-- Buscando todos os registros da tabela clients
SELECT * FROM clients;
  
-- Buscando o nome de todos os clientes cadastrados 
SELECT fullName FROM clients;

-- Buscando as informações dos clientes que realizaram pedidos.
SELECT * FROM clients c, client_PJ pj, orders o WHERE c.idClient = idOrderClient;

-- Buscar todos os campos da tabela cliente e incluir somente os que tem CNPJ
SELECT
	c.idClient,
    c.fullName,
    c.email,
    c.password,
    c.contact,
    c.Address,
    c.Number,
    c.neighborhood,
    c.city,
    c.zipCode,
    c.state,
    pj.socialName,
	pj.CNPJ
FROM
		clients c
LEFT JOIN
     client_PJ pj ON c.idClient = pj.idClientPJ
WHERE
	CNPJ IS NOT NULL;

-- Buscando clientes que os nomes começam com ( Ca )
SELECT * FROM clients WHERE fullName LIKE 'Ca%';

-- Buscando informações do cliente (idClient, fullName, socialName, CNPJ)
SELECT
	c.idClient,
    c.fullName,
    pj.socialName,
	pj.CNPJ
FROM
	clients c
LEFT JOIN
	client_PJ pj ON c.idClient = pj.idClientPJ
WHERE 
	pj.CNPJ IS NOT NULL;
    
 -- Buscando informações do cliente (idClient, fullName, CPF)
SELECT
    c.idClient,
    c.fullName,
    pf.CPF
FROM
    clients c
INNER JOIN
    client_PF pf ON c.idClient = pf.idClientPF
WHERE
    pf.CPF IS NOT NULL;
 
 -- Buscando a quantidade de clientes cadastrados.
 SELECT count(*) FROM clients;
 
 -- Buscar produto(s) com Status de pagamento confirmado
 SELECT
	p. idProduct,
	p.productName,
    o.orderStatus
 FROM 
	products p
 INNER JOIN
	orders o ON p.idProduct = idOrder
WHERE 
	o.orderStatus = 'Pagamento confirmado';
    
-- -- Buscar produto(s) com Status de pagamento pendente    
SELECT
	p. idProduct,
	p.productName,
    o.orderStatus
 FROM 
	products p
 INNER JOIN
	orders o ON p.idProduct = idOrder
WHERE 
	o.orderStatus = 'Pagamento pendente';    