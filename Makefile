mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
top := $(dir $(mkfile_path))

all: image

image: docker.img

docker.img: bp2/hooks/onos-hook bp2/hooks/onos-wrapper bp2/hooks/onos-service ./Dockerfile.local
	mkdir -p ./work
	cp Dockerfile.local ./work/Dockerfile
	cp -r ./bp2 ./work
	docker build --tag=ciena/onos:1.3 ./work
	touch ./docker.img

bp2/hooks/onos-wrapper:
	GOPATH=$(top) CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
		go build -o bp2/hooks/onos-wrapper github.com/ciena/onosms/cmd/wrapper

bp2/hooks/onos-hook:
	GOPATH=$(top) CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
		go build -o bp2/hooks/onos-hook github.com/ciena/onosms/cmd/hook

clean:
	rm -rf docker.img *~ bp2/hooks/onos-hook bp2/hooks/onos-wrapper bin pkg vendor src hook wrapper work

bp2/hooks/onos-hook: \
	./src/github.com/ciena/onosms/cmd/hook/gather.go \
	./src/github.com/ciena/onosms/cmd/hook/onos-hook.go \
	./src/github.com/ciena/onosms/onos.go \
	./src/github.com/ciena/onosms/stringset.go \
	./src/github.com/ciena/onosms/util.go

bp2/hooks/onos-wrapper: \
	./src/github.com/ciena/onosms/cmd/wrapper/wrapper.go \
	./src/github.com/ciena/onosms/onos.go \
	./src/github.com/ciena/onosms/stringset.go \
	./src/github.com/ciena/onosms/util.go
