FROM openjdk:17-jre-alpine
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
ARG DEPENDENCY=build/dependency
COPY ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY ${DEPENDENCY}/META-INF /app/META-INF
COPY ${DEPENDENCY}/BOOT-INF/classes /app
ENTRYPOINT ["java", "-XX:MaxRAM=1g", "-XX:+UseContainerSupport", "-Djava.security.egd=file:/dev/./urandom", "-cp", "app:app/lib/*", "hello.Application"]
