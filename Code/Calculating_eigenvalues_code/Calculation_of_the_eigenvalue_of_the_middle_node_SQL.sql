----------------------------------------------------------------特征值筛选----------------------------------------------------------
--一个节点筛选
select	a.A,a.B,isNULL(b.weight,0) as 'weight',isNULL(c.backwardweight,0) as 'backwardweight',(isNULL(b.weight,0)+isNULL(c.backwardweight,0)) as 'SUM',ABS(isNULL(b.weight,0)-isNULL(c.backwardweight,0)) as 'Diff',
isNULL(d.[Sum of all transitionsA],0) as 'Sum of all transitions',(d.[Sum of all transitionsA]/isNULL(d.all_edgesA,1)) as 'Mean of weights',
(isNULL(b.weight,0)/isNULL(d.[Sum of all transitionsA],1)) as 'Normalized weight',
isNULL((c.backwardweight/e.[Sum of all transitionsB]),0) as 'Normalized backward weight',
(isNULL(b.weight,0)-(d.[Sum of all transitionsA]/d.all_edgesA)) as 'Weight greater than mean',
(isNULL(c.backwardweight,0)-isNULL((e.[Sum of all transitionsB]/e.all_edgesB),0)) as 'Backward weight greater than mean'
from
(
select A,B
from [Parallel Postulate(一个节点)更新]
)a
left join
(
--再筛选出最小值中的最大值
select distinct a.A1,a.B2,MAX(a.点击量) as 'weight'
from 
(
--首先筛选出A-B,B-C中的最小值
select [Parallel Postulate(一个节点)更新].A as 'A1',a.B as 'B1',b.A as 'A2',[Parallel Postulate(一个节点)更新].B as 'B2',
(
SELECT   
   CASE   
      WHEN a.点击量>=b.点击量 THEN b.点击量   
      WHEN a.点击量<b.点击量 THEN a.点击量   
   END
) as '点击量'

from [Parallel Postulate(一个节点)更新],clickstream a,clickstream b
where REPLACE(a.A,'_',' ') = REPLACE([Parallel Postulate(一个节点)更新].A,'_',' ') and  a.B = b.A   
and REPLACE(b.B,'_',' ') = REPLACE([Parallel Postulate(一个节点)更新].B,'_',' ')
group by  [Parallel Postulate(一个节点)更新].A,a.B,b.A,[Parallel Postulate(一个节点)更新].B,a.点击量,b.点击量
)a
group by a.A1,a.B2
)b
on a.A = b.A1 and a.B = b.B2
left join
(
--再筛选出最小值中的最大值
select distinct a.A1,a.B2,MAX(a.点击量) as 'backwardweight'
from 
(
--首先筛选出A-B,B-C中的最小值
select [Parallel Postulate(一个节点)更新].A as 'A1',a.B as 'B1',b.A as 'A2',[Parallel Postulate(一个节点)更新].B as 'B2',
(
SELECT   
   CASE   
      WHEN a.点击量>=b.点击量 THEN b.点击量   
      WHEN a.点击量<b.点击量 THEN a.点击量   
   END
) as '点击量'

from [Parallel Postulate(一个节点)更新],clickstream a,clickstream b
where REPLACE(a.A,'_',' ') = REPLACE([Parallel Postulate(一个节点)更新].B,'_',' ') and  a.B = b.A   
and REPLACE(b.B,'_',' ') = REPLACE([Parallel Postulate(一个节点)更新].A,'_',' ')
group by  [Parallel Postulate(一个节点)更新].A,a.B,b.A,[Parallel Postulate(一个节点)更新].B,a.点击量,b.点击量
)a
group by a.A1,a.B2
)c
on a.A	 = c.A1 and a.B = c.B2
left join
(
select [Parallel Postulate(一个节点)更新].A,SUM(点击量) as 'Sum of all transitionsA',COUNT(*)  as 'all_edgesA'
from [Parallel Postulate(一个节点)更新],clickstream
where REPLACE(clickstream.A,'_',' ') = REPLACE([Parallel Postulate(一个节点)更新].A,'_',' ')
group by  [Parallel Postulate(一个节点)更新].A
)d
on a.A = d.A
left join
(
select [Parallel Postulate(一个节点)更新].B,SUM(点击量) as 'Sum of all transitionsB',COUNT(*)  as 'all_edgesB'
from [Parallel Postulate(一个节点)更新],clickstream
where REPLACE(clickstream.A,'_',' ') = REPLACE([Parallel Postulate(一个节点)更新].B,'_',' ')
group by  [Parallel Postulate(一个节点)更新].B
)e
on a.B = e.B
where c.backwardweight!=0;
