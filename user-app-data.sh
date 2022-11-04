#!/bin/bash
sudo apt-get update
sudo apt-get install default-jdk -y
cd /opt
sudo wget https://download.jboss.org/wildfly/16.0.0.Final/wildfly-16.0.0.Final.tar.gz
sudo tar -xvzf wildfly-16.0.0.Final.tar.gz
sudo mv wildfly-16.0.0.Final /opt/wildfly
sudo groupadd wildfly
sudo useradd -r -g wildfly -d /opt/wildfly -s /sbin/nologin wildfly
sudo chown -R wildfly: wildfly
sudo chmod o+x /opt/wildfly/bin/
