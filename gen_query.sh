#!/bin/bash

source /usr/local/hawq/greenplum_path.sh
CURDIR=`pwd`
DATASIZE=`grep DATASIZE tpcds.config|awk -F '=' '{print $2}'`

gen_query() {

	dsqgenCom="-distributions $GPHOME/bin/tpcds.idx \
			-dialect hawq -verbose y \
			-input ${CURDIR}/WORK/templates.lst \
			-directory ${CURDIR}/WORK"

	rm -rf ${CURDIR}/WORK/${DATASIZE}
	mkdir -p ${CURDIR}/WORK/${DATASIZE}
	queryPath="${CURDIR}/WORK/${DATASIZE}"

	dsqgenParam="$dsqgenCom -sc ${DATASIZE} \
			-output $queryPath"

	echo "$GPHOME/bin/dsqgen $dsqgenParam"
	if ! $GPHOME/bin/dsqgen $dsqgenParam; then
		echo "generage query scale:${DATASIZE} failed"
		return 1
	fi
	
	for ((i = 1; i < 100; ++i));
	do
		if [[ ${i} -eq 10 ]] || [[ ${i} -eq 11 ]] ||
		   [[ ${i} -eq 13 ]] || [[ ${i} -eq 14 ]] ||
		   [[ ${i} -eq 23 ]] || [[ ${i} -eq 24 ]] ||
		   [[ ${i} -eq 35 ]] || [[ ${i} -eq 44 ]] ||
		   [[ ${i} -eq 47 ]] || [[ ${i} -eq 48 ]] ||
		   [[ ${i} -eq 4  ]] || [[ ${i} -eq 57 ]] ||
		   [[ ${i} -eq 61 ]] || [[ ${i} -eq 64 ]] ||
		   [[ ${i} -eq 68 ]] || [[ ${i} -eq 6  ]] ||
		   [[ ${i} -eq 72 ]] || [[ ${i} -eq 74 ]] ||
		   [[ ${i} -eq 76 ]] || [[ ${i} -eq 78 ]] ||
		   [[ ${i} -eq 81 ]] || [[ ${i} -eq 83 ]] ||
		   [[ ${i} -eq 95 ]] || [[ ${i} -eq 99 ]]; then
			echo "\timing" > ${CURDIR}/WORK/${DATASIZE}/query_${i}.sql
			echo "set optimizer=on;" >> ${CURDIR}/WORK/${DATASIZE}/query_${i}.sql
			echo "set new_executor=auto;" >> ${CURDIR}/WORK/${DATASIZE}/query_${i}.sql
			sed -n "/query${i}.tpl/,/query${i}.tpl/p" ${CURDIR}/WORK/${DATASIZE}/query_0.sql >> ${CURDIR}/WORK/${DATASIZE}/query_${i}.sql
		else
			echo "\timing" > ${CURDIR}/WORK/${DATASIZE}/query_${i}.sql
			echo "set new_executor=auto;" >> ${CURDIR}/WORK/${DATASIZE}/query_${i}.sql
                        sed -n "/query${i}.tpl/,/query${i}.tpl/p" ${CURDIR}/WORK/${DATASIZE}/query_0.sql >> ${CURDIR}/WORK/${DATASIZE}/query_${i}.sql
		fi
	done
	return 0

}

gen_query
