drop table TeamMemberDays;
Create table TeamMemberDays
(
Sale_Date varchar(100),Store	varchar(200), TeamMember varchar(200)
);

drop table StoreSales;
Create table StoreSales
(Sale_date varchar(100), Wimbledon	int ,Lewisham int);


/*-- Import the files for above table --*/

With tab1 as (
Select sale_Date,store,teamMember,
count(teammember) over(partition by store,sale_Date) StoreDate_T_count,
count(sale_date) over(partition by teammember) Team_member_day_count
from TeamMemberDays t),
tab2 as (
select sale_date, 'Wimbledon' as store,Wimbledon as sales
from storeSales
union
select sale_date,'Lewisham' as store,Lewisham  as sales
from storesales
),
tab3 as (
select tab1.teammember,tab1.store,tab2.sales/tab1.StoreDate_T_count Sales,Team_member_day_count
from tab1  join tab2 on (tab1.sale_date=tab2.sale_date and tab1.store=tab2.store)
),
tab4 as (
select teammember,store,
round(sum(sales)/min(Team_member_day_count)) sales,
rank() over(partition by store order by sum(sales)/min(Team_member_day_count) desc) rnk
from tab3
group by teammember,store
)
select * from tab4;