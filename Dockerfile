FROM centos

#es download url
ENV ES_URL https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.4.0.tar.gz
#es install path
ENV ES_PATH /usr/local/elasticsearch
#es git 
ENV ES_GIT https://github.com/mypjb/elasticsearch-docker.git

# es user
ENV ES_USER es

ENV BIN_PATH /docker/bin

RUN yum update -y \
	&& yum install -y net-tools wget git java-1.8.0-openjdk

#COPY es.tar.gz /

RUN wget $ES_URL -O es.tar.gz \
#RUN git --help \
	&& mkdir -p $ES_PATH \
	&& tar xzf es.tar.gz -C $ES_PATH --strip-components=1 \
	&& rm es.tar.gz \
	&& cd $ES_PATH \
	&& ln -s $ES_PATH/bin/elasticsearch /usr/local/bin \
	&& git clone $ES_GIT es_git \
	&& cp es_git/config/* config \
	&& rm -rf es_git 

RUN useradd -d /home/$ES_USER -m $ES_USER \
	&& echo "Aa123456" | passwd $ES_USER --stdin \
	&& chown -R $ES_USER $ES_PATH \
#	&& echo "* soft	nofile	65536" >> /etc/security/limits.conf \
#	&& echo "* hard   nofile  65536" >> /etc/security/limits.conf \
	&& mkdir -p /storage/elasticsearch \
	&& chown -R $ES_USER /storage/elasticsearch 

ENV ES_NAME es_node

ENV ES_CLUSTER_NAME es_cluster

EXPOSE 9200 9300

CMD sed -i "s/\$ES_NAME/$ES_NAME/" $ES_PATH/config/elasticsearch.yml ; \
	sed -i "s%\$ES_CLUSTER_NAME%$ES_CLUSTER_NAME%" $ES_PATH/config/elasticsearch.yml ; \
	su $ES_USER -c "elasticsearch -d" ; \
	/bin/bash ;
