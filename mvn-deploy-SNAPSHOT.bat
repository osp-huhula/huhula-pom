@ECHO OFF
SETLOCAL
REM Requires Central Publisher Portal user token in ~/.m2/settings.xml for server id "sonatype-snapshot"
REM (https://central.sonatype.org/publish/generate-portal-token/) and SNAPSHOTs enabled for the namespace.

mvn clean deploy site -B -PSKIP-ASC -DPROFILE_RELEASE=SNAPSHOT  > c:\.tmp\log\mvn-deploy-SNAPSHOT.log

ENDLOCAL