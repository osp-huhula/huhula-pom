@ECHO OFF
SETLOCAL

mvn clean deploy site -B -PSKIP-ASC -DPROFILE_RELEASE=RELEASE -Dmvn-base-version-release=J7.1.4.0 > c:\.tmp\log\mvn-deploy-RELEASE.log

ENDLOCAL