@ECHO ON
SETLOCAL

::SET VARIABLE
::SET VERSION=J7.1.3.1
::SET NEXT_VERSION=J7.1.3.2-SNAPSHOT


SET CMVN=cmd /C mvnw -s %MVN_HOME%\conf\settings.xml
SET CMVN_SUPER_POM=%CMVN% -f huhula-super-pom\pom.xml

::STARTING
echo executing in current dir "%~dp0"
CD "%~dp0"
IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN_SUPER_POM% -q versions:set -DnewVersion=0.0.0-SNAPSHOT -DprocessAllModules
IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN_SUPER_POM% -q clean install site -PSKIP-ASC
IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN% -q clean install site -PSKIP-ASC
IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN% -q versions:revert
IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN% clean deploy site -PTIMESTAMP -DdryRun=false
IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)
::%CMVN% -q release:clean release:prepare release:perform --batch-mode -Dresume=false -DdryRun=true -Dtag=%VERSION% -DreleaseVersion=%VERSION% -DdevelopmentVersion=%NEXT_VERSION%
::%CMVN% -q release:clean
::%CMVN% -q release:rollback 
::%CMVN% -q release:clean release:prepare release:perform --batch-mode -Dresume=false -DdryRun=false -Dtag=%VERSION% -DreleaseVersion=%VERSION% -DdevelopmentVersion=%NEXT_VERSION%
::%CMVN% clean deploy -PRELEASE

GOTO:EOF

:VERIFY_ERROR
IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

:ROLLBACK
%CMVN_SUPER_POM% -q release:rollback 
%CMVN_SUPER_POM% -q versions:revert
%CMVN% -q release:rollback 
%CMVN% -q versions:revert
exit /b %errorlevel%
GOTO:EOF

ENDLOCAL