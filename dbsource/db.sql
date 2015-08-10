create table users (
id serial primary key,
email varchar(32) unique not null,
phone varchar(11) unique not null,
nickname varchar(32) not null,
password varchar(32) not null,
birthday varchar(8) default '19700101',
sex varchar(1) default '0',
create_dt varchar(14) not null,
status varchar(1) not null
);
-- TODO add col: photo_url

create table news (
id serial primary key,
user_id integer not null,
title varchar(32) not null,
keywords varchar(32),
content varchar(2048) not null,
create_dt varchar(14) not null,
modify_dt varchar(14) not null,
status varchar(1) not null
);
create table enjoy (
id serial primary key,
news_id integer not null,
user_id integer not null,
status varchar(1) not null
);

create table comments (
id serial primary key,
news_id integer not null,
user_id integer not null,
content varchar(512) not null,
create_dt varchar(14) not null,
status varchar(1) not null
);

create table replys (
id serial primary key,
comment_id integer not null,
user_id integer not null,
content varchar(512) not null,
create_dt varchar(14) not null,
status varchar(1) not null
);

