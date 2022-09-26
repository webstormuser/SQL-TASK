/* create the table*/
drop table if exists cars;
create table if not exists cars
(
    id      int,
    model   varchar(50),
    brand   varchar(40),
    color   varchar(30),
    make    int
);
/* Insert th records into table*/
insert into cars values (1, 'Model S', 'Tesla', 'Blue', 2018);
insert into cars values (2, 'EQS', 'Mercedes-Benz', 'Black', 2022);
insert into cars values (3, 'iX', 'BMW', 'Red', 2022);
insert into cars values (4, 'Ioniq 5', 'Hyundai', 'White', 2021);
insert into cars values (5, 'Model S', 'Tesla', 'Silver', 2018);
insert into cars values (6, 'Ioniq 5', 'Hyundai', 'Green', 2021);
/*select records*/
select * from cars
order by model, brand;

/*Method 1 --->Using unique Identifier to remove duplicates in some columns */
/* find first duplicate records in table */
select model,brand ,count(*)
from cars group by model,brand; /* it has 2 records which are duplicate*/
delete from cars 
where id in 
(select max(id) from cars group by model, brand 
having count(*)>1); 
select * from cars; /* duplicate data has been deleted*/

/*METHOD 2 --->using SELF JOIN--->*/

delete from 
cars where id in 
(select c2.id from cars c1 join cars c2 
on c1.model=c2.model and
c1.brand =c2.brand where c1.id<c2.id);
select * from cars;

/* METHOD 3<------using WINDOW FUNCTION ------->*/
select * from cars ;
insert into cars values (5, 'Model S', 'Tesla', 'Silver', 2018);
insert into cars values (6, 'Ioniq 5', 'Hyundai', 'Green', 2021);

delete from cars where id 
in (select id from 
        (select * ,row_number() over(partition by model, brand)
        as rn from cars)x
where x.rn>1);

select * from cars ;

insert into cars values (5, 'Model S', 'Tesla', 'Silver', 2018);
insert into cars values (6, 'Ioniq 5', 'Hyundai', 'Green', 2021);


/*METHOD 4<-----using MIN (it works fine if table contain more duplicates)---->*/

delete from cars 
where id not in
(select min(id) from cars group by model,brand);

select * from cars;


/*METHOD 5 <------------------USING BACKUP TABLE ------------->*/
create table cars_backup as select * /* Step1 creater an empty backup table */
from cars where 1=2;
/*Step 2 insert unique records from cars into backup table */
insert into cars_backup 
select * from cars where id in
(select min(id) 
from cars group by model,brand);

/*Step 3 drop the original cars table */
drop table cars;
/*Step 4 rename the backup table to original tablle*/
alter table cars_backup rename to cars;

select * from cars;