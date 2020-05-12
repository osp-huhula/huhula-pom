@ECHO OFF
SETLOCAL

cmd /C mvn validate -PVERSION_TIMESTAMP_SNAPSHOT,UPDATE_RELEASE_RELEASE
git status
git add pom.xml **\pom.xml
git status
git commit -m "update to next timestamp SNAPSHOT version."
git push
ENDLOCAL