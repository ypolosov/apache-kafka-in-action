# Chapter 2

## Describing a Topic

```sh
kafka-topics.sh \
    --describe \
    --topic products.prices.changelog \
    --bootstrap-server localhost:9092


kafka-topics.sh \
    --list \
    --bootstrap-server localhost:9092


kafka-topics.sh \
    --delete \
    --topic products.prices.changelog \
    --bootstrap-server localhost:9092


kafka-topics.sh \
    --create \
    --topic products.prices.changelog \
    --replication-factor  2 \
    --partitions  2 \
    --bootstrap-server localhost:9092
```


