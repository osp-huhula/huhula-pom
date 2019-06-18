@ECHO ON
SETLOCAL

::SET VARIABLE
SET VERSION=J7.1.2.3
SET NEXT_VERSION=J7.1.2.4-SNAPSHOT


SET CMVN=cmd /C mvn -Dmvn.antrun.config.echoproperties=true
SET CMVN_SUPER_POM=%CMVN% -f huhula-super-pom\pom.xml

::STARTING
echo executing in current dir "%~dp0"
CD "%~dp0"

%CMVN_SUPER_POM% release:clean --batch-mode release:prepare -Dresume=false -Dtag=%VERSION% -DreleaseVersion=%VERSION% -DdevelopmentVersion=%NEXT_VERSION%

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN_SUPER_POM% versions:set -DnewVersion=%VERSION%

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN_SUPER_POM% clean install deploy site

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN% clean install deploy site

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)


%CMVN_SUPER_POM% versions:revert

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

@REM %CMVN% release:perform
GOTO:ROLLBACK
GOTO:EOF

:ROLLBACK
%CMVN_SUPER_POM% -q release:rollback 
%CMVN_SUPER_POM% -q versions:revert
exit /b %errorlevel%
GOTO:EOF

ENDLOCAL