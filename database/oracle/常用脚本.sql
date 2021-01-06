--重启oracle实例
（1） 切换需要启动的数据库实例：export ORACLE_SID=C1
（2） 进入Sqlplus控制台，命令：sqlplus /nolog
（3） 以系统管理员登录，命令：connect / as sysdba
（4） 如果是关闭数据库，命令：shutdown abort
（5） 启动数据库，命令：startup
（6） 退出sqlplus控制台，命令：exit

--重启oracle服务和监听
方法1：
用root以ssh登录到linux，打开终端输入以下命令：
cd $ORACLE_HOME #进入到oracle的安装目录 
dbstart #重启服务器 
lsnrctl start #重启监听器 
cd $ORACLE_HOME #进入到oracle的安装目录
dbstart #重启服务器
lsnrctl start #重启监听器

方法2：
cd $ORACLE_HOME/bin #进入到oracle的安装目录 
./dbstart #重启服务器 
./lsnrctl start #重启监听器

方法3：
（1） 以oracle身份登录数据库，命令：su -oracle
（2） 进入Sqlplus控制台，命令：sqlplus /nolog
（3） 以系统管理员登录，命令：connect / as sysdba
（4） 启动数据库，命令：startup
（5） 如果是关闭数据库，命令：shutdown immediate
（6） 退出sqlplus控制台，命令：exit
（7） 进入监听器控制台，命令：lsnrctl
（8） 启动监听器，命令：start
（9） 退出监听器控制台，命令：exit


--批量清空某一类型的表
DECLARE
  CURSOR CUR_TRUNC IS
    SELECT TABLE_NAME FROM USER_TABLES WHERE table_name LIKE 'ODS_AMS_%';
BEGIN
  FOR CUR_DEL IN CUR_TRUNC LOOP
    EXECUTE IMMEDIATE 'truncate table ' || CUR_DEL.TABLE_NAME;
  END LOOP;
END;

--数据泵导入导出数据
1、测试环境数据泵导出命令：
1）、创建DIRECTORY（新环境需要，若之前已经建过文件夹后，此次就不需要再建了，直接使用之前建的即可）
createorreplacedirectory DMP_GHDW as'/opt/DMP_GHDW';
2）、查看DIRECTORY
select * from dba_directories;
3）、为超级管理员赋予操作逻辑目录操作权限（一般不需要设置此步骤，但有时是必须。我们使用超级管理员用户建的，超级管理员已经有该文件夹的操作权限了，所以不需要再赋权了。）
grant read,write on directory DMP_GHDW to sys;
注：以上命令在plsql中执行，在linux环境下执行无效。
4）、执行导出命令（directory=DMPDIR，文件夹使用之前别人建过的，确认确实存在该文件夹即可。）
expdp GHDW/GHDW@172.16.11.17/PDBTEST2  directory=DMPDIR dumpfile=GHDW20201216.dmp logfile=GHDW20201216.log

-- 生成sql脚本,对VARCHAR/VARCHAR2类型的字段扩容2倍
SELECT
	'alter table ' || a.TABLE_NAME || ' modify ' || a.COLUMN_NAME || ' VARCHAR2(' || a.data_length * 2 || ');' 
FROM
	USER_TAB_COLUMNS a 
WHERE
	a.DATA_TYPE = 'VARCHAR2' 
	AND a.TABLE_NAME = upper( 'AA' )
;

-- 生成sql脚本,批量把DATE类型修改成VARCHAR2(8)
SELECT
	'alter table ' || a.TABLE_NAME || ' modify ' || '( ' || a.COLUMN_NAME || ' VARCHAR2(8) );' 
FROM
	USER_TAB_COLUMNS a 
WHERE
	a.DATA_TYPE = 'DATE' 
;

-- 生成sql脚本,批量增加 etl_time 字段
SELECT
	'alter table ' || a.TABLE_NAME || ' add etl_time DATE DEFAULT SYSDATE;' 
FROM
	USER_TAB_COLUMNS a 
GROUP BY
	a.TABLE_NAME
;





