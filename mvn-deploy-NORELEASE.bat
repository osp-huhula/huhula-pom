@ECHO OFF
SETLOCAL

mvn clean deploy site -PSKIP-ASC > c:\.tmp\log\mvn-deploy-DRYRUN.log

ENDLOCAL