# Development

## Build

The image compiles Cassandra from `Mmuzaf/cassandra@cassandra-19476-coc26`.

```sh
docker build -t cep-38 .
```

```sh
docker build -t cep-38 --build-arg REPO=https://github.com/apache/cassandra.git --build-arg BRANCH=trunk .
```

Docker caches the `git clone` layer. After pushing new commits to the branch, rebuild without the cache or you ship stale code:

```sh
docker build -t cep-38 --no-cache .
```

## Run

```sh
docker run -it --rm cep-38
```

```sh
tail -f /cassandra/logs/system.log
```

## Publish to Docker Hub

The README points at `mmuzaf/cep-38`. 
Docker Hub is the default registry.

### Automatic (GitHub Actions)

See `.github/workflows/publish.yml`.

It:

1. Reads `REPO` and `BRANCH` from the Dockerfile ARGs and resolves the branch head with `git ls-remote`.
2. Asks Docker Hub whether `mmuzaf/cep-38:<sha>` already exists. If yes, stops. Docker Hub is the only state.
3. Otherwise builds on native amd64 and arm64 runners in parallel, pushes `<sha>-amd64` and `<sha>-arm64`, then merges them into `:latest` and `:<sha>`.

Set the two secrets once:

```sh
gh secret set DOCKERHUB_USERNAME --body mmuzaf
gh secret set DOCKERHUB_TOKEN     # paste a Docker Hub access token with Read & Write scope
```

Create the token on hub.docker.com under Account settings, then Personal access tokens. Trigger a run by hand:

```sh
gh workflow run publish.yml
gh run watch
```

### Manual

```sh
docker login
docker tag cep-38 mmuzaf/cep-38:latest
docker push mmuzaf/cep-38:latest
```

```sh
docker buildx create --use --name cep38 2>/dev/null || docker buildx use cep38
docker buildx build --platform linux/amd64,linux/arm64 -t mmuzaf/cep-38:latest --push .
```

## GitHub Pages

```sh
gh api -X POST repos/Mmuzaf/cep-38/pages -f 'source[branch]=main' -f 'source[path]=/'
```

Without `gh`, open the repo Settings, then Pages, choose "Deploy from a branch", and pick `main` with the root folder.

The site is https://mmuzaf.github.io/cep-38
