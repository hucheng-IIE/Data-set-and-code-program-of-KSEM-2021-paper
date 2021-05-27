----------------------------------------------------------------特征值筛选----------------------------------------------------------
------column2对的特征值抽取RARB----------------------
select	a.A,a.B,isNULL(b.weight,0) as 'weight',isNULL(c.backwardweight,0) as 'backwardweight',(isNULL(b.weight,0)+isNULL(c.backwardweight,0)) as 'SUM',ABS(isNULL(b.weight,0)-isNULL(c.backwardweight,0)) as 'Diff',
isNULL(d.[Sum of all transitionsA],0) as 'Sum of all transitions',(d.[Sum of all transitionsA]/isNULL(d.all_edgesA,1)) as 'Mean of weights',
(isNULL(b.weight,0)/isNULL(d.[Sum of all transitionsA],1)) as 'Normalized weight',
isNULL((c.backwardweight/e.[Sum of all transitionsB]),0) as 'Normalized backward weight',
(isNULL(b.weight,0)-(d.[Sum of all transitionsA]/d.all_edgesA)) as 'Weight greater than mean',
(isNULL(c.backwardweight,0)-isNULL((e.[Sum of all transitionsB]/e.all_edgesB),0)) as 'Backward weight greater than mean'
from
(
select A,B
from[Global Warming]
)a
left join
(
select	a.A,a.B,SUM(a.点击量) as  'weight'
from 
(
--去掉重复概念对,提取A到Bcolumn2的点击次数--------------------
select[Global Warming].A,[Global Warming].B,clickstream.点击量,[Global WarmingA].column2,[Global WarmingB].column2 as 'column'
from[Global Warming],[Global WarmingB],clickstream,[Global WarmingA]
where [Global WarmingB].column1!=[Global WarmingB].column2
and[Global Warming].B = [Global WarmingB].column1 and[Global Warming].A = [Global WarmingA].column1 and [Global WarmingA].column1 != [Global WarmingA].column2 and 
[Global WarmingB].column1!=[Global WarmingB].column2
and  REPLACE(clickstream.A,'_',' ') =REPLACE([Global WarmingA].column2,'_',' ') and REPLACE(clickstream.B,'_',' ') =REPLACE([Global WarmingB].column2,'_',' ')
group by[Global Warming].A,[Global Warming].B,clickstream.点击量,[Global WarmingA].column2,[Global WarmingB].column2
)a
group by a.A,a.B
)b
on a.A = b.A and a.B = b.B
left join
(
select	a.A,a.B,SUM(a.点击量) as  'backwardweight'
from 
(
--去掉重复概念对,提取A到Bcolumn2的点击次数--------------------
select[Global Warming].A,[Global Warming].B,[Global WarmingA].column2,[Global WarmingB].column2 as 'column',clickstream.点击量
from[Global Warming],[Global WarmingB],clickstream,[Global WarmingA]
where [Global WarmingB].column1!=[Global WarmingB].column2
and[Global Warming].B = [Global WarmingB].column2 and[Global Warming].A = [Global WarmingA].column2 and [Global WarmingA].column1 != [Global WarmingA].column2 
and [Global WarmingB].column1!=[Global WarmingB].column2
and  REPLACE(clickstream.B,'_',' ') =[Global WarmingA].column2 and REPLACE(clickstream.A,'_',' ') =REPLACE([Global WarmingB].column2,'_',' ')
group by[Global Warming].A,[Global Warming].B,clickstream.点击量,[Global WarmingA].column2,[Global WarmingB].column2
)a
group by a.A,a.B
)c
on a.A	 = c.A and a.B = c.B
left join
(
select	d.A as 'A',SUM(点击量) as 'Sum of all transitionsA',COUNT(*) as 'all_edgesA'
from 
(
select[Global Warming].A,column2
from[Global Warming],[Global WarmingA]
where [Global WarmingA].column1!=[Global WarmingA].column2
and[Global Warming].A = [Global WarmingA].column1
group by[Global Warming].A,column2
)d,clickstream
where REPLACE(clickstream.A,'_',' ') = REPLACE(d.column2,'_',' ')
group by d.A
)d
on a.A = d.A
left join
(
select	d.B as 'B',SUM(点击量) as 'Sum of all transitionsB',COUNT(*) as 'all_edgesB'
from 
(
select [Global Warming].B,column2
from [Global Warming],[Global WarmingB]
where [Global WarmingB].column1!=[Global WarmingB].column2
and [Global Warming].B = [Global WarmingB].column1
group by [Global Warming].B,column2
)d,clickstream
where REPLACE(clickstream.A,'_',' ') = REPLACE(d.column2,'_',' ')
group by d.B
)e
on a.B = e.B
where b.weight!=0

--Gravitation
