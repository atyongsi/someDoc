--ORA-04021，等待锁定对象时发生超时
--1.定位问题，找到哪条sql引起的锁表
select * from dba_ddl_locks where owner = 'GHDW';
select * from v$session where SID = 637
select * from v$sql where sql_id='41ax27r0cz1nt'

--2.解决问题，如果表上发生了死锁，kill掉进程
select object_name,s.sid,s.serial# 
  from v$locked_object l,dba_objects o ,v$session s
 where l.object_id　=　o.object_id and l.session_id=s.sid;

alter system kill session 'sid,serial#';

--3.如果报错ORA-00031：标记要终止的会话
--数据库级不能杀掉该进程，需要到操作系统级别来处理
select a.spid,b.sid,b.serial#,b.username 
from v$process a,v$session b 
where a.addr=b.paddr and b.status='KILLED';

--获取进程号 spid
select * from dba_ddl_locks where owner = 'GHDW';  查询sid
select b.spid,a.osuser,b.program from v$session a,v$process b
where a.paddr=b.addr and a.sid=33    --33就是上面的sid

--在OS上杀死进程
--1）在unix上，用root身份执行命令：kill -9 spid
--2）在windows（unix也适用）用orakill杀死线程，orakill是oracle提供的一个可执行命令，语法为：orakill sid thread 
-- sid：表示要杀死的进程属于的实例名   thread：是要杀掉的线程号，即第3步查询出的spid。



























