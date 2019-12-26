#!/bin/bash

apt update

apt-get -y install nodejs

apt-get -y install npm

npm install request --save

CHECK_GO=$(go version  2>&1 > /dev/null)
RESULT=$?

if [ ! $RESULT -eq 0 ]; then

  if [ ! -f log ]; then
    npm start server.js > log
  fi
  GO_URL=$(cat log | grep go1.13.5 | grep linux-amd64 | sed -n 1p | awk -F' ' '{print $4}' | awk -F'"' '{print $2}')
  GO_BINARY=$(echo $GO_URL | awk -F'/' '{print $5}')

  wget ${GO_URL}
  tar -C /usr/local -xvf ${GO_BINARY}
fi

FIND_GO=$(cat ~/.bashrc | grep "go/bin" | wc -l)
if [ ${FIND_GO} -eq 0 ]; then
  echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
fi

FIND_GOPATH=$(cat ~/.bashrc | grep "GOPATH" | wc -l)
if [ ${FIND_GOPATH} -eq 0 ]; then
  echo 'export GOPATH=$(go env GOPATH)' >> ~/.bashrc
fi

FIND_GOROOT=$(cat ~/.bashrc | grep "GOROOT" | wc -l)
if [ ${FIND_GOROOT} -eq 0 ]; then
  echo 'export GOROOT=/usr/local/go' >> ~/.bashrc
fi

echo -e 'source ~/.bashrc'
echo -e
