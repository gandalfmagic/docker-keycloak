
FROM quay.io/keycloak/keycloak:20.0.3 as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

#ENV KC_FEATURES=preview,docker
ENV KC_DB=postgres
ENV KC_HTTP_RELATIVE_PATH=/auth
# specify the custom cache config file here
ENV KC_CACHE_CONFIG_FILE=cache-ispn-jdbc-ping.xml

# copy the custom cache config file into the keycloak conf dir
COPY ./conf/cache-ispn-jdbc-ping.xml /opt/keycloak/conf/cache-ispn-jdbc-ping.xml

RUN /opt/keycloak/bin/kc.sh build


FROM quay.io/keycloak/keycloak:20.0.3

COPY --from=builder /opt/keycloak/lib/quarkus/ /opt/keycloak/lib/quarkus/

WORKDIR /opt/keycloak

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start"]
