# Student Management App requires Servlet 6.0 (Jakarta EE 10) -> Tomcat 10.1+
FROM tomcat:10.1-jdk21-temurin

# Clean default webapps and deploy our WAR as the ROOT app
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY target/student-management.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
