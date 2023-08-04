#!/bin/bash

cd /etc/prometheus/
sudo nano rules.yml

groups:
- name: cpul
  rules:
  - alert: HighCpuLoad
    expr: (sum by (instance) (avg by (mode, instance) (rate(node_cpu_seconds_total{mode!="idle"}[2m]))) > 0.8) * on(instance) group_left (nodename) node_uname_info{nodename=~".+"}
    for: 1m
    annotations:
      summary: High CPU load (instance {{ $labels.instance }})
      description: "CPU load is > 80%\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
    

- name: memory
  rules:
  - alert: HighMemoryUtilization
    expr: node_memory_MemTotal - node_memory_MemFree < 0.8 * node_memory_MemTotal
    for: 2m
    annotations:
      summary: High memory utilization on host {{ $labels.instance }}
     description: "The memory utilization on host {{ $labels.instance }} has exceeded 80% for 2 minutes"
 
- name: disk
  rules:
  - alert: OutOfDiskSpace
    expr: (node_filesystem_free{mountpoint !~ "/mnt.*"} / node_filesystem_size{mountpoint !~ "/mnt.*"} * 100) < 15
    for: 5m
    annotations:
      summary: Out of disk space on {{ $labels.instance }}
      description: "On {{ $labels.instance }} device {{ $labels.device }} mounted on {{ $labels.mountpoint }} has out of disk space of {{ $value }}%"

- name: error
  rules:
  - alert: HighRequestErrorRate
    expr: (sum(rate(http_requests_total{status="500"}[5m])) / sum(rate(http_requests_total[5m]))) > 0.05
    for: 5m
    annotations:
      summary: High request error rate
      description: "The error rate for HTTP requests has exceeded 5% for 5 minutes"
   
- name: cpu
  rules:
  - alert: InstanceDown
    expr: up == 0
    for: 5m
    annotations:
      summary: "Instance {{ $labels.instance }} down"
      description: "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes."
  

- name: ssl
  rules:
  - alert: SslCertificateExpiry
    expr: ssl_verified_cert_not_after{chain_no="0"} - time() < 86400 * 7
    for: 0m
    annotations:
      summary: SSL certificate expiry (< 7 days) (instance {{ $labels.instance }})
      description: "{{ $labels.instance }} Certificate is expiring in 7 days\n  VALUE = {{ $value }}\n  LABELS = {{ $labels }}"
   

- name: network
  rules:
  - alert: HighIncomingTraffic
    expr: sum(increase(openvpn_server_client_sent_bytes_total[1d]))
    for: 1m
    annotations:
      summary: High incoming traffic {{ $labels.instance }}


- name: network
  rules:
  - alert: HighOutgoingTraffic
    expr: sum(increase(openvpn_server_client_received_bytes_total[1d]))
    for: 1m
    annotations:
      summary: High outgoing traffic {{ $labels.instance }}
   


