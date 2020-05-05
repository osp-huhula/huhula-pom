@ECHO ON
SETLOCAL

::SET VARIABLE
SET VERSION=J7.1.3.1
SET NEXT_VERSION=J7.1.3.2-SNAPSHOT


SET CMVN=cmd /C mvnw -s %MVN_HOME%\conf\settings.xml -Dmvn.antrun.config.echoproperties=true
SET CMVN_SUPER_POM=%CMVN% -f huhula-super-pom\pom.xml

::STARTING
echo executing in current dir "%~dp0"
CD "%~dp0"


IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN_SUPER_POM% -q versions:set -DnewVersion=%VERSION% -DprocessAllModules

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN_SUPER_POM% -q clean deploy site

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN% -q clean deploy site

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN% versions:revert

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN% release:clean release:prepare release:perform --batch-mode -Dresume=false -DdryRun=true -Dtag=%VERSION% -DreleaseVersion=%VERSION% -DdevelopmentVersion=%NEXT_VERSION%
%CMVN% release:clean

%CMVN% release:clean release:prepare release:perform --batch-mode -Dresume=false -DdryRun=false -Dtag=%VERSION% -DreleaseVersion=%VERSION% -DdevelopmentVersion=%NEXT_VERSION%

%CMVN% clean deploy -PRELEASE

GOTO:EOF

:ROLLBACK
%CMVN_SUPER_POM% -q release:rollback 
%CMVN_SUPER_POM% -q versions:revert
%CMVN% -q release:rollback 
%CMVN% -q versions:revert
exit /b %errorlevel%
GOTO:EOF

ENDLOCAL