drop table if exists `users`;

create table users (
	id int(10) unsigned not null auto_increment,
	name varchar(255) not null unique,
	password varchar(255) not null,
	email varchar(255) not null unique,
	primary key(id)
);