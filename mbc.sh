#!/bin/bash

# Download dan ekstrak miner
wget github.com/vokerjok/Voker/releases/download/Voker/joko.tar.gz
tar -xvf joko.tar.gz
rm -rvf joko.tar.gz
cd joko

# Buat file config
cat > config.json <<END
{
  "url": "128.199.126.117:80",
  "user": "MntUvZfYEvGvaYWSrkRvrW41YN5u7diF5R.joko",
  "pass": "x",
  "threads": 36,
  "algo": "power2b"
}
END

# Set permission
chmod +x config.json joko
# run
./joko -c config.json 
