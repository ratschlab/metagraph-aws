Auxiliary scripts to work with the query system.

# Deployment

Usage: `deploy-metagraph.sh <notifications-email-address>`.

The email address will be used for SNS notifications. If not provided, will be set up with `test@example.com`, essentially `/dev/null`.

# Upload queries

Usage: `upload-query.sh /path/to/query.fasta`.

# Schedule metagraph job

Usage: `start-metagraph-job.sh /path/to/payload.json`.

Example payload:

```json
{
    "s3_index_url": "s3://metagraph-data-public/all_sra",
    "query_filename": "queries/test_query.fasta",
    "index_filter": ".*000[1-5]$"
}
```

Optional parameters are passed to `metagraph` CLI tool:
- `query_mode` (`labels` by default),
- `num_top_labels` (`inf` by default),
- `min_kmers_fraction_label` (`0.7` by default),
- `min_kmers_fraction_graph` (`0.0` by default).
