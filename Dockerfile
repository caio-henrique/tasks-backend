FROM tomcat:9.0.43-jdk8-openjdk

ARG WAR_FILE

COPY ${WAR_FILE} /usr/local/tomcat/webapps/