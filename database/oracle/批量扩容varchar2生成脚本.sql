--OSD层在数据源表的基础上，对VARCHAR/VARCHAR2类型的字段扩容2倍，把DATE类型修改成VARCHAR2(8)
SELECT
	'alter table ' || a.TABLE_NAME || ' modify ' || a.COLUMN_NAME || ' VARCHAR2(' || a.data_length * 2 || ');' 
FROM
	USER_TAB_COLUMNS a 
WHERE
	a.DATA_TYPE = 'VARCHAR2' 
	AND a.TABLE_NAME = upper( 'ODS_TS32_TACCOUNTBALANCEFLOW' );








