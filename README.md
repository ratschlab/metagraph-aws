# MetaGraph Sequence Indexes
![global MetaGraph sequence search](img/github_header.jpg)

## Overview 
The MetaGraph Sequence Index dataset offers full-text searchable index files for raw sequencing data hosted in major public repositories. These include the European Nucleotide Archive (ENA) managed by the European Bioinformatics Institute (EMBL-EBI), the Sequence Read Archive (SRA) maintained by the National Center for Biotechnology Information (NCBI), and the DNA Data Bank of Japan (DDBJ) Sequence Read Archive (DRA). 
Currently, the index supports searches across more than 10 million individual samples, with this number steadily increasing as indexing efforts continue.

## Data

### Summary
Following the principle of phylogenetic compression, we have hierarchically clustered all samples using information from their biological taxonomy (as far as available). As a result, we currently have a pool of approximately 5,000 individual index chunks. Each of these chunks contains the information of a subset of the samples. Every chunk is assigned into one taxonomic categories. Overall, there are approx 200 taxonomic categories available, each containing only a few up to over 1,000 individual index chunks. The number of chunks within the same category is mostly driven by the number of samples available from that taxonomic group. The chunk size is limited for practical reasons, to allow for parallel construction and querying.

### Available categories
Individual categories were formed by grouping phylogenetically similar samples together. This grouping started at the species level of the taxonomic tree. If too few samples were available to form a chunk, the taxonomic parent was selected for aggregation for samples. The resulting list of categories is available [here]().

### Dataset layout
All data is available under the following root: s3://metagraph-data-public/all_sra

```
s3://metagraph-data-public/all_sra
+-- data
|   +-- category_A
|   |   +-- chunk_1
|   |   +-- ...
|   +-- ...
+-- metadata
    +-- category_A
    |   +-- chunk_1
    |   +-- ...
    +-- ...
```
Where `category_A` would be one of the [Available categories](#available-categories) mentioned above. Likewise, `chunk_1` would be replaced with a running number of the chunk, padded with zeros up to a total length of 4. 

As an example, to reach the data for the 10th chunk of the `metagenome` category, the resulting path would be `s3://metagraph-data-public/all_sra/data/metagenome/0010/`.


### Chunk structure
Irrespective of whether you are in the `data` or the `metadata` branch, each chunk contains a standardized set of files. 

In the `data` branch one chunk contains:
```
annotation.clean.row_diff_brwt.annodbg
annotation.clean.row_diff_brwt.annodbg.md5
graph.primary.small.dbg
graph.primary.small.dbg.md5
```

Both files ending with `dbg` are needed for a full-text query. They form the MetaGraph index. The files ending in `md5` are check sums to verify correct transfer of data in case you download it.

In the `metadata` branch one chunk contains:
```
metadata.tsv.gz
```
This is a gzip-compress, human readable text file containing additional information about the samples that are contained within each index chunk.

## Usage within AWS
The following steps describe how to set up a search query across all or a subset of available index files.

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
