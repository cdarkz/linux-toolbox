#!/bin/bash
JENKINS_JAR="./jenkins-cli.jar"
curl http://localhost:8080/jenkins/jnlpJars/jenkins-cli.jar -o ${JENKINS_JAR}
if [ $? != 0 ]; then
	exit
fi

JENKINS_CLI="java -jar jenkins-cli.jar -s http://localhost:8080/jenkins/ -auth @${HOME}/.jenkins-cli"
JOBS=`${JENKINS_CLI} list-jobs`

for job in ${JOBS};
do
	${JENKINS_CLI} delete-job test_build
	${JENKINS_CLI} copy-job ${job} test_build
	${JENKINS_CLI} get-job test_build > test_build.xml
	START_LINE=`grep -n '<hudson.plugins.emailext.ExtendedEmailPublisher' ./test_build.xml | cut -f1 -d:`
	END_LINE=`grep -n '</hudson.plugins.emailext.ExtendedEmailPublisher' ./test_build.xml | cut -f1 -d:`
	sed -i "${START_LINE},${END_LINE}d" test_build.xml
	START_LINE=`grep -n '<com.dabsquared.gitlabjenkins.publisher.GitLabCommitStatusPublisher' ./test_build.xml | cut -f1 -d:`
	END_LINE=`grep -n '</com.dabsquared.gitlabjenkins.publisher.GitLabCommitStatusPublisher' ./test_build.xml | cut -f1 -d:`
	sed -i "${START_LINE},${END_LINE}d" test_build.xml
	cat test_build.xml | ${JENKINS_CLI} update-job test_build
	echo "===== Build start for ${job}"
	${JENKINS_CLI} build test_build -s
	echo "===== Build result: $? for ${job}"
	${JENKINS_CLI} delete-job test_build
done

rm -f ${JENKINS_JAR}
