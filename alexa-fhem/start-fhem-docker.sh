docker rm -f fhem-isolated
docker run -d \
  --name fhem-isolated \
  -p 8086:8083 \
  -p 7073:7073 \
  -v /home/harald/fhem-docker/fhem-data:/opt/fhem \
  fhem/fhem
  