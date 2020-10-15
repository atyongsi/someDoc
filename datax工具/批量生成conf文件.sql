SELECT
    TABLE_NAME,
'
 {
  "job": {
    "setting": {
        "speed": {
          "byte":1048576,
          "channel": 3
        },
        "errorLimit": {
           "record": 0,
           "percentage": 0.02
        }
    },
    "content": [{
      "reader": {
          "name": "oraclereader",
          "parameter": {
            "username": "${o32_user}",
            "password": "${o32_pswd}",
            "connection": [{
              "querySql": [
                "SELECT ' || rtrim(xmlagg(xmlparse(content a.COL_NAME_TEMP||',' wellformed) ORDER BY COLUMN_ID).getclobval(),',') ||' FROM ' || a.TABLE_NAME || '"
              ],
              "jdbcUrl": [
                "${o32_url}"
              ]
            }]
          }
        },
      "writer": {
          "name": "oraclewriter",
          "parameter": {
              "column": [
                  "'|| rtrim(xmlagg(xmlparse(content a.COLUMN_NAME||'","' wellformed) ORDER BY COLUMN_ID).getclobval(),'","') ||'"
              ],
              "password":"${ghdw_pswd}",
              "username":"${ghdw_user}",
               "connection":[{
                      "jdbcUrl":"${ghdw_url}",
                      "table":[
                          "ODS_TS32_'||a.TABLE_NAME||'"
                      ]
                }]
            }

        }
    }]
  }
}
'
FROM
    (
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    COLUMN_ID,
CASE
    WHEN DATA_TYPE = 'DATE' THEN
    'TO_CHAR(' || COLUMN_NAME || ',' || '''YYYYMMDD''' || ')' ELSE COLUMN_NAME 
    END AS COL_NAME_TEMP 
FROM
    USER_TAB_COLS 
WHERE
    TABLE_NAME IN ( 'TSTOCKBUSINESS','TENTRUSTS' )) a 
GROUP BY
    TABLE_NAME