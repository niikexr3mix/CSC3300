create database DVDRental;

use DVDRental;

show tables;

CREATE TABLE Member (
  MemberNumber varchar(8),
  Name varchar(20) not null,
  Address varchar(20) not null,
  Date varchar(8),
  PRIMARY KEY (MemberNumber)
);

CREATE TABLE Staff (
  StaffNumber varchar(8),
  Name varchar(20),
  Position varchar(20),
  Salary varchar(6),
  PRIMARY KEY (StaffNumber)
);

CREATE TABLE Branch (
  BranchNumber varchar(8),
  PhoneNumber varchar(10),
  Address varchar(8),
  PRIMARY KEY (BranchNumber)
);

CREATE TABLE Registration (
  RegNo varchar(8),
  MemberNumber varchar(8),
  Date varchar(8),
  PRIMARY KEY (RegNo)
);

CREATE TABLE Adress (
  Street varchar(15),
  City varchar(15),
  State varchar(15),
  ZipCode varchar(5)
);

CREATE TABLE Name (
  First varchar(10),
  Last varchar(10)
);

CREATE TABLE DVD (
  CatelogNumber varchar(10),
  Status varchar(1),
  Cost varchar(2),
  Title varchar(15),
  Category varchar(8),
  DailyRental varchar(15),
  Details varchar(15),
  PRIMARY KEY (CatelogNumber)
);

CREATE TABLE Category (
  Drama varchar(15),
  Adult varchar(15),
  Action varchar(15),
  Children varchar(15),
  Horror varchar(15),
  SciFi varchar(15)
);

CREATE TABLE DVDForRent (
  RentalNumber varchar(15),
  MemberName varchar(15),
  MemberNumber varchar(15),
  DVDNumber varchar(15),
  Title varchar(15),
  DailyRental varchar(15),
  OutDate varchar(15),
  ReturnDate varchar(15)
);

