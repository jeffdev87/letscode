-- Drop database se existir pra garantir que o scritp nao falhe
drop database if exists teste_db;

-- Create database
create database teste_db;

-- Conecte ao banco recem criado
\c teste_db;

-- Faca as criacoes e insercoes
create table teste(testcolumn int);