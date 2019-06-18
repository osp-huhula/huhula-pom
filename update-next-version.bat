@ECHO ON
SETLOCAL

::SET VARIABLE
SET VERSION=J7.1.2.3
SET NEXT_VERSION=J7.1.2.4-SNAPSHOT


SET CMVN=cmd /C mvn -q
SET CMVN_SUPER_POM=%CMVN% -f huhula-super-pom\pom.xml

::STARTING
echo executing in current dir "%~dp0"
CD "%~dp0"

%CMVN_SUPER_POM% versions:set -DnewVersion=%VERSION%

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN_SUPER_POM% -N versions:update-child-modules

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN_SUPER_POM% clean install

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN% clean install

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN_SUPER_POM% release:clean -B --batch-mode release:prepare -Dresume=false -Dtag=%VERSION% -DreleaseVersion=%VERSION% -DdevelopmentVersion=%NEXT_VERSION%

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN_SUPER_POM% -N versions:update-child-modules

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

GOTO:EOF

:ROLLBACK
%CMVN% release:rollback
%CMVN% versions:revert
exit /b %errorlevel%
GOTO:EOF

ENDLOCAL