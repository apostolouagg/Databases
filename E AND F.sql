/*TABLES*/

/*cars*/
CREATE TABLE public.cars
(
    car_vin character varying COLLATE pg_catalog."default" NOT NULL,
    category character varying COLLATE pg_catalog."default",
    car_registration_number character varying COLLATE pg_catalog."default",
    manufacturer character varying COLLATE pg_catalog."default",
    model character varying COLLATE pg_catalog."default",
    color character varying COLLATE pg_catalog."default",
    release_year integer,
    current_value character varying COLLATE pg_catalog."default",
    insurance character varying COLLATE pg_catalog."default",
    legal_driver character varying COLLATE pg_catalog."default",
    contract_code character varying COLLATE pg_catalog."default",
    CONSTRAINT cars_pkey PRIMARY KEY (car_vin),
    CONSTRAINT cars_contract_code_fkey FOREIGN KEY (contract_code)
        REFERENCES public.client (contract_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT cars_insurance_fkey FOREIGN KEY (insurance)
        REFERENCES public.incat (idincat) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT cars_legal_driver_fkey FOREIGN KEY (legal_driver)
        REFERENCES public.drivers (drivers_license_number) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL
)

TABLESPACE pg_default;

ALTER TABLE public.cars
    OWNER to postgres;


/*client*/
CREATE TABLE public.client
(
    contract_code character varying COLLATE pg_catalog."default" NOT NULL,
    client_full_name character varying COLLATE pg_catalog."default",
    phone_number character varying COLLATE pg_catalog."default",
    email character varying COLLATE pg_catalog."default",
    CONSTRAINT client_pkey PRIMARY KEY (contract_code)
)

TABLESPACE pg_default;

ALTER TABLE public.client
    OWNER to postgres;


/*drivers*/
CREATE TABLE public.drivers
(
    drivers_license_number character varying COLLATE pg_catalog."default" NOT NULL,
    gender character varying COLLATE pg_catalog."default",
    birthday date,
    address character varying COLLATE pg_catalog."default",
    contract_code character varying COLLATE pg_catalog."default",
    drivers_name character varying COLLATE pg_catalog."default",
    CONSTRAINT drivers_pkey PRIMARY KEY (drivers_license_number),
    CONSTRAINT drivers_address_fkey FOREIGN KEY (address)
        REFERENCES public.drivers_address (idaddress) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT drivers_contract_code_fkey FOREIGN KEY (contract_code)
        REFERENCES public.client (contract_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL
)

TABLESPACE pg_default;

ALTER TABLE public.drivers
    OWNER to postgres;


/*drivers address*/
CREATE TABLE public.drivers_address
(
    idaddress character varying COLLATE pg_catalog."default" NOT NULL,
    street_name character varying COLLATE pg_catalog."default",
    street_number character varying COLLATE pg_catalog."default",
    postal_code integer,
    city character varying COLLATE pg_catalog."default",
    country character varying COLLATE pg_catalog."default",
    CONSTRAINT drivers_address_pkey PRIMARY KEY (idaddress)
)

TABLESPACE pg_default;

ALTER TABLE public.drivers_address
    OWNER to postgres;


/*incat*/
CREATE TABLE public.incat
(
    idincat character varying COLLATE pg_catalog."default" NOT NULL,
    insurance_category character varying COLLATE pg_catalog."default",
    CONSTRAINT incat_pkey PRIMARY KEY (idincat)
)

TABLESPACE pg_default;

ALTER TABLE public.incat
    OWNER to postgres;


/*insurance*/
CREATE TABLE public.insurance
(
    idinsurance character varying COLLATE pg_catalog."default" NOT NULL,
    start_date date,
    end_date date,
    contract_cost character varying COLLATE pg_catalog."default",
    vehicle character varying COLLATE pg_catalog."default",
    ins character varying COLLATE pg_catalog."default",
    contract_code character varying COLLATE pg_catalog."default",
    CONSTRAINT insurance_pkey PRIMARY KEY (idinsurance),
    CONSTRAINT insurance_contract_code_fkey FOREIGN KEY (contract_code)
        REFERENCES public.client (contract_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT insurance_ins_fkey FOREIGN KEY (ins)
        REFERENCES public.incat (idincat) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT insurance_vehicle_fkey FOREIGN KEY (vehicle)
        REFERENCES public.cars (car_vin) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL
)

TABLESPACE pg_default;

ALTER TABLE public.insurance
    OWNER to postgres;

CREATE TRIGGER update_contracts
    AFTER INSERT OR DELETE OR UPDATE 
    ON public.insurance
    FOR EACH ROW
    EXECUTE FUNCTION public.update_contracts();


/*violation participants*/
CREATE TABLE public.violation_participants
(
    idparticipant character varying COLLATE pg_catalog."default" NOT NULL,
    involved_cars character varying COLLATE pg_catalog."default",
    involved_drivers character varying COLLATE pg_catalog."default",
    violation_code character varying COLLATE pg_catalog."default",
    CONSTRAINT violation_participants_pkey PRIMARY KEY (idparticipant),
    CONSTRAINT violation_participants_involved_cars_fkey FOREIGN KEY (involved_cars)
        REFERENCES public.cars (car_vin) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT violation_participants_involved_drivers_fkey FOREIGN KEY (involved_drivers)
        REFERENCES public.drivers (drivers_license_number) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL,
    CONSTRAINT violation_participants_violation_code_fkey FOREIGN KEY (violation_code)
        REFERENCES public.violations (idviolations) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL
)

TABLESPACE pg_default;

ALTER TABLE public.violation_participants
    OWNER to postgres;


/*violations*/
CREATE TABLE public.violations
(
    idviolations character varying COLLATE pg_catalog."default" NOT NULL,
    violation_date_time character varying COLLATE pg_catalog."default",
    violation_description character varying COLLATE pg_catalog."default",
    violation_time time without time zone,
    CONSTRAINT violations_pkey PRIMARY KEY (idviolations)
)

TABLESPACE pg_default;

ALTER TABLE public.violations
    OWNER to postgres;




/*Inserts*/
COPY Drivers_Address (idaddress, street_name, street_number, postal_code, country, city) FROM 'C:\Users\Public\Address.csv' DELIMITER ',' CSV HEADER;
COPY Violations (idviolations, violation_date_time, violation_description, violation_time) FROM 'C:\Users\Public\Violations.csv' DELIMITER ',' CSV HEADER;
COPY Drivers (drivers_license_number, gender, birthday, address, contract_code, drivers_name) FROM 'C:\Users\Public\Drivers.csv' DELIMITER ',' CSV HEADER;
COPY Insurance (idinsurance, start_date, end_date, contract_cost, vehicle, ins, contract_code) FROM 'C:\Users\Public\Insurance.csv' DELIMITER ',' CSV HEADER;
COPY Client (contract_code, client_full_name, phone_number, email) FROM 'C:\Users\Public\Client.csv' DELIMITER ',' CSV HEADER;
COPY Cars (car_vin, category, car_registration_number, manufacturer, model, color, release_year, current_value, insurance, legal_driver, contract_code) FROM 'C:\Users\Public\Cars.csv' DELIMITER ',' CSV HEADER;
COPY Violation_Participants (idparticipant, involved_cars, involved_drivers, violation_code) FROM 'C:\Users\Public\Violation Participants.csv' DELIMITER ',' CSV HEADER;
COPY InCat (idincat, insurance_category) FROM 'C:\Users\Public\InCat.csv' DELIMITER ',' CSV HEADER;



/*A*/
select insurance.contract_code,drivers_name,client_full_name,start_date from drivers inner join client on drivers.contract_code=client.contract_code inner join insurance on drivers.contract_code=insurance.contract_code where extract (month from start_date)=extract (month from current_date) and extract(year from start_date)= extract(year from current_date );
/*B*/
select insurance.contract_code, phone_number,end_date from insurance inner join client on insurance.contract_code=client.contract_code where end_date>date_trunc('month', current_date + interval '1' month);
/*C*/
select count (contract_code), insurance_category, case when extract(year from start_date)=2016 then '2016' when extract(year from start_date)=2017 then '2017' when extract(year from start_date)=2018 then '2018' when extract(year from start_date)=2019 then '2019' when  extract(year from start_date)=2020 then '2020' else 'other' end as start_year from insurance inner join incat on idincat=ins group by insurance_category,start_year order by start_year;
/*D*/
/*1η παραλλαγή*/
select sum (TO_NUMBER(contract_cost,'L9G999g999.99')) as total ,insurance_category from insurance inner join incat on ins=idincat group by insurance_category order by sum (TO_NUMBER(contract_cost,'L9G999g999.99'));

/*2η παραλλαγή*/
select count(contract_code),avg(TO_NUMBER(contract_cost,'L9G999g999.99')) as average_contract_cost,insurance_category, avg(TO_NUMBER(contract_cost,'L9G999g999.99'))*count(contract_code) as total from insurance inner join incat on ins=idincat group by insurance_category;

/*E*/
select CASE
        WHEN EXTRACT(year from current_date)-EXTRACT(year from birthday) <24 then '18-24'
        WHEN  EXTRACT(year from current_date)-EXTRACT(year from birthday) between 25 and 49 then '25-49'
        WHEN  EXTRACT(year from current_date)-EXTRACT(year from birthday) between 50 and 69 then '50-69'
        else '70+'
    End as driver_age,count(*)*100/(select count(*)from violation_participants)
FROM violation_participants inner join drivers on involved_drivers = drivers_license_number group by driver_age;

/*F*/
select CASE
        WHEN abs(release_year-EXTRACT(year from current_date)) <5 then '0-5'
        WHEN abs(release_year-EXTRACT(year from current_date)) between 6 and 10 then '6-10'
        WHEN abs(release_year-EXTRACT(year from current_date)) between 11 and 15 then '11-15'
        WHEN abs(release_year-EXTRACT(year from current_date)) between 16 and 20 then '16-20'
        when abs(release_year-EXTRACT(year from current_date))> 20 then '20+'
    End as car_age ,count(*)*100/(select count(*)from cars)
FROM cars
GROUP BY car_age;




/*trigger*/
create or replace function update_contracts ()
returns trigger as
$BODY$
begin
update insurance set end_date = end_date + interval '1 year' where  end_date = CURRENT_DATE and ins in (select idincat from incat where incat.insurance_category='professional') ;
return new;
end;
$BODY$
language plpgsql;
	
create trigger update_contracts after update or insert or delete on insurance
		for each row
		execute procedure update_contracts();
		
		
update insurance set start_date = start_date
select * from insurance where end_date = current_date 




/*cursor*/
create type nektarios as
(
    driver     varchar,
    startdate    date,
    contract_num varchar,
    signee varchar


);


CREATE OR REPLACE FUNCTION  thenek() RETURNS SETOF nektarios AS $$
DECLARE parakalokyrie CURSOR FOR SELECT insurance.contract_code,drivers_name,client_full_name,start_date
                        FROM drivers INNER JOIN client ON drivers.contract_code=client.contract_code
                        INNER JOIN insurance ON drivers.contract_code=insurance.contract_code
                        where extract (month from start_date) = extract(month from current_date) and extract(year from start_date)= extract(year from current_date );
    rec nektarios;
BEGIN
    open parakalokyrie;
    FETCH parakalokyrie INTO rec.contract_num ,rec.driver,rec.signee,rec.startdate;
    WHILE FOUND LOOP
        return next rec;
        FETCH parakalokyrie INTO rec.contract_num ,rec.driver,rec.signee,rec.startdate;
    end loop;
    close parakalokyrie;
    return ;
end;

$$ LANGUAGE plpgsql;
