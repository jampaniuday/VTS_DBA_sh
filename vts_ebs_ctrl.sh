#!/usr/bin/bash
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = #
# Script to allow some or all of the R12.2 eBusiness Services to be
# started, shutdown, or aborted.
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = #

export DBA=/export/vtssupp/VTS

if [ -f $DBA/bin/vts_utils.sh ]; then
.   $DBA/bin/vts_utils.sh
else
  echo "$DBA/bin/vts_utils.sh is missing"
  exit 1
fi


function FN_APPS_CTRL
{
  l_cmd=""

  l_srv=${1:?"Missing the host server name"}
  l_action=${2:?"Missing the action to be performed"}

  ## milbyr 20150204 ##l_script_home="/${L_APPLUSER}/inst/apps/${L_ORACLESID}_${l_srv}/admin/scripts"
  ##l_script_home="\${ADMIN_SCRIPTS_HOME}"
  case $l_action in
    ABORT )
      l_cmd="kill -kill -1"
      ;;
    STOP | stop )
      l_cmd="echo \$WLPWD | \$ADMIN_SCRIPTS_HOME/adstpall.sh apps/\$APPSPWD"
      ;;
    START | start )
      l_cmd="echo \$WLPWD | \$ADMIN_SCRIPTS_HOME/adstrtal.sh apps/\$APPSPWD "

      ;;
    *)
      FN_Error "FN_APPS_CTRL: Error: $l_srv $l_action"
      ;;
    esac

   if [ ! "$l_cmd" == "" ]; then
     FN_Print "FN_rexec ${L_APPLUSER}@${l_srv} ${l_cmd}"
     FN_rexec ${L_APPLUSER} ${l_srv} ". ./.bash_profile; ${l_cmd}"
   fi
}


function FN_WEB_CTRL
{
 echo "FN_WEB_CTRL"
 for SRV in $(echo $L_IASSRV | sed -e "s/,/ /g" )
 do
   echo FN_APPS_CTRL $SRV $L_ACTION
   FN_APPS_CTRL $SRV $L_ACTION
 done
}


function FN_CP_CTRL
{
 echo "FN_CP_CTRL"
 for SRV in $(echo $L_CPSRV | sed -e "s/,/ /g" )
 do
   FN_Debug FN_APPS_CTRL $SRV $L_ACTION
   FN_APPS_CTRL $SRV $L_ACTION
 done
}

function FN_EBS_CTRL
{
  FN_Print "FN_EBS_CTRL"
  FN_CP_CTRL  &
  FN_WEB_CTRL &
  FN_Print "Waiting for the services to finish"
  wait
}


function FN_DB_CTRL
{
  l_cmd=""

  FN_Print "FN_DB_CTRL"

  case $L_ACTION in
    ABORT | abort )
      l_cmd=". ./.bash_profile;lsnrctl stop ${L_ORACLESID}; lsnrctl stop ${L_ORACLESID}_\$(hostname); set -x;sqlplus -s \/nolog \@${DBA}/sql/dbstop.sql ABORT ; kill -kill -1"
      ;;
    STOP | stop )
      l_cmd=". ./.bash_profile;lsnrctl stop ${L_ORACLESID}; lsnrctl stop ${L_ORACLESID}_\$(hostname); set -x;sqlplus -s \/nolog \@${DBA}/sql/dbstop.sql IMMEDIATE "
      ;;
    START | start )
      l_cmd=". ./.bash_profile;lsnrctl start ${L_ORACLESID}; lsnrctl start ${L_ORACLESID}_\$(hostname); set -x;sqlplus -s \/nolog \@${DBA}/sql/dbstart.sql "
      ;;
    *)
      FN_Error "FN_DB_CTRL: Error: $l_srv $l_action"
      ;;
    esac

#   if [ ! -z $l_cmd ]; then
     FN_Print "FN_rexec ${L_ORAUSER}@${L_DBSRV} ${l_cmd}"
     FN_rexec "${L_ORAUSER}@${L_DBSRV} ${l_cmd}"
#     FN_rexec ${L_ORAUSER} ${{L_DBSRV} "${l_cmd}"
#   fi


} ### end of FN_DB_CTRL ###


function FN_Main
{
  FN_Init_Vars $L_T_SID
  FN_List_Vars

  case $L_SERVICES in
  ALL )
      FN_Print "ok $L_SERVICES"
      if [ ${L_ACTION} = "START" ] || [ ${L_ACTION} = "start" ]; then
        FN_DB_CTRL
        FN_EBS_CTRL
      else
        FN_EBS_CTRL
        FN_DB_CTRL
      fi
      ;;
  APPS )
      FN_Print "ok $L_SERVICES"
      FN_EBS_CTRL
      ;;
  CP )
      FN_Print "ok $L_SERVICES"
      FN_CP_CTRL
      ;;
  WEB )
      FN_Print "ok $L_SERVICES"
      FN_WEB_CTRL
      ;;
  DB )
      FN_Print "ok $L_SERVICES"
      FN_DB_CTRL
      ;;
  * )
    FN_Error "FN_Main: This is an error"
      ;;
  esac
}

# - - - - - - - - - - - -  Main - - - - - - - - - #
  export L_T_SID=${1:?"Missing the target sid"}
  export L_ACTION=${2:-"STATUS"}
  export L_SERVICES=${3:-"NONE"}
  export L_ABORT=${4:-"DONT"}
  #export L_VERBOSE=1
  export L_VERBOSE=x

  PG=$(basename $0)
  LG=${PG%%.sh}
  TS=`date +%Y%m%d`

  export L_COMPLETE=1
  export L_ERROR=0

  if FN_ValidENV $L_T_SID ; then
    FN_Main $L_T_SID 2>&1 | tee $DBA/logs/${LG}_${L_T_SID}.$TS.log
  else
    FN_Error " the $L_T_SID is invalid"
  fi

## requires something to check the L_ERROR status and notify the appropriate people
# - - - - - - - - - - - - - - - - - - - - - - - - #
