#!/bin/bash

BASH_PROFILE=`grep BASH_PROFILE tpcds.config|awk -F '=' '{print $2}'`
source ${BASH_PROFILE}
export PGCLIENTENCODING=UTF8

T_DATA_DIR=`grep DIRS tpcds.config| awk -F '=' '{print $2}'`
GPLOAD_HOST=`grep GPLOAD_HOST tpcds.config| awk -F '=' '{print $2}'`

errexit99()
{
        if [ $1 -ne 0 ]
        then
        echo "[ERROR]: EXCEPTION EXIT"
        exit 1
        fi
}

arrhost=(${GPLOAD_HOST//,/ })
for i in ${arrhost[@]}
do
    d_tmp=$i

    arr=(${T_DATA_DIR//,/ })
    for i_t_data_dir in ${arr[@]}
    do

    	ssh $d_tmp "rm -rf ${i_t_data_dir}/tpcds"

    	sleep 3

    done

done
