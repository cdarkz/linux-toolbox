#!/bin/bash
JENKINS_JAR="./jenkins-cli.jar"
curl -k https://10.0.13.181/jenkins/jnlpJars/jenkins-cli.jar -o ${JENKINS_JAR}
if [ $? != 0 ]; then
	exit
fi

JENKINS_CLI="java -jar ${JENKINS_JAR} -s http://localhost:8080/jenkins/ -auth @${HOME}/.jenkins-cli"
TEST_NAME="test_build"
JOBS=$(${JENKINS_CLI} list-jobs | grep -vE "${TEST_NAME}")

${JENKINS_CLI} delete-job ${TEST_NAME}

for job in ${JOBS};
do
	${JENKINS_CLI} copy-job "${job}" ${TEST_NAME}
	${JENKINS_CLI} get-job ${TEST_NAME} > ${TEST_NAME}.xml
	START_LINE=$(grep -n '<hudson.plugins.emailext.ExtendedEmailPublisher' ./${TEST_NAME}.xml | cut -f1 -d:)
	END_LINE=$(grep -n '</hudson.plugins.emailext.ExtendedEmailPublisher' ./${TEST_NAME}.xml | cut -f1 -d:)
	sed -i "${START_LINE},${END_LINE}d" ${TEST_NAME}.xml
	START_LINE=$(grep -n '<com.dabsquared.gitlabjenkins.publisher.GitLabCommitStatusPublisher' ./${TEST_NAME}.xml | cut -f1 -d:)
	END_LINE=$(grep -n '</com.dabsquared.gitlabjenkins.publisher.GitLabCommitStatusPublisher' ./${TEST_NAME}.xml | cut -f1 -d:)
	sed -i "${START_LINE},${END_LINE}d" ${TEST_NAME}.xml
	${JENKINS_CLI} update-job ${TEST_NAME} < ${TEST_NAME}.xml
	echo "===== Build start for ${job}"
	${JENKINS_CLI} build ${TEST_NAME} -s
	echo "===== Build result: $? for ${job}"
	${JENKINS_CLI} delete-job ${TEST_NAME}
done

rm -f ${JENKINS_JAR}
rm -f ${TEST_NAME}.xml
