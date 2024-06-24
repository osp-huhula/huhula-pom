@ECHO OFF
SETLOCAL

mvn clean deploy site -B -PSKIP-ASC -DPROFILE_RELEASE=FINAL > c:\.tmp\log\mvn-deploy-FINAL.log

ENDLOCAL