--! qt:dataset:src
set hive.strict.checks.bucketing=false;

set hive.mapred.mode=nonstrict;


set hive.exec.max.dynamic.partitions.pernode=1000000;
set hive.exec.max.dynamic.partitions=1000000;
set hive.exec.max.created.files=1000000;
set hive.map.aggr=true;

create table smb_bucket_1_n4(key int, value string) CLUSTERED BY (key) SORTED BY (key) INTO 1 BUCKETS STORED AS RCFILE; 
create table smb_bucket_2_n4(key int, value string) CLUSTERED BY (key) SORTED BY (key) INTO 1 BUCKETS STORED AS RCFILE; 
create table smb_bucket_3_n4(key int, value string) CLUSTERED BY (key) SORTED BY (key) INTO 1 BUCKETS STORED AS RCFILE;

load data local inpath '../../data/files/smb_rc1/000000_0' overwrite into table smb_bucket_1_n4;
load data local inpath '../../data/files/smb_rc2/000000_0' overwrite into table smb_bucket_2_n4;
load data local inpath '../../data/files/smb_rc3/000000_0' overwrite into table smb_bucket_3_n4;

explain 
select * from (select a.key from smb_bucket_1_n4 a join smb_bucket_2_n4 b on (a.key = b.key) where a.key = 5) t1 left outer join (select c.key from smb_bucket_2_n4 c join smb_bucket_3_n4 d on (c.key = d.key) where c.key=5) t2 on (t1.key=t2.key) where t2.key=5;

set hive.optimize.bucketmapjoin=true;
set hive.optimize.bucketmapjoin.sortedmerge=true;
set hive.mapred.reduce.tasks.speculative.execution=false;
set hive.auto.convert.join=true;
set hive.auto.convert.sortmerge.join=true;
set hive.auto.convert.join.noconditionaltask=true;
set hive.auto.convert.join.noconditionaltask.size=10000000000;
set hive.optimize.reducededuplication.min.reducer=1;
set hive.auto.convert.sortmerge.join.bigtable.selection.policy=org.apache.hadoop.hive.ql.optimizer.LeftmostBigTableSelectorForAutoSMJ;

-- explain
-- select * from smb_bucket_1_n4 a left outer join smb_bucket_2_n4 b on a.key = b.key left outer join src c on a.key=c.value

-- select a.key from smb_bucket_1_n4 a

explain 
select * from (select a.key from smb_bucket_1_n4 a join smb_bucket_2_n4 b on (a.key = b.key) where a.key = 5) t1 left outer join (select c.key from smb_bucket_2_n4 c join smb_bucket_3_n4 d on (c.key = d.key) where c.key=5) t2 on (t1.key=t2.key) where t2.key=5;

select * from (select a.key from smb_bucket_1_n4 a join smb_bucket_2_n4 b on (a.key = b.key) where a.key = 5) t1 left outer join (select c.key from smb_bucket_2_n4 c join smb_bucket_3_n4 d on (c.key = d.key) where c.key=5) t2 on (t1.key=t2.key) where t2.key=5;

