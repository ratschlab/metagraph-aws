This is a GitHub to keep track of Metagraph AWS deployment.

# Usage

### Clone the project

```sh
git clone https://github.com/ratschlab/metagraph-aws.git
cd metagraph-aws
```

### Configure `aws` tool

```sh
aws configure sso
```

You should use access keys, etc from your AWS access portal.

### Deploy the Cloud Formation template

```sh
scripts/deploy-metagraph.sh test@example.com
```

If you want to receive SNS notifications when the query is processed, put your actual email in there.

This will deploy the following on your AWS:

- S3 bucket for you to post your queries and store the results.
- AWS Batch environment to execute the queries.
- Step Function and Lambda to schedule and monitor your queries.
- SNS topic to receive notifications when the query is fully processed.
  - You need to confirm subscription in your email inbox.

### Upload test query to the s3 bucket

```sh
scripts/upload-query.sh examples/test_query.fasta
```

You can generally upload your own queries by providing `/path/to/query.fasta` instead of `test_query.fasta`.

### Submit a test job

```sh
scripts/start-metagraph-job.sh examples/scheduler-payload.json
```

Minimal job definition (`scheduler-payload.json`):

```json
{
    "s3_index_url": "s3://metagraph-data-public/all_sra",
    "query_filename": "test_query.fasta",
    "index_filter": ".*000[1-5]$"
}
```

Additional parameters to be passed to `metagraph` CLI:
- `query_mode` (`labels` by default),
- `num_top_labels` (`inf` by default),
- `min_kmers_fraction_label` (`0.7` by default),
- `min_kmers_fraction_graph` (`0.0` by default).

### Instructions for offline usage

## Additional instructions

For further documentation and usage instructions, please refer to our [Quick start](https://metagraph.ethz.ch/static/docs/quick_start.html) guide in the [MetaGraph documentation](https://metagraph.ethz.ch/static/docs/index.html). The source code is maintained on our [GitHub repository](https://github.com/ratschlab/metagraph).
