# huhula-pom

# General
	Maven version		: 
		Apache Maven 3.2.5 (12a6b3acb947671f09b81f49094c53f426d8cea1; 2014-12-14T15:29:23-02:00)
		Maven home: C:\.app\maven\3.2.5\bin\..
		Java version: 1.6.0_45, vendor: Sun Microsystems Inc.

# Performing a Snapshot Deployment

Snapshot deployment are performed when your version ends in -SNAPSHOT . You do not need to fulfill the requirements when performing snapshot deployments and can simply run on your project.


```
mvn clean deploy
```


SNAPSHOT versions are not synchronized to the Central Repository. If you wish your users to consume your SNAPSHOT versions, they would need to add the snapshot repository to their Nexus Repository Manager, settings.xml, or pom.xml. Successfully deployed SNAPSHOT versions will be found in https://oss.sonatype.org/content/repositories/snapshots/
Performing a Release Deployment

In order to perform a release deployment you have to edit your version in all your POM files to use release versions. This means that they can not end in -SNAPSHOT In addition plugin and dependency declarations can also not use snapshot versions. This ensures that you only depend on other released components. Ideally they are all available in the Central Repository. This ensures that your users can retrieve your components as well as your transitive dependencies from the Central Repository.

The change of the versions for your project, and the parent references in a multi module setup, can be performed manually or with the help of the Maven versions plugin.

```
mvn versions:set -DnewVersion=1.2.3

mvn versions:set -DnewVersion=2.50.1-SNAPSHOT -DprocessAllModules
```

Once you have updated all the versions and ensured that your build passes without deployment you can perform the deployment with the usage of the release profile with

```
mvn clean deploy -P release
```

If you made a mistake, do

```
mvn versions:revert
```

afterwards, or

```
mvn versions:commit
```

if you're happy with the results.

resuse:

```
mvn release:clean release:prepare -Dresume=false -DreleaseVersion=J7.1.1.5 -DdevelopmentVersion=J7.1.1.6-SNAPSHOT
mvn versions:set -DnewVersion=J7.1.1.5 -DprocessAllModules
mvn versions:commit
mvn release:prepare -Dresume=false
mvn release:clean release:prepare release:perform -Dresume=false -DreleaseVersion=J7.1.1.5 -DdevelopmentVersion=J7.1.1.6-SNAPSHOT 
mvn release:rollback 

mvn versions:set -DnewVersion=J7.1.1.6-SNAPSHOT -DprocessAllModules
mvn versions:commit -DprocessAllModules
git commit
mvn release:clean release:prepare -Dresume=false -DreleaseVersion=J7.1.1.6 -DdevelopmentVersion=J7.1.1.7-SNAPSHOT
mvn release:perform
mvn release:rollback


```
# Reference

 - http://central.sonatype.org/pages/apache-maven.html