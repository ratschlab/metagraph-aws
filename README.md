This is a basic Git to keep track of Metagraph AWS deployment project.

Update Docker image:

```sh
docker build -t metagraph-batch .
docker tag metagraph-batch:latest 043309319928.dkr.ecr.eu-central-2.amazonaws.com/metagraph-batch:latest
docker push 043309319928.dkr.ecr.eu-central-2.amazonaws.com/metagraph-batch:latest
```

Deploy Cloud Formation template:

```sh
aws cloudformation deploy --template-file metagraph-stack.yaml --capabilities CAPABILITY_NAMED_IAM --stack-name MetagraphQuerySystem
```

