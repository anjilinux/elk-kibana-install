
How to Setup ELK Stack in Ubuntu with Filebeat to collect logs from servers 


1  apt-get update
    2  sudo apt-get install openjdk-8-jdk
    3  wget -qO - https://artifacts.elastic.co/GPG-KEY-... | sudo apt-key add -
    4  sudo apt-get install apt-transport-https
    5  echo "deb https://artifacts.elastic.co/packages... stable main" | sudo tee –a /etc/apt/sources.list.d/elastic-7.x.list
    6  sudo apt-get update
    7  sudo apt-get install elasticsearch
    8  sudo nano /etc/elasticsearch/elasticsearch.yml
  network.host: 10.0.44.189
  http.port: 9200
    9 systemctl start elasticsearch.service
  10  curl http://10.0.44.189:9200 


Setup Kibana

1  apt-get update
    2  sudo apt-get install openjdk-8-jdk
    3  wget -qO - https://artifacts.elastic.co/GPG-KEY-... | sudo apt-key add -
    4  sudo apt-get install apt-transport-https
    5  echo "deb https://artifacts.elastic.co/packages... stable main" | sudo tee –a /etc/apt/sources.list.d/elastic-7.x.list
    6  sudo apt-get update
    7  sudo apt-get install kibana
    8  sudo nano /etc/kibana/kibana.yml
  server.port: 5601
  server.host: "10.0.43.154"
  elasticsearch.hosts: ["http://10.0.44.189:9200"]
    9  systemctl start kibana
   10  systemctl status kibana
   11  tail -f /var/log/kibana/kibana.log


Setup Logstash

logstash pipeline samples : https://www.elastic.co/guide/en/logst... 
   12  sudo apt-get install logstash
   13  cd /etc/logstash/conf.d/
   14  vim apache.conf
logstash pipeline for apache using filebeat 
   15  curl -L -O https://artifacts.elastic.co/download...
   16  dpkg -i filebeat-7.17.6-amd64.deb 
   17  sudo filebeat modules enable system
   18  systemctl start logstash.service


Client Setup (Apache Web server)

    1  curl -L -O https://artifacts.elastic.co/download...
    2  dpkg -i filebeat-7.17.6-amd64.deb 
    3  vim /etc/filebeat/filebeat.yml
  paths:
      - /var/log/apache2/*.log
  output.logstash:
    # The Logstash hosts
    hosts: ["10.0.43.154:5044"]
   4  sudo filebeat setup --index-management -E output.logstash.enabled=false -E 'output.elasticsearch.hosts=["10.0.44.189:9200"]'
   5  sudo filebeat modules enable system
   6  sudo filebeat modules enable apache
   7  systemctl restart filebeat.service
   8  filebeat test output
   
