
Create table #TopMarks ( ID int, S1 INT,S2 INT, S3 INT)
INSERT INTO #TopMarks Values (1,100,200,300), (2,100,20,30), (3,200,200,300)

Select * from #TopMarks

Select ID,(S1+S2+S3) as [Top],
RANK() over ( order by S1+S2+S3 desc)
from #TopMarks


Name.  month.  Revenue (col name)
Adi.       Jab.        1000
Adi.        Feb.        2000
Jack.     Mar.        3000


They want an answer in below format

Name.  Jab_rev.   Feb_rev.   Mar_rev