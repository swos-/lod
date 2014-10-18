delimiter $$

drop procedure if exists create_user$$

create procedure create_user(p_name varchar(255), p_password varchar(255), p_email varchar(255), out o_id int)
begin
    insert into users (name, password, email) values (p_name, p_password, p_email);
    set o_id = last_insert_id();
end$$

delimiter ;