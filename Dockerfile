FROM maven as build
WORKDIR /app
COPY . .
RUN mvn install

FROM openjdk:11.0
WORKDIR /app
COPY --from=build /app/target/SDLC-check.jar .
EXPOSE 8090
CMD ["java","-jar","-XX:+UnlockExperimentalVMOptions","-XX:+UseCGroupMemoryLimitForHeap","SDLC-check.jar"]