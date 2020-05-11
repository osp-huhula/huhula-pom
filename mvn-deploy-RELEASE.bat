@ECHO OFF
SETLOCAL

mvn clean deploy site -B -PSKIP-ASC -DPROFILE_RELEASE=RELEASE > c:\.tmp\log\mvn-deploy-RELEASE.log

ENDLOCAL