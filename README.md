# docker-handson-demo

## How to build

```
$ docker image build -t wordpress:1.0 .
```

## How to run

```
$ docker container run --rm -itd -p 8000:80 --name wordpress01 wordpress:1.0
```

Access to `http://localhost:8000/wordpress/`
