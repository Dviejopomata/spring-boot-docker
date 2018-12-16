FROM openjdk:8-jdk as build-env
WORKDIR /app
COPY build.gradle gradlew settings.gradle ./
COPY ./gradle ./gradle
RUN ./gradlew dependencies
COPY ./src ./src
RUN /app/gradlew jibExportDockerContext --jibTargetDir=container


FROM gcr.io/distroless/java

COPY --from=build-env /app/container/libs /app/libs/
COPY --from=build-env /app/container/snapshot-libs /app/libs/
COPY --from=build-env /app/container/resources /app/resources/
COPY --from=build-env /app/container/classes /app/classes/

ENTRYPOINT ["java","-Xms1024M","-Xmx2048M","-cp","/app/libs/*:/app/resources/:/app/classes/","com.github.dviejopomata.springbootdocker.SpringBootDockerApplication"]
CMD []