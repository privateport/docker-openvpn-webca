docker stop privateport/openvpn-webca
docker rm privateport/openvpn-webca
docker build -t privateport/openvpn-webca .
docker run --rm -p 3000:3000 -v /docker.persistant/openvpn-webca:/persistant -v /docker.persistant/openvpn-server:/persistant/openvpn-server --hostname openvpn-webca --name openvpn-webca -it privateport/openvpn-webca $1 $2 $3 $4 $5 $6

