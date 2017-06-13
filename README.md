# elasticsearch-docker
this is a elasticsearch

# start elasticsearch:
docker run --name elasticsearch -p 9200:9200 -p 9300:9300 -itd mypjb/elasticsearch

# storage
docker run --name elasticsearch -p 9200:9200 -p 9300:9300 -v $(pwd):/storage/elasticsearch -itd mypjb/elasticsearch

# name
docker run --name elasticsearch -p 9200:9200 -p 9300:9300 -e ES_NAME=es_node1 -e ES_CLUSTER_NAME=es_cluster_name1 -itd mypjb/elasticsearch
