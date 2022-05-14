0-----------------TODAY-----------BD------365

select
	birth_date, 
	current_bd,
	today,
	case 
		when current_bd - today > 0 then current_bd - today
		else 365 + (current_bd - today)
	end
from
(select 
	birth_date,
	current_date as today,
	make_date(date_part('year', current_date)::int, date_part('month', birth_date)::int, date_part('day', birth_date)::int) as current_bd
from employees) as date_table;