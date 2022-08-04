create database demo;
use demo;

create table USERS_INFO (
        id VARCHAR(6) PRIMARY KEY,
        first_name VARCHAR(50),
        last_name VARCHAR(50),
        dob DATE,
        email VARCHAR(50),
        gender VARCHAR(50),
        trading_status VARCHAR(8)
);

insert into USERS_INFO (id, first_name, last_name, dob, email, gender, trading_status) values ('User_1', 'Rica', 'Blaisdell', '1958-04-23', 'rblaisdell0@rambler.ru', 'Female', 'bronze');
insert into USERS_INFO (id, first_name, last_name, dob, email, gender, trading_status) values ('User_2', 'Ruthie', 'Brockherst', '1971-07-17', 'rbrockherst1@ow.ly', 'Female', 'platinum');
insert into USERS_INFO (id, first_name, last_name, dob, email, gender, trading_status) values ('User_3', 'Mariejeanne', 'Cocci', '1961-02-13', 'mcocci2@techcrunch.com', 'Female', 'bronze');
insert into USERS_INFO (id, first_name, last_name, dob, email, gender, trading_status) values ('User_4', 'Hashim', 'Rumke', '1953-04-08', 'hrumke3@sohu.com', 'Male', 'platinum');
insert into USERS_INFO (id, first_name, last_name, dob, email, gender, trading_status) values ('User_5', 'Hansiain', 'Coda', '1974-04-14', 'hcoda4@senate.gov', 'Male', 'platinum');
insert into USERS_INFO (id, first_name, last_name, dob, email, gender, trading_status) values ('User_6', 'Robinet', 'Leheude', '1993-08-02', 'rleheude5@reddit.com', 'Female', 'platinum');
insert into USERS_INFO (id, first_name, last_name, dob, email, gender, trading_status) values ('User_7', 'Fay', 'Huc', '1953-05-13', 'fhuc6@quantcast.com', 'Female', 'bronze');
insert into USERS_INFO (id, first_name, last_name, dob, email, gender, trading_status) values ('User_8', 'Patti', 'Rosten', '1984-05-09', 'prosten7@ihg.com', 'Female', 'silver');
insert into USERS_INFO (id, first_name, last_name, dob, email, gender, trading_status) values ('User_9', 'Even', 'Tinham', '1987-12-20', 'etinham8@facebook.com', 'Male', 'silver');

select * from USERS_INFO; 