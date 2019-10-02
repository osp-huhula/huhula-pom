@ECHO OFF
SETLOCAL

::SET VARIABLE
SET VERSION=J8.1.0.0
SET NEXT_VERSION=J8.1.0.1-SNAPSHOT


SET CMVN=cmd /C mvnw -s C:\.rep\git\P\software-architecture\config\maven\settings.xml -Dmvn.antrun.config.echoproperties=true
SET CMVN_SUPER_POM=%CMVN% -f huhula-super-pom\pom.xml

::STARTING
echo ##########################################
echo executing in current dir "%~dp0"
echo ##########################################
CD "%~dp0"

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

echo ##########################################
echo executing cleaning up (versions:revert)
echo ########################################## 
%CMVN_SUPER_POM% versions:revert -DnewVersion=%VERSION%

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

echo ##########################################
echo executing update version super-POM (versions:set)
echo ########################################## 
%CMVN_SUPER_POM% versions:set -DnewVersion=%VERSION%

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

echo ##########################################
echo executing update version (versions:set)
echo ########################################## 
%CMVN_SUPER_POM% versions:revert -DnewVersion=%VERSION%

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

echo ##########################################
echo executing mvn process in super-pom
echo ##########################################
%CMVN_SUPER_POM% clean deploy site

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

echo ##########################################
echo executing mvn process in POM (aggregator)
echo ##########################################
%CMVN% clean deploy site

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

echo ##########################################
echo executing revert version (super-pom)
echo ##########################################
%CMVN_SUPER_POM% versions:revert

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

echo ##########################################
echo executing simulation release 
echo ##########################################
%CMVN% release:clean release:prepare-with-pom -Dresume=false -DdryRun=true --batch-mode -DautoVersionSubmodules=true -Dtag=%VERSION% -DreleaseVersion=%VERSION% -DdevelopmentVersion=%NEXT_VERSION%

::%CMVN_SUPER_POM% versions:set -DnewVersion=%VERSION%
::%CMVN% release:clean release:prepare-with-pom -Dresume=false -DdryRun=false --batch-mode -DautoVersionSubmodules=true -Dtag=%VERSION% -DreleaseVersion=%VERSION% -DdevelopmentVersion=%NEXT_VERSION%
%CMVN% mvn clean deploy site -PRELEASE -DreleaseVersion=%VERSION% -DdevelopmentVersion=%NEXT_VERSION%

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

echo ##########################################
echo executing rollback release 
echo ##########################################
%CMVN% release:rollback

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