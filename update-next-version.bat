@ECHO ON
SETLOCAL

::SET VARIABLE
SET VERSION=J8.1.0.0
SET NEXT_VERSION=J8.1.0.1-SNAPSHOT


SET CMVN=cmd /C mvnw -s C:\.rep\git\P\software-architecture\config\maven\settings.xml -Dmvn.antrun.config.echoproperties=true
SET CMVN_SUPER_POM=%CMVN% -f huhula-super-pom\pom.xml

::STARTING
echo executing in current dir "%~dp0"
CD "%~dp0"


IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN_SUPER_POM% versions:set -DnewVersion=%VERSION%

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN_SUPER_POM% clean deploy site

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN% clean deploy site

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN_SUPER_POM% versions:commit

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN% release:clean release:prepare-with-pom -Dresume=false -DdryRun=true --batch-mode -DautoVersionSubmodules=true -Dtag=%VERSION% -DreleaseVersion=%VERSION% -DdevelopmentVersion=%NEXT_VERSION%

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN% release:perform

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)
GOTO:EOF

:ROLLBACK
%CMVN% -q release:rollback 
exit /b %errorlevel%
GOTO:EOF

ENDLOCAL