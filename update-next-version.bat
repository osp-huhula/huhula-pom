@ECHO ON
SETLOCAL

::SET VARIABLE
SET VERSION=J7.1.2.3
SET NEXT_VERSION=J7.1.2.4-SNAPSHOT


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

%CMVN_SUPER_POM% versions:revert

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN_SUPER_POM% release:clean release:prepare -Dresume=false -DdryRun=true --batch-mode -Dtag=%VERSION% -DreleaseVersion=%VERSION% -DdevelopmentVersion=%NEXT_VERSION%
%CMVN% release:perform
GOTO:EOF

:ROLLBACK
%CMVN_SUPER_POM% -q release:rollback 
%CMVN_SUPER_POM% -q versions:revert
%CMVN% -q release:rollback 
%CMVN% -q versions:revert
exit /b %errorlevel%
GOTO:EOF

ENDLOCAL