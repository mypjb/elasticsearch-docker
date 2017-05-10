FROM centos

#es download url
ENV ES_URL https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.4.0.tar.gz
#es install path
ENV ES_PATH /usr/local/elasticsearch
#es git 
ENV GIT https://github.com/mypjb/elasticsearch-docker.git

# es user
ENV ES_USER es

RUN yum update -y \
	&& yum install -y net-tools wget

RUN wget $ES_URL -O es.tar.gz \
	&& mkdir -p $ES_PATH \
	&& tar xzf es.tar.gz -C $ES_PATH --strip-components=1 \
	&& cd $ES_PATH \
	&& ln -s $ES_PATH/bin/elasticsearch /usr/local/bin

RUN useradd -d /home/$ES_USER -m $ES_USER \
	&& echo "Aa123456" | passwd $ES_USER --stdin \
	&& chown -R $ES_USER $ES_PATH \
	&& echo "soft	nofile	65536" >> /etc/security/limits.conf \
	&& echo "hard   nofile  65536" >> /etc/security/limits.conf \
	&& echo "vm.max_map_count=262144" >> /etc/sysctl.conf \
	&& sysctl -p

EXPOSE 9200

CMD su $ES_USER -c "elasticsearch" ;

