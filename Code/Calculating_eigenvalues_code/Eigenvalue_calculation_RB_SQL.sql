----------------------------------------------------------------特征值筛选----------------------------------------------------------
------相似概念对的特征值抽取RB----------------------
select	a.A,a.B,isNULL(b.weight,0) as 'weight',isNULL(c.backwardweight,0) as 'backwardweight',(isNULL(b.weight,0)+isNULL(c.backwardweight,0)) as 'SUM',ABS(isNULL(b.weight,0)-isNULL(c.backwardweight,0)) as 'Diff',
isNULL(d.[Sum of all transitionsA],0) as 'Sum of all transitions',(d.[Sum of all transitionsA]/isNULL(d.all_edgesA,1)) as 'Mean of weights',
(isNULL(b.weight,0)/isNULL(d.[Sum of all transitionsA],1)) as 'Normalized weight',
isNULL((c.backwardweight/e.[Sum of all transitionsB]),0) as 'Normalized backward weight',
(isNULL(b.weight,0)-(d.[Sum of all transitionsA]/d.all_edgesA)) as 'Weight greater than mean',
(isNULL(c.backwardweight,0)-isNULL((e.[Sum of all transitionsB]/e.all_edgesB),0)) as 'Backward weight greater than mean'
from
(
select A,B
from [precalculus]
)a
left join
(
--A和其相似概念对组成一个集合的点击量
select	a.A,a.B,SUM(a.点击量) as  'weight'
from 
(
--去掉重复概念对,提取A到B相似概念的点击次数--------------------
select [precalculus].A,[precalculusB].B as 'B!',相似概念,[precalculus].B,clickstream.点击量
from [precalculus],[precalculusB],clickstream
where [precalculusB].B!=[precalculusB].相似概念
and [precalculus].B = [precalculusB].B
and  REPLACE(clickstream.A,'_',' ') =REPLACE([precalculus].A,'_',' ') and REPLACE(clickstream.B,'_',' ') =REPLACE([precalculusB].相似概念,'_',' ')
group by [precalculus].A,[precalculusB].B,相似概念,[precalculus].B,clickstream.A,clickstream.B,clickstream.点击量
)a
group by a.A,a.B
)b
on a.A = b.A and a.B = b.B
left join
(
select b.A,b.B,SUM(b.点击量) as 'backwardweight'
from 
(
--去掉重复概念对，提取B的相似概念到A的点击次数-------
select [precalculus].A,[precalculusB].B as 'B1',相似概念,[precalculus].B,clickstream.点击量
from [precalculus],[precalculusB],clickstream
where [precalculusB].B!=[precalculusB].相似概念
and [precalculus].B = [precalculusB].B
and  REPLACE(clickstream.B,'_',' ') =REPLACE([precalculus].A,'_',' ') and REPLACE(clickstream.A,'_',' ') =REPLACE([precalculusB].相似概念,'_',' ')
group by [precalculus].A,[precalculusB].B,相似概念,[precalculus].B,clickstream.A,clickstream.B,clickstream.result,clickstream.点击量
)b
group by  b.A,b.B
)c
on a.A	 = c.A and a.B = c.B
left join
(
select  [precalculus].A,SUM(点击量) as 'Sum of all transitionsA',COUNT(*) as 'all_edgesA'
from [precalculus],clickstream
where REPLACE(clickstream.A,'_',' ') = REPLACE([precalculus].A,'_',' ')
group by [precalculus].A 
)d
on a.A = d.A
left join
(
select	d.B as 'B',SUM(点击量) as 'Sum of all transitionsB',COUNT(*) as 'all_edgesB'
from 
(
select [precalculus].A,相似概念,[precalculus].B
from [precalculus],[precalculusB]
where [precalculusB].B!=[precalculusB].相似概念
and [precalculus].B = [precalculusB].B
group by [precalculus].A,相似概念,[precalculus].B
)d,clickstream
where REPLACE(clickstream.A,'_',' ') = REPLACE(d.相似概念,'_',' ')
group by d.B
)e
on a.B = e.B
--存在重复概念对-----------------
where b.weight!=0;
