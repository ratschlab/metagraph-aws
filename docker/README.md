Update Docker image (push to BMI AWS):

```sh
docker build -t metagraph-batch .
docker tag metagraph-batch:latest 043309319928.dkr.ecr.eu-central-2.amazonaws.com/metagraph-batch:latest
docker push 043309319928.dkr.ecr.eu-central-2.amazonaws.com/metagraph-batch:latest
```

Default `Dockerfile` installs `metagraph` from bioconda, `git_trunk.dockerfile` builds from sources.