-- Criação do Banco de Dados para o cenário de E-Commerce

create database ecommerce;
use ecommerce;

-- Tabela Cliente
create table clients(
	idClient int auto_increment primary key,
    Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    Address varchar(100),
    constraint unique_cpf_client unique(CPF)
);

alter table clients auto_increment=1;

-- desc clients;

-- Tabela Produto
create table product(
	idProduct int auto_increment primary key,
    Pname varchar(30) not null,
    classification_kids bool default false,
    category enum('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') not null,
    evaluation float default 0,
    size varchar(10)
);

alter table product auto_increment=1;

create table payments(
    idPayment int auto_increment primary key,
    idClient int,
    typePayment enum('Boleto', 'Cartão', 'Dois cartões'),
    limitAvailable float,
    constraint fk_payments_client foreign key (idClient) references clients(idClient)
);

alter table payments auto_increment=1;

-- Tabela pedido idOrderClient, orderDescription, sendValue, paymentCash
create table orders(
    idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado','Confirmado','Em Processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    paymentCash bool default false,
    constraint fk_orders_client foreign key (idOrderClient) references clients(idClient)
			on update cascade
);

alter table orders auto_increment=1;

-- desc orders;

-- Tabela estoque
create table productStorage(
    idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);

alter table productStorage auto_increment=1;

-- Tabela fornecedor
create table supplier(
    idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);

alter table supplier auto_increment=1;

-- desc supplier;

-- Tabela vendedor
create table seller(
    idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15),
    CPF char(11),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
);

alter table seller auto_increment=1;

create table productSeller(
    idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);

-- desc productSeller;

create table productOrder(
    idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível','Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_seller foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_product foreign key (idPOorder) references orders(idOrder)
);

create table storageLocation(
   idLproduct int,
   idLstorage int,
   location varchar(255) not null,
   primary key (idLproduct, idLStorage),
   constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
   constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);

create table productSupplier(
    idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key (idPsProduct) references product(idProduct)
);

 -- desc productSupplier;

-- show tables;

-- Inserção de dados

use ecommerce;

show tables;

insert into clients (Fname, Minit, Lname, CPF, Address)
		values('Maria','M','Silva', 12345678901,'rua silva de prata 29, Carangola - Cidade das flores'),
			  ('Matheus','O','Pimentel', 98765432101,'rua almeida 289, Centro - Cidade das flores'),
              ('Ricardo','F','Silva', 12345678902,'avenida almeida 1009, Centro - Cidade das flores'),
              ('Julia','S','Franca', 12345678903,'rua das laranjeiras 861, Centro - Cidade das flores'),
              ('Roberta','G','Assis', 12345678904,'avenida koller 19, Centro - Cidade das flores'),
              ('Isabela','M','Cruz', 12345678905,'rua almeida das flores 28, Centro das flores');

insert into product (Pname, classification_kids, category, evaluation, size) values
                            ('Fone de ouvido', false, 'Eletrônico','4',null),
                            ('Barbie Elsa',true,'Brinquedos','3',null),
                            ('Body Carters',true,'Vestimenta','5',null),
                            ('Microfone Vedo - Youtuber',false,'Eletrônico','4',null),
                            ('Sofá retrátil',false,'Móveis','3','3x57x80'),
                            ('Farinha de arroz',false,'Alimentos','2',null),
                            ('Fire Stick Amazon',false,'Eletrônico','3',null);

select * from clients;
select * from product;

insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values
                            (1,default,'compra via aplicativo',null,1),
                            (2,default,'compra via aplicativo',50,0),
                            (3,'Confirmado',null,null,1),
                            (4,default,'compra via web site',150,0);
 
 select * from orders;
 insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus) values 
                         (1,1,2,null),
                         (2,2,1,null),
                         (3,3,1,null);  
                         
insert into productStorage (storageLocation, quantity) values 
						   ('Rio de Janeiro', 1000),
						   ('Rio de Janeiro', 500),
						   ('São Paulo', 10),
						   ('São Paulo', 100),
						   ('São Paulo', 10),
						   ('Brasilia', 60);  
                           
insert into storageLocation (idLproduct, idLstorage, location) values 
                        (1,2,'RJ'),
                        (2,6,'GO');
                        
insert into supplier (SocialName, CNPJ, contact) values 
					 ('Almeida e filhos', 123456789123456, '21985474'),
					 ('Eletrônicos Silva', 234567891234567, '21985484'),
					 ('Eletrônicos Valma', 345678912345678, '21975474');                      
							
select * from supplier;	

insert into productSupplier (idPsSupplier, idPsProduct, quantity) values 
                        (1,1,500),
                        (1,2,400),
                        (2,4,633),
                        (3,3,5),
                        (2,5,10);
                        
insert into seller (SocialName, AbstName, CNPJ, CPF, location, contact) values
                        ('Tech eletronics', null, 123456789123456, null, 'Rio de Janeiro', 219946287),
                        ('Botique Durgas',null,null,12345678901,'Rio de Janeiro', 219567895),
                        ('Kids world',null,23456789456789,null,'São Paulo', 1133333303);     

select * from seller;

insert  into productSeller (idPseller, idPproduct, prodQuantity) values 
                        (1,6,80),
                        (2,7,10); 
                        
select * from productSeller;   

select count(*) from clients;
select * from clients c, orders o where c.idClient = idOrderClient;

select Fname,Lname, idOrder, orderStatus from clients c, orders o where c.idClient = idOrderClient;
select concat(Fname, '',Lname) as Client, idOrder as Request, orderStatus as status from clients c, orders o where c.idClient = idOrderClient;

insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash) values
                            (2, default,'compra via aplicativo',null,1);
                            
select count(*) from clients c, orders o where c.idClient = idOrderClient;		

select * from clients c, orders o 
            where c.idClient = idOrderClient
            group by idOrder;
            
select * from clients left outer join orders ON idClient = idOrderClient;

select * from clients c inner join orders o ON c.idClient = o.idOrderClient 
                inner join productOrder p on p.idPOorder = o.idOrder;

-- Recuperando quantos pedidos foram realizados pelos clientes.
select c.idClient, Fname, count(*) as Number_of_orders from clients c 
                inner join orders o ON c.idClient = o.idOrderClient
        group by idClient;                                                      

                            