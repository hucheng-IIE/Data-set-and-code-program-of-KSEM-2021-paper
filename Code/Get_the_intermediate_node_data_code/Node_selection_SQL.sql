select  precalculus.A,precalculus.B
from clickstream a,precalculus,clickstream b,clickstream c
where REPLACE(a.A,'_',' ') = REPLACE(precalculus.A,'_',' ') 
and a.B = b.A and b.B = c.A and  REPLACE(c.B,'_',' ') = REPLACE(precalculus.B,'_',' ')
group by precalculus.A,precalculus.B