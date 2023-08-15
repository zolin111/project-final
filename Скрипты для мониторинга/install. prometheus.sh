#!/bin/bash
sudo apt install prometheus prometheus-alertmanager prometheus-node-exporter 

prometheus --version
node_exporter --version
prometheus-alertmanager --version
sudo cat ~/etc/prometheus/rules.yaml
