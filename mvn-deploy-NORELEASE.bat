@ECHO OFF
SETLOCAL

mvn clean deploy site -PSKIP-ASC,VERSION_NO_RELEASE > c:\.tmp\log\mvn-deploy-DRYRUN.log

ENDLOCAL