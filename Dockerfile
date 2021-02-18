FROM tomcat:10.0.2-jdk8-openjdk

ARG WAR_FILE
ARG CONTEXT

COPY ${WAR_FILE} /usr/local/tomcat/webapp/${CONTEXT}.war