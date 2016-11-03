set sql_safe_updates=0;
delete from product_cost_history;

insert into product_cost_history (product_id,effective_date_from,item_cost,active_flag)
select id,date(now()),product_cost,'true' from product where name not in ('Hot Dogs','Tornados');
