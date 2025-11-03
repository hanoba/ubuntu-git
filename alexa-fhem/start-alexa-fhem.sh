# Node 16 Docker für alexa-fhem starten
docker rm -f alexa-fhem
docker run -dit \
  --name alexa-fhem \
  --workdir /home/node \
  -p 3001:3000 \
  -v /home/harald/fhem-docker/alexa-fhem:/home/node \
  -v /home/harald/fhem-docker/alexa-fhem-ssh:/root/.ssh \
  -e FHEM_HOST=192.168.178.24 \
  -e FHEM_PORT=8086 \
  -e DEBUG="*" \
  node:16 \
  sh -c "npm install -g alexa-fhem && exec alexa-fhem -c /home/node/alexa-fhem.cfg"
docker ps
docker logs -f alexa-fhem