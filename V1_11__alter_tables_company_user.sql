alter table company add email character varying(200),
                              add work_phone hstore,
                              add mobile_phone hstore,
                              add contact_person_details hstore;
							  
update 	users set 	phone = null;					  
							  
ALTER TABLE  users alter COLUMN phone type hstore USING phone::hstore;							  