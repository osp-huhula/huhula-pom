@ECHO ON
SETLOCAL

::SET VARIABLE
SET ROLLBACK="false"
SET RELEASE="true"
SET VERSION=J6.0.0.1-R1906282040
SET NEXT_VERSION=J6.0.0.1-SNAPSHOT


SET CMVN=cmd /C mvnw -s C:\.rep\git\P\software-architecture\config\maven\settings.xml -Dmvn.antrun.config.skip.echoproperties=true
SET CMVN_SUPER_POM=%CMVN% -f huhula-super-pom\pom.xml

IF %ROLLBACK% EQU "true" (
	GOTO:ROLLBACK
)

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


%CMVN% versions:revert
%CMVN_SUPER_POM% versions:revert

IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)

%CMVN% release:clean release:prepare release:perform -Dresume=false -DdryRun=true  --batch-mode -Dtag=%VERSION% -DreleaseVersion=%VERSION% -DdevelopmentVersion=%NEXT_VERSION%
IF NOT %ERRORLEVEL% EQU 0 (
   echo Failure Reason Given is %errorlevel%
   GOTO:ROLLBACK
)
	
IF %RELEASE% EQU "true" (
	ECHO Releasing
	
	%CMVN% release:clean release:prepare -Dresume=false -DdryRun=false --batch-mode -Dtag=%VERSION% -DreleaseVersion=%VERSION% -DdevelopmentVersion=%NEXT_VERSION%
	IF NOT %ERRORLEVEL% EQU 0 (
	   echo Failure Reason Given is %errorlevel%
	   GOTO:ROLLBACK
	)
	%CMVN% clean deploy -PRELEASE -Dresume=false -DdryRun=false --batch-mode -Dtag=%VERSION% -DreleaseVersion=%VERSION% -DdevelopmentVersion=%NEXT_VERSION%
)

GOTO:EOF

:ROLLBACK
%CMVN_SUPER_POM% -q release:rollback 
%CMVN_SUPER_POM% -q versions:revert
%CMVN% -q release:rollback 
%CMVN% -q versions:revert
exit /b %errorlevel%
GOTO:EOF

ENDLOCAL