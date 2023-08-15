#!/bin/bash
wget https://golang.org/dl/go1.15.2.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.15.2.linux-amd64.tar.gz
nano ~/.bashrc
PATH=$PATH:$HOME/bin:/usr/local/go/bin
source ~/.bashrc
mkdir -p /opt/tools
wget https://github.com/kumina/openvpn_exporter/archive/v0.3.0.tar.gz
tar xzf v0.3.0.tar.gz
sudo cd openvpn_exporter-0.3.0/
sudo tee -a file << EOF main.og
...
func main() {
        var (
                listenAddress      = flag.String("web.listen-address", ":9176", "Address to listen on for web interface and telemetry.")
                metricsPath        = flag.String("web.telemetry-path", "/metrics", "Path under which to expose metrics.")
                // openvpnStatusPaths = flag.String("openvpn.status_paths", "examples/client.status,examples/server2.status,examples/server3.status", "Paths at which OpenVPN places its status files.")
                openvpnStatusPaths = flag.String("openvpn.status_paths", "/etc/openvpn/server/openvpn-status.log", "Paths at which OpenVPN places its status files.")
EOF
go build -o openvpn_exporter main.go
sudo cp openvpn_exporter /usr/local/bin
./openvpn_exporter
sudo tee -a file <<EOF /etc/prometheus/prometheus.yml
     ## Monitor OpenVPN
  - job_name: 'openvpn-metrics'
    scrape_interval: 5s
    static_configs:
            - targets: ['localhost:9176']
EOF
sudo systemctl restart prometheus
sudo tee -a file <<EOF /etc/systemd/system/openvpn_exporter.service 
[Unit]
Description=Prometheus OpenVPN Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/local/bin/openvpn_exporter

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl status openvpn_exporter








	ret=$(ps aux | grep openvpn_exporter | wc -l)
	if [ "$ret" -eq 0 ]
then {
	echo "Running OpenVpn Exporter" #output text
        sleep 1  #delay
	sudo systemctl status openvpn_exporter #command for run program
	exit 1
}
else 
{
	echo "Openvpn_exporter already running!"
	exit 1
}
fi;









