create database demo;
use demo;

create table CUSTOMERS_INFO (
        user_id INTEGER(6) PRIMARY KEY,
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        dob DATE,
        email VARCHAR(50),
        gender VARCHAR(50),
        club_status VARCHAR(8)
);

insert into CUSTOMERS_INFO (user_id, first_name, last_name, dob, email, gender, club_status) values ('1', 'Rica', 'Blaisdell', '1958-04-23', 'rblaisdell0@rambler.ru', 'Female', 'bronze');
insert into CUSTOMERS_INFO (user_id, first_name, last_name, dob, email, gender, club_status) values ('2', 'Ruthie', 'Brockherst', '1971-07-17', 'rbrockherst1@ow.ly', 'Female', 'platinum');
insert into CUSTOMERS_INFO (user_id, first_name, last_name, dob, email, gender, club_status) values ('3', 'Mariejeanne', 'Cocci', '1961-02-13', 'mcocci2@techcrunch.com', 'Female', 'bronze');
insert into CUSTOMERS_INFO (user_id, first_name, last_name, dob, email, gender, club_status) values ('4', 'Hashim', 'Rumke', '1953-04-08', 'hrumke3@sohu.com', 'Male', 'platinum');
insert into CUSTOMERS_INFO (user_id, first_name, last_name, dob, email, gender, club_status) values ('5', 'Hansiain', 'Coda', '1974-04-14', 'hcoda4@senate.gov', 'Male', 'platinum');
insert into CUSTOMERS_INFO (user_id, first_name, last_name, dob, email, gender, club_status) values ('6', 'Robinet', 'Leheude', '1993-08-02', 'rleheude5@reddit.com', 'Female', 'platinum');
insert into CUSTOMERS_INFO (user_id, first_name, last_name, dob, email, gender, club_status) values ('7', 'Fay', 'Huc', '1953-05-13', 'fhuc6@quantcast.com', 'Female', 'bronze');
insert into CUSTOMERS_INFO (user_id, first_name, last_name, dob, email, gender, club_status) values ('8', 'Patti', 'Rosten', '1984-05-09', 'prosten7@ihg.com', 'Female', 'silver');
insert into CUSTOMERS_INFO (user_id, first_name, last_name, dob, email, gender, club_status) values ('9', 'Even', 'Tinham', '1987-12-20', 'etinham8@facebook.com', 'Male', 'silver');
insert into CUSTOMERS_INFO (user_id, first_name, last_name, dob, email, gender, club_status) values ('10', 'Dan', 'Gingera', '1984-03-30', 'dgingera@confluent.io', 'Male', 'platinum');
insert into CUSTOMERS_INFO (user_id, first_name, last_name, dob, email, gender, club_status) values ('11', 'Farhan', 'Ali', '1977-10-03', 'fali@confluent.io', 'Male', 'silver');
insert into CUSTOMERS_INFO (user_id, first_name, last_name, dob, email, gender, club_status) values ('12', 'Sarwar', 'Bhuiyan', '1982-11-15', 'sarwar@confluent.io', 'Male', 'gold');
insert into CUSTOMERS_INFO (user_id, first_name, last_name, dob, email, gender, club_status) values ('13', 'Sanaz', 'Alizadeh', '1981-05-21', 'saalizad@awesome.com', 'Female', 'platinum');