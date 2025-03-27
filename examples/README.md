`scheduler-payload.json` contains example payload:
```json
{
    "s3_index_url": "s3://metagraph-data-public/all_sra",
    "query_filename": "test_query.fasta",
    "index_filter": ".*000[1-5]$"
}
```
`test_query.fasta` contains example query:
```
>seq1
AAAGTTGTGTAGTGCGATCGGTGGATGCCTTGGCACCAAGAGCCGATGAAGGACGTTGTGACCTGCGATAAGCCCTGGGGAGTTGGTGAGCGAGCTGTGATCCGG
>seq2
AAGCGTCTGGGAAGGCGTACCGGAGTGGGTGAGAGTCCTGTAACTGTAAGCGTGGCACTGGTGTGGGGTTGCCCCGAGTAGCGTGGGACTCGTGGAATT
```
`100_studies_short.fq` contains a larger query used to benchmark metagraph, and `large-query.json` contains example payload to process it.