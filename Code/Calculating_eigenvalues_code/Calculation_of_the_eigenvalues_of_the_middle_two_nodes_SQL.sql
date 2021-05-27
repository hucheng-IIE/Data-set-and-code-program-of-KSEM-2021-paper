----------------------------------------------------------------特征值筛选----------------------------------------------------------
--两个节点筛选
select	a.A,a.B,isNULL(b.weight,0) as 'weight',isNULL(c.backwardweight,0) as 'backwardweight',(isNULL(b.weight,0)+isNULL(c.backwardweight,0)) as 'SUM',ABS(isNULL(b.weight,0)-isNULL(c.backwardweight,0)) as 'Diff',
isNULL(d.[Sum of all transitionsA],0) as 'Sum of all transitions',(d.[Sum of all transitionsA]/isNULL(d.all_edgesA,1)) as 'Mean of weights',
(isNULL(b.weight,0)/isNULL(d.[Sum of all transitionsA],1)) as 'Normalized weight',
isNULL((c.backwardweight/e.[Sum of all transitionsB]),0) as 'Normalized backward weight',
(isNULL(b.weight,0)-(d.[Sum of all transitionsA]/d.all_edgesA)) as 'Weight greater than mean',
(isNULL(c.backwardweight,0)-isNULL((e.[Sum of all transitionsB]/e.all_edgesB),0)) as 'Backward weight greater than mean'
from
(
select A,B
from [physics更新(二个节点)]
)a
left join
(
--再筛选出最小值中的最大值
select distinct a.A1,a.B2,MAX(a.点击量) as 'weight'
from 
(
--首先筛选出A1-B,B-C,C--A2中的最小值
--将两节点拆解成一个节点来做
--首先筛选出A-B,B-C中的最小值

select distinct a.A1,a.B1,c.a,c.B,b.A2,b.B2,(
SELECT   
   CASE   
      WHEN a.点击量>=b.点击量 THEN b.点击量   
      WHEN a.点击量<b.点击量 THEN a.点击量   
   END
) as '点击量'
from 
(
select [physics更新(二个节点)].A as 'A1',a.B as 'B1',a.点击量
from [physics更新(二个节点)],clickstream a
where REPLACE(a.A,'_',' ') = REPLACE([physics更新(二个节点)].A,'_',' ') 
group by  [physics更新(二个节点)].A,a.B,a.点击量
)a 
left join
(
select c.A,c.B
from clickstream c
group by c.A,c.B
)c
on a.B1 = c.A
left join
(
select b.B as 'A2',[physics更新(二个节点)].B as 'B2',b.点击量
from [physics更新(二个节点)],clickstream b
where REPLACE(b.B,'_',' ') = REPLACE([physics更新(二个节点)].B,'_',' ') 
group by b.B,[physics更新(二个节点)].B,b.点击量
)b
on c.B = b.A2
group by a.A1,a.B1,c.a,c.B,b.A2,b.B2,a.点击量,b.点击量
)a
group by a.A1,a.B2
)b
on a.A = b.A1 and a.B = b.B2

left join
(
--再筛选出最小值中的最大值
select distinct a.B2,a.A1,MAX(a.点击量) as 'backwardweight'
from 
(
--首先筛选出A1-B,B-C,C--A2中的最小值
--将两节点拆解成一个节点来做
--首先筛选出A-B,B-C中的最小值

select distinct  a.A1,a.B1,c.a,c.B,b.A2,b.B2,(
SELECT   
   CASE   
      WHEN a.点击量>=b.点击量 THEN b.点击量   
      WHEN a.点击量<b.点击量 THEN a.点击量   
   END
) as '点击量'
from 
(
select [physics更新(二个节点)].B as 'A1',a.B as 'B1',a.点击量
from [physics更新(二个节点)],clickstream a
where REPLACE(a.A,'_',' ') = REPLACE([physics更新(二个节点)].B,'_',' ') 
group by  [physics更新(二个节点)].B,a.B,a.点击量
)a 
left join
(
select c.A,c.B
from clickstream c
group by c.A,c.B
)c
on a.B1 = c.A
left join
(
select b.B as 'A2',[physics更新(二个节点)].A as 'B2',b.点击量
from [physics更新(二个节点)],clickstream b
where REPLACE(b.B,'_',' ') = REPLACE([physics更新(二个节点)].A,'_',' ') 
group by b.B,[physics更新(二个节点)].A,b.点击量
)b
on c.B = b.A2
group by a.A1,a.B1,c.a,c.B,b.A2,b.B2,a.点击量,b.点击量
)a
group by a.A1,a.B2
)c
on a.A = c.B2 and a.B = c.A1

left join
(
select [physics更新(二个节点)].A,SUM(点击量) as 'Sum of all transitionsA',COUNT(*)  as 'all_edgesA'
from [physics更新(二个节点)],clickstream
where REPLACE(clickstream.A,'_',' ') = REPLACE([physics更新(二个节点)].A,'_',' ')
group by  [physics更新(二个节点)].A
)d
on a.A = d.A
left join
(
select [physics更新(二个节点)].B,SUM(点击量) as 'Sum of all transitionsB',COUNT(*)  as 'all_edgesB'
from [physics更新(二个节点)],clickstream
where REPLACE(clickstream.A,'_',' ') = REPLACE([physics更新(二个节点)].B,'_',' ')
group by  [physics更新(二个节点)].B
)e
on a.B = e.B
where b.weight!=0;
