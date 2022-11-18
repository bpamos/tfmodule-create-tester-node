version: '2'
services:
    prometheus-server:
        image: prom/prometheus
        ports:
            - 9090:9090
        volumes:
            - ./prometheus/prometheus.yml:/etc/prometheus/${vpc_name}_prometheus.yml

    grafana-ui:
        image: grafana/grafana
        ports:
            - 3000:3000
        environment:
            - GF_SECURITY_ADMIN_PASSWORD=secret
        links:
            - prometheus-server:prometheus