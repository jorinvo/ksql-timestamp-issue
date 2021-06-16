set -e


docker-compose down

# Reset volumes
sudo rm -rf .data

# Ensure volume permissions
sudo mkdir -p .data/{kafka-data,zookeeper-data,zookeeper-log}
sudo chown 1000:1000 .data/{kafka-data,zookeeper-data,zookeeper-log}

# Startup
docker-compose up -d

sleep 20

# Create toppics with infinite retention
# TODO: in production replication should be 3 and partitions 10
docker-compose exec broker kafka-topics \
  --create \
  --bootstrap-server localhost:9092 \
  --replication-factor 1 \
  --partitions 1 \
  --topic institute_document_log \
  --config retention.ms=-1

# Init KSQL migrations
docker-compose exec ksqldb-cli ksql-migrations \
  --config-file /share/ksql-migrations/ksql-migrations.properties \
  initialize-metadata

sleep 10

# Migration run
docker-compose exec ksqldb-cli ksql-migrations \
  --config-file /share/ksql-migrations/ksql-migrations.properties \
  apply --all
