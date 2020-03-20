@ECHO OFF
SETLOCAL
::START

::SET VARIABLE
SET VERSION_RELEASE=J7.1.2.2

::STARTING
echo executing in current dir "%~dp0"
CD "%~dp0"

::update version fro all current related project
echo updating version in all modules to %VERSION_RELEASE%
cmd /C mvn versions:set -DnewVersion=%VERSION_RELEASE% -DprocessAllModules
::PAUSE

::deploy and release
mvn clean deploy -PRELEASE

::END
ENDLOCAL