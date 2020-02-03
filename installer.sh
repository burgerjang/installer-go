#!/bin/bash

command -v npm

if [ $? -eq 1 ]; then
	apt update

	apt-get -y install nodejs

	apt-get -y install npm

	npm install request --save
fi

command -v fzf

if [ $? -eq 1 ]; then
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install
	exit 0
else
	FZF=true
fi

CHECK_GO=$(go version  2>&1 > /dev/null)
RESULT=$?

exp="go([[:alnum:]\.]*)\.src.*"

if [ ! $RESULT -eq 0 ]; then

	if [ ! -f log ]; then
		npm start server.js > log
	fi

	if [ "${FZF}" == "true" ]; then
		while read -r line; do
			if [[ "${line}" =~ ${exp} ]]; then
				echo "${BASH_REMATCH[1]}"
			fi
		done < log | sort --version-sort --reverse | uniq > list
		SELECTED=$(cat list | fzf --reverse --no-mouse --height=15 --bind=left:page-up,right:page-down)
	fi

	GO_URL=$(cat log | grep "go${SELECTED}" | grep linux-amd64 | sed -n 1p | awk -F' ' '{print $4}' | awk -F'"' '{print $2}')
	GO_BINARY=$(echo $GO_URL | awk -F'/' '{print $5}')
	wget ${GO_URL}
	tar -C /usr/local -xvf ${GO_BINARY}
    rm -rf ${GO_BINARY}

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
else
	go get -v golang.org/x/tools/cmd/godoc
fi


echo -e 'source ~/.bashrc'
echo -e
