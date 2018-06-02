node {	
	def MVN_HOME = tool 'maven-3.5.0';
	echo "MVN_HOME = ${MVN_HOME}"
	stage('cleaning'){
	    cleanWs();
	}
	//clean verify -Dmvn.verify.fail=false
	stage('Cheking out (GIT)') {
		checkout scm
		//sh 'git clone https://github.com/osp-huhula/huhula.git ./'
	}
	stage('maven compile') {
		if (isUnix()) {
			sh "'${MVN_HOME}/bin/mvn' clean compile -Dmvn.project.location=${WORKSPACE}  "
		} else {
			bat(/"${mvnHome}\bin\mvn" clean compile -Dmvn.project.location=${WORKSPACE} /)
		}
	}
	stage('maven verify') {
		if (isUnix()) {
			sh "'${MVN_HOME}/bin/mvn' verify -Dmvn.project.location=${WORKSPACE} -Dmvn.verify.fail=false "
		} else {
			bat(/"${mvnHome}\bin\mvn" verify -Dmvn.project.location=${WORKSPACE} -Dmvn.verify.fail=false " /)
		}
	}
	stage('maven install & site ') {
		if (isUnix()) {
			sh "'${MVN_HOME}/bin/mvn' clean install site -Dmvn.project.location=${WORKSPACE} -Dmvn.verify.fail=false "
		} else {
			bat(/"${mvnHome}\bin\mvn" clean install site -Dmvn.project.location=${WORKSPACE} -Dmvn.verify.fail=false /)
		}
	}
	stage('Results') {
      junit '**/target/surefire-reports/TEST-*.xml'
      archive 'target/*.jar'
   }
}

