@ECHO OFF
SETLOCAL

mvn clean deploy site -B -PSKIP-ASC -DPROFILE_RELEASE=SNAPSHOT  > c:\.tmp\log\mvn-deploy-SNAPSHOT.log

ENDLOCAL