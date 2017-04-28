Various tools and scripts for cloud computing class
=====================================================
Refer to individual readme files in each directory.

The yml files are docker compose files that will create a 3-tier app -> UI, rest client and DB.

These are the commands you need to set this up. You need to enable [docker swarm](https://docs.docker.com/engine/swarm/) mode have [docker-compose](https://docs.docker.com/compose/) installed.
```
docker service create --name registry --publish 5000:5000 registry:2
docker run -it -d -p 9090:8080 -v /var/run/docker.sock:/var/run/docker.sock manomarks/visualizer
docker-compose -f users.yml build
docker-compose -f users.yml push
docker stack deploy users --compose-file users.yml
```

