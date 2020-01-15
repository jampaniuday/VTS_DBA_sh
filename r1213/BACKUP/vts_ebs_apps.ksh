#!/usr/bin/ksh
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = #
# 20111216 R.Milby	Modified for R12 and EMSS			#
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = #
# 20120110 milbyr	added step to change answers to suit appsTier, CP or Web.					#
# 20120302 ve-deanm1	added FPATH environment variable								#
# 20120308 milbyr	added SYSADMIN password change to FN_Change_PWD 						#
# 20120427 ve-deanm1    Added Workflow SYSADMIN -> * change             						#
# 20120427 ve-deanm1    Added Alert Manager Mail and Response address   						#
# 20120507 ve-deanm1    Allow Step 11 (Workflow) to run on web tier     						#
# 			as the autoconfig on web overwrites settings							#
# 20120511 milbyr       Change FN_DBLINKS_APPS as per Nr-12016492							# 
# 20120718 milbyr       added / to end of PO_FAX_OUTPUT_DIRECTORY_FOR_CONTROL_FILE and PO_FAX_OUTPUT_DIRECTORY dirs     #
# 20120718 milbyr       added FN_frmcmp_batch (step 25).								#
# 20120718 milbyr       Changes APPLPTMP from 2 to 1.									#
# 20120810 milbyr       Nr-12026683 - from Di 										#
# 20120830 ve-deanm1	Nr-12028770 - updates to clone requested post SUPP (edi) checks done by CP                      #
# 20120830 ve-deanm1	  - db links not being dropped since password for feeders are hard coded.                       #
# 20120830 ve-deanm1	  - two new db link drops added for BODATA, as well as BODATA DB links function                 #
# 20120830 ve-deanm1	  - site profile 'IGI: CIS Gateway Test' not part of current clone - added                      #
# 20120830 ve-deanm1         This was via the profile IGI_CIS2007_GATEWAY_TEST = 'HMRC Test'                            #
# 20120830 ve-deanm1	  - Alter the following site profiles:                                                          #
# 20120830 ve-deanm1	     "XXLCC_PAY_XML_INV_EMAIL_CC_ADD" " angela.rady@leics.gov.uk" "SITE"                        #
# 20120830 ve-deanm1	     "XXLCC_FROM_EMAIL" "angela.rady@leics.gov.uk" "SITE"                                       #
# 20120830 ve-deanm1	     "XXLCC_STATUS_EMAIL" "angela.rady@leics.gov.uk" "SITE"                                     #
# 20120830 ve-deanm1	     "XXLCC_PAY_XML_INV_EMAIL_CC_ADD" "angela.rady@leics.gov.uk" "SITE"                         #
# 20120830 ve-deanm1	  - Alter Workflowmailer Override address to Angela.Rady from Adrian.BArnes                     #
# 20120830 ve-deanm1	     1365: set parameter_value = 'Angela.Rady@leics.gov.uk'					#
# 20120903 milbyr	Added FN_File_Tidy function									#
# 20120925 milbyr	Added context variable to change oacore_nprocs from 20 to 2					#
# 20121002 ve-deanm1	Nr-12030373 - Altered FN_frmcmp_batch function to grant execute perms on frmcmp_batch.sh        #
# 20121024 ve-deanm1	Apps Stop and Start to resolve weird failure to start on v06emzs123 (Step 28)                   #
# 20121126 ve-deanm1	Nr-12037045 - Clear two sftp config tables.                                                     #
# 20130124 ve-deanm1	Nr-13002145 - Additional entry to xxlcc.xxlcc_lob_source_ftp table (DPDPLOB)                    #
# 20130130 ve-deanm1	Nr-13001994 - Removed function FN_Code_LCAPBCS01_cmd on request as no longer required           #
# 20130130 ve-deanm1	Nr-13001994 - Removed function FN_Code_LCAPBCS01_prog on request as no longer required          #
# 20130219 ve-deanm1	Nr-13004714 - Additional entry to xxlcc.xxlcc_lob_source_ftp table (FRAMEWORKI)                 #
# 20130219 milbyr	Nr-13006084 - additional NCC custom tops.							#
# 20130325 milbyr	Change IBY_HTTP_PROXY site profile to null.							#
# 20130328 ve-deanm1	Change IBY_HTTP_PROXY site profile to "null", rather than ""                                    #
# 20130405 ve-deanm1	Added NCC Post Clone Steps (single function, not normalised or pretty)                          #
# 20130508 ve-deanm1	Added additionally requested NCC post clone steps (Nr-13012036)                                 #
# 20130508 ve-deanm1	   - related to IBY.IBY_SYS_PMT_PROFILES_B altering all output to printed and                   #
# 20130508 ve-deanm1	       positive pay updates to instance specific directories                                    #
# 20130510 ve-deanm1	Altered function FN_frmcmp_batch to comment out TWO_TASK being set to PRD3 in clones            #
# 20130510 ve-deanm1	Nr-13013057 - New post clone steps                                                              #
# 20130510 ve-deanm1	   - IBY_REMIT_ADVICE_SETUP:NCH_IBY_PAY_EFT_BACS_UK: REMIT_ADVICE_DELIVERY_METHOD='PRINTED'     #
# 20130510 ve-deanm1	   - IBY_REMIT_ADVICE_SETUP:NCC_IBY_PAY_EFT_BACS_UK: REMIT_ADVICE_DELIVERY_METHOD='PRINTED'     #
# 20130510 ve-deanm1	   - IBY_REMIT_ADVICE_SETUP:BRI_IBY_PAY_EFT_BACS_UK: REMIT_ADVICE_DELIVERY_METHOD='PRINTED'     #
# 20130510 ve-deanm1	   - Update IBY.IBY_SYS_PMT_PROFILES_B IBY_PAY_EFT_BACS_UK_10001 new outbound payment dir       #
# 20130510 ve-deanm1	   - SITE level update to FND_OBIEE_URL to http://v10emzs134.ncl.emss.gov.uk:9704               #
# 20130725 milbyr	Nr-13020447 - change XML Publisher temp dir.							# 
# 20131104 ve-deanm1	INC0391470 - Added db link drops as requested (YT)                                              #
# 20131104 ve-deanm1       - FN_DBLINKS_SKY_USER:DROP DATABASE LINK SKYL_<SID>_LPNT_DBLNK.LEICS.GOV.UK                  #
# 20131104 ve-deanm1       - FN_DBLINKS_BODATA:DROP DATABASE LINK EBUS_LPNT_2_DBLNK.LEICS.GOV.UK                        #
# 20131104 ve-deanm1       - FN_DBLINKS_CTS_USER:DROP DATABASE LINK CTS_<SID>_LPNT_DBLINK.LEICS.GOV.UK                  #
# 20131118 ve-deanm1    INC0402750 - Update to entry in xxlcc.xxlcc_lob_source_ftp table (TALIS) - new passwd           #
# 20131230 milbyr1	Changed step 15 to run on both CP tier and WEB tier						#
#			Added the FN_EBS_Profile_Delete function                                                        # 
# 20140212 milbyr	INC0561634 - added 7 insert commands for xxlcc.xxlcc_lob_source_ftp 				#
# 20140307 milbyr	INC0571352 - added insert command for xxlcc.xxlcc_lob_source_ftp 				#
# 20131118 ve-deanm1    INC0612359 - altered setting of IBY_TRANSMIT_VALUES to /applxxxx/csf/outbound/AR_BACS_OUT       #
# 20140814 milbyr	INC0612359 - modified FN_Code_LCARDDI05_prog and FN_Code_LCARDDI06_prog                         #
# 20141105 ve-deanm1    Removed adcfgclone question for "Username for the Applications File System Owner" in 1213       #
# 20141107 ve-stirling  INC0686104 - Added value for ICX: Oracle Payment Server                                         #
# 20141110 ve-deanm1    INC0687877 - remove tcp.validnode_checking / tcp.invited_nodes from APPS_FND listener 1213      #
# 20141110 ve-deanm1    INC0723000 -  manual clear-down of ICX session tables in EBS.                                   #
# 20150727 stirlingg    Removed answer fn_apps_ans "${L_APPLUSER}" after newcastle solaris upgrade
# = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = #
#
export FPATH=/export/ops/ebssupp/velos/fun
#
export DBA=/export/ops/ebssupp/velos

if [ -f $DBA/bin/vit_utils.ksh ]; then
.   $DBA/bin/vit_utils.ksh
else
  echo "$DBA/bin/vit_utils.ksh is missing"
  exit 1
fi


function FN_Inc
{
  export L_STEP=`expr $L_STEP \+ 1`
} 


function FN_APPS_Env
{
  case $1 in
    appsora | APPSORA )
      if [ -f  /${L_APPLUSER}/apps/apps_st/appl/APPS${L_ORACLESID}_$(hostname).env ]; then
        . /${L_APPLUSER}/apps/apps_st/appl/APPS${L_ORACLESID}_$(hostname).env
      else
        export PATH=/${L_APPLUSER}/apps/tech_st/10.1.3/bin:/usr/ccs/bin:/usr/bin
      fi
      ;;
    noappsora | NOAPPSORA )
      echo "not executing appsora.env  "
      export PATH=/${L_APPLUSER}/apps/tech_st/10.1.3/bin:/usr/ccs/bin:/usr/bin
      ;;
    *)
      echo "FN_APPS_Env: This is an error"
      ;;
  esac

  ##   echo "- - - - - - - - - - - - - - - - - - - -"
  ##   env
  ##   which perl
  ##   which unzip
  ##   echo "- - - - - - - - - - - - - - - - - - - -"
}   ### End of FN_APPS_Env ###


function FN_IS_CP_TIER {
  if [ $(hostname) = "${L_CPSRV}" ]; then
    L_RES=0
  else
    L_RES=1
  fi
  exit $L_RES
}


function FN_startmgr 
{
  case $1 in
    move_out )
      mv /${L_APPLUSER}/apps/apps_st/appl/fnd/12.0.0/bin/startmgr.sh /${L_APPLUSER}/apps/apps_st/appl/fnd/12.0.0/bin/startmgr.sh.clone
      touch /${L_APPLUSER}/apps/apps_st/appl/fnd/12.0.0/bin/startmgr.sh
      ;;
    move_in )
      mv /${L_APPLUSER}/apps/apps_st/appl/fnd/12.0.0/bin/startmgr.sh.clone /${L_APPLUSER}/apps/apps_st/appl/fnd/12.0.0/bin/startmgr.sh
    ;;
    *)  FN_Error "FN_startmgr: ERROR"
    ;;
    esac
    
}  ### end of FN_startmgr ###

function FN_AppsTier
{

        function fn_apps_ans
         {
           print -u9 "$*"
           sleep 5
         } ### end of fn_apps_ans ###
      
        function fn_apps_response_WEB
         {
        
          ##                      Copyright (c) 2002 Oracle Corporation
          ##                         Redwood Shores, California, USA
       
          ##                         Oracle Applications Rapid Clone
       
          ##                                  Version 12.0.0
       
          ##                       adcfgclone Version 120.20.12000000.12
       
          ## Enter the APPS password :
               fn_apps_ans "$(FN_GetAPPSPassword ${L_T_SID})"
       
          ## Running:
          ## /appldev4/apps/apps_st/comn/clone/bin/../jre/bin/java -Xmx600M -cp /appldev4/apps/apps_st/comn/clone/jlib/java:/appldev4/apps/apps_st/comn/clone/jlib/xmlparserv2.jar:/appldev4/apps/apps_st/comn/clone/jlib/ojdbc14.jar oracle.apps.ad.context.CloneContext -e /appldev4/apps/apps_st/comn/clone/bin/../context/apps/CTXORIG.xml -validate -pairsfile /tmp/adpairsfile_596.lst -stage /appldev4/apps/apps_st/comn/clone  2> /tmp/adcfgclone_596.err; echo $? > /tmp/adcfgclone_596.res
       
          ## Log file located at /appldev4/apps/apps_st/comn/clone/bin/CloneContext_1020150413.log
       
          ## Provide the values required for creation of the new APPL_TOP Context file.
       
          ## Target System Hostname (virtual or normal) [v06ss101] : v06ss101
            fn_apps_ans "${L_IASSRV}"
       
          ## Target System Database SID : DEV4
            fn_apps_ans "${L_ORACLESID}"
       
          ## Target System Database Server Node [v06ss101] : v06ss102
            fn_apps_ans "$L_DBSRV"
       
          ## Target System Database Domain Name [edi.emss.gov.uk] : edi.emss.data.net
            fn_apps_ans "$(FN_GetDBDomain)"
       
          ## Target System Base Directory : /appldev4
            fn_apps_ans "/${L_APPLUSER}"
       
          ## Target System Tools ORACLE_HOME Directory [/appldev4/apps/tech_st/10.1.2] : /appldev4/apps/tech_st/10.1.2
            fn_apps_ans "/${L_APPLUSER}/apps/tech_st/10.1.2"
       
          ## Target System Web ORACLE_HOME Directory [/appldev4/apps/tech_st/10.1.3] : /appldev4/apps/tech_st/10.1.3
            fn_apps_ans "/${L_APPLUSER}/apps/tech_st/10.1.3"
       
          ## Target System APPL_TOP Directory [/appldev4/apps/apps_st/appl] : /appldev4/apps/apps_st/appl
            fn_apps_ans "/${L_APPLUSER}/apps/apps_st/appl"
       
          ## Target System COMMON_TOP Directory [/appldev4/apps/apps_st/comn] : /appldev4/apps/apps_st/comn
            fn_apps_ans "/${L_APPLUSER}/apps/apps_st/comn"
       
          ## Target System Instance Home Directory [/appldev4/inst] : /appldev4/inst
            fn_apps_ans "/${L_APPLUSER}/inst"

          ## This question has been removed in 12.1.3 (removed as part of the upgrade 1206-1213)`
          ## Username for the Applications File System Owner [appldev4] : appldev4
            ##fn_apps_ans "${L_APPLUSER}"
       
          ## Target System Root Service [enabled] :
            fn_apps_ans "enabled"
       
          ## Target System Web Entry Point Services [enabled] :
            fn_apps_ans "enabled"
       
          ## Target System Web Application Services [enabled] : enabled
            fn_apps_ans "enabled"
       
          ## Target System Batch Processing Services [enabled] : disabled
            fn_apps_ans "disabled"
       
          ## Target System Other Services [enabled] : disabled
            fn_apps_ans "disabled"
       
          ## Do you want to preserve the Display [v06ss101:1] (y/n) ? : n
            fn_apps_ans "n"
       
          ## Target System Display [v06ss101:0.0] : v06ss101:1.0
            fn_apps_ans "${L_IASSRV}:1.0"
       
    ## preserve port details
            fn_apps_ans "n"

          ## Target System Port Pool [0-99] : 4
            fn_apps_ans "$L_PORT"
       
          ## Checking the port pool 4
          ## done: Port Pool 4 is free
          ## Report file located at /appldev4/inst/apps/DEV4_v06ss101/admin/out/portpool.lst
          ## Complete port information available at /appldev4/inst/apps/DEV4_v06ss101/admin/out/portpool.lst
       
          ## UTL_FILE_DIR on database tier consists of the following directories.
       
          ## 1. /usr/tmp
          ## 2. /appldev4/conc/temp
          ## 3. /appldev4/conc/out
          ## 4. /appldev4/conc/log
          ## 5. /oradev4/db/tech_st/10.2.0/appsutil/outbound/DEV4_v06ss102
          ## 6. /usr/tmp
       
          ## Choose a value which will be set as APPLPTMP value on the target node [1] : 2
            fn_apps_ans "1"
       
          ## Backing up /appldev4/inst/apps/DEV4_v06ss101/appl/admin/DEV4_v06ss101.xml to /appldev4/inst/apps/DEV4_v06ss101/appl/admin/DEV4_v06ss101.xml.bak
       
          ## Do you want to reset custom variable settings(y/n) [n] : n
            fn_apps_ans "y"

          ## Value for c_xxntcty[/appld016/apps/apps_st/appl/xxntcty/12.0.0] :
            fn_apps_ans "/${L_APPLUSER}/apps/apps_st/custom/xxntcty/12.0.0"

         ## Value for c_xxlcc[/appld016/apps/apps_st/appl/xxlcc/12.0.0] :
           fn_apps_ans "/${L_APPLUSER}/apps/apps_st/custom/xxlcc/12.0.0"

         ## Value for c_xxleics[/appld016/apps/apps_st/appl/xxleics/12.0.0] :
           fn_apps_ans "/${L_APPLUSER}/apps/apps_st/custom/xxleics/12.0.0"


         ## Value for c_xxmig[/appld016/apps/apps_st/appl/xxmig/12.0.0] :
           fn_apps_ans "/${L_APPLUSER}/apps/apps_st/custom/xxmig/12.0.0"

         ## Do you want to startup the Application Services for D016? (y/n) [y] : n
           fn_apps_ans "n"

         } ### end of fn_db_response_WEB ###


        function fn_apps_response_CP
         {
         ##### NOTE:  This assumes that the WEB Tier(s) have already been configured and the password changed. ####
        
          ##                      Copyright (c) 2002 Oracle Corporation
          ##                         Redwood Shores, California, USA
       
          ##                         Oracle Applications Rapid Clone
       
          ##                                  Version 12.0.0
       
          ##                       adcfgclone Version 120.20.12000000.12
       
          ## Enter the APPS password :
               fn_apps_ans "$(FN_GetAPPSPassword ${L_S_SID})"
       
          ## Running:
          ## /appldev4/apps/apps_st/comn/clone/bin/../jre/bin/java -Xmx600M -cp /appldev4/apps/apps_st/comn/clone/jlib/java:/appldev4/apps/apps_st/comn/clone/jlib/xmlparserv2.jar:/appldev4/apps/apps_st/comn/clone/jlib/ojdbc14.jar oracle.apps.ad.context.CloneContext -e /appldev4/apps/apps_st/comn/clone/bin/../context/apps/CTXORIG.xml -validate -pairsfile /tmp/adpairsfile_596.lst -stage /appldev4/apps/apps_st/comn/clone  2> /tmp/adcfgclone_596.err; echo $? > /tmp/adcfgclone_596.res
       
          ## Log file located at /appldev4/apps/apps_st/comn/clone/bin/CloneContext_1020150413.log
       
          ## Provide the values required for creation of the new APPL_TOP Context file.
       
          ## Target System Hostname (virtual or normal) [v06ss101] : v06ss101
            fn_apps_ans "${L_CPSRV}"
       
          ## Target System Database SID : DEV4
            fn_apps_ans "${L_ORACLESID}"
       
          ## Target System Database Server Node [v06ss101] : v06ss102
            fn_apps_ans "$L_DBSRV"
       
          ## Target System Database Domain Name [edi.emss.gov.uk] : edi.emss.data.net
            fn_apps_ans "$(FN_GetDBDomain)"
       
          ## Target System Base Directory : /appldev4
            fn_apps_ans "/${L_APPLUSER}"
       
          ## Target System Tools ORACLE_HOME Directory [/appldev4/apps/tech_st/10.1.2] : /appldev4/apps/tech_st/10.1.2
            fn_apps_ans "/${L_APPLUSER}/apps/tech_st/10.1.2"
       
          ## Target System Web ORACLE_HOME Directory [/appldev4/apps/tech_st/10.1.3] : /appldev4/apps/tech_st/10.1.3
            fn_apps_ans "/${L_APPLUSER}/apps/tech_st/10.1.3"
       
          ## Target System APPL_TOP Directory [/appldev4/apps/apps_st/appl] : /appldev4/apps/apps_st/appl
            fn_apps_ans "/${L_APPLUSER}/apps/apps_st/appl"
       
          ## Target System COMMON_TOP Directory [/appldev4/apps/apps_st/comn] : /appldev4/apps/apps_st/comn
            fn_apps_ans "/${L_APPLUSER}/apps/apps_st/comn"
       
          ## Target System Instance Home Directory [/appldev4/inst] : /appldev4/inst
            fn_apps_ans "/${L_APPLUSER}/inst"
       
          ## This question has been removed in 12.1.3 (removed as part of the upgrade 1206-1213)`
          ## Username for the Applications File System Owner [appldev4] : appldev4
            ##fn_apps_ans "${L_APPLUSER}"
       
          ## Target System Root Service [enabled] :
            fn_apps_ans "enabled"
       
          ## Target System Web Entry Point Services [enabled] :
            fn_apps_ans "disabled"
       
          ## Target System Web Application Services [enabled] : enabled
            fn_apps_ans "disabled"
       
          ## Target System Batch Processing Services [enabled] : enabled
            fn_apps_ans "enabled"
       
          ## Target System Other Services [enabled] : enabled
            fn_apps_ans "disabled"
       
          ## Do you want to preserve the Display [v06ss101:1] (y/n) ? : n
            fn_apps_ans "n"
       
          ## Target System Display [v06ss101:0.0] : v06ss101:1.0
            fn_apps_ans "${L_CPSRV}:1.0"
       
        ## preserve port details
            fn_apps_ans "n"

          ## Target System Port Pool [0-99] : 4
            fn_apps_ans "$L_PORT"
       
          ## Checking the port pool 4
          ## done: Port Pool 4 is free
          ## Report file located at /appldev4/inst/apps/DEV4_v06ss101/admin/out/portpool.lst
          ## Complete port information available at /appldev4/inst/apps/DEV4_v06ss101/admin/out/portpool.lst
       
          ## UTL_FILE_DIR on database tier consists of the following directories.
       
          ## 1. /usr/tmp
          ## 2. /appldev4/conc/temp
          ## 3. /appldev4/conc/out
          ## 4. /appldev4/conc/log
          ## 5. /oradev4/db/tech_st/10.2.0/appsutil/outbound/DEV4_v06ss102
          ## 6. /usr/tmp
       
          ## Choose a value which will be set as APPLPTMP value on the target node [1] : 2
            fn_apps_ans "1"
       
          ## Backing up /appldev4/inst/apps/DEV4_v06ss101/appl/admin/DEV4_v06ss101.xml to /appldev4/inst/apps/DEV4_v06ss101/appl/admin/DEV4_v06ss101.xml.bak
       
          ## Do you want to reset custom variable settings(y/n) [n] : n
            fn_apps_ans "y"

          ## Value for c_xxntcty[/appld016/apps/apps_st/appl/xxntcty/12.0.0] :
            fn_apps_ans "/${L_APPLUSER}/apps/apps_st/custom/xxntcty/12.0.0"

         ## Value for c_xxlcc[/appld016/apps/apps_st/appl/xxlcc/12.0.0] :
           fn_apps_ans "/${L_APPLUSER}/apps/apps_st/custom/xxlcc/12.0.0"

         ## Value for c_xxleics[/appld016/apps/apps_st/appl/xxleics/12.0.0] :
           fn_apps_ans "/${L_APPLUSER}/apps/apps_st/custom/xxleics/12.0.0"


         ## Value for c_xxmig[/appld016/apps/apps_st/appl/xxmig/12.0.0] :
           fn_apps_ans "/${L_APPLUSER}/apps/apps_st/custom/xxmig/12.0.0"

         ## Do you want to startup the Application Services for D016? (y/n) [y] : n
           fn_apps_ans "n"

         } ### end of fn_db_response_CP ###

  FN_Debug "adcfgclone.pl appsTier"

 
( cd /appl${L_LCORACLESID}/apps/apps_st/comn/clone/bin; /usr/bin/perl adcfgclone.pl appsTier ) |&

   sleep 5

   exec 8<&p 
   exec 9>&p
  
  if [ $(hostname) = "${L_CPSRV}" ]; then
   fn_apps_response_CP &
   l_response_pid=$!
  else
   fn_apps_response_WEB &
   l_response_pid=$!
  fi 

  # it is compulsary to utilise the 8 stream 
  while read -u8 ME_TXT
  do
     FN_Print "8: $ME_TXT"
  done

  kill -9 $l_response_pid
}


function FN_tns_ifile
{
  echo "ifile=/export/ops/emss/GLOBAL/tnsnames_LCC.ora" > ${TNS_ADMIN}/${CONTEXT_NAME}_ifile.ora
}



function FN_Conc_Requests
{

  PROFILE_DATE=`date +%d-%m-%y`

export TWO_TASK=$L_ORACLESID

  sqlplus -s /nolog <<EOF
    connect apps/$(FN_GetAPPSPassword $L_ORACLESID)
    -- connect apps/$APPSPWD

    whenever sqlerror exit FAILURE
    prompt Removing the completed concurrent requests...
    delete from fnd_concurrent_requests
    where phase_code = 'C';

    prompt Removing the running concurrent requests...
    delete from fnd_concurrent_requests
    where phase_code = 'R';

    prompt All remaining concurrent requests on hold...
    update fnd_concurrent_requests
    set hold_flag = 'Y'
    where phase_code = 'P';

-- to be changed milbyr 20120111     prompt Change inventory managers concurrent requests from hold...
-- to be changed milbyr 20120111     prompt Cost Manager                         33733
-- to be changed milbyr 20120111     prompt Manager:Lot Move Transactions        1007492
-- to be changed milbyr 20120111     prompt Process transaction interface        32320
-- to be changed milbyr 20120111     prompt WIP Move Transaction Manager         31915
-- to be changed milbyr 20120111     prompt Workflow Background Process 		36888 
-- to be changed milbyr 20120111 
-- to be changed milbyr 20120111     update fnd_concurrent_requests
-- to be changed milbyr 20120111     set hold_flag = 'N'
-- to be changed milbyr 20120111     where hold_flag = 'Y'
-- to be changed milbyr 20120111       and concurrent_program_id in ( 31915, 33733, 1007492, 32320, 36888);

    prompt commit
    commit;

    prompt concurrent request status
    select phase_code, status_code, hold_flag, count(*)
    from fnd_concurrent_requests
    group by phase_code, status_code, hold_flag;

EOF
}


function FN_EBS_Profile_Delete
{
  L_PN=${1:?"Missing profile name"}
  L_PL=${2:?"Missing profile level"}

  sqlplus -s /nolog <<EOF
    connect apps/$(FN_GetAPPSPassword $L_T_SID)
    set echo on verify on feedback on serveroutput on
--    whenever sqlerror exit FAILURE
    prompt Updating site profile values ...

  DECLARE
    bSuccess BOOLEAN;

   BEGIN
     bSuccess := fnd_profile.delete( '${L_PN}', '${L_PL}' );
     IF (bSuccess = TRUE) THEN
       dbms_output.put_line( '    SUCCESS : Profile option $L_PN  has been deleted.' );
     ELSE
       dbms_output.put_line( '    FAILED : $L_PN has NOT been deleted - please check manually.' );
     END IF;
  END;
  /
EOF
}   ### End of FN_EBS_Profile_Delete ###


function FN_EBS_Profile_Update
{
  L_PN=${1:?"Missing profile name"}
  L_PV=${2:?"Missing profile value"}
  L_PL=${3:?"Missing profile level"}

  L_PROFILE_DATE=`date +%d-%m-%y`

  sqlplus -s /nolog <<EOF
    connect apps/$(FN_GetAPPSPassword $L_T_SID)
    set echo on verify on feedback on serveroutput on
--    whenever sqlerror exit FAILURE
    prompt Updating site profile values ...

  DECLARE
   lblnSuccess BOOLEAN;

   PROCEDURE set_profile_opt( p_option IN VARCHAR2 , p_value  IN VARCHAR2 , p_level  IN VARCHAR2 ) IS
      lblnSuccess BOOLEAN;
    BEGIN
      lblnSuccess := fnd_profile.save( p_option, p_value, p_level );
      IF (lblnsuccess = TRUE) THEN
        dbms_output.put_line( '    SUCCESS : Profile option ' || p_option || ' set to ' || p_value || ' (' || p_level || ')' );
      ELSE
        dbms_output.put_line( '    FAILED : '|| p_option || ' with value ' || p_value || ' - please check manually' );
      END IF;
    END set_profile_opt;

  BEGIN
   set_profile_opt( '${L_PN}', '${L_PV}', '${L_PL}' );
  END;
  /
EOF
}   ### End of FN_EBS_Profile_Update ###


function FN_EBS_Branding {
  L_PROFILE_DATE=`date +%d-%m-%y`
  cd $OA_MEDIA
  L_B_DIR=${DBA}/../EMSS/EMSS_CLONING
  L_GIF_FN=FNDSSCORP_EMSS_${L_T_SID}_transparent.gif
  L_GIF=${L_B_DIR}/GIFS/${L_GIF_FN}
  if [ -f ${L_GIF} ]; then
    cp  ${L_GIF} $OA_MEDIA
    cp  ${L_GIF} $OA_MEDIA/FNDSSCORP.gif
  else
   echo "FN_EBS_Branding: gif file ${L_GIF} does not exist"
  fi
  # update the FND_CORPORATE_BRANDING_IMAGE profile            
  FN_EBS_Profile_Update "FND_CORPORATE_BRANDING_IMAGE" "/OA_MEDIA/${L_GIF_FN}" "SITE"
  FN_EBS_Profile_Update "SITENAME" "${L_ORACLESID} copied from ${L_S_SID} on ${L_PROFILE_DATE}" "SITE"
}   ### End of FN_EBS_Branding ###


function FN_IGI_CISProxyServer {
  # blank IGI_CIS2007_PROXY_SERVER profile option
  FN_EBS_Profile_Update "IGI_CIS2007_PROXY_SERVER" "null" "SITE"
}   ### End of FN_IGI_CISProxyServer ###


function FN_Profiles_BNE {
  FN_EBS_Profile_Update "BNE_UPLOAD_IMPORT_DIRECTORY" "/${L_APPLUSER}/apps/apps_st/appl/bne/12.0.0/upload/import" "SITE"
  FN_EBS_Profile_Update "BNE_UPLOAD_STAGING_DIRECTORY" "/${L_APPLUSER}/csf/log" "SITE"
  FN_EBS_Profile_Update "BNE_UPLOAD_TEXT_DIRECTORY" "/${L_APPLUSER}/apps/apps_st/appl/bne/12.0.0/upload" "SITE"
  FN_EBS_Profile_Update "BNE_UIX_PHYSICAL_DIRECTORY" "/${L_APPLUSER}/apps/apps_st/comn/webapps/oacore/html/cabo" "SITE"
  FN_EBS_Profile_Update "BNE_SERVER_LOG_PATH" "/${L_APPLUSER}/apps/apps_st/appl/bne/12.0.0/log" "SITE"
}   ### End of FN_Profiles_BNE ###


function FN_Profiles_XXLCC {
  FN_EBS_Profile_Update "XXLCC_GL_LOB_SOURCE_PATH" "/${L_APPLUSER}/apps/apps_st/appl/xxlcc/12.0.0/fisinvac_dev" "SITE"
  FN_EBS_Profile_Update "XXLCC_PAYSLIP_ADVERT_DIR" "/${L_APPLUSER}/apps/apps_st/appl/xxlcc/12.0.0/media/payslips" "SITE"
  FN_EBS_Profile_Update "XXLCC_PAYSLIP_LOGO_DIR" "/${L_APPLUSER}/apps/apps_st/appl/xxlcc/12.0.0/media/payslips" "SITE"
  FN_EBS_Profile_Update "XXLCC_FAX_GATEWAY" "angela.rady@leics.gov.uk" "SITE"
  FN_EBS_Profile_Update "XXLCC_FROM_EMAIL" "angela.rady@leics.gov.uk" "SITE"
  FN_EBS_Profile_Update "XXLCC_STATUS_EMAIL" "angela.rady@leics.gov.uk" "SITE"
  FN_EBS_Profile_Update "LCC_OUT_DIRECTORY" "/${L_APPLUSER}/csf/out" "SITE"
  #
  FN_EBS_Profile_Update "XXLCC_AR_IRS_INV_EMAIL_USER" "ptFj/ziv8vwSMWTLh1UUIA==" "SITE"
  FN_EBS_Profile_Update "XXLCC_AR_IRS_INV_EMAIL_PASSWORD" "d5eMI4x2n9Kw737+KiVADA==" "SITE"
  FN_EBS_Profile_Update "XXLCC_AR_IRS_INV_EMAIL_MAILBOX" "FIS-TEST-ARIRS-IN" "SITE"
  FN_EBS_Profile_Update "XXLCC_PAY_XML_INV_EMAIL_FROM_ADD" "FIS_TEST_AP_INV_OUT@leics.gov.uk" "SITE"
  FN_EBS_Profile_Update "XXLCC_PAY_XML_INV_EMAIL_CC_ADD" "angela.rady@leics.gov.uk" "SITE"
  FN_EBS_Profile_Update "XXLCC_PAY_XML_INV_EMAIL_MAILBOX" "FIS-TEST-AP-INV-IN" "SITE"
  FN_EBS_Profile_Update "XXLCC_PAY_XML_INV_WISDOM_ENDPOINT" "http://lccedrms1/_WisdomSDK/WisdomSDK.asmx" "SITE"
  FN_EBS_Profile_Update "XXLCC_PAY_XML_INV_WISDOM_SERVER_URL" "http://lccedrms1:8087" "SITE"
}   ### End of FN_Profiles_XXLCC ###


function FN_Profiles_Debug {
  FN_EBS_Profile_Update "HZ_API_DEBUG_FILE_PATH" "/${L_ORAUSER}/db/tech_st/10.2.0/appsutil/outbound/${L_ORACLESID}_${L_DBSRV}" "SITE"
  FN_EBS_Profile_Update "JTF_DEBUG_LOG_DIRECTORY" "/${L_ORAUSER}/db/tech_st/10.2.0/appsutil/outbound/${L_ORACLESID}_${L_DBSRV}" "SITE"
  FN_EBS_Profile_Update "PA_DEBUG_LOG_DIRECTORY" "/${L_ORAUSER}/db/tech_st/10.2.0/appsutil/outbound/${L_ORACLESID}_${L_DBSRV}" "SITE"
  FN_EBS_Profile_Update "TAX_DEBUG_FILE_LOCATION" "/${L_ORAUSER}/db/tech_st/10.2.0/appsutil/outbound/${L_ORACLESID}_${L_DBSRV}" "SITE"
  FN_EBS_Profile_Update "GL_DEBUG_LOG_DIRECTORY" "/${L_ORAUSER}/db/tech_st/10.2.0/appsutil/outbound/${L_ORACLESID}_${L_DBSRV}" "SITE"
  FN_EBS_Profile_Update "IBY_DEBUG_LOG_DIRECTORY" "/${L_ORAUSER}/db/tech_st/10.2.0/appsutil/outbound/${L_ORACLESID}_${L_DBSRV}" "SITE"
  FN_EBS_Profile_Update "OKE_DEBUG_FILE_DIR" "/${L_ORAUSER}/db/tech_st/10.2.0/appsutil/outbound/${L_ORACLESID}_${L_DBSRV}" "SITE"
  FN_EBS_Profile_Update "XNC_DEBUG_LOG_DIRECTORY" "/${L_ORAUSER}/db/tech_st/10.2.0/appsutil/outbound/${L_ORACLESID}_${L_DBSRV}" "SITE"

  FN_EBS_Profile_Update "CONC_COPIES" "0" "SITE"
  FN_EBS_Profile_Update "WF_MAIL_WEB_AGENT" "http://${L_IASSRV}.$(FN_GetDBDomain):$(expr 8000 + ${L_PORT})" "SITE"
}   ### End of FN_Profiles_Debug ###


function FN_Profiles_PER {
  FN_EBS_Profile_Update "PER_DATA_EXCHANGE_DIR" "/${L_APPLUSER}/apps/apps_st/custom/xxlcc/12.0.0/hcm_exchange" "SITE"
  ## There is a profile set at responsibility  10003  set to /usr/tmp##

  FN_EBS_Profile_Update "PER_P11D_OUTPUT_FOLDER" "/${L_APPLUSER}/apps/apps_st/custom/xxlcc/12.0.0/hcm_intermediate" "SITE"

  # RESPONSIBILITY: "LCC Employee Self-Service"  and "LCC Manager Self-Service"
  ## FN_EBS_Profile_Update "PER_P11D_OUTPUT_FOLDER" "/${L_APPLUSER}/apps/apps_st/custom/xxlcc/12.0.0/hcm_intermediate" "?10003/51114?"
  ## FN_EBS_Profile_Update "PER_P11D_OUTPUT_FOLDER" "/${L_APPLUSER}/apps/apps_st/custom/xxlcc/12.0.0/hcm_intermediate" "?10003/51115?"
}   ### End of FN_Profiles_PER ###


function FN_Profiles_IGI {
  ## FN_EBS_Profile_Update "IGI_CIS2007_CRL_PATH" "/${L_APPLUSER}/apps/apps_st/appl/xxlcc/12.0.0/certificates/hmrc_gateway_revocation.crl" "SITE"
  ## FN_EBS_Profile_Update "IGI_CIS2007_KEYSTORE_PATH" "/${L_APPLUSER}/apps/apps_st/custom/xxlcc/12.0.0/certificates/hmrc_cis2007_prd_keystore.store" "SITE"
  ##   - - - - - - #
  FN_EBS_Profile_Update "IGI_CIS2007_CRL_PATH" "null" "SITE"
  FN_EBS_Profile_Update "IGI_CIS2007_KEYSTORE_PATH" "null" "SITE"
  FN_EBS_Profile_Update "IGI_CIS2007_XML_SERVER" "null" "SITE"
  FN_EBS_Profile_Update "IGI_CIS2007_KEYSTORE_PWD" "null" "SITE"
  FN_EBS_Profile_Update "IGI_CIS2007_KEY_PWD" "null" "SITE"
  FN_EBS_Profile_Update "IGI_CIS2007_SENDER_PWD" "null" "SITE"
  FN_EBS_Profile_Update "IGI_CIS2007_GATEWAY_TEST" "HMRC Test" "SITE"
}   ### End of FN_Profiles_IGI ###


function FN_Profiles_IBY {
  FN_EBS_Profile_Update "IBY_JAVA_DEBUG_FILE" "/${L_APPLUSER}/csf/log/iby_debug.log" "SITE"
  FN_EBS_Profile_Update "IBY_JAVA_ERROR_FILE" "/${L_APPLUSER}/csf/log/iby_error.log" "SITE"
  ## milbyr 20131231 ##
  FN_EBS_Profile_Delete 'IBY_HTTP_PROXY' 'SITE' 
  ## gstirling INC0686104 20141107 ##
  FN_EBS_Profile_Update "ICX_PAY_SERVER" "http://${L_CPSRV}.$(FN_GetDBDomain):${l_pp}/OA_HTML/ibyecapp" "SITE"
}   ### End of FN_Profiles_IBY ###

#Nr-13013057 -added
function FN_Profiles_OBIEE {
FN_EBS_Profile_Update "FND_OBIEE_URL" "http://v10emzs134.ncl.emss.gov.uk:9704" "SITE"
}   ### End of FN_Profiles_OBIEE ###

function FN_Profiles_NCC {
  l_lc_source=`echo appl${L_S_SID} | tr "[:upper:]" "[:lower:]"`
  l_lc_target=`echo appl${L_T_SID} | tr "[:upper:]" "[:lower:]"`

  sqlplus -s /nolog <<SQLEOF
    connect apps/$(FN_GetAPPSPassword $L_ORACLESID)
    set lines 250 pages 200

update FND_PROFILE_OPTION_VALUES set PROFILE_OPTION_VALUE = 
'/${l_lc_target}/csf/temp' where PROFILE_OPTION_VALUE =
'/${l_lc_source}/csf/temp';

update FND_PROFILE_OPTION_VALUES set PROFILE_OPTION_VALUE = 
'/${l_lc_target}/csf/inbound/ntcty/GL_Interface_Files/Bank_Rec' where PROFILE_OPTION_VALUE =
'/${l_lc_source}/csf/inbound/ntcty/GL_Interface_Files/Bank_Rec';

update FND_PROFILE_OPTION_VALUES set PROFILE_OPTION_VALUE = 
'/${l_lc_target}/csf/inbound/ntcty/GL_Interface_Files/Bank_Rec' where PROFILE_OPTION_VALUE =
'/${l_lc_source}/csf/inbound/ntcty/GL_Interface_Files/Bank_Rec';

update FND_PROFILE_OPTION_VALUES set PROFILE_OPTION_VALUE = 
'/${l_lc_target}/csf/outbound/ntcty/ncc/AP/pospay' where PROFILE_OPTION_VALUE =
'/${l_lc_source}/csf/outbound/ntcty/ncc/AP/pospay';

update FND_PROFILE_OPTION_VALUES set PROFILE_OPTION_VALUE = 
'/${l_lc_target}/csf/outbound/ntcty/nch/AP/NCHpospay' where PROFILE_OPTION_VALUE =
'/${l_lc_source}/csf/outbound/ntcty/nch/AP/NCHpospay';

update FND_PROFILE_OPTION_VALUES set PROFILE_OPTION_VALUE = 
'/${l_lc_target}/csf/outbound/ntcty/ncc/AP/pospay/ARCHIVE' where PROFILE_OPTION_VALUE =
'/${l_lc_source}/csf/outbound/ntcty/ncc/AP/pospay/ARCHIVE';

update FND_PROFILE_OPTION_VALUES set PROFILE_OPTION_VALUE = 
'/${l_lc_target}/csf/outbound/ntcty/nch/AP/NCHpospay/ARCHIVE' where PROFILE_OPTION_VALUE =
'/${l_lc_source}/csf/outbound/ntcty/nch/AP/NCHpospay/ARCHIVE';

update FND_PROFILE_OPTION_VALUES set PROFILE_OPTION_VALUE = 
'' where PROFILE_OPTION_VALUE =
'financialsystems@emss.managed.OTRS.com';

update FND_PROFILE_OPTION_VALUES set PROFILE_OPTION_VALUE = 
'/${l_lc_target}/csf/inbound/ntcty' where PROFILE_OPTION_VALUE =
'/${l_lc_source}/csf/inbound/ntcty';

update FND_PROFILE_OPTION_VALUES set PROFILE_OPTION_VALUE = 
'/${l_lc_target}/csf/inbound/ntcty/Payables_Interface_Files' where PROFILE_OPTION_VALUE =
'/${l_lc_source}/csf/inbound/ntcty/Payables_Interface_Files';

update FND_PROFILE_OPTION_VALUES set PROFILE_OPTION_VALUE = 
'/${l_lc_target}/csf/inbound/ntcty/rocc' where PROFILE_OPTION_VALUE =
'/${l_lc_source}/csf/inbound/ntcty/rocc';

update FND_PROFILE_OPTION_VALUES set PROFILE_OPTION_VALUE = 
'/${l_lc_target}/csf/inbound/ntcty/Payables_Interface_Files/ARCHIVE' where PROFILE_OPTION_VALUE =
'/${l_lc_source}/csf/inbound/ntcty/Payables_Interface_Files/ARCHIVE';

update FND_PROFILE_OPTION_VALUES set PROFILE_OPTION_VALUE = 
'/${l_lc_target}/csf/inbound' where PROFILE_OPTION_VALUE =
'/${l_lc_source}/csf/inbound';

update FND_PROFILE_OPTION_VALUES set PROFILE_OPTION_VALUE = 
'/${l_lc_target}/csf/inbound/ntcty/GL_Interface_Files/Estates_Rents' where PROFILE_OPTION_VALUE =
'/${l_lc_source}/csf/inbound/ntcty/GL_Interface_Files/Estates_Rents';

update FND_PROFILE_OPTION_VALUES set PROFILE_OPTION_VALUE = 
'/${l_lc_target}/csf/inbound/ntcty/GL_Interface_Files/RADIUS_Ledger' where PROFILE_OPTION_VALUE =
'/${l_lc_source}/csf/inbound/ntcty/GL_Interface_Files/RADIUS_Ledger';

update FND_PROFILE_OPTION_VALUES set PROFILE_OPTION_VALUE = 
'/${l_lc_target}/csf/inbound/ntcty/GL_Interface_Files/PCard' where PROFILE_OPTION_VALUE =
'/${l_lc_source}/csf/inbound/ntcty/GL_Interface_Files/PCard';

update FND_PROFILE_OPTION_VALUES set PROFILE_OPTION_VALUE = 
'/${l_lc_target}/csf/inbound/ntcty/GL_Interface_Files/Supporting_People' where PROFILE_OPTION_VALUE =
'/${l_lc_source}/csf/inbound/ntcty/GL_Interface_Files/Supporting_People';

update FND_PROFILE_OPTION_VALUES set PROFILE_OPTION_VALUE = 
'/${l_lc_target}/csf/out' where PROFILE_OPTION_VALUE =
'/${l_lc_source}/csf/out';

update FND_PROFILE_OPTION_VALUES set PROFILE_OPTION_VALUE = 
'/${l_lc_target}/csf/inbound/ntcty/Payables_Interface_Files/ARCHIVE' where PROFILE_OPTION_VALUE =
'/${l_lc_source}/csf/inbound/ntcty/Payables_Interface_Files/ARCHIVE';

update FND_PROFILE_OPTION_VALUES set PROFILE_OPTION_VALUE = 
'/${l_lc_target}/csf/inbound/ntcty/GL_Interface_Files/HB_Debtors' where PROFILE_OPTION_VALUE =
'/${l_lc_source}/csf/inbound/ntcty/GL_Interface_Files/HB_Debtors';

update FND_PROFILE_OPTION_VALUES set PROFILE_OPTION_VALUE = 
'/${l_lc_target}/csf/inbound/ntcty/Fairer_Charging_Invoices' where PROFILE_OPTION_VALUE =
'/${l_lc_source}/csf/inbound/ntcty/Fairer_Charging_Invoices';

update FND_PROFILE_OPTION_VALUES set PROFILE_OPTION_VALUE = 
'/${l_lc_target}/csf/log' where PROFILE_OPTION_VALUE =
'/${l_lc_source}/csf/log';

update  fnd_lookup_values
set MEANING =  replace(meaning,'${l_lc_source}','${l_lc_target}'), LAST_UPDATE_DATE = sysdate
where LOOKUP_TYPE = 'XXLCC_BACS_TRANS_DST_PATH';

update  fnd_lookup_values
set MEANING =  replace(meaning,'${l_lc_source}','${l_lc_target}'), LAST_UPDATE_DATE = sysdate
where LOOKUP_TYPE = 'XXLCC_BACS_TRANS_SRC_PATH';

--update  fnd_lookup_values
--set MEANING =  '', LAST_UPDATE_DATE = sysdate
--where LOOKUP_TYPE = 'XXLCC_BACS_TRANS_FTP_FILENAME';

update  fnd_lookup_values
set DESCRIPTION =  '', LAST_UPDATE_DATE = sysdate
where LOOKUP_TYPE = 'XXNTCTY_AR_INV_EMAIL_DETAILS'
and LOOKUP_CODE= 'FROM_ADDRESS';

update  fnd_lookup_values
set DESCRIPTION =  replace(meaning,'${l_lc_source}','${l_lc_target}'), LAST_UPDATE_DATE = sysdate
where LOOKUP_TYPE = 'XXNTCTY_HR_I06_OUTPUT_FILEPATH';

col SYSTEM_PROFILE_CODE for a40
col OUTBOUND_PMT_FILE_DIRECTORY for a60
col POSITIVE_PAY_FILE_DIRECTORY for a60
select SYSTEM_PROFILE_CODE, OUTBOUND_PMT_FILE_DIRECTORY, POSITIVE_PAY_FILE_DIRECTORY, PROCESSING_TYPE, MARK_COMPLETE_EVENT
from IBY.IBY_SYS_PMT_PROFILES_B
where SYSTEM_PROFILE_CODE in (
'NCC_IBY_PAY_EFT_BACS_UK',
'NCH_IBY_PAY_EFT_BACS_UK',
'BRI_IBY_PAY_EFT_BACS_UK',
'NCC_IBY_PAY_CHK',
'NCH_IBY_PAY_CHK',
'IBY_PAY_EFT_BACS_UK_10002');

update IBY.IBY_SYS_PMT_PROFILES_B
set OUTBOUND_PMT_FILE_DIRECTORY = '/${l_lc_target}/csf/outbound/ntcty/bri/BACS_OUT',
    PROCESSING_TYPE             = 'PRINTED',
    MARK_COMPLETE_EVENT         = 'PRINTED'
where SYSTEM_PROFILE_CODE = 'BRI_IBY_PAY_EFT_BACS_UK';

update IBY.IBY_SYS_PMT_PROFILES_B
set OUTBOUND_PMT_FILE_DIRECTORY = '/${l_lc_target}/csf/outbound/leprb/BACS_OUT',
    PROCESSING_TYPE             = 'PRINTED',
    MARK_COMPLETE_EVENT         = 'PRINTED'
where SYSTEM_PROFILE_CODE = 'IBY_PAY_EFT_BACS_UK_10002';

update IBY.IBY_SYS_PMT_PROFILES_B
set OUTBOUND_PMT_FILE_DIRECTORY = '/${l_lc_target}/csf/outbound/ntcty/ncc/AP/cheques',
    POSITIVE_PAY_FILE_DIRECTORY = '/${l_lc_target}/csf/outbound/ntcty/ncc/AP/pospay'
where SYSTEM_PROFILE_CODE = 'NCC_IBY_PAY_CHK';

update IBY.IBY_SYS_PMT_PROFILES_B
set OUTBOUND_PMT_FILE_DIRECTORY = '/${l_lc_target}/csf/outbound/ntcty/ncc/BACS_OUT',
    PROCESSING_TYPE             = 'PRINTED',
    MARK_COMPLETE_EVENT         = 'PRINTED'
where SYSTEM_PROFILE_CODE = 'NCC_IBY_PAY_EFT_BACS_UK';

update IBY.IBY_SYS_PMT_PROFILES_B
set OUTBOUND_PMT_FILE_DIRECTORY = '/${l_lc_target}/csf/outbound/ntcty/nch/AP/NCHcheques',
    POSITIVE_PAY_FILE_DIRECTORY = '/${l_lc_target}/csf/outbound/ntcty/nch/AP/NCHpospay'
where SYSTEM_PROFILE_CODE = 'NCH_IBY_PAY_CHK';

update IBY.IBY_SYS_PMT_PROFILES_B
set OUTBOUND_PMT_FILE_DIRECTORY = '/${l_lc_target}/csf/outbound/ntcty/nch/BACS_OUT',
    PROCESSING_TYPE             = 'PRINTED',
    MARK_COMPLETE_EVENT         = 'PRINTED'
where SYSTEM_PROFILE_CODE = 'NCH_IBY_PAY_EFT_BACS_UK';

select SYSTEM_PROFILE_CODE, OUTBOUND_PMT_FILE_DIRECTORY, POSITIVE_PAY_FILE_DIRECTORY, PROCESSING_TYPE, MARK_COMPLETE_EVENT
from IBY.IBY_SYS_PMT_PROFILES_B
where SYSTEM_PROFILE_CODE in (
'NCC_IBY_PAY_EFT_BACS_UK',
'NCH_IBY_PAY_EFT_BACS_UK',
'BRI_IBY_PAY_EFT_BACS_UK',
'NCC_IBY_PAY_CHK',
'NCH_IBY_PAY_CHK',
'IBY_PAY_EFT_BACS_UK_10002');


--Nr-13013057
select * from IBY_REMIT_ADVICE_SETUP
where SYSTEM_PROFILE_CODE in
(
'NCH_IBY_PAY_EFT_BACS_UK',
'NCC_IBY_PAY_EFT_BACS_UK',
'BRI_IBY_PAY_EFT_BACS_UK'
);

UPDATE IBY_REMIT_ADVICE_SETUP set REMIT_ADVICE_DELIVERY_METHOD='PRINTED'
WHERE SYSTEM_PROFILE_CODE='NCH_IBY_PAY_EFT_BACS_UK';

UPDATE IBY_REMIT_ADVICE_SETUP set REMIT_ADVICE_DELIVERY_METHOD='PRINTED'
WHERE SYSTEM_PROFILE_CODE='NCC_IBY_PAY_EFT_BACS_UK';

UPDATE IBY_REMIT_ADVICE_SETUP set REMIT_ADVICE_DELIVERY_METHOD='PRINTED'
WHERE SYSTEM_PROFILE_CODE='BRI_IBY_PAY_EFT_BACS_UK';

select * from IBY_REMIT_ADVICE_SETUP
where SYSTEM_PROFILE_CODE in
(
'NCH_IBY_PAY_EFT_BACS_UK',
'NCC_IBY_PAY_EFT_BACS_UK',
'BRI_IBY_PAY_EFT_BACS_UK'
);






commit;
SQLEOF
}   ### End of FN_Profiles_NCC ###


function FN_DBLINKS_APPS
{
  export L_APP_PWD=$(FN_GetAPPSPassword $L_ORACLESID)

  sqlplus -s /nolog <<EOF
    connect apps/${L_APP_PWD}
    --  whenever sqlerror exit FAILURE

    show user;

    prompt DROP DATABASE LINK apps_to_apps.leics.gov.uk;
    DROP DATABASE LINK apps_to_apps.leics.gov.uk;
    
    prompt CREATE DATABASE LINK APPS_TO_APPS.LEICS.GOV.UK
    CREATE DATABASE LINK APPS_TO_APPS.LEICS.GOV.UK
    CONNECT TO APPS
    IDENTIFIED BY ${L_APP_PWD}
    USING '${L_ORACLESID}';
    
    prompt DROP DATABASE LINK edw_apps_to_wh.leics.gov.uk;
    DROP DATABASE LINK edw_apps_to_wh.leics.gov.uk;
    
    prompt CREATE DATABASE LINK EDW_APPS_TO_WH.LEICS.GOV.UK
    CREATE DATABASE LINK EDW_APPS_TO_WH.LEICS.GOV.UK
    CONNECT TO APPS
    IDENTIFIED BY ${L_APP_PWD}
    USING '${L_ORACLESID}';
    
    prompt DROP DATABASE LINK APPS_TO_APPS.US.ORACLE.COM;
    DROP DATABASE LINK APPS_TO_APPS.US.ORACLE.COM;
    
    prompt CREATE DATABASE LINK APPS_TO_APPS.US.ORACLE.COM
    CREATE DATABASE LINK APPS_TO_APPS.US.ORACLE.COM
     CONNECT TO APPS
     IDENTIFIED BY ${L_APP_PWD}
     USING '${L_ORACLESID}';
    
    prompt DROP DATABASE LINK EDW_APPS_TO_WH.US.ORACLE.COM;
    DROP DATABASE LINK EDW_APPS_TO_WH.US.ORACLE.COM;
    
    prompt CREATE DATABASE LINK EDW_APPS_TO_WH.US.ORACLE.COM
    CREATE DATABASE LINK EDW_APPS_TO_WH.US.ORACLE.COM
     CONNECT TO APPS
     IDENTIFIED BY ${L_APP_PWD}
     USING '${L_ORACLESID}';
    
    prompt DROP DATABASE LINK FIS_PRD3_PRD2_DBLNK.LEICS.GOV.UK;
    DROP DATABASE LINK FIS_PRD3_PRD2_DBLNK.LEICS.GOV.UK;

    prompt DROP DATABASE LINK FIS_PRD3_TMP1_DBLNK.LEICS.GOV.UK;
    DROP DATABASE LINK FIS_PRD3_TMP1_DBLNK.LEICS.GOV.UK;

    prompt DROP DATABASE LINK TRENT_PRD3_HRDW_DBLNK.LEICS.GOV.UK;
    DROP DATABASE LINK TRENT_PRD3_HRDW_DBLNK.LEICS.GOV.UK;
    
    prompt DROP DATABASE LINK TRENT_PRD3_HRPRD1_DBLNK.LEICS.GOV.UK;
    DROP DATABASE LINK TRENT_PRD3_HRPRD1_DBLNK.LEICS.GOV.UK;

    prompt DROP DATABASE LINK TRENT_PRD3_HRDW_DBLINK.LEICS.GOV.UK;
    DROP DATABASE LINK TRENT_PRD3_HRDW_DBLINK.LEICS.GOV.UK;

    prompt DROP DATABASE LINK TRENT_PRD3_HRPRD1_DBLINK.LEICS.GOV.UK;
    DROP DATABASE LINK TRENT_PRD3_HRPRD1_DBLINK.LEICS.GOV.UK;

    prompt DROP DATABASE LINK TESTTRENT_PRD3_HRPIE1_DDS_DBLINK.LEICS.GOV.UK;
    DROP DATABASE LINK TESTTRENT_PRD3_HRPIE1_DDS_DBLINK.LEICS.GOV.UK;

    prompt DROP DATABASE LINK TRENT_PRD3_HRPIE1_DBLINK.LEICS.GOV.UK;
    DROP DATABASE LINK TRENT_PRD3_HRPIE1_DBLINK.LEICS.GOV.UK;

    prompt DROP DATABASE LINK EBUS_LPMS_DBLNK.LEICS.GOV.UK;
    DROP DATABASE LINK EBUS_LPMS_DBLNK.LEICS.GOV.UK;

    prompt DROP DATABASE LINK ONE_PRD3_EMS_DBLINK.LEICS.GOV.UK;
    DROP DATABASE LINK ONE_PRD3_EMS_DBLINK.LEICS.GOV.UK;

    prompt DROP SYNONYM xxlcc_employees;
    DROP SYNONYM xxlcc_employees;

    prompt DROP SYNONYM xxlcc_transactions;
    DROP SYNONYM xxlcc_transactions;

    prompt DROP SYNONYM xxlcc_cheques;
    DROP SYNONYM xxlcc_cheques;

    prompt DROP VIEW xxlcc_cheques_payroll_nm_v;
    DROP VIEW xxlcc_cheques_payroll_nm_v;

    prompt DROP VIEW xxlcc_cheques_v;
    DROP VIEW xxlcc_cheques_v;

    -- Nr-12016492 --    prompt CREATE DATABASE LINK TRENT_${L_ORACLESID}_hr01_DBLNK
    -- Nr-12016492 --    CREATE DATABASE LINK TRENT_${L_ORACLESID}_hr01_DBLNK
    -- Nr-12016492 --    CONNECT TO FIS IDENTIFIED BY HQ6794
    -- Nr-12016492 --    USING 'hr01_dds';
  
    -- Nr-12016492 --    prompt CREATE SYNONYM xxlcc_employees
    -- Nr-12016492 --    CREATE SYNONYM xxlcc_employees
    -- Nr-12016492 --    FOR LCC_EMPLOYEES@TRENT_${L_ORACLESID}_hr01_DBLNK.leics.gov.uk;

    -- Nr-12016492 --    prompt CREATE SYNONYM xxlcc_transactionS
    -- Nr-12016492 --    CREATE SYNONYM xxlcc_transactionS
    -- Nr-12016492 --    FOR LCC_TRANSACTIONS@TRENT_${L_ORACLESID}_hr01_DBLNK.leics.gov.uk;

    -- Nr-12016492 --    prompt CREATE SYNONYM xxlcc_cheques
    -- Nr-12016492 --    CREATE SYNONYM xxlcc_cheques
    -- Nr-12016492 --    FOR LCC_CHEQUES@TRENT_${L_ORACLESID}_hr01_DBLNK.leics.gov.uk;

    -- Nr-12016492 --    prompt CREATE or replace VIEW xxlcc_cheques_payroll_nm_v
    -- Nr-12016492 --    CREATE or replace VIEW xxlcc_cheques_payroll_nm_v
    -- Nr-12016492 --    AS SELECT UNIQUE payroll_nm
    -- Nr-12016492 --    FROM xxlcc_cheques
    -- Nr-12016492 --    WITH check option;

    -- Nr-12016492 --    prompt CREATE or replace VIEW xxlcc_cheques_v
    -- Nr-12016492 --    CREATE or replace VIEW xxlcc_cheques_v
    -- Nr-12016492 --    AS SELECT UNIQUE payroll_nm, payroll_date
    -- Nr-12016492 --    FROM xxlcc_cheques
    -- Nr-12016492 --    WITH check option;

EOF
}   ### End of FN_DBLINKS_APPS ###


function FN_DBLINKS_SKY_USER
{
  sqlplus -s /nolog <<SQLEOF
    connect sky_user/sky_user_${L_ORACLESID}
    --  whenever sqlerror exit FAILURE

    show user;

    prompt DROP DATABASE LINK SKYL_${L_S_SID}_LPMS_DBLNK.LEICS.GOV.UK;
    DROP DATABASE LINK SKYL_${L_S_SID}_LPMS_DBLNK.LEICS.GOV.UK;

    prompt DROP DATABASE LINK SKYL_${L_S_SID}_HZNLIVE_DBLNK.LEICS.GOV.UK;
    DROP DATABASE LINK skyl_${L_S_SID}_HZNLIVE_DBLNK.LEICS.GOV.UK;

    prompt DROP DATABASE LINK SKYL_${L_S_SID}_LPNT_DBLNK.LEICS.GOV.UK;
    DROP DATABASE LINK SKYL_${L_S_SID}_LPNT_DBLNK.LEICS.GOV.UK;

    prompt DROP SYNONYM skyl_leasdmnd_sup;
    DROP SYNONYM skyl_leasdmnd_sup;

    prompt DROP SYNONYM addruse;
    DROP SYNONYM addruse;

    prompt DROP SYNONYM leasdmnd;
    DROP SYNONYM leasdmnd;

    prompt DROP SYNONYM tenant;
    DROP SYNONYM tenant;

    prompt DROP SYNONYM address;
    DROP SYNONYM address;

    prompt DROP SYNONYM rentdmdhd;
    DROP SYNONYM rentdmdhd;

    prompt DROP SYNONYM codesgen;
    DROP SYNONYM codesgen;

    prompt DROP SYNONYM vat;
    DROP SYNONYM vat;

    prompt DROP SYNONYM lease;
    DROP SYNONYM lease;

    --   we dont have the password yet
    -- Nr-12016492 --      prompt CREATE DATABASE LINK SKYL_${L_ORACLESID}_TPMS_DBLNK  PASSWORD is WRONG
    -- Nr-12016492 --      CONNECT TO FIS_USER IDENTIFIED BY fis_user_password   
    -- Nr-12016492 --      USING 'tpms_dds';
      
    --   we dont have the password yet
    -- Nr-12016492 --      prompt CREATE DATABASE LINK SKYL_${L_ORACLESID}_HZNTESt_DBLNK PASSWORD is WRONG
    -- Nr-12016492 --      CREATE DATABASE LINK SKYL_${L_ORACLESID}_HZNTESt_DBLNK
    -- Nr-12016492 --      CONNECT TO FIS_USER IDENTIFIED BY fis_user_password_target 
    -- Nr-12016492 --      USING 'hzntest_dds';
      
    -- Nr-12016492 --      prompt CREATE SYNONYM skyl_leasdmnd_sup
    -- Nr-12016492 --      CREATE SYNONYM skyl_leasdmnd_sup
    -- Nr-12016492 --      FOR skyl_leasdmnd_sup@SKYL_${L_ORACLESID}_tpms_dblnk;
      
    -- Nr-12016492 --      prompt CREATE SYNONYM addruse
    -- Nr-12016492 --      CREATE SYNONYM addruse
    -- Nr-12016492 --      FOR addruse@SKYL_${L_ORACLESID}_hzntest_dblnk;

    -- Nr-12016492 --      prompt CREATE SYNONYM leasdmnd
    -- Nr-12016492 --      CREATE SYNONYM leasdmnd
    -- Nr-12016492 --      FOR leasdmnd@SKYL_${L_ORACLESID}_hzntest_dblnk;

    -- Nr-12016492 --      prompt CREATE SYNONYM tenant
    -- Nr-12016492 --      CREATE SYNONYM tenant
    -- Nr-12016492 --      FOR tenant@SKYL_${L_ORACLESID}_hzntest_dblnk;

    -- Nr-12016492 --      prompt CREATE SYNONYM address
    -- Nr-12016492 --      CREATE SYNONYM address
    -- Nr-12016492 --      FOR address@SKYL_${L_ORACLESID}_hzntest_dblnk; 

    -- Nr-12016492 --      prompt CREATE SYNONYM rentdmdhd
    -- Nr-12016492 --      CREATE SYNONYM rentdmdhd
    -- Nr-12016492 --      FOR rentdmdhd@SKYL_${L_ORACLESID}_hzntest_dblnk;
    -- Nr-12016492 --      
    -- Nr-12016492 --      prompt CREATE SYNONYM codesgen
    -- Nr-12016492 --      CREATE SYNONYM codesgen
    -- Nr-12016492 --      FOR codesgen@SKYL_${L_ORACLESID}_hzntest_dblnk;

    -- Nr-12016492 --      prompt CREATE SYNONYM vat
    -- Nr-12016492 --      CREATE SYNONYM vat
    -- Nr-12016492 --      FOR vat@SKYL_${L_ORACLESID}_hzntest_dblnk; 

    -- Nr-12016492 --      prompt CREATE SYNONYM lease
    -- Nr-12016492 --      CREATE SYNONYM lease
    -- Nr-12016492 --      FOR lease@SKYL_${L_ORACLESID}_hzntest_dblnk; 

SQLEOF
}   ### End of FN_DBLINKS_SKY_USER ###


function FN_DBLINKS_ARTS_USER
{
  sqlplus -s /nolog <<SQLEOF
    connect arts_user/arts_user_${L_ORACLESID}
    --  whenever sqlerror exit FAILURE
    show user;

    prompt DROP DATABASE LINK ARTS_${L_S_SID}_PD_DBLNK.LEICS.GOV.UK;
    DROP DATABASE LINK ARTS_${L_S_SID}_PD_DBLNK.LEICS.GOV.UK;

    prompt DROP DATABASE LINK ARTS_${L_S_SID}_PDM_DBLNK;
    DROP DATABASE LINK ARTS_${L_S_SID}_PDM_DBLNK;

    prompt DROP SYNONYM la_parent_group_invoices;
    DROP SYNONYM la_parent_group_invoices;

    prompt DROP SYNONYM la_par_grp_inv_lines;
    DROP SYNONYM la_par_grp_inv_lines;

    prompt DROP SYNONYM la_groups;
    DROP SYNONYM la_groups;

    prompt DROP SYNONYM la_xrefs;
    DROP SYNONYM la_xrefs;

    prompt DROP SYNONYM la_agreements;
    DROP SYNONYM la_agreements;

    prompt DROP SYNONYM la_parent_invoices;
    DROP SYNONYM la_parent_invoices;

    prompt DROP SYNONYM la_par_inv_lines;
    DROP SYNONYM la_par_inv_lines;

    prompt DROP SYNONYM la_school_invoices;
    DROP SYNONYM la_school_invoices;

    prompt DROP SYNONYM la_sch_inv_analysis;
    DROP SYNONYM la_sch_inv_analysis;

    prompt DROP SYNONYM la_tt_invoices;
    DROP SYNONYM la_tt_invoices;

    prompt DROP SYNONYM la_tt_inv_analysis;
    DROP SYNONYM la_tt_inv_analysis;

    prompt DROP SYNONYM pd_address;
    DROP SYNONYM pd_address;

    prompt DROP SYNONYM pd_school_details;
    DROP SYNONYM pd_school_details;

    prompt DROP SYNONYM pd_system_parameters;
    DROP SYNONYM pd_system_parameters;

    prompt DROP SYNONYM pd_parents;
    DROP SYNONYM pd_parents;

    prompt DROP SYNONYM la_customer_list;
    DROP SYNONYM la_customer_list;

    prompt DROP SYNONYM plan_table;
    DROP SYNONYM plan_table;

    prompt DROP SYNONYM la_term_periods;
    DROP SYNONYM la_term_periods;

    prompt DROP SYNONYM LA_TERM_PERIODS;
    DROP SYNONYM LA_TERM_PERIODS;

    --   At this tie we don't know the fis_user_pass
    -- Nr-12016492 --    prompt CREATE DATABASE LINK ARTS_${L_ORACLESID}_pdm_DBLNK  ======  Not correct password
    -- Nr-12016492 --    CREATE DATABASE LINK ARTS_${L_ORACLESID}_pdm_DBLNK
    -- Nr-12016492 --    CONNECT TO FIS_USER IDENTIFIED BY fis_user_pass 
    -- Nr-12016492 --    USING 'pdm_dds';

    -- Nr-12016492 --    prompt CREATE SYNONYM la_parent_group_invoices
    -- Nr-12016492 --    CREATE SYNONYM la_parent_group_invoices
    -- Nr-12016492 --    FOR la_parent_group_invoices@ARTS_${L_ORACLESID}_pdm_DBLNK; 

    -- Nr-12016492 --    prompt CREATE SYNONYM la_par_grp_inv_lines
    -- Nr-12016492 --    CREATE SYNONYM la_par_grp_inv_lines
    -- Nr-12016492 --    FOR la_par_grp_inv_lines@ARTS_${L_ORACLESID}_pdm_DBLNK; 

    -- Nr-12016492 --    prompt CREATE SYNONYM la_groups
    -- Nr-12016492 --    CREATE SYNONYM la_groups
    -- Nr-12016492 --    FOR la_groups@ARTS_${L_ORACLESID}_pdm_DBLNK;            

    -- Nr-12016492 --    prompt CREATE SYNONYM la_xrefs
    -- Nr-12016492 --    CREATE SYNONYM la_xrefs
    -- Nr-12016492 --    FOR la_xrefs@ARTS_${L_ORACLESID}_pdm_DBLNK;             

    -- Nr-12016492 --    prompt CREATE SYNONYM la_agreements
    -- Nr-12016492 --    CREATE SYNONYM la_agreements
    -- Nr-12016492 --    FOR la_agreements@ARTS_${L_ORACLESID}_pdm_DBLNK;

    -- Nr-12016492 --    prompt CREATE SYNONYM la_parent_invoices
    -- Nr-12016492 --    CREATE SYNONYM la_parent_invoices
    -- Nr-12016492 --    FOR la_parent_invoices@ARTS_${L_ORACLESID}_pdm_DBLNK;

    -- Nr-12016492 --    prompt CREATE SYNONYM la_par_inv_lines
    -- Nr-12016492 --    CREATE SYNONYM la_par_inv_lines
    -- Nr-12016492 --    FOR la_par_inv_lines@ARTS_${L_ORACLESID}_pdm_DBLNK;

    -- Nr-12016492 --    prompt CREATE SYNONYM la_school_invoices
    -- Nr-12016492 --    CREATE SYNONYM la_school_invoices
    -- Nr-12016492 --    FOR la_school_invoices@ARTS_${L_ORACLESID}_pdm_DBLNK;

    -- Nr-12016492 --    prompt CREATE SYNONYM la_sch_inv_analysis
    -- Nr-12016492 --    CREATE SYNONYM la_sch_inv_analysis
    -- Nr-12016492 --    FOR la_sch_inv_analysis@ARTS_${L_ORACLESID}_pdm_DBLNK;

    -- Nr-12016492 --    prompt CREATE SYNONYM la_tt_invoices
    -- Nr-12016492 --    CREATE SYNONYM la_tt_invoices
    -- Nr-12016492 --    FOR la_tt_invoices@ARTS_${L_ORACLESID}_pdm_DBLNK;    

    -- Nr-12016492 --    prompt CREATE SYNONYM la_tt_inv_analysis
    -- Nr-12016492 --    CREATE SYNONYM la_tt_inv_analysis
    -- Nr-12016492 --    FOR la_tt_inv_analysis@ARTS_${L_ORACLESID}_pdm_DBLNK;

    -- Nr-12016492 --    prompt CREATE SYNONYM pd_address
    -- Nr-12016492 --    CREATE SYNONYM pd_address
    -- Nr-12016492 --    FOR pd_address@ARTS_${L_ORACLESID}_pdm_DBLNK;

    -- Nr-12016492 --    prompt CREATE SYNONYM pd_school_details
    -- Nr-12016492 --    CREATE SYNONYM pd_school_details
    -- Nr-12016492 --    FOR pd_school_details@ARTS_${L_ORACLESID}_pdm_DBLNK;

    -- Nr-12016492 --    prompt CREATE SYNONYM pd_system_parameters
    -- Nr-12016492 --    CREATE SYNONYM pd_system_parameters
    -- Nr-12016492 --    FOR pd_system_parameters@ARTS_${L_ORACLESID}_pdm_DBLNK;

    -- Nr-12016492 --    prompt CREATE SYNONYM pd_parents
    -- Nr-12016492 --    CREATE SYNONYM pd_parents
    -- Nr-12016492 --    FOR pd_parents@ARTS_${L_ORACLESID}_pdm_DBLNK;

    -- Nr-12016492 --    prompt CREATE SYNONYM la_customer_list
    -- Nr-12016492 --    CREATE SYNONYM la_customer_list
    -- Nr-12016492 --    FOR la_customer_list@ARTS_${L_ORACLESID}_pdm_DBLNK;

    -- Nr-12016492 --    prompt CREATE SYNONYM plan_table
    -- Nr-12016492 --    CREATE SYNONYM plan_table
    -- Nr-12016492 --    FOR plan_table@ARTS_${L_ORACLESID}_pdm_DBLNK;

    -- Nr-12016492 --    prompt CREATE SYNONYM la_term_periods
    -- Nr-12016492 --    CREATE SYNONYM la_term_periods
    -- Nr-12016492 --    FOR la_term_periods@ARTS_${L_ORACLESID}_pdm_DBLNK;       

SQLEOF
}   ### End of FN_DBLINKS_ARTS_USER ###


function FN_DBLINKS_TAR_USER
{
  sqlplus -s /nolog <<SQLEOF
    connect tar_user/tar_user_${L_ORACLESID}
    --  whenever sqlerror exit FAILURE
    show user;

    prompt DROP DATABASE LINK TAR_${L_S_SID}_LPMS_DBLNK.LEICS.GOV.UK;
    DROP DATABASE LINK TAR_${L_S_SID}_LPMS_DBLNK.LEICS.GOV.UK;

    prompt DROP SYNONYM properties;
    DROP SYNONYM properties;

    prompt DROP SYNONYM ar_cert_items;
    DROP SYNONYM ar_cert_items;

    prompt DROP SYNONYM vpe_assets;
    DROP SYNONYM vpe_assets;

    -- Nr-12016492 --    prompt CREATE DATABASE LINK TAR_${L_ORACLESID}_TPMS_DBLNK.LEICS.GOV.UK =========  wrong password
    -- Nr-12016492 --    CREATE DATABASE LINK TAR_${L_ORACLESID}_TPMS_DBLNK.LEICS.GOV.UK
    -- Nr-12016492 --    CONNECT TO tar IDENTIFIED BY tar
    -- Nr-12016492 --    USING 'lpms_dds';
    -- Nr-12016492 --
    -- Nr-12016492 --    prompt CREATE SYNONYM properties
    -- Nr-12016492 --    CREATE SYNONYM properties
    -- Nr-12016492 --    FOR properties@TAR_${L_ORACLESID}_TPMS_DBLNK.LEICS.GOV.UK;
    -- Nr-12016492 --  
    -- Nr-12016492 --    prompt CREATE SYNONYM ar_cert_items
    -- Nr-12016492 --    CREATE SYNONYM ar_cert_items
    -- Nr-12016492 --    FOR ar_cert_items@TAR_${L_ORACLESID}_TPMS_DBLNK.LEICS.GOV.UK;
    -- Nr-12016492 --   
    -- Nr-12016492 --    prompt CREATE SYNONYM vpe_assets
    -- Nr-12016492 --    CREATE SYNONYM vpe_assets
    -- Nr-12016492 --    FOR vpe_assets@TAR_${L_ORACLESID}_TPMS_DBLNK.LEICS.GOV.UK;

SQLEOF
}   ### End of FN_DBLINKS_TAR_USER ###


function FN_DBLINKS_CTS_USER
{
  sqlplus -s /nolog <<SQLEOF
    connect cts_user/cts_user_${L_ORACLESID}
    --  whenever sqlerror exit FAILURE
    show user;

    prompt DROP DATABASE LINK CTS_${L_S_SID}_KEYG_DBLINK.LEICS.GOV.UK;
    DROP DATABASE LINK CTS_${L_S_SID}_KEYG_DBLINK.LEICS.GOV.UK;

    prompt DROP DATABASE LINK CTS_${L_S_SID}_LPNT_DBLINK.LEICS.GOV.UK;
    DROP DATABASE LINK CTS_${L_S_SID}_LPNT_DBLINK.LEICS.GOV.UK;

    prompt DROP SYNONYM fis_salesrep;
    DROP SYNONYM fis_salesrep;

    prompt DROP SYNONYM fis_customer;
    DROP SYNONYM fis_customer;

    prompt DROP SYNONYM fis_control;
    DROP SYNONYM fis_control;

    prompt DROP SYNONYM fis_invoice_hdr;
    DROP SYNONYM fis_invoice_hdr;

    prompt DROP SYNONYM fis_invoice_line;
    DROP SYNONYM fis_invoice_line;

SQLEOF
}   ### End of FN_DBLINKS_CTS_USER ###


function FN_DBLINKS_CDS_USER
{
  sqlplus -s /nolog <<SQLEOF
    connect cds_user/cds_user_${L_ORACLESID}
    --  whenever sqlerror exit FAILURE
    show user;

    prompt DROP DATABASE LINK CDS_${L_S_SID}_LCID_DBLINK.LEICS.GOV.UK;
    DROP DATABASE LINK CDS_${L_S_SID}_LCID_DBLINK.LEICS.GOV.UK;

SQLEOF
}   ### End of FN_DBLINKS_CDS_USER ###


function FN_DBLINKS_BODATA
{
  sqlplus -s /nolog <<SQLEOF
    connect bodata/bodata_${L_ORACLESID}
    --  whenever sqlerror exit FAILURE
    show user;

    prompt DROP DATABASE LINK EBUS_LPMS_DBLNK.LEICS.GOV.UK;
    DROP DATABASE LINK EBUS_LPMS_DBLNK.LEICS.GOV.UK;

    prompt DROP DATABASE LINK EBUS_LPNT_DBLNK.LEICS.GOV.UK;
    DROP DATABASE LINK EBUS_LPNT_DBLNK.LEICS.GOV.UK;

    prompt DROP DATABASE LINK EBUS_LPNT_2_DBLNK.LEICS.GOV.UK;
    DROP DATABASE LINK EBUS_LPNT_2_DBLNK.LEICS.GOV.UK;


SQLEOF
}   ### End of FN_DBLINKS_BODATA ###







function FN_Wisdom {
  #
  # Update and recompile java for 'XXLCC_PAY_INV_REJECTED_UPLOAD', 'XXLCC_PAY_INV_WISDOM_UPLOAD' 
  #
  L_PROFILE_DATE=`date +%Y%m%d_%H%M%S`
  #
  cd $XXLCC_TOP/java/bin
  ./buildXXLCCWisdom.sh
  ./buildXXLCCRejectedInvoiceUpload.sh

  sqlplus -s /nolog <<EOSQL
    connect apps/$(FN_GetAPPSPassword $L_ORACLESID)
    whenever sqlerror exit FAILURE

      prompt updating EXECUTION_OPTIONS for fnd_concurrent_programs...
      prompt   XXLCC_PAY_INV_REJECTED_UPLOAD, XXLCC_PAY_INV_WISDOM_UPLOAD
      update fnd_concurrent_programs set EXECUTION_OPTIONS = '-classpath /appl${L_LCORACLESID}/apps/apps_st/custom/xxlcc/12.0.0/java/jar/XXLCCWisdom.jar:/appl${L_LCORACLESID}/apps/apps_st/comn/java/classes:/appl${L_LCORACLESID}/apps/apps_st/comn/java/lib/jdbc14.zip:/appl${L_LCORACLESID}/apps/apps_st/comn/java/lib/nls_charset12.zip'
      where CONCURRENT_PROGRAM_NAME in (
      'XXLCC_PAY_INV_REJECTED_UPLOAD',
      'XXLCC_PAY_INV_WISDOM_UPLOAD');

      commit;

      select CONCURRENT_PROGRAM_NAME, EXECUTION_OPTIONS
      from fnd_concurrent_programs
      where CONCURRENT_PROGRAM_NAME in (
      'XXLCC_PAY_INV_REJECTED_UPLOAD',
      'XXLCC_PAY_INV_WISDOM_UPLOAD');

EOSQL

}   ### End of FN_Wisdom ###


function FN_Site_Profile_Values
{

  PROFILE_DATE=`date +%d-%m-%y`

  sqlplus -s /nolog <<EOF
    connect apps/$(FN_GetAPPSPassword $L_ORACLESID)
    set echo on verify on feedback on
--    whenever sqlerror exit FAILURE
    prompt Updating site profile values ...

  --------------------------------------------------------------------------------------------
  -- Params: 
  -- 1. Instance
  -- 2. IRS_INV_EMAIL_USR
  -- 3. IRS_INV_EMAIL_PWD
  -- 4. User email address
  -- 5. Out Dir
  -- 6. Fax Dir
  -- 7. XDO del file
  -- 8. Java XML Log File
  -- 9. XML Base
  -- 10. BNE Upload Staging Dir
  -- 11. BNE Upload Import Dir
  -- 12. BNE Upload Text Dir
  -- 13. LOB Source Path
  -- 14. BNE Server log path
  -- 15. IBY_ECAPP_URL
  -- 16. FND_PERZ_DOC_ROOT_PATH
  -- 17. XXLCC_PAYSLIP_ADVERT_DIR/LOGO
  --
  --------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------
  --
  --	Modification History
  --
  --------------------------------------------------------------------------------------------
  --------------------------------------------------------------------------------------------
  SET SERVEROUTPUT ON SIZE 1000000
  --SET FEED OFF
  --spool pc_set_profile_options.txt
  DECLARE
     lblnSuccess BOOLEAN;
  
     CURSOR curProfile IS
        SELECT  fpo.profile_option_name
        ,       fpov.level_id
        ,       DECODE(fpov.level_id, 10001, 'SITE', 10004, 'USER', 'UNKNOWN') AS Profile_Level
        ,       fu.user_name
        ,       fu.user_id
        ,       profile_option_value
        FROM  fnd_profile_options fpo
           LEFT JOIN fnd_profile_option_Values fpov ON fpo.profile_option_id = fpov.profile_option_id
           LEFT JOIN fnd_user fu ON fpov.level_id = 10004 AND fpov.level_value = user_id
        WHERE fpo.profile_option_name = 'ICX_FORMS_LAUNCHER'; 
  
     lstrInstance       VARCHAR2(200) := '${L_ORACLESID}';
     lstrIrsInvEmailUsr VARCHAR2(200) := 'mememeem2';
     lstrIrsInvEmailPwd VARCHAR2(200) := 'pwd 3';
     lstrUserEmailAddr  VARCHAR2(200) := 'email 4';
     lstrOutDir         VARCHAR2(200) := 'outdir 5';
     lstrFaxDir         VARCHAR2(200) := 'fax dir6';
     lstrXdodelFile     VARCHAR2(200) := 'xml log7';
     lstrJavaXMLLogFile VARCHAR2(200) := 'java log8';
     lstrXMLBase        VARCHAR2(200) := 'xml base 9';
     lstrBNEUploadStag  VARCHAR2(200) := 'up stag10';
     lstrBNEUploadImp   VARCHAR2(200) := 'up imp 11';
     lstrBNEUploadTxt   VARCHAR2(200) := 'p txt 12';
     lstrLOBSourcePath  VARCHAR2(200) := 'log src 13';
     lstrBNEServerLog   VARCHAR2(200) := 'svr log 14';
     lstrEcappUrl       VARCHAR2(200) := 'ap url 15';
     lstrFNDPerRootPath VARCHAR2(200) := 'root pth 16';
     lstrPayslipMedia   VARCHAR2(200) := 'payslip media 17';
     
      PROCEDURE set_profile_opt( p_option IN VARCHAR2 , p_value  IN VARCHAR2 , p_level  IN VARCHAR2 ) IS
          lblnSuccess BOOLEAN;
      BEGIN
        lblnSuccess := fnd_profile.save( p_option, p_value, p_level );
        IF (lblnsuccess = TRUE) THEN
          dbms_output.put_line( '    SUCCESS : Profile option ' || p_option || ' set to ' || p_value || ' (' || p_level || ')' );
        ELSE
          dbms_output.put_line( '    FAILED : '|| p_option || ' with value ' || p_value || ' - please check manually' );	   
        END IF;
      END set_profile_opt;   
  							 
  BEGIN
     -- Site-level profile options
     set_profile_opt( 'XXLCC_OUT_DIRECTORY', '/${L_APPLUSER}/csf/out', 'SITE' );
     set_profile_opt( 'PO_FAX_OUTPUT_DIRECTORY_FOR_CONTROL_FILE', '/${L_APPLUSER}/apps/apps_st/custom/xxlcc/12.0.0/fax/', 'SITE' );
     set_profile_opt( 'PO_FAX_OUTPUT_DIRECTORY', '/${L_APPLUSER}/apps/apps_st/custom/xxlcc/12.0.0/fax/', 'SITE' );
     set_profile_opt( 'IBY_XDO_DELIVERY_CFG_FILE', '/${L_APPLUSER}/apps/apps_st/appl/xdo/12.0.0/resource/xdodelivery.cfg', 'SITE' );
     set_profile_opt( 'IBY_JAVA_XML_LOG', '/${L_APPLUSER}/apps/apps_st/appl/iby/12.0.0/log/iby_xml_messages.log', 'SITE' );
     set_profile_opt( 'IBY_XML_BASE', '/${L_APPLUSER}/apps/apps_st/appl/iby/12.0.0/xml', 'SITE' );
     set_profile_opt( 'FND_PERZ_DOC_ROOT_PATH', '/${L_APPLUSER}/apps/apps_st/custom/xxlcc/12.0.0/tmp', 'SITE' );

  -- Remove USER-level settings of ICX_FORMS_LAUNCHER
  --  FOR lrecProfile IN curProfile LOOP
      -- if set at USER level
  --    IF (lrecProfile.Profile_Level = 'USER') THEN
  --       lblnSuccess := fnd_profile.delete( 'ICX_FORMS_LAUNCHER', 'USER', lrecProfile.user_id );
  --       IF (lblnsuccess = TRUE) THEN
  --         dbms_output.put_line( 'ICX_FORMS_LAUNCHER' || ': SUCCESSFULLY DELETED for USER: ' || lrecProfile.user_id);
  --       ELSE
  --         dbms_output.put_line( 'ICX_FORMS_LAUNCHER' || ': FAILED TO DELETE for USER: ' || lrecProfile.user_id);
  --       END IF;
  --    END IF;
  --  END LOOP;

  END;
  /

  -------------------------------------------------------
    commit;
EOF

}


function FN_Autoconfig {

   #  should use CONTEXT_NAME # 
  echo  "/$L_APPLUSER/inst/apps/${L_T_SID}_$(hostname)/admin/scripts/adautocfg.sh appspass=$L_APPSPWD"
  /$L_APPLUSER/inst/apps/${L_T_SID}_$(hostname)/admin/scripts/adautocfg.sh appspass=$L_APPSPWD
  
}


function FN_CR_CSF_Dirs
{
  mkdir /appl$L_LCORACLESID/csf/log
  chmod 777 /appl$L_LCORACLESID/csf/log

  mkdir /appl$L_LCORACLESID/csf/out
  chmod 777 /appl$L_LCORACLESID/csf/out
}


function FN_Custom_env 
{
  l_fn=/appl$L_LCORACLESID/appl/custom${L_ORACLESID}_$(hostname).env
  
  echo "DISPLAY=`hostname`:1" >>$l_fn
  echo "export DISPLAY" >>$l_fn
}


function FN_adovars_env 
{
  l_fn=/appl$L_LCORACLESID/appl/admin/adovars.env
  
  echo "AOC_TOP=/appl${L_LCORACLESID}/appl/aoc/11.5.0" >>$l_fn
  echo "export AOC_TOP" >>$l_fn
  
  echo "DISPLAY=`hostname`:1" >>$l_fn
  echo "export DISPLAY" >>$l_fn
}


function FN_APPS_START
{
  l_pwd=${1:?"Missing the apps password"}

  cd /${L_APPLUSER}/inst/apps/${L_ORACLESID}_$(hostname)/admin/scripts
  pwd
  ./adstrtal.sh apps/$l_pwd
}


function FN_CM_Fix
{
  l_pwd=${1:?"FN_CM_Fix: Missing the apps password"}

  FN_Debug  "$L_ORACLESID: Old Conc. Mgr processes"
  ps -ef |egrep "FNDLIBR|FNDSM"|grep -v grep
  FN_Debug  " "
  FN_Debug  "killing the old Conc. Mgr processes for appl$L_LCORACLESID"
  kill -9 `ps -ef |grep $L_APPLUSER | egrep "FNDLIBR|FNDSM"|grep -v grep|awk '{print $2}'`
  
  FN_Debug "Restarting the Conc. Mgrs"
  cd /${L_APPLUSER}/inst/apps/${L_ORACLESID}_${L_CPSRV}/admin/scripts && ./adcmctl.sh start apps/$l_pwd

  FN_Debug "Waiting 100 seconds for the Conc. Mgrs to get into action"
  sleep 100
  if [ $(ps -ef |grep $L_APPLUSER |grep FNDLIBR |grep -v grep |wc -l) -gt 1 ]; then
    ps -ef | grep $L_APPLUSER | grep -v grep | mailx -r ebssupp@leics.gov.uk -s "$L_ORACLESID clone is up and running" robert.milby@velos-it.com 
  else
    ps -ef | grep $L_APPLUSER | grep -v grep | mailx -r ebssupp@leics.gov.uk -s "$L_ORACLESID clone : Investigate" robert.milby@velos-it.com
  fi
}


function FN_APPS_STOP
{
  l_pwd=${1:?"Missing the apps password"}

  cd /${L_APPLUSER}/inst/apps/${L_ORACLESID}_$(hostname)/admin/scripts
  pwd
  ./adstpall.sh apps/$l_pwd
  # give the managers time to shutdown
  # just kill the processes in FN_CM_Fix # sleep 120
}


function FN_Change_PWD
{
  L_MANAGER=$(FN_PASSWORD_GEN "Manager" $L_T_SID )

  FN_Debug "FNDCPASS apps/$(FN_GetAPPSPassword $L_S_SID) 0 Y system/$L_MANAGER SYSTEM APPLSYS $L_APPSPWD"
  FNDCPASS apps/$(FN_GetAPPSPassword $L_S_SID) 0 Y system/$L_MANAGER SYSTEM APPLSYS $L_APPSPWD

  # If the apps password is not changed then all orther steps will fail.
  if [ $? -ne 0 ]; then
    FN_Error "The apps password was not changed from the source setting"
    export L_ERROR=1
  fi

  # change the sysadmin password to a generated password which will test the above password change.
  FN_Debug "FNDCPASS apps/$L_APPSPWD 0 Y system/$L_MANAGER USER sysadmin $(FN_PASSWORD_GEN `date +%A` $L_T_SID )"
  FNDCPASS apps/$L_APPSPWD 0 Y system/$L_MANAGER USER sysadmin $(FN_PASSWORD_GEN `date +%A` $L_T_SID )
}


function  FN_Change_env
{
  l_fn=${1:?"FN_Change_env: Missing the file name"}
  l_tmp_fn=${l_fn}.`date +%y%m%d`
  mv $l_fn $l_tmp_fn

  cat $l_tmp_fn | awk -v ldir="/${L_APPLUSER}/csf" '
    /^APPLCSF/  {print "APPLCSF="ldir }
    !(/^APPLCSF/) {print }' >$l_fn

}



function FN_context_change {
  
  # change the APPLCSF, APPLPTMP, and APPLTMP dirs
  # APPLCSF oa_var="s_applcsf">/appldev4/inst/apps/DEV_V06ss101/logs/appl/conc</APPLCSF>
  # APPLPTMP oa_var="s_applptmp" osd="UNIX">/appldev4/conc/temp</APPLPTMP>
  # APPLTMP oa_var="s_appltmp">/appldev4/inst/apps/DEV4_v06ss101/appltmp</APPLTMP>
  # oacore_nprocs - change the template value of 20 to 2


### to do - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#      <oa_workflow_server>
#         <hostname oa_var="s_javamailer_imaphost">lccexcas</hostname>
#         <domain oa_var="s_javamailer_imapdomainname">ad.leics.gov.uk</domain>
#         <username oa_var="s_wf_admin_role">SYSADMIN</username>
#         <username oa_var="s_javamailer_reply_to">r12-wf-sit@leics.gov.uk</username>
#         <username oa_var="s_javamailer_imap_user">r12-wf-sit</username>
#      </oa_workflow_server>
#      <oa_smtp_server>
#         <hostname oa_var="s_smtphost">v06ss101</hostname>
#         <domain oa_var="s_smtpdomainname">edi.emss.gov.uk</domain>
#      </oa_smtp_server>
### - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  l_fn=${CONTEXT_FILE}
  l_tmp_fn=${l_fn}.`date +%y%m%d`
  mv $l_fn $l_tmp_fn

  cat $l_tmp_fn | awk '
   /<APPLCSF oa_var/  {print "<APPLCSF oa_var=\"s_applcsf\">/" a_applusr "/csf</APPLCSF>" }
   /<APPLPTMP oa_var/ {print "<APPLPTMP oa_var=\"s_applptmp\" osd=\"UNIX\">/" a_applusr "/csf/temp</APPLPTMP>" }
   /oacore_nprocs/    {print "<oacore_nprocs oa_var=\"s_oacore_nprocs\">1</oacore_nprocs>"}
    !(/<APPLCSF oa_var/ || /<APPLPTMP oa_var/ || /oacore_nprocs/) { print }' a_applusr=${L_APPLUSER} | sed -e "s/finsyscontrol/${L_WFACCT}/" >$l_fn

}   ### end of FN_context_change ###


function FN_setWorkflow
{
  FN_Debug "FN_setWorkflow :: start"


  export L_DOMAIN="@edi.emss.gov.uk"

	## select v.parameter_name,v.parameter_id, v.PARAMETER_DISPLAY_NAME, v.PARAMETER_VALUE
	## from FND_SVC_COMP_PARAM_VALS_V v, FND_SVC_COMPONENTS SC
	## where v.COMPONENT_ID=sc.COMPONENT_ID
	##   and v.parameter_name in ('NODENAME','ACCOUNT','FROM','REPLYTO','INBOUND_SERVER','OUTBOUND_SERVER','TEST_ADDRESS')
	##   --and v.parameter_id in (10037, 10018, 10029, 10053, 10033, 10043, 10057)
	## order by sc.COMPONENT_ID, v.parameter_name

  sqlplus -s /nolog <<EOF
    connect apps/$(FN_GetAPPSPassword $L_ORACLESID)
    whenever sqlerror exit FAILURE
     
      prompt  The current WF mailer account
      select parameter_id, parameter_value
      from fnd_svc_comp_param_vals
      where parameter_id in('10053','10018');
 
      prompt Updating Workflow gateway account...
      update fnd_svc_comp_param_vals
      set parameter_value = '${L_WFACCT}'
      where parameter_id = '10018'
 
      prompt Updating Workflow reply-to account...
      update fnd_svc_comp_param_vals
      set parameter_value = '${L_WFACCT}@leics.gov.uk'
      where parameter_id = '10053'
      
      prompt Updating Workflow user account...
      update fnd_svc_comp_param_vals
      set parameter_value = 'Angela.Rady@leics.gov.uk'
      where parameter_id = 10057;
      
      prompt Updating Inbound server IP address...
      select parameter_value 
      from fnd_svc_comp_param_vals
      where parameter_id = 10033;
      
      prompt Updating Outbound server IP address...
      update fnd_svc_comp_param_vals
      set parameter_value = 'lccexhub1.ad.leics.gov.uk'
      where parameter_id = 10043;
--      where (parameter_id,component_id) in 
--      ( select parameter_id, component_id
--        from fnd_svc_components C, fnd_svc_comp_params_tl P
--        where C.component_name = 'Workflow Notification Mailer'
--          and P.display_name = 'Outbound Server Name'
--      );

      
      prompt Updating message sent from ...
      update fnd_svc_comp_param_vals
      set parameter_value = parameter_value || ' (${L_ORACLESID})'
      where parameter_id = 10029;


      prompt Updating Workflow Administrator from SYSADMIN to everyone
      select name, text from apps.wf_resources where name='WF_ADMIN_ROLE';
      update apps.wf_resources set text='*' where name='WF_ADMIN_ROLE';
      select name, text from apps.wf_resources where name='WF_ADMIN_ROLE';


      prompt Updating Alert Manager Mail Database Server Name
      select PROFILE_OPTION_NAME, PROFILE_OPTION_VALUE from ALR_PROFILE_OPTIONS where PROFILE_OPTION_NAME='ORACLE_MAIL_DATABASE';
      update apps.ALR_PROFILE_OPTIONS set PROFILE_OPTION_VALUE='lccexhub1.ad.leics.gov.uk' where PROFILE_OPTION_NAME='ORACLE_MAIL_DATABASE';
      select PROFILE_OPTION_NAME, PROFILE_OPTION_VALUE from ALR_PROFILE_OPTIONS where PROFILE_OPTION_NAME='ORACLE_MAIL_DATABASE';

      prompt Updating Alert Manager Send Response Mail Account
      select NAME, ENCRYPTED_PASSWORD, SENDMAIL_ACCOUNT, DEFAULT_RESPONSE_ACCOUNT from apps.ALR_ORACLE_MAIL_ACCOUNTS;
      update apps.ALR_ORACLE_MAIL_ACCOUNTS set NAME='${L_WFACCT}', ENCRYPTED_PASSWORD = 'disabled' where SENDMAIL_ACCOUNT = 'Y';
      update apps.ALR_ORACLE_MAIL_ACCOUNTS set NAME='${L_WFACCT}', ENCRYPTED_PASSWORD = 'disabled' where DEFAULT_RESPONSE_ACCOUNT = 'Y';
      select NAME, ENCRYPTED_PASSWORD, SENDMAIL_ACCOUNT, DEFAULT_RESPONSE_ACCOUNT from apps.ALR_ORACLE_MAIL_ACCOUNTS;

      commit;
EOF

 FN_Debug "FN_setWorkflow :: end"

}


function FN_Grants_ops {
  sqlplus -s /nolog <<SQLEOF
    connect apps/$(FN_GetAPPSPassword $L_ORACLESID)
    set echo on;
    whenever sqlerror exit FAILURE

    show user

    grant all on xxlcc_gl_feeder_rundate to ops\$appl${L_LCORACLESID};
    grant all on xxlcc_gl_feeder_errors to ops\$appl${L_LCORACLESID};
    grant select on gl_je_lines to ops\$appl${L_LCORACLESID};
    grant select on ap_invoices_all to ops\$appl${L_LCORACLESID};
    grant select on gl_je_batches to ops\$appl${L_LCORACLESID};
    grant select on gl_je_headers to ops\$appl${L_LCORACLESID};
    grant select on ar_customers to ops\$appl${L_LCORACLESID};
    grant select on ra_customer_trx_all to ops\$appl${L_LCORACLESID};
    grant select on ar_adjustments_all to ops\$appl${L_LCORACLESID};
    grant select on gl_je_sources to ops\$appl${L_LCORACLESID};
    grant select on gl_code_combinations to ops\$appl${L_LCORACLESID};
    grant select on ap_batches_all to ops\$appl${L_LCORACLESID};
    grant select on po_vendors to ops\$appl${L_LCORACLESID};
    grant all on xxlcc_ca_download to ops\$appl${L_LCORACLESID};
    GRANT ALL on xxlcc_gl_commet_dl to ops\$appl${L_LCORACLESID};
    GRANT SELECT on gl_code_combinations to ops\$appl${L_LCORACLESID};
    GRANT SELECT on gl_je_batches to ops\$appl${L_LCORACLESID};
    GRANT SELECT on gl_je_headers to ops\$appl${L_LCORACLESID};
    GRANT SELECT on gl_je_lines to ops\$appl${L_LCORACLESID};
    GRANT SELECT on gl_je_sources to ops\$appl${L_LCORACLESID};
    GRANT SELECT on ap_invoices to ops\$appl${L_LCORACLESID};
    GRANT SELECT on po_vendors to ops\$appl${L_LCORACLESID};
    GRANT SELECT on ar_customers to ops\$appl${L_LCORACLESID};
    GRANT SELECT on ra_customer_trx to ops\$appl${L_LCORACLESID};
    GRANT SELECT on ar_adjustments to ops\$appl${L_LCORACLESID};
    GRANT SELECT on ap_invoice_distributions to ops\$appl${L_LCORACLESID};
    GRANT SELECT on gl_import_references to ops\$appl${L_LCORACLESID};
    GRANT SELECT on xla_ae_lines to ops\$appl${L_LCORACLESID};
    GRANT SELECT on xla_distribution_links to ops\$appl${L_LCORACLESID};
    GRANT SELECT on xxlcc_gl_base_drill_v to ops\$appl${L_LCORACLESID};
    GRANT EXECUTE on fnd_global to ops\$appl${L_LCORACLESID};
    GRANT EXECUTE on mo_global to ops\$appl${L_LCORACLESID};

    connect xxlcc/custom_${L_ORACLESID}

    show user

    GRANT SELECT ON xxlcc_commet_seq TO ops\$appl${L_LCORACLESID};

SQLEOF
}   ### End of FN_Grants_ops ###


function FN_Notification_Method {
  sqlplus -s /nolog <<SQLEOF
    connect apps/$(FN_GetAPPSPassword $L_ORACLESID)
--    whenever sqlerror exit FAILURE

    prompt   supplier_notif_method  (PRE)
    select  supplier_notif_method, count(1)
    from ap_supplier_sites_all
    WHERE  supplier_notif_method in ('EMAIL','FAX')
    group by supplier_notif_method;

    prompt UPDATE ap_supplier_sites_all
    UPDATE ap_supplier_sites_all
    SET supplier_notif_method = 'PRINT'
    WHERE supplier_notif_method in ('EMAIL','FAX');

    prompt remit_advice_delivery_method (PRE)
    select remit_advice_delivery_method, count(1)
    from iby_external_payees_all
    where remit_advice_delivery_method = 'EMAIL'
    or remit_advice_delivery_method = 'FAX'
    group by remit_advice_delivery_method;

    prompt UPDATE iby_external_payees_all
    update iby_external_payees_all
    set remit_advice_delivery_method = 'PRINTED'
    where remit_advice_delivery_method = 'EMAIL'
    or remit_advice_delivery_method = 'FAX';

    prompt commit;
    commit;

SQLEOF
}   ### End of FN_Notification_Method ###


function FN_User_XXLCC {
  sqlplus -s  /nolog <<SQLEOF
    connect xxlcc/custom_${L_ORACLESID}
    whenever sqlerror exit FAILURE

    show user

    prompt truncate table xxlcc.xxlcc_lob_source_ftp;
    truncate table xxlcc.xxlcc_lob_source_ftp;

    prompt insert into xxlcc.xxlcc_lob_source_ftp values ('STADS', 'ICTDB1',NULL,'stadsftp','D3vEBSgr4b');
    insert into xxlcc.xxlcc_lob_source_ftp values ('STADS', 'ICTDB1',NULL,'stadsftp','D3vEBSgr4b');

    prompt insert into xxlcc.xxlcc_lob_source_ftp values ('HTWM-LHMIS', 'highway1',NULL,'hwtestap','hwD3vt0EBS');
    insert into xxlcc.xxlcc_lob_source_ftp values ('HTWM-LHMIS', 'highway1',NULL,'hwtestap','hwD3vt0EBS');

    prompt insert into xxlcc.xxlcc_lob_source_ftp values ('TALIS', 'Talisdev',NULL,'talisftp','M0b1l3Ph0n3!');
    insert into xxlcc.xxlcc_lob_source_ftp values ('TALIS', 'Talisdev',NULL,'talisftp','M0b1l3Ph0n3!');

    prompt insert into xxlcc.xxlcc_lob_source_ftp values ('DPDPLOB','ascsqltest1',NULL,'cntroctst','V1rtu4l');
    insert into xxlcc.xxlcc_lob_source_ftp values ('DPDPLOB','ascsqltest1',NULL,'cntroctst','V1rtu4l');

    prompt insert into xxlcc.xxlcc_lob_source_ftp values ('FRAMEWORKI','ictdb1',NULL,'fwftp','ImUD3V_FtP');
    insert into xxlcc.xxlcc_lob_source_ftp values ('FRAMEWORKI','ictdb1',NULL,'fwftp','ImUD3V_FtP');

    -- INC0561634
    prompt INSERT INTO xxlcc.xxlcc_lob_source_ftp VALUES ('IASDP','acsqltest01',NULL,'cntroctst','V1rtu4l');
    INSERT INTO xxlcc.xxlcc_lob_source_ftp VALUES ('IASDP','acsqltest01',NULL,'cntroctst','V1rtu4l');

    prompt INSERT INTO xxlcc.xxlcc_lob_source_ftp VALUES ('IASRES','acsqltest01',NULL,'cntroctst','V1rtu4l');
    INSERT INTO xxlcc.xxlcc_lob_source_ftp VALUES ('IASRES','acsqltest01',NULL,'cntroctst','V1rtu4l');

    prompt INSERT INTO xxlcc.xxlcc_lob_source_ftp VALUES ('IASCP','acsqltest01',NULL,'cntroctst','V1rtu4l');
    INSERT INTO xxlcc.xxlcc_lob_source_ftp VALUES ('IASCP','acsqltest01',NULL,'cntroctst','V1rtu4l');

    prompt INSERT INTO xxlcc.xxlcc_lob_source_ftp VALUES ('IASHC','acsqltest01',NULL,'cntroctst','V1rtu4l');
    INSERT INTO xxlcc.xxlcc_lob_source_ftp VALUES ('IASHC','acsqltest01',NULL,'cntroctst','V1rtu4l');

    prompt INSERT INTO xxlcc.xxlcc_lob_source_ftp VALUES ('IASHRS','acsqltest01',NULL,'cntroctst','V1rtu4l');
    INSERT INTO xxlcc.xxlcc_lob_source_ftp VALUES ('IASHRS','acsqltest01',NULL,'cntroctst','V1rtu4l');

    prompt INSERT INTO xxlcc.xxlcc_lob_source_ftp VALUES ('IASSL','acsqltest01',NULL,'cntroctst','V1rtu4l');
    INSERT INTO xxlcc.xxlcc_lob_source_ftp VALUES ('IASSL','acsqltest01',NULL,'cntroctst','V1rtu4l');

    prompt INSERT INTO xxlcc.xxlcc_lob_source_ftp VALUES ('IASDS','acsqltest01',NULL,'cntroctst','V1rtu4l');
    INSERT INTO xxlcc.xxlcc_lob_source_ftp VALUES ('IASDS','acsqltest01',NULL,'cntroctst','V1rtu4l');
    -- end of INC0561634

    -- INC0571352
    prompt INSERT INTO xxlcc.xxlcc_lob_source_ftp (source_name, server, directory, user_name, passwd) VALUES ('LHO_RECEIPTS', 'ictdb1', 'Pending', 'ras2ftp', 'p1x13du5t'); 
    INSERT INTO xxlcc.xxlcc_lob_source_ftp (source_name, server, directory, user_name, passwd) VALUES ('LHO_RECEIPTS', 'ictdb1', 'Pending', 'ras2ftp', 'p1x13du5t'); 
    -- end of INC0571352

    prompt commit;
    commit;

SQLEOF
}   ### End of FN_User_XXLCC ###


function FN_XXLCC_FILE_PATH {
  ## milbyr 20130408 ##l_lc_source=`echo appl${L_S_SID} | tr [:upper:] [:lower:]`
  l_lc_source=`echo ${L_S_SID} | tr [:upper:] [:lower:]`

  ## milbyr 20130408 ##l_lc_target=`echo appl${L_T_SID} | tr [:upper:] [:lower:]`
  l_lc_target=`echo ${L_T_SID} | tr [:upper:] [:lower:]`

  sqlplus -s /nolog <<SQLEOF
    connect apps/$(FN_GetAPPSPassword $L_ORACLESID)
--    whenever sqlerror exit FAILURE
    set lines 120 pages 200 

    select LOOKUP_CODE ||' - '||  MEANING "XXLCC_FILE_PATH mapping (PRE)"
    from fnd_lookup_values
    where LOOKUP_TYPE = 'XXLCC_FILE_PATH';

    update  fnd_lookup_values
    set MEANING =  replace(meaning,'${l_lc_source}','${l_lc_target}')
    , LAST_UPDATE_DATE = sysdate
    where LOOKUP_TYPE = 'XXLCC_FILE_PATH';

    select LOOKUP_CODE ||' - '||  MEANING "XXLCC_FILE_PATH mapping (POST)"
    from fnd_lookup_values
    where LOOKUP_TYPE = 'XXLCC_FILE_PATH';

    commit;
SQLEOF
}   ### End of FN_XXLCC_FILE_PATH ###


function FN_Code_LCAPBCS01_cmd {
  l_date=`date +%Y%m%d`
  l_fn=$XXLCC_TOP/bin/LCAPBCS01.cmd
  l_lc_source=`echo appl${L_S_SID} | tr [:upper:] [:lower:]`
  l_lc_target=`echo appl${L_T_SID} | tr [:upper:] [:lower:]`

  ls -al ${l_fn} && mv ${l_fn} ${l_fn}.${l_date} 

  if [ $? -eq 0 ]; then
   FN_Debug "${l_fn}.${l_date} | sed -e s/${l_lc_source}/${l_lc_target}/g >${l_fn}"
   cat  ${l_fn}.${l_date} | sed -e "s/${l_lc_source}/${l_lc_target}/g" | sed -e "s/apbcspay.dat/apbcspay_test.dat/" >${l_fn}
  else
    FN_Error "FN_Code_LCAPBCS01_cmd: the ${l_fn} file change failed"
  fi
}   ### End of FN_Code_LCAPBCS01_cmd ###


function FN_Code_LCAPBCS01_prog {
  l_date=`date +%Y%m%d`
  l_fn=$XXLCC_TOP/bin/LCAPBCS01.prog

  ls -al ${l_fn} && mv ${l_fn} ${l_fn}.${l_date} 

  if [ $? -eq 0 ]; then
   FN_Debug "${l_fn}.${l_date} | sed -e s/^ftp/#ftp/ >${l_fn}"
   cat  ${l_fn}.${l_date} | sed -e "s/^ftp/\#ftp/"  >${l_fn}
  else
    FN_Error "FN_Code_LCAPBCS01.prog: the ${l_fn} file change failed"
  fi
}   ### End of FN_Code_LCAPBCS01_prog ###


function FN_Code_LCARDDI05_cmd {
  l_date=`date +%Y%m%d`
  l_fn=$XXLCC_TOP/bin/LCARDDI05.cmd

  ls -al ${l_fn} && mv ${l_fn} ${l_fn}.${l_date} 

  if [ $? -eq 0 ]; then
   FN_Debug "${l_fn}.${l_date} | sed -e s/192.168.249.24/192.168.247.152|sed -e s/arddi.dat/arddi_R12TEST.dat/  >${l_fn}"
   cat  ${l_fn}.${l_date} | sed -e "s/192.168.249.24/192.168.247.152/" |sed -e "s/arddi.dat/arddi_R12TEST.dat/" >${l_fn}
  else
    FN_Error "FN_Code_LCARDDI05_cmd: the ${l_fn} file change failed"
  fi
}   ### End of FN_Code_LCARDDI05_cmd ###


function FN_Code_LCARDDI05_prog {
  l_date=`date +%Y%m%d`
  l_fn=$XXLCC_TOP/bin/LCARDDI05.prog

  ls -al ${l_fn} && mv ${l_fn} ${l_fn}.${l_date} 

  if [ $? -eq 0 ]; then
   # INC0612359 #FN_Debug "${l_fn}.${l_date} | sed -e s/^ftp/\#ftp|sed -e s/arddi.dat/arddi_R12TEST.dat/  >${l_fn}"
   # INC0612359 #cat  ${l_fn}.${l_date} | sed -e "s/^ftp/\#ftp/" |sed -e "s/arddi.dat/arddi_R12TEST.dat/" >${l_fn}

    FN_Debug "Post CR259 Implementation Edit of ${l_fn}" 
    cat ${l_fn}.${l_date} | sed -e "83s/^/\#/" | sed -e "88s/DESTINATION/DESTINATION_TEST/" >${l_fn} 

  else
    FN_Error "FN_Code_LCARDDI05_prog: the ${l_fn} file change failed"
  fi
}   ### End of FN_Code_LCARDDI05_prog ###


function FN_Code_LCARDDI06_cmd {
  l_date=`date +%Y%m%d`
  l_fn=$XXLCC_TOP/bin/LCARDDI06.cmd

  ls -al ${l_fn} && mv ${l_fn} ${l_fn}.${l_date} 

  if [ $? -eq 0 ]; then
   FN_Debug "${l_fn}.${l_date} | sed -e s/192.168.249.24/192.168.247.152 |sed -e s/arddrem.dat/arddrem_R12TEST.dat/ >${l_fn}"
   cat  ${l_fn}.${l_date} | sed -e "s/192.168.249.24/192.168.247.152/" |sed -e "s/arddrem.dat/arddrem_R12TEST.dat/">${l_fn}
  else
    FN_Error "FN_Code_LCARDDI06_cmd: the ${l_fn} file change failed"
  fi
}   ### End of FN_Code_LCARDDI06_cmd ###


function FN_Code_LCARDDI06_prog {
  l_date=`date +%Y%m%d`
  l_fn=$XXLCC_TOP/bin/LCARDDI06.prog

  ls -al ${l_fn} && mv ${l_fn} ${l_fn}.${l_date} 

  if [ $? -eq 0 ]; then
   # INC0612359 #FN_Debug "${l_fn}.${l_date} | sed -e s/^ftp/\#ftp|sed -e s/arddrem.dat/arddrem_R12TEST.dat/  >${l_fn}"
   # INC0612359 #cat  ${l_fn}.${l_date} | sed -e "s/^ftp/\#ftp/" |sed -e "s/arddrem.dat/arddrem_R12TEST.dat/" >${l_fn}

   FN_DEBUG "Post CR259 Implementation Edit of ${l_fn}" 
   cat ${l_fn}.${l_date} | sed -e "206s/^/\#/" | sed -e "211s/DESTINATION/DESTINATION_TEST/" >>${l_fn}

  else
    FN_Error "FN_Code_LCARDDI06_prog: the ${l_fn} file change failed"
  fi
}   ### End of FN_Code_LCARDDI06_prog ###


function FN_Code_XXLCC_PAY_BACS_01_prog {
  l_date=`date +%Y%m%d`
  l_fn=$XXLCC_TOP/bin/XXLCC_PAY_BACS_01.prog

  ls -al ${l_fn} && mv ${l_fn} ${l_fn}.${l_date} 

  if [ $? -eq 0 ]; then
   FN_Debug "${l_fn}.${l_date} | sed -e s/^ftp/\#ftp >${l_fn}"
   cat  ${l_fn}.${l_date} | sed -e "s/^ftp/\#ftp/" >${l_fn}
  else
    FN_Error "FN_Code_XXLCC_PAY_BACS_01_prog: the ${l_fn} file change failed"
  fi
}   ### End of FN_Code_XXLCC_PAY_BACS_01_prog ###


function FN_Code_LCCCA_R12_sql {
  l_date=`date +%Y%m%d`
  l_fn=$XXLCC_TOP/sql/LCCCA_R12.sql

  ls -al ${l_fn} && mv ${l_fn} ${l_fn}.${l_date} 

  if [ $? -eq 0 ]; then
   FN_Debug "${l_fn}.${l_date} | sed -e s/lpms_dds/tpms_dds >${l_fn}"
   cat  ${l_fn}.${l_date} | sed -e "s/lpms_dds/tpms_dds/" >${l_fn}
  else
    FN_Error "FN_Code_LCCCA_R12_sql: the ${l_fn} file change failed"
  fi
}   ### End of FN_Code_LCCCA_R12_sql ###


function FN_Code_LCCDLO_R12_sql {
  l_date=`date +%Y%m%d`
  l_fn=$XXLCC_TOP/sql/LCCDLO_R12.sql

  ls -al ${l_fn} && mv ${l_fn} ${l_fn}.${l_date} 

  if [ $? -eq 0 ]; then
   FN_Debug "${l_fn}.${l_date} | sed -e s/^HOST/--HOST >${l_fn}"
   cat  ${l_fn}.${l_date} | sed -e "s/^HOST/--HOST/" >${l_fn}
  else
    FN_Error "FN_Code_LCCDLO_R12_sql: the ${l_fn} file change failed"
  fi
}   ### End of FN_Code_LCCDLO_R12_sql ###


function FN_Code_LCCCOMMET_R12_sql {
  l_date=`date +%Y%m%d`
  l_fn=$XXLCC_TOP/sql/LCCCOMMET_R12.sql
  l_lc_source=`echo appl${L_S_SID} | tr [:upper:] [:lower:]`
  l_lc_target=`echo appl${L_T_SID} | tr [:upper:] [:lower:]`

  ls -al ${l_fn} && mv ${l_fn} ${l_fn}.${l_date} 

  if [ $? -eq 0 ]; then
   FN_Debug "${l_fn}.${l_date} | sed -e s/${L_S_SID}/${L_T_SID} | sed -e s/${l_lc_source}/${l_lc_target}/g | sed -e s/clbr_/tlbr_/g >${l_fn}"
   cat ${l_fn}.${l_date} | sed -e "s/${L_S_SID}/${L_T_SID}/" | sed -e "s/${l_lc_source}/${l_lc_target}/g" | sed -e "s/clbr_/tlbr_/g" >${l_fn}
  else
    FN_Error "FN_Code_LCCCOMMET_R12_sql: the ${l_fn} file change failed"
  fi
}   ### End of FN_Code_LCCCOMMET_R12_sql ###


function FN_Code_xdodelivery_cfg {
  l_date=`date +%Y%m%d`
  l_fn=$XDO_TOP/resource/xdodelivery.cfg

  ls -al ${l_fn} && mv ${l_fn} ${l_fn}.disabled

  if [ $? -eq 0 ]; then
   FN_Debug "${l_fn}.disabled "
  else
    FN_Error "FN_Code_xdodelivery_cfg: the ${l_fn} file change failed"
  fi
}   ### End of FN_Code_xdodelivery_cfg ###


function FN_Code_xdo_cfg {
  l_date=`date +%Y%m%d`
  l_fn=$OA_JRE_TOP/lib/xdo.cfg

  ls -al ${l_fn} && mv ${l_fn} ${l_fn}.${l_date}

  if [ $? -eq 0 ]; then
   FN_Debug "${l_fn}.${l_date} | sed -e s/${l_lc_source}/${l_lc_target}/g"
   cat ${l_fn}.${l_date} | sed -e s/${l_lc_source}/${l_lc_target}/g > ${l_fn}
  else
    FN_Error "FN_Code_xdo_cfg: the ${l_fn} file change failed"
  fi
}   ### End of FN_Code_xdo_cfg ###



function FN_Code_dloxmit {
  l_date=`date +%Y%m%d`
  l_fn=$XXLCC_TOP/bin/dloxmit

  ls -al ${l_fn} && mv ${l_fn} ${l_fn}.${l_date} 

  if [ $? -eq 0 ]; then
   FN_Debug "${l_fn}.${l_date} | sed -e s/\/home\/dloxfer/\/tmp >${l_fn}"
   cat ${l_fn}.${l_date} | sed -e "s/\/home\/dloxfer/\/tmp/" >${l_fn}
  else
    FN_Error "FN_Code_dloxmit: the ${l_fn} file change failed"
  fi
}   ### End of FN_Code_dloxmit ###


function FN_Code_dairyxmit {
  l_date=`date +%Y%m%d`
  l_fn=$XXLCC_TOP/bin/dairyxmit

  ls -al ${l_fn} && mv ${l_fn} ${l_fn}.${l_date} 

  if [ $? -eq 0 ]; then
   FN_Debug "${l_fn}.${l_date} | sed -e s/\/eddb60\/live\//\/eddb60\/demo\// >${l_fn}"
   cat ${l_fn}.${l_date} | sed -e "s/\/eddb60\/live\//\/eddb60\/demo\//" >${l_fn}
  else
    FN_Error "FN_Code_dairyxmit: the ${l_fn} file change failed"
  fi
}   ### End of FN_Code_dairyxmit ###


function FN_Code_XXLCC_PAY_BACS_01_cmd {
  l_date=`date +%Y%m%d`
  l_fn=$XXLCC_TOP/bin/XXLCC_PAY_BACS_01.cmd
  l_lc_source=`echo appl${L_S_SID} | tr [:upper:] [:lower:]`
  l_lc_target=`echo appl${L_T_SID} | tr [:upper:] [:lower:]`

  ls -al ${l_fn} && mv ${l_fn} ${l_fn}.${l_date} 

  if [ $? -eq 0 ]; then
   FN_Debug "${l_fn}.${l_date} | sed -e s/${l_lc_source}/${l_lc_target}/g >${l_fn}"
   cat ${l_fn}.${l_date} | sed -e "s/${l_lc_source}/${l_lc_target}/g" >${l_fn}
  else
    FN_Error "FN_Code_XXLCC_PAY_BACS_01_cmd: the ${l_fn} file change failed"
  fi
}   ### End of FN_Code_XXLCC_PAY_BACS_01_cmd ###


function FN_Code_bucksnet_sh {
  l_date=`date +%Y%m%d`
  l_fn=$XXLCC_TOP/bin/bucksnet.sh
  l_lc_source=`echo appl${L_S_SID} | tr [:upper:] [:lower:]`
  l_lc_target=`echo appl${L_T_SID} | tr [:upper:] [:lower:]`

  ls -al ${l_fn} && mv ${l_fn} ${l_fn}.${l_date} 

  if [ $? -eq 0 ]; then
   FN_Debug "${l_fn}.${l_date} | sed -e s/${l_lc_source}/${l_lc_target}/g >${l_fn}"
   cat ${l_fn}.${l_date} | sed -e "s/${l_lc_source}/${l_lc_target}/g" >${l_fn}
  else
    FN_Error "FN_Code_bucksnet_sh: the ${l_fn} file change failed"
  fi
}   ### End of FN_Code_bucksnet_sh ###


function FN_Code_kings_sh {
  l_date=`date +%Y%m%d`
  l_fn=$XXLCC_TOP/bin/kings.sh
  l_lc_source=`echo appl${L_S_SID} | tr [:upper:] [:lower:]`
  l_lc_target=`echo appl${L_T_SID} | tr [:upper:] [:lower:]`

  ls -al ${l_fn} && mv ${l_fn} ${l_fn}.${l_date} 

  if [ $? -eq 0 ]; then
   FN_Debug "${l_fn}.${l_date} | sed -e s/${l_lc_source}/${l_lc_target}/g >${l_fn}"
   cat ${l_fn}.${l_date} | sed -e "s/${l_lc_source}/${l_lc_target}/g" >${l_fn}
  else
    FN_Error "FN_Code_kings_sh: the ${l_fn} file change failed"
  fi
}   ### End of FN_Code_kings_sh ###


function FN_Code_avco_ba2_sh_VELOS {
  l_date=`date +%Y%m%d`
  l_fn=$XXLCC_TOP/bin/avco_ba2.sh.VELOS
  l_lc_source=`echo appl${L_S_SID} | tr [:upper:] [:lower:]`
  l_lc_target=`echo appl${L_T_SID} | tr [:upper:] [:lower:]`

  ls -al ${l_fn} && mv ${l_fn} ${l_fn}.${l_date} 

  if [ $? -eq 0 ]; then
   FN_Debug "${l_fn}.${l_date} | sed -e s/${l_lc_source}/${l_lc_target}/g >${l_fn}"
   cat ${l_fn}.${l_date} | sed -e "s/${l_lc_source}/${l_lc_target}/g" >${l_fn}
  else
    FN_Error "FN_Code_avco_ba2_sh_VELOS: the ${l_fn} file change failed"
  fi
}   ### End of FN_Code_avco_ba2_sh_VELOS ###


function FN_Code_avco_irs_sh_VELOS {
  l_date=`date +%Y%m%d`
  l_fn=$XXLCC_TOP/bin/avco_irs.sh.VELOS
  l_lc_source=`echo appl${L_S_SID} | tr [:upper:] [:lower:]`
  l_lc_target=`echo appl${L_T_SID} | tr [:upper:] [:lower:]`

  ls -al ${l_fn} && mv ${l_fn} ${l_fn}.${l_date} 

  if [ $? -eq 0 ]; then
   FN_Debug "${l_fn}.${l_date} | sed -e s/${l_lc_source}/${l_lc_target}/g >${l_fn}"
   cat ${l_fn}.${l_date} | sed -e "s/${l_lc_source}/${l_lc_target}/g" >${l_fn}
  else
    FN_Error "FN_Code_avco_irs_sh_VELOS: the ${l_fn} file change failed"
  fi
}   ### End of FN_Code_avco_irs_sh_VELOS ###


function FN_Alert_Options {
  l_lc_source=`echo appl${L_S_SID} | tr [:upper:] [:lower:]`
  l_lc_target=`echo appl${L_T_SID} | tr [:upper:] [:lower:]`

  sqlplus -s /nolog <<SQLEOF
    connect apps/$(FN_GetAPPSPassword $L_ORACLESID)
--    whenever sqlerror exit FAILURE
    set lines 120 pages 200 

    select PROFILE_OPTION_NAME ||'-'|| PROFILE_OPTION_VALUE "(pre change)"
    from ALR.ALR_PROFILE_OPTIONS
    where PROFILE_OPTION_NAME='DIAGNOSTICS_MESSAGE_FILE';

    update ALR.ALR_PROFILE_OPTIONS
    set PROFILE_OPTION_VALUE = '/${l_lc_target}/apps/apps_st/appl/alr/12.0.0/bin/alrmsg'
    where PROFILE_OPTION_NAME='DIAGNOSTICS_MESSAGE_FILE';

    select PROFILE_OPTION_NAME ||'-'|| PROFILE_OPTION_VALUE "(post change)"
    from ALR.ALR_PROFILE_OPTIONS
    where PROFILE_OPTION_NAME='DIAGNOSTICS_MESSAGE_FILE';

    commit;
SQLEOF
}    ### End of FN_Alert_Options ###
  

function FN_FILE_PATH_IBY {
  l_lc_source=`echo appl${L_S_SID} | tr [:upper:] [:lower:]`
  l_lc_target=`echo appl${L_T_SID} | tr [:upper:] [:lower:]`
  l_pp=`expr 8000 \+ $L_PORT`

  sqlplus -s /nolog <<SQLEOF
    connect apps/$(FN_GetAPPSPassword $L_ORACLESID)
--    whenever sqlerror exit FAILURE
    set lines 120 pages 200 
  
    select TRANSMIT_PARAMETER_CODE||'-'||TRANSMIT_VARCHAR2_VALUE "(pre change)"
    from IBY.IBY_TRANSMIT_VALUES
    where TRANSMIT_PARAMETER_CODE = 'FILE_DIR';

    update  iby.iby_transmit_values
 -- set transmit_varchar2_value =  replace(replace(transmit_varchar2_value,'${l_lc_source}','${l_lc_target}'),'/appl/','/custom/')
    set transmit_varchar2_value = '/${l_lc_target}/csf/outbound/AR_BACS_OUT'
    where transmit_parameter_code = 'FILE_DIR';

    select TRANSMIT_PARAMETER_CODE||'-'||TRANSMIT_VARCHAR2_VALUE "(post change)"
    from IBY.IBY_TRANSMIT_VALUES
    where TRANSMIT_PARAMETER_CODE = 'FILE_DIR';

    select NAME ||'-'|| BASEURL "(pre change)"
    from IBY.IBY_BEPINFO
    where NAME='XXLCC_CREDIT_CARD';

    update apps.IBY_BEPINFO 
    set BASEURL='http://${L_IASSRV}.$(FN_GetDBDomain):${l_pp}/OA_HTML' 
    where NAME='XXLCC_CREDIT_CARD';

    select NAME ||'-'|| BASEURL "(post change)"
    from IBY.IBY_BEPINFO
    where NAME='XXLCC_CREDIT_CARD';

    select SYSTEM_PROFILE_CODE ||'-'|| OUTBOUND_PMT_FILE_DIRECTORY "(pre change)"
    from IBY.IBY_SYS_PMT_PROFILES_B 
    where SYSTEM_PROFILE_CODE = 'IBY_PAY_EFT_BACS_UK_10001';

    --Nr-13013057 - updated
    update IBY.IBY_SYS_PMT_PROFILES_B
    set OUTBOUND_PMT_FILE_DIRECTORY = '/${l_lc_target}/appl/csf/outbound/leics/BACS_OUT'
    where SYSTEM_PROFILE_CODE = 'IBY_PAY_EFT_BACS_UK_10001';

    select SYSTEM_PROFILE_CODE ||'-'|| OUTBOUND_PMT_FILE_DIRECTORY "(post change)"
    from IBY.IBY_SYS_PMT_PROFILES_B 
    where SYSTEM_PROFILE_CODE = 'IBY_PAY_EFT_BACS_UK_10001';

    commit;
SQLEOF
}   ### End of FN_FILE_PATH_IBY ###


function FN_EBS_User_Enddate {
  FN_Debug "FN_EBS_User_Enddate :: start"

  sqlplus -s  /nolog <<SQLEOF
    connect apps/$(FN_GetAPPSPassword $L_ORACLESID)
    whenever sqlerror exit FAILURE

-- 20120419 -- where user_name NOT in ( 'GUEST', 'SYSADMIN', 'APPSMGR', 'AUTOINSTALL', 'SSTOTT', 'CPICKERING')

   BEGIN
     DECLARE
    
       CURSOR curUsers IS
         SELECT user_name, end_date
         FROM fnd_user
         WHERE NVL( end_date, SYSDATE + 1 ) > SYSDATE
           AND user_name NOT IN ('SYSADMIN', 'APPSMGR', 'AUTOINSTALL', 'GUEST');
    
     BEGIN
       FOR lrecUser IN curUsers  LOOP
         fnd_user_pkg.DisableUser( lrecUser.user_name );
       END LOOP;
     END;
  END;
  /

SQLEOF

  if [ $? -eq 0 ]; then
    FN_Debug "  users end-dated"
  else
    FN_Debug "   user end-dating FAILED"
  fi
  FN_Debug "FN_EBS_User_Enddate :: end"
}   ### End of FN_EBS_User_Enddate ###


function  FN_frmcmp_batch {
  ## This is a work-around for an Oracle problem.
  ## It is fixed with 11gR2 techstack patching and 12.1
  ##
  echo "FN_frmcmp_batch"
  mv $ORACLE_HOME/bin/frmcmp_batch.sh $ORACLE_HOME/bin/frmcmp_batch.sh.autoconfig
  cat $ORACLE_HOME/bin/frmcmp_batch.sh.autoconfig | sed -e "s/TNS_ADMIN/#TNS_ADMIN/;s/  TWO_TASK=PRD3/#  TWO_TASK=do_not_set/" >$ORACLE_HOME/bin/frmcmp_batch.sh
  chmod 755 ${ORACLE_HOME}/bin/frmcmp_batch.sh
  grep TNS_ADMIN $ORACLE_HOME/bin/frmcmp_batch.sh
  grep TWO_TASK  $ORACLE_HOME/bin/frmcmp_batch.sh
}   ### End of FN_frmcmp_batch ###


function FN_Create_SQL_Account {
  FN_Debug "FN_Create_SQL_Account :: start"
  L_SQL_USER=${1:?"Missing the SQL User Account name"}
  FN_Debug "FN_Create_SQL_Account:  New sql user $L_SQL_USER"

  sqlplus -s  /nolog <<SQLEOF
    connect apps/$(FN_GetAPPSPassword $L_ORACLESID)
    set echo on
    whenever sqlerror exit FAILURE

    CREATE USER $L_SQL_USER IDENTIFIED BY $L_SQL_USER 
    PASSWORD EXPIRE
    temporary tablespace temp
    default tablespace AOCDAT;

    GRANT CREATE SESSION, ALTER SESSION, RESOURCE, CONNECT TO $L_SQL_USER;

    GRANT SELECT any table TO $L_SQL_USER;

SQLEOF

  if [ $? -eq 0 ]; then
    FN_Debug "  user $L_SQL_USER created"
  else
    FN_Debug "   user $L_SQL_USER FAILED to be created"
  fi
  FN_Debug "FN_Create_SQL_Account :: end"
}


function FN_custom_fndpcesr {

  # CUSTOM XXLCC_TOP
  # Remove the symbolically linked files
  # recreate the symbolic links to the correct application structure

  ## Nr-13006084 - 4 custom tops
  for CUST_LN in xxlcc xxmig xxleics xxntcty
  do
    echo "rm /${L_APPLUSER}/apps/apps_st/appl/${CUST_LN}"
    rm /${L_APPLUSER}/apps/apps_st/appl/${CUST_LN}

    echo "ln -s /${L_APPLUSER}/apps/apps_st/custom/${CUST_LN} /${L_APPLUSER}/apps/apps_st/appl/${CUST_LN}"
    ln -s /${L_APPLUSER}/apps/apps_st/custom/${CUST_LN} /${L_APPLUSER}/apps/apps_st/appl/${CUST_LN}
  done

  LC_S_SID=`echo $L_S_SID | tr [:upper:] [:lower:]`

  echo " LC_S_SID is set to $LC_S_SID   - ${L_APPLUSER}"

  ## Nr-13006084 - 4 custom tops
  for L_CUST_DIR in $XXLCC_TOP $XXLEICS_TOP $XXMIG_TOP $XXNTCTY_TOP
  do
    echo "= = = = = = = = = $L_CUST_DIR = = = = = = = = ="
    cd ${L_CUST_DIR}/bin && ls -al |grep fndcpesr|awk '{print $9" "$11}'|while read OFN DFN
    do
      ## ls -al $OFN
      DFN=`echo $DFN | sed -e "s/appl${LC_S_SID}/${L_APPLUSER}/g"`
      ###mv   $OFN $OFN.orig
      echo " removing $OFN"
      rm  $OFN
      echo "sym. link $DFN $OFN"
      ln -s $DFN $OFN
    done
  done

}   ### end of FN_custom_fndpcesr ###


function FN_HR_Profile_Values {
  ## 20120810 milbyr Nr-12026683 - from Di ##
  l_lc_source=`echo appl${L_S_SID} | tr "[:upper:]" "[:lower:]"`
  l_lc_target=`echo appl${L_T_SID} | tr "[:upper:]" "[:lower:]"`

  sqlplus -s /nolog <<SQLEOF
    connect apps/$(FN_GetAPPSPassword $L_ORACLESID)
--    whenever sqlerror exit FAILURE
    set lines 120 pages 200  feedback on echo on  verify on

      prompt 'HR: Intermediate File Output Storage Folder (PER_P11D_OUTPUT_FOLDER)${l_lc_source} ${l_lc_target}'          
      
      prompt 'PER_P11D_OUTPUT_FOLDER profile option value'
      select V.PROFILE_OPTION_VALUE
      from fnd_profile_option_values V
      where V.PROFILE_OPTION_ID in 
        ( select  O.PROFILE_OPTION_ID
          from fnd_profile_options O
          where O.PROFILE_OPTION_NAME = 'PER_P11D_OUTPUT_FOLDER')
        and V.PROFILE_OPTION_VALUE like '%${l_lc_source}%';
      
      update fnd_profile_option_values
      set PROFILE_OPTION_VALUE = '/${l_lc_target}/csf/out'
      where PROFILE_OPTION_ID in 
        ( select  O.PROFILE_OPTION_ID
          from fnd_profile_options O
          where O.PROFILE_OPTION_NAME = 'PER_P11D_OUTPUT_FOLDER')
        and PROFILE_OPTION_VALUE like '%${l_lc_source}%';
      
      prompt 'Updated - PER_P11D_OUTPUT_FOLDER profile option value'
      select V.PROFILE_OPTION_VALUE
      from fnd_profile_option_values V
      where V.PROFILE_OPTION_ID in 
        ( select  O.PROFILE_OPTION_ID
          from fnd_profile_options O
          where O.PROFILE_OPTION_NAME = 'PER_P11D_OUTPUT_FOLDER');
      
      
      prompt 'HR: Data Exchange directory (PER_DATA_EXCHANGE_DIR)'
      
      
      prompt 'PER_DATA_EXCHANGE_DIR profile option value'
      select V.PROFILE_OPTION_VALUE
      from fnd_profile_option_values V
      where V.PROFILE_OPTION_ID in 
        ( select  O.PROFILE_OPTION_ID
          from fnd_profile_options O
          where O.PROFILE_OPTION_NAME = 'PER_DATA_EXCHANGE_DIR')
        and V.PROFILE_OPTION_VALUE like '%${l_lc_source}%';
      
      update fnd_profile_option_values
        set PROFILE_OPTION_VALUE = '/${l_lc_target}/csf/temp'
      where PROFILE_OPTION_ID in 
        ( select  O.PROFILE_OPTION_ID
          from fnd_profile_options O
          where O.PROFILE_OPTION_NAME = 'PER_DATA_EXCHANGE_DIR')
        and PROFILE_OPTION_VALUE like '%${l_lc_source}%';
      
      prompt 'Updated - PER_DATA_EXCHANGE_DIR profile option value'
      select V.PROFILE_OPTION_VALUE
      from fnd_profile_option_values V
      where V.PROFILE_OPTION_ID in 
        ( select  O.PROFILE_OPTION_ID
          from fnd_profile_options O
          where O.PROFILE_OPTION_NAME = 'PER_DATA_EXCHANGE_DIR');
          commit;
SQLEOF
}    ### End of FN_HR_Profile_Values ###

function FN_File_Tidy {
  #  remove the temporary files
  echo "executing - find /${L_APPLUSER}/csf/temp -type f -print | xargs rm -f"
  find /${L_APPLUSER}/csf/temp -type f -print | xargs rm -f

}   ### End of FN_File_Tidy ###


function FN_clear_xxlcc_sftp_tables
{
  sqlplus -s /nolog <<EOSQL
    connect apps/$(FN_GetAPPSPassword $L_ORACLESID)
    set echo on verify on feedback on serveroutput on

    prompt 'clearing xxlcc sftp interface tables'
    prompt '===================================='

    select count(*) from XXLCC.XXLCC_FILE_TYPE_PATHS_TO_CLEAR;
    select count(*) from XXLCC.XXLCC_FILE_TRX_CREDENTIALS;

    delete from XXLCC.XXLCC_FILE_TYPE_PATHS_TO_CLEAR;
    delete from XXLCC.XXLCC_FILE_TRX_CREDENTIALS;

    select count(*) from XXLCC.XXLCC_FILE_TYPE_PATHS_TO_CLEAR;
    select count(*) from XXLCC.XXLCC_FILE_TRX_CREDENTIALS;

EOSQL
}   ### End of FN_clear_xxlcc_sftp_tables ###


function FN_ap_bacs
{
  sqlplus -s /nolog <<EOSQL
    connect apps/$(FN_GetAPPSPassword $L_ORACLESID)
    set echo on verify on feedback on serveroutput on

    prompt 'changing the organsisation profile option  XXLCC: Profile for AP BACS Filename'
    prompt '===================================='

    select v.proFILE_OPTION_VALUE
    from fnd_profile_option_values V
    where V.PROFILE_OPTION_ID in
      ( select  O.PROFILE_OPTION_ID
        from fnd_profile_options O
        where O.PROFILE_OPTION_NAME = 'XXLCC_AP_BACS_FILENAME')
     and V.PROFILE_OPTION_VALUE  like 'apbcspay%.dat';

    update fnd_profile_option_values
    set PROFILE_OPTION_VALUE = replace(PROFILE_OPTION_VALUE,'.','_test.')
    where PROFILE_OPTION_ID in
        ( select  O.PROFILE_OPTION_ID
          from fnd_profile_options O
          where O.PROFILE_OPTION_NAME = 'XXLCC_AP_BACS_FILENAME')
     and PROFILE_OPTION_VALUE  like 'apbcspay%.dat';

    select v.proFILE_OPTION_VALUE
    from fnd_profile_option_values V
    where V.PROFILE_OPTION_ID in
      ( select  O.PROFILE_OPTION_ID
        from fnd_profile_options O
        where O.PROFILE_OPTION_NAME = 'XXLCC_AP_BACS_FILENAME')
     and V.PROFILE_OPTION_VALUE  like 'apbcspay%.dat';


    prompt 'clearing xxlcc bacs lookup table'
    prompt '===================================='

    select count(*), FILE_TYPE
    from xxlcc_file_trx_credentials
    where FILE_TYPE = 'BACS_OUT'
    group by FILE_TYPE;

    delete 
    from xxlcc_file_trx_credentials
    where FILE_TYPE = 'BACS_OUT'

EOSQL
}   ### End of FN_ap_bacs ###


function FN_xml_publisher
{
  sqlplus -s /nolog <<EOSQL
    connect apps/$(FN_GetAPPSPassword $L_ORACLESID)
    set echo on verify on feedback on serveroutput on

    prompt 'Current XML Publisher temp dir setting'
    prompt '===================================='

    select property_code, value
    from  XDO_CONFIG_VALUES
    where property_code = 'SYSTEM_TEMP_DIR';
  
    prompt 'changing the XML Publisher temp dir'
    prompt '===================================='
  
    update XDO_CONFIG_VALUES
      set value = '/${L_APPLUSER}/csf/temp'
    where PROPERTY_CODE = 'SYSTEM_TEMP_DIR';

    commit;
  
    prompt 'New XML Publisher temp dir setting'
    prompt '===================================='
  
    select property_code, value
    from  XDO_CONFIG_VALUES
    where property_code = 'SYSTEM_TEMP_DIR';

EOSQL
}   ### End of FN_xml_publisher ###
#
#
#
#
function FN_remove_tcp_invited_nodes
{
  l_date=`date +%Y%m%d`
  l_fn=$TNS_ADMIN/sqlnet.ora
  #
  ls -al ${l_fn} && mv ${l_fn} ${l_fn}.${l_date}
  if [ $? -eq 0 ]; then
    cat ${l_fn}.${l_date} | sed -e "s/^tcp.validnode_checking/\#tcp.validnode_checking/" | sed -e "s/^tcp.invited_nodes/\#tcp.invited_nodes/" > ${l_fn}
  else
    FN_Error "FN_remove_tcp_invited_nodes: the ${l_fn} file change failed"
  fi
}   ### END of FN_remove_tcp_invited_nodes ###
#
#
#
function FN_Truncate_ICX_Tables {
  #
  # Truncate the ICX tables that have grown to be too large for the concurrent jobs to delete
  #
  sqlplus -s /nolog <<EOSQL
    connect apps/$(FN_GetAPPSPassword $L_ORACLESID)
    whenever sqlerror exit FAILURE
      set lines 200
      col segment_name for a30
      prompt 'Truncate the ICX tables that have grown to be too large for the concurrent jobs to delete'
      prompt '========================================================================================='
        select OWNER, SEGMENT_NAME, BYTES/1024/1024 Mb
        from dba_segments
        where SEGMENT_NAME in (
        'ICX_SESSIONS',
        'ICX_SESSION_ATTRIBUTES',
        'ICX_TRANSACTIONS',
        'ICX_TEXT',
        'ICX_CONTEXT_RESULTS_TEMP',
        'ICX_FAILURES',
        'FND_SESSION_VALUES'
        );

        prompt '=== part of FNDDLTMP.sql ==='
	truncate table ICX.ICX_SESSIONS;
	truncate table ICX.ICX_SESSION_ATTRIBUTES;
	truncate table ICX.ICX_TRANSACTIONS;
	truncate table ICX.ICX_TEXT;
	truncate table ICX.ICX_CONTEXT_RESULTS_TEMP;
	truncate table ICX.ICX_FAILURES;
	truncate table APPLSYS.FND_SESSION_VALUES;

	prompt '==== not part of FNDDLTMP.sql ==='
	truncate table APPLSYS.FND_LOGINS;
	truncate table APPLSYS.FND_LOGIN_RESP_FORMS;
	truncate table APPLSYS.FND_LOGIN_RESPONSIBILITIES;
	truncate table APPLSYS.FND_UNSUCCESSFUL_LOGINS;

	select OWNER, SEGMENT_NAME, BYTES/1024/1024 Mb
	from dba_segments
	where SEGMENT_NAME in (
	'ICX_SESSIONS',
	'ICX_SESSION_ATTRIBUTES',
	'ICX_TRANSACTIONS',
	'ICX_TEXT',
	'ICX_CONTEXT_RESULTS_TEMP',
	'ICX_FAILURES',
	'FND_SESSION_VALUES'
	);

EOSQL

}   ### End of FN_Truncate_ICX_Tables ###
#
#
#
#
function FN_Main
{
  FN_Init_Vars $L_T_SID
  FN_List_Vars

  while  ( [ $L_COMPLETE -eq 1 ] && [ $L_ERROR -eq 0 ] )
  do
    case $L_STEP in
      1)
        echo "at step $L_STEP: FN_AppsTier"
        FN_APPS_Env noappsora
        $(FN_IS_CP_TIER) && FN_startmgr move_out
        FN_AppsTier
        FN_Inc
#        L_COMPLETE=0
        ;;
      2)
        echo "at step $L_STEP: FN_APPS_STOP"
        FN_APPS_Env appsora

        if [ $(hostname) = "${L_CPSRV}" ]; then
          echo "## milbyr 20140513 ## FN_APPS_STOP  $(FN_GetAPPSPassword $L_S_SID)"
        else
          FN_APPS_STOP  $(FN_GetAPPSPassword $L_T_SID)
        fi

        FN_Inc
#        L_COMPLETE=0
        ;;
      3)
        echo "at step $L_STEP: FN_Change_PWD"
        FN_APPS_Env appsora

        if [ $(hostname) = "${L_CPSRV}" ]; then
          $(FN_IS_CP_TIER) && FN_Change_PWD
        fi
        FN_Inc
  #      L_COMPLETE=0
        ;;
      4)
        echo "at step $L_STEP: FN_EBS_Branding"
        FN_APPS_Env appsora
        $(FN_IS_CP_TIER) && FN_EBS_Branding
        FN_Inc
  #      L_COMPLETE=0
        ;;
      5)
        echo "at step $L_STEP: FN_context_change"
        FN_APPS_Env appsora
        FN_context_change
        FN_Inc
  #      L_COMPLETE=0
        ;;
      6)
        echo "at step $L_STEP: FN_Autoconfig"
        FN_APPS_Env appsora
        FN_Autoconfig
        FN_Inc
  #      L_COMPLETE=0
        ;;
      7)
        echo "at step $L_STEP: FN_tns_ifile"
        FN_APPS_Env appsora
        FN_tns_ifile
        FN_Inc
  #      L_COMPLETE=0
        ;;
      8)
        echo "at step $L_STEP: FN_Site_Profile_Values"
        FN_APPS_Env appsora
        $(FN_IS_CP_TIER) && FN_Site_Profile_Values
        FN_Inc
  #      L_COMPLETE=0
        ;;
      9)
        echo "at step $L_STEP: FN_IGI_CISProxyServer"  
        FN_APPS_Env appsora
        $(FN_IS_CP_TIER) && FN_IGI_CISProxyServer
        FN_Inc
  #      L_COMPLETE=0
        ;;
      10)
        echo "at step $L_STEP: FN_Wisdom"
        if $(FN_IS_CP_TIER) ; then
          FN_APPS_Env appsora
          FN_Wisdom
        fi
        FN_Inc
  #      L_COMPLETE=0
        ;;
      11)
        echo "at step $L_STEP: FN_setWorkflow"
        FN_APPS_Env appsora
        FN_setWorkflow
        FN_Inc
  #     L_COMPLETE=0
        ;;
      12)
        echo "at step $L_STEP: FN_Alert_Options"
        if $(FN_IS_CP_TIER) ; then
          FN_APPS_Env appsora
          FN_Alert_Options
        fi
        FN_Inc
  #      L_COMPLETE=0
        ;;
      13)
        echo "at step $L_STEP: FN_custom_fndpcesr"
        FN_APPS_Env appsora
        $(FN_IS_CP_TIER) && FN_custom_fndpcesr
        FN_Inc
  #      L_COMPLETE=0
        ;;
      14)
        echo "at step $L_STEP: FN_startmgr_move_in"
        FN_APPS_Env appsora
        $(FN_IS_CP_TIER) && FN_startmgr move_in
	# Used to start Apps Services however autoconfig on web tier
	#  will cause library issues so do not start here
	# FN_APPS_START $L_APPSPWD
        FN_Inc
  #      L_COMPLETE=0
        ;;
      15)
        echo "at step $L_STEP: FN_Profiles various"
        
        ## milbyr 20131230 ## if $(FN_IS_CP_TIER) ; then
          FN_APPS_Env appsora
        
          FN_Profiles_BNE
          FN_Profiles_XXLCC
          FN_Profiles_Debug
          FN_Profiles_PER
          FN_Profiles_IGI
          FN_Profiles_IBY
          FN_Profiles_OBIEE
          FN_Profiles_NCC
       # fi

        FN_Inc
   #     L_COMPLETE=0
        ;;
      16)
        echo "at step $L_STEP: FN_DBLINKS various"
        if $(FN_IS_CP_TIER) ; then
          FN_APPS_Env appsora

          FN_DBLINKS_APPS
          FN_DBLINKS_SKY_USER
          FN_DBLINKS_ARTS_USER
          FN_DBLINKS_TAR_USER
          FN_DBLINKS_CTS_USER
          FN_DBLINKS_CDS_USER
          FN_DBLINKS_BODATA
        fi

        FN_Inc
   #     L_COMPLETE=0
        ;;
      17)
        echo "at step $L_STEP: FN_Grants various"
        if $(FN_IS_CP_TIER) ; then
          FN_APPS_Env appsora
          FN_Grants_ops
        fi
        FN_Inc
   #     L_COMPLETE=0
        ;;
      18)
        echo "at step $L_STEP: FN_Notification_Method"
        if $(FN_IS_CP_TIER) ; then
          FN_APPS_Env appsora
          FN_Notification_Method 
        fi
        FN_Inc
   #     L_COMPLETE=0
        ;;
      19)
        echo "at step $L_STEP: FN_User_XXLCC"
        if $(FN_IS_CP_TIER) ; then
          FN_APPS_Env appsora
          FN_User_XXLCC
        fi
        FN_Inc
   #     L_COMPLETE=0
        ;;
      20)
        echo "at step $L_STEP: FN_XXLCC_FILE_PATH"
        if $(FN_IS_CP_TIER) ; then
          FN_APPS_Env appsora
          FN_XXLCC_FILE_PATH
        fi
        FN_Inc
   #     L_COMPLETE=0
        ;;
      21)
        echo "at step $L_STEP: FN_Code various"
        if $(FN_IS_CP_TIER) ; then
          FN_APPS_Env appsora

           # Removed by Nr-13001994
           #FN_Code_LCAPBCS01_cmd
           #FN_Code_LCAPBCS01_prog

           FN_Code_LCARDDI05_cmd
           FN_Code_LCARDDI05_prog

           FN_Code_LCARDDI06_cmd
           FN_Code_LCARDDI06_prog

           FN_Code_XXLCC_PAY_BACS_01_prog
           FN_Code_LCCCA_R12_sql
           FN_Code_LCCDLO_R12_sql
           FN_Code_LCCCOMMET_R12_sql
           FN_Code_xdodelivery_cfg
           FN_Code_xdo_cfg
           FN_Code_dloxmit
           FN_Code_dairyxmit
           FN_Code_XXLCC_PAY_BACS_01_cmd
           FN_Code_bucksnet_sh
           FN_Code_kings_sh
           FN_Code_avco_ba2_sh_VELOS
           FN_Code_avco_irs_sh_VELOS
        fi
        FN_Inc
   #     L_COMPLETE=0
        ;;
      22)
        echo "at step $L_STEP: FN_FILE_PATH_IBY"
        if $(FN_IS_CP_TIER) ; then
          FN_APPS_Env appsora
          FN_FILE_PATH_IBY
        fi
        FN_Inc
   #     L_COMPLETE=0
        ;;
      23)
        echo "at step $L_STEP: FN_EBS_User_Enddate"
        if $(FN_IS_CP_TIER) ; then
          FN_APPS_Env appsora
          FN_EBS_User_Enddate
        fi
        FN_Inc
  #      L_COMPLETE=0
        ;;
      24)
        echo "at step $L_STEP: FN_APPS_START for WEB tier"
        ## only start the web services until the CP services have been verified ##
        if ! $(FN_IS_CP_TIER) ; then
          FN_APPS_Env appsora
          FN_APPS_START $L_APPSPWD
        fi
        FN_Inc
  #     L_COMPLETE=0
        ;;
      25)
        echo "at step $L_STEP: FN_frmcmp_batch"
        if ! $(FN_IS_CP_TIER) ; then
          FN_APPS_Env appsora
          FN_frmcmp_batch
        fi
        FN_Inc
  #     L_COMPLETE=0
        ;;
      26)
        echo "at step $L_STEP: FN_HR_Profile_Values"
        if ! $(FN_IS_CP_TIER) ; then
          FN_APPS_Env appsora
          FN_HR_Profile_Values
        fi
        FN_Inc
  #     L_COMPLETE=0
        ;;
      27)
        echo "at step $L_STEP: FN_File_Tidy"
        if ! $(FN_IS_CP_TIER) ; then
          FN_APPS_Env appsora
          FN_File_Tidy
        fi
        FN_Inc
  #     L_COMPLETE=0
        ;;
      28)
        echo "at step $L_STEP: Apps Stop and Start to resolve weird failure to start on v06emzs123"
        if ! $(FN_IS_CP_TIER)
        then
          sleep 10
          FN_APPS_STOP  ${L_APPSPWD}
          sleep 10
          FN_APPS_START ${L_APPSPWD}
        fi
        FN_Inc
  #     L_COMPLETE=0
        ;;
      29)
        echo "at step $L_STEP: Clearing XXLCC sftp interface tables as requested in Nr-12037045"
        if $(FN_IS_CP_TIER)
        then
          FN_clear_xxlcc_sftp_tables
        fi
        FN_Inc
  #     L_COMPLETE=0
        ;;
      30)
        echo "at step $L_STEP: Clearing XXLCC BACS lookup tables as requested in Nr-13006905"
        if $(FN_IS_CP_TIER)
        then
          FN_ap_bacs
        fi
        FN_Inc
  #     L_COMPLETE=0
        ;;
      31)
        echo "at step $L_STEP: Removing tcp.validnode_checking and tcp.invited_nodes from APPS_FND sqlnet.ora config"
        if $(FN_IS_CP_TIER)
        then
          FN_remove_tcp_invited_nodes
        fi
        FN_Inc
  #     L_COMPLETE=0
        ;;
      32)
        echo "at step $L_STEP: Removing ICX session data that has grown too large to remove using concurrent jobs"
        if $(FN_IS_CP_TIER)
        then
          FN_Truncate_ICX_Tables
        fi
        FN_Inc
  #     L_COMPLETE=0
        ;;
      33)
        echo "at step $L_STEP: Changing XML Publisher temp dir Nr-13020447"
        if ! $(FN_IS_CP_TIER)
        then
          FN_xml_publisher
        fi
        FN_Inc
       L_COMPLETE=0
        ;;
      *)
        echo "this is an error (L_STEP=$L_STEP)"
        export L_ERROR=1
        ;;
      esac
  done

}

# - - - - - - - - - - - -  Main - - - - - - - - - #
  export L_S_SID=${1:?"Missing the source sid"}
  export L_T_SID=${2:?"Missing the target sid"}
  export L_VERBOSE=1

  PG=$(basename $0)
  LG=${PG%%.ksh}
  TS=`date +%Y%m%d`

  export L_COMPLETE=1
  export L_ERROR=0
  export L_STEP=${3:-1}

  if FN_ValidENV $L_T_SID ; then
    FN_Main $L_T_SID 2>&1 | tee -a $DBA/logs/${LG}_${L_S_SID}_${L_T_SID}_$(hostname).$TS.log
  else
    echo " the $L_T_SID is invalid"
  fi

## requires something to check the L_ERROR status and notify the appropriate people
# - - - - - - - - - - - - - - - - - - - - - - - - #
