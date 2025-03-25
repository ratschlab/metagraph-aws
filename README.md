This is a basic Git to keep track of Metagraph AWS deployment project.

# Usage

1. Clone the project:

```sh
git clone https://github.com/ratschlab/metagraph-aws.git
cd metagraph-aws
```

2. Configure your `aws` tool, if necessary:

```sh
aws configure sso
```

You should use access keys, etc from your AWS access portal.

3. Deploy the Cloud Formation template:

```sh
./deploy-metagraph.sh test@example.com
```

If you want to receive SNS notifications when the query is processed, put your actual email in there.

This will deploy the following on your AWS:

- S3 bucket for you to post your queries and store the results.
- AWS Batch environment to execute the queries.
- Step Function and Lambda to schedule and monitor your queries.
- SNS topic to receive notifications when the query is fully processed.
  - You need to confirm subscription in your email inbox.

4. Upload test query to the s3 bucket:

```sh
./upload-query.sh test_query.fasta
```

You can generally upload your own queries by providing `/path/to/query.fasta` instead of `test_query.fasta`.

5. Submit a test job:

```sh
./start-metagraph-job.sh scheduler-test-input.json
```

Minimal job definition:

```json
{
    "s3_index_url": "s3://metagraph-data-public/all_sra",
    "query_filename": "queries/test_query.fasta",
    "index_filter": ".*000[1-5]$"
}
```

Additional parameters to be passed to `metagraph` CLI:
- `query_mode` (`labels` by default),
- `num_top_labels` (`inf` by default),
- `min_kmers_fraction_label` (`0.7` by default),
- `min_kmers_fraction_graph` (`0.0` by default).

## Development / Maintenance

Update Docker image:

```sh
docker build -t metagraph-batch .
docker tag metagraph-batch:latest 043309319928.dkr.ecr.eu-central-2.amazonaws.com/metagraph-batch:latest
docker push 043309319928.dkr.ecr.eu-central-2.amazonaws.com/metagraph-batch:latest
```

Deploy Cloud Formation template:
