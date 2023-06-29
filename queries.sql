
use bread_basket_bakery;

# converting the integer DayOfWeek column to text alternative
select transactionNo, items, DayOfWeek,
	case
		when DayOfWeek = 1 then 'Sunday'
        when DayOfWeek = 2 then 'Monday'
        when DayOfWeek = 3 then 'Tuesday'
        when DayOfWeek = 4 then 'Wednesday'
        when DayOfWeek = 5 then 'Thursday'
        when DayOfWeek = 6 then 'Friday'
        when DayOfWeek = 7 then 'Saturday'
        else 'Unclassified'
	end as WeekDay,
    Daytype
from bakery_data;

# extracting the date and time values seperately from the DateTime column
select dateTime,
	SUBSTRING_INDEX(DateTime, ' ', 1) as date,
	SUBSTRING_INDEX(DateTime, ' ', -1) as time
from bakery_data;

# generating the quantity column
select transaction_no, items,
	count(*) as quantity,
    date_purchased, time_purchased, day_part, weekday, day_type
from bakery_data_cleaned
group by transaction_no, items;


-- CREATING A VIEW
create or replace view bakery_data_cleaned as
select transactionNo as transaction_no, 
	items,
    -- count(*) as quantity,
	SUBSTRING_INDEX(DateTime, ' ', 1) as date_purchased,
	SUBSTRING_INDEX(DateTime, ' ', -1) as time_purchased,
    dayPart as day_part,
	case
		when DayOfWeek = 1 then 'Sunday'
        when DayOfWeek = 2 then 'Monday'
        when DayOfWeek = 3 then 'Tuesday'
        when DayOfWeek = 4 then 'Wednesday'
        when DayOfWeek = 5 then 'Thursday'
        when DayOfWeek = 6 then 'Friday'
        when DayOfWeek = 7 then 'Saturday'
        else 'Unclassified'
	end as weekday,
    dayType as day_type
from bakery_data
order by transaction_no, items;

# testing created VIEW 
select *
from bakery_data_cleaned;


-- FINAL QUERIES FOR VISUALIZATION
# total number of transactions
select max(transaction_no)
from bakery_data_cleaned;

# total transactions by day parts
select day_part, count(*) as total_number
from bakery_data_cleaned
group by day_part;

# total transactions by Items
select items, count(*) as total_number
from bakery_data_cleaned
group by items
order by total_number desc;

# total transactions by Weekday
select weekday, count(*) as total_number
from bakery_data_cleaned
group by weekday
order by total_number desc;

# total transactions by quantity
select quantity, count(*) as total_number
from bakery_data_cleaned
group by quantity;

# total number of items bought per transaction 
select transaction_no, 
	count(*) quantity, 
    date_purchased, time_purchased, day_part, weekday, day_type
from bakery_data_cleaned
group by transaction_no;

# average quantity per transaction
select avg(de.quantity) as average_quantity
from (select transaction_no, 
	count(*) quantity, 
    date_purchased, time_purchased, day_part, weekday, day_type
	from bakery_data_cleaned
	group by transaction_no) as de;


-- DATASETS EXTRACTED
# testing created VIEW (DATASET 1)
select *
from bakery_data_cleaned;

# total number of items bought per transaction (DATASET 2)
select transaction_no, 
	count(*) quantity, 
    date_purchased, time_purchased, day_part, weekday, day_type
from bakery_data_cleaned
group by transaction_no;

# weekday with the most transactions (DATASET 3)
select mo.weekday, mo.no_of_transactions
from (select de.weekday, count(*) as no_of_transactions
	from (select transaction_no, 
		count(*) quantity, 
		date_purchased, time_purchased, day_part, weekday, day_type
		from bakery_data_cleaned
		group by transaction_no) as de
	group by de.weekday) as mo
where mo.no_of_transactions = (select max(mo.no_of_transactions)
	from (select de.weekday, count(*) as no_of_transactions
		from (select transaction_no, 
			count(*) quantity, 
			date_purchased, time_purchased, day_part, weekday, day_type
			from bakery_data_cleaned
			group by transaction_no) as de
		group by de.weekday) as mo);

# day period with the most transactions (DATASET 4)
select mo.day_part, mo.no_of_transactions
from (select de.day_part, count(*) as no_of_transactions
	from (select transaction_no, 
		count(*) quantity, 
		date_purchased, time_purchased, day_part, weekday, day_type
		from bakery_data_cleaned
		group by transaction_no) as de
	group by de.day_part) as mo
where mo.no_of_transactions = (select max(mo.no_of_transactions)
	from (select de.day_part, count(*) as no_of_transactions
		from (select transaction_no, 
			count(*) quantity, 
			date_purchased, time_purchased, day_part, weekday, day_type
			from bakery_data_cleaned
			group by transaction_no) as de
		group by de.day_part) as mo);

