FROM jboss/keycloak-adapter-wildfly:latest

ENV MYSQL_CONNECTOR_VERSION 5.1.45

USER root

# Install prepare infrastructure
RUN yum -y update && \
 yum -y install wget nc which

RUN mkdir -p ${JBOSS_HOME}/modules/com/mysql/jdbc/main/
RUN wget "http://central.maven.org/maven2/mysql/mysql-connector-java/${MYSQL_CONNECTOR_VERSION}/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar" -O ${JBOSS_HOME}/modules/com/mysql/jdbc/main/mysql-connector-java-${MYSQL_CONNECTOR_VERSION}.jar
COPY wildfly ${JBOSS_HOME}
RUN sed -i -e s/MYSQL-CONNECTOR-VERSION/${MYSQL_CONNECTOR_VERSION}/g ${JBOSS_HOME}/modules/com/mysql/jdbc/main/module.xml
RUN chown jboss:jboss -R /opt/jboss/wildfly
USER jboss

# Custmoize datasources
COPY datasource.xsl ${JBOSS_HOME}/
RUN java -jar /usr/share/java/saxon.jar -s:${JBOSS_HOME}/standalone/configuration/standalone.xml -xsl:${JBOSS_HOME}/datasource.xsl -o:${JBOSS_HOME}/standalone/configuration/standalone.xml; java -jar /usr/share/java/saxon.jar -s:${JBOSS_HOME}/standalone/configuration/standalone-ha.xml -xsl:${JBOSS_HOME}/datasource.xsl -o:${JBOSS_HOME}/standalone/configuration/standalone-ha.xml; rm ${JBOSS_HOME}/datasource.xsl