----------------------------------------------------------------特征值筛选----------------------------------------------------------
------相似概念对的特征值抽取RA----------------------
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
--提取A的集合及B和点击量
select [precalculus].A,[precalculusA].A as 'A1',相似概念,[precalculus].B,clickstream.点击量
from [precalculus],[precalculusA],clickstream
where [precalculusA].A!=[precalculusA].相似概念
and [precalculus].A = [precalculusA].A
and  REPLACE(clickstream.A,'_',' ') =REPLACE([precalculusA].相似概念,'_',' ') and REPLACE(clickstream.B,'_',' ') =REPLACE([precalculus].B,'_',' ')
group by [precalculus].A,[precalculusA].A,相似概念,[precalculus].B,clickstream.A,clickstream.B,clickstream.result,clickstream.点击量
)a
group by a.A,a.B
)b
on a.A = b.A and a.B = b.B
left join
(
-----B可以点击A的相似概念,增加了backwardweight的值---------------------
select	b.A as 'A',b.B,isNULL(SUM(点击量),0)as 'backwardweight'
from 
(
select [precalculus].A,[precalculusA].A as 'A1',相似概念,[precalculus].B,clickstream.点击量
from [precalculus],[precalculusA],clickstream
where [precalculusA].A!=[precalculusA].相似概念
and [precalculus].A = [precalculusA].A
and  REPLACE(clickstream.B,'_',' ') =REPLACE([precalculusA].相似概念,'_',' ') and REPLACE(clickstream.A,'_',' ') =REPLACE([precalculus].B,'_',' ')
group by [precalculus].A,[precalculusA].A,相似概念,[precalculus].B,clickstream.点击量
)b
group by b.A,b.B
)c
on a.A	 = c.A and a.B = c.B
left join
(
select	d.A as 'A',SUM(点击量) as 'Sum of all transitionsA',COUNT(*) as 'all_edgesA'
from 
(
select [precalculus].A,相似概念
from [precalculus],[precalculusA]
where [precalculusA].A!=[precalculusA].相似概念
and [precalculus].A = [precalculusA].A
group by [precalculus].A,相似概念
)d,clickstream
where REPLACE(clickstream.A,'_',' ') = REPLACE(d.相似概念,'_',' ')
group by d.A
)d
on a.A = d.A
left join
(
select  [precalculus].B,SUM(点击量) as 'Sum of all transitionsB',COUNT(*) as 'all_edgesB'
from [precalculus],clickstream
where REPLACE(clickstream.A,'_',' ') = REPLACE([precalculus].B,'_',' ')
group by [precalculus].B 
)e
on a.B = e.B

where b.weight!=0

--Gravitation
