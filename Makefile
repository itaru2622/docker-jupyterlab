img      ?=itaru2622/jupyterlab:bookworm
base     ?=python:3.12-bookworm
node_ver ?=20

wDir ?=${PWD}
port ?=8888

build:
	docker build --build-arg base=${base} --build-arg node_ver=${node_ver} -t ${img} .
start:
	docker run -it --rm -p ${port}:8888 -v ${wDir}:${wDir} -w ${wDir} ${img}
