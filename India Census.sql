show databases;
use project;
show tables;
select * from data_01;
select * from data_02;

#1)	How many rows in Data set -1  (Data_01)
select count(*) from data_01;

#2)	How many rows in Data Set -2 (Data_02)
select count(*) from data_02;

#3)	Only Andhra Pradesh and Assam
select * from data_01 where state in("Andhra Pradesh", "Assam");

#4)	What is Total Population in India
select sum(population) India_population from data_02;

#5)	What is the average population growth in India
select avg(growth)*100 Avg_Growth_Population_In_India from data_01;

#6)	What is the average population growth in State wise 
select state, round(avg(growth)*100,2) Avg_Growth_Population_In_India_State_Wise from data_01 group by(state);

#7)	What is the Sex Ratio according to the State wise
select state,round(avg(sex_ratio),0) Avg_sex_ratio from data_01 group by(state) order by  Avg_sex_ratio desc;

#8)	What is the Literacy according to the State wise
select state, round(avg(literacy),0) avg_literacy_ratio from data_01 group by state order by avg_literacy_ratio desc;

#9)	Which State has literacy average of more than 90%
select state, round(avg(literacy),0) avg_literacy_ratio from data_01 
group by state having (round(avg(literacy),0)>90) order by avg_literacy_ratio desc ;

#10)	Which three state have the average  highest growth ratio
select state, round(avg(growth)*100,2) avg_growth from data_01 group by state order by avg_growth desc limit 3;

#11)	Which three state have the average Lowest growth ratio
select state, round(avg(growth)*100,2) avg_growth from data_01 group by state order by avg_growth limit 3;

#12)	Which three state have the average highest Sex ratio
select state, round(avg(sex_ratio),0) sex_ratio from data_01 group by state order by sex_ratio desc limit 3; 

#13)	Which three state have the average Lowest Sex ratio
select state, round(avg(sex_ratio),0) sex_ratio from data_01 group by state order by sex_ratio  limit 3; 

#Create only for State literacy illiterate
create table topstates(state varchar(255), topstates float);
insert into topstates select state, round(avg(literacy),0) avg_literacy from data_01 group by state order by literacy desc; 
#bottom
#15)	Which three states have the lowest literacy 
select * from topstates order by topstates limit 3;

#top 
#14)	Which three states have the highest literacy 
select * from topstates order by topstates desc limit 3;


select * from (select * from topstates order by topstates asc limit 3) a 
union
select * from ( select * from topstates order by topstates desc limit 3) b;
select * from data_01 where state like "as%"; 




select d1.district, d1.state,d1.sex_ratio, d2.population from data_01 d1 inner join data_02 d2 on d1.district=d2.district;

select d1.district, d1.state,round(d1.sex_ratio/1000,2) avg_sex_ratio, d2.population from data_01 d1 inner join data_02 d2 on d1.district=d2.district;

#16)	What is the number of males and females at the district level of each state
select d3.district, d3.state,round( d3.population/(d3.sex_ratio+1),0) males, round((d3.population*d3.sex_ratio)/(d3.sex_ratio+1),0) females from 
(select d1.district, d1.state,d1.sex_ratio/1000 sex_ratio, d2.population 
from data_01 d1 
inner join data_02 d2 
on d1.district=d2.district) d3;

#17)	What is the number of males and females at the each state
select d4.state, sum(d4.males) total_males ,sum(d4.females) totals_females from 
(select d3.district, d3.state,round( d3.population/(d3.sex_ratio+1),0) males, round((d3.population*d3.sex_ratio)/(d3.sex_ratio+1),0) females from 
(select d1.district, d1.state,d1.sex_ratio/1000 sex_ratio, d2.population 
from data_01 d1 
inner join data_02 d2 
on d1.district=d2.district) d3) d4 group by d4.state;

#total literacy rate 
select d1.district, d1.state,d1.literacy literacy_ratio, d2.population 
from data_01 d1 
inner join data_02 d2 
on d1.district=d2.district;


select d1.district, d1.state,round(d1.literacy/100,2) literacy_ratio, d2.population 
from data_01 d1 
inner join data_02 d2 
on d1.district=d2.district;

#18)	How many people are literate and illiterate at the district level of each state
select d3.district, d3.state, round(d3.literacy_ratio*d3.population) literate_pepole, 
round((1-d3.literacy_ratio)* d3.population) illiterate_people from 
(select d1.district, d1.state,d1.literacy/100 literacy_ratio, d2.population 
from data_01 d1 
inner join data_02 d2 
on d1.district=d2.district) d3;

#19)	How many people are literate and illiterate at the of each state
select d4.state, sum(literate_pepole), sum(illiterate_people) from 
(select d3.district, d3.state, round(d3.literacy_ratio*d3.population) literate_pepole, 
round((1-d3.literacy_ratio)* d3.population) illiterate_people from 
(select d1.district, d1.state,d1.literacy/100 literacy_ratio, d2.population 
from data_01 d1 
inner join data_02 d2 
on d1.district=d2.district) d3) d4 group by d4.state;


#population in previous census 
select d1.district, d1.state, d1.growth growth, d2.population 
from data_01 d1 
inner join data_02 d2 
on d1.district=d2.district;

#20)	What is the population census at district level last and current 
select d3.district, d3.state, round(d3.population/(1+d3.growth),0) previous_census, d3.population current_census_population from 
(select d1.district, d1.state, d1.growth growth, d2.population 
from data_01 d1 
inner join data_02 d2 
on d1.district=d2.district) d3;

#21)	What is the population census at State level last and current 
select d4.state, sum(d4.previous_census) previous_census, sum(d4.current_census_population) current_census_population from 
(select d3.district, d3.state, round(d3.population/(1+d3.growth),0) previous_census, d3.population current_census_population from 
(select d1.district, d1.state, d1.growth growth, d2.population 
from data_01 d1 
inner join data_02 d2 
on d1.district=d2.district) d3) d4 group by d4.state;

#22)	What is the population census at India last and current 
select sum(d5.previous_census) previous_census ,sum(d5.current_census_population) current_census_population from 
(select d4.state, sum(d4.previous_census) previous_census, sum(d4.current_census_population) current_census_population from 
(select d3.district, d3.state, round(d3.population/(1+d3.growth),0) previous_census, d3.population current_census_population from 
(select d1.district, d1.state, d1.growth growth, d2.population 
from data_01 d1 
inner join data_02 d2 
on d1.district=d2.district) d3) d4 group by d4.state) d5;



