-- OSD层在数据源表的基础上,数据类型更改,增加ETL字段

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

SELECT
	'alter table ' || a.TABLE_NAME || ' modify ' || '( ' || a.COLUMN_NAME || ' VARCHAR2(8) );' 
FROM
	USER_TAB_COLUMNS a 
WHERE
	a.COLUMN_NAME like '%DATE%'
;


-- 生成sql脚本,批量增加 etl_time 字段
SELECT
	'alter table ' || a.TABLE_NAME || ' add etl_time DATE DEFAULT SYSDATE;' 
FROM
	USER_TAB_COLUMNS a 
GROUP BY
	a.TABLE_NAME
;



