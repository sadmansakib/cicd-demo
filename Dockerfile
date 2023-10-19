# gradle build stage for the project
FROM --platform=linux/amd64 gradle:8.3.0-jdk17-alpine as gradle
WORKDIR /workspace/app
COPY gradle gradle
COPY build.gradle settings.gradle gradlew ./
COPY src src
RUN gradle clean bootJar -x test
RUN mkdir -p build/dependency && (cd build/dependency; jar -xf ../libs/*.jar)

# maven build stage for the project
FROM --platform=linux/amd64 maven:3.9.4-eclipse-temurin-17-alpine as maven
WORKDIR /workspace/app
COPY .mvn .mvn
COPY mvnw pom.xml ./
COPY src src
RUN mvn install -DskipTests
RUN mkdir -p build/dependency && (cd build/dependency; jar -xf ../libs/*.jar)


FROM --platform=linux/amd64 eclipse-temurin:17.0.8.1_1-jre-alpine as gradle-build
ARG DEPENDENCY=/workspace/app/build/dependency
ARG mainClass
ENV main=$mainClass
COPY --from=gradle ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=gradle ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=gradle ${DEPENDENCY}/BOOT-INF/classes /app
RUN echo -e "#!/bin/bash \n java -cp app:app/lib/* ${main}" > ./entrypoint.sh
RUN chmod +x ./entrypoint.sh
#ENTRYPOINT ["java","-cp","app:app/lib/*","$main"]
#ENTRYPOINT ["tail", "-f", "/dev/null"]
ENTRYPOINT ["./entrypoint.sh"]

FROM --platform=linux/amd64 eclipse-temurin:17.0.8.1_1-jre-alpine as maven-build
ARG DEPENDENCY=/workspace/app/build/dependency
ARG mainClass
COPY --from=maven ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=maven ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=maven ${DEPENDENCY}/BOOT-INF/classes /app
ENTRYPOINT ["java","-cp","app:app/lib/*","$mainClass"]




