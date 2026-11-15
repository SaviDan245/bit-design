FROM maven:3.9.16-eclipse-temurin-21 AS builder
WORKDIR /build
COPY app/pom.xml .
RUN mvn -B dependency:go-offline
COPY app/src ./src
RUN mvn -B package -DskipTests && tar -czf app.tar.gz -C target app.jar

FROM python:3.12-slim
RUN apt-get update && apt-get install -y --no-install-recommends openssh-client curl \
    && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir ansible-core==2.17.7
COPY --from=builder /build/app.tar.gz /artifacts/app.tar.gz
COPY docker/ansible/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENV ANSIBLE_CONFIG=/ansible/ansible.cfg
WORKDIR /ansible
ENTRYPOINT ["/entrypoint.sh"]
