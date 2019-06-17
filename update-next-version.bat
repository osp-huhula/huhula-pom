@ECHO ON
SETLOCAL

::SET VARIABLE
SET VERSION=J7.1.2.1-SNAPSHOT
SET NEXT_VERSION=J7.1.2.1-SNAPSHOT


::STARTING
echo executing in current dir "%~dp0"
CD "%~dp0"

::update version from all current related project
::mvn release:clean release:prepare -Dresume=false -DreleaseVersion=%VERSION% -DdevelopmentVersion=%NEXT_VERSION%
::mvn --batch-mode release:update-versions -DreleaseVersion=%VERSION% -DdevelopmentVersion=%NEXT_VERSION% -DautoVersionSubmodules=true
::mvn versions:set -DnewVersion=%VERSION% -DprocessAllModules
::mvn clean install
::mvn versions:commit -DprocessAllModules
::git commit
::mvn release:perform
::GOTO:EOF

::update version fro all current related project
cmd /C mvn -f huhula-super-pom\pom.xml versions:set -DnewVersion=%VERSION% 
if NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   exit /b %errorlevel%
)

cmd /C mvn -f huhula-super-pom\pom.xml -N versions:update-child-modules
if NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   exit /b %errorlevel%
)

cmd /C mvn -f huhula-super-pom\pom.xml clean install -q
if NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   exit /b %errorlevel%
)

cmd /C mvn clean install -q
if NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   exit /b %errorlevel%
)

cmd /C mvn versions:commit -DprocessAllModulesif NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   exit /b %errorlevel%
)

::cmd /C mvn -f resume-online-bom\pom.xml versions:set -DnewVersion=%VERSION%
::cmd /C mvn clean install -q
::cmd /C mvn -f resume-online-bom\pom.xml versions:commit
::
::cmd /C mvn release:clean release:prepare -Dresume=false -DreleaseVersion=%VERSION% -DdevelopmentVersion=%NEXT_VERSION%
::cmd /C mvn --batch-mode release:update-versions -DreleaseVersion=%VERSION% -DdevelopmentVersion=%NEXT_VERSION% -DautoVersionSubmodules=true
::cmd /C mvn release:perform
GOTO:EOF

:ROLLBACK
cmd /C mvn release:rollback
cmd /C mvn versions:revert

:FINISH
ENDLOCAL