#!/bin/bash
if [ $# != 1 ] ; then
	echo "usage: $0 database"
exit 1;
fi
export HIVE=/opt/CDH/hive/bin
DATABASE=$1
echo "start backup database:$DATABASE..........."
echo "showing tables.............."
TABLE=`$HIVE/hive -e "use $DATABASE;show tables" 2>/dev/null`
if [ -a hql ] ; then
	echo "remove file hql first"
	rm -rf hql
fi
echo "export HIVE=/opt/CDH/hive/bin" >> hql
echo "\$HIVE/hive<<EOF" >> hql
echo "create database if not exists $DATABASE;use $DATABASE;" >> hql
for T in $TABLE
do
	echo "backup table:$T.........."
	RESULT=`$HIVE/hive -e "use $DATABASE;show create table $T" 2>/dev/null`
	echo "------$T--------" >> hql
	echo $RESULT";" >>hql
done
echo "EOF" >> hql
