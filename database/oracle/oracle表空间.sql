--创建表空间，指定数据存放位置
CREATE tablespace MY_TABLESPACE datafile 'C:\software\oracle_data_store\MY_TABLESPACE.dbf' size 100M autoextend on next 10M maxsize unlimited;
--创建用户
CREATE USER wys IDENTIFIED BY admin1000 --用户密码
DEFAULT tablespace MY_TABLESPACE -- 表空间是上面创建的
temporary tablespace TEMP -- 临时表空间默认 TEMP;
--用户授权，普通用户可以不加dba
grant connect,resource,dba to wys;

--查看表空间使用情况
SELECT a.tablespace_name "表空间名称", 
total / (1024 * 1024) "表空间大小(M)", 
free / (1024 * 1024) "表空间剩余大小(M)", 
(total - free) / (1024 * 1024 ) "表空间使用大小(M)", 
total / (1024 * 1024 * 1024) "表空间大小(G)", 
free / (1024 * 1024 * 1024) "表空间剩余大小(G)", 
(total - free) / (1024 * 1024 * 1024) "表空间使用大小(G)", 
round((total - free) / total, 4) * 100 "使用率 %" 
FROM (SELECT tablespace_name, SUM(bytes) free 
FROM dba_free_space 
GROUP BY tablespace_name) a, 
(SELECT tablespace_name, SUM(bytes) total 
FROM dba_data_files 
GROUP BY tablespace_name) b 
WHERE a.tablespace_name = b.tablespace_name

--查看表空间是否自动增长
SELECT FILE_NAME "文件路径",
TABLESPACE_NAME "表空间名字",
AUTOEXTENSIBLE "是否自动增长" FROM dba_data_files;

--设置表空间自动增长
ALTER DATABASE DATAFILE '/表空间路径/表空间文件名称.dbf' AUTOEXTEND ON;//打开自动增长
ALTER DATABASE DATAFILE '/表空间路径/表空间文件名称.dbf' AUTOEXTEND ON NEXT 200M ;//每次自动增长200M
ALTER DATABASE DATAFILE '/表空间路径/表空间文件名称.dbf' AUTOEXTEND ON NEXT 200M MAXSIZE 1024M;//每次自动增长200M，表空间最大不超过1G






















