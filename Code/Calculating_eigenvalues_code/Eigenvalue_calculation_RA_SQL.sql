----------------------------------------------------------------特征值筛选----------------------------------------------------------
------column2对的特征值抽取AB----------------------
select	a.A,a.B,isNULL(b.weight,0) as 'weight',isNULL(c.backwardweight,0) as 'backwardweight',(isNULL(b.weight,0)+isNULL(c.backwardweight,0)) as 'SUM',ABS(isNULL(b.weight,0)-isNULL(c.backwardweight,0)) as 'Diff',
isNULL(d.[Sum of all transitionsA],0) as 'Sum of all transitions',(d.[Sum of all transitionsA]/isNULL(d.all_edgesA,1)) as 'Mean of weights',
(isNULL(b.weight,0)/isNULL(d.[Sum of all transitionsA],1)) as 'Normalized weight',
isNULL((c.backwardweight/e.[Sum of all transitionsB]),0) as 'Normalized backward weight',
(isNULL(b.weight,0)-(d.[Sum of all transitionsA]/d.all_edgesA)) as 'Weight greater than mean',
(isNULL(c.backwardweight,0)-isNULL((e.[Sum of all transitionsB]/e.all_edgesB),0)) as 'Backward weight greater than mean'
from
(
select A,B
from [Global Warming]
)a
left join
(
select [Global Warming].A,[Global Warming].B,SUM(点击量) as 'weight'
from [Global Warming],clickstream
where REPLACE(clickstream.A,'_',' ') = REPLACE([Global Warming].A,'_',' ') and REPLACE(clickstream.B,'_',' ') = REPLACE([Global Warming].B,'_',' ')
group by  [Global Warming].A,[Global Warming].B
)b
on a.A = b.A and a.B = b.B
left join
(
select [Global Warming].A,[Global Warming].B,SUM(点击量) as 'backwardweight'
from [Global Warming],clickstream
where REPLACE(clickstream.B,'_',' ') = REPLACE([Global Warming].A,'_',' ') and REPLACE(clickstream.A,'_',' ') = REPLACE([Global Warming].B,'_',' ')
group by  [Global Warming].A,[Global Warming].B
)c
on a.A	 = c.A and a.B = c.B
left join
(
select [Global Warming].A,SUM(点击量) as 'Sum of all transitionsA',COUNT(*)  as 'all_edgesA'
from [Global Warming],clickstream
where REPLACE(clickstream.A,'_',' ') = REPLACE([Global Warming].A,'_',' ')
group by  [Global Warming].A
)d
on a.A = d.A
left join
(
select [Global Warming].B,SUM(点击量) as 'Sum of all transitionsB',COUNT(*)  as 'all_edgesB'
from [Global Warming],clickstream
where REPLACE(clickstream.A,'_',' ') = REPLACE([Global Warming].B,'_',' ')
group by  [Global Warming].B
)e
on a.B = e.B
where b.weight!=0;
