# Chapter 2

## Creating a Topic

This will create a topic called `products.prices.changelog` with partition 1 and replication-factor 1. replication-factor 1 means that there is no replication for the partition.

```sh
kafka-topics.sh \
    --create \
    --topic products.prices.changelog \
    --partitions 1 \
    --replication-factor 1 \
    --bootstrap-server localhost:9092
```

## Publishing a Message to a Topic

To publish a single message to a topic

```sh
echo "coffee pads 10" | kafka-console-producer.sh \
    --topic products.prices.changelog \
    --bootstrap-server localhost:9092
```

If you don't use the `echo` and `|` (pipe) command. You can publish message to the topic interactively

```sh
kafka-console-producer.sh \
    --topic products.prices.changelog \
    --bootstrap-server localhost:9092
```

## Consuming Messages from a Topic

```sh
kafka-console-consumer.sh \
    --topic products.prices.changelog \
    --bootstrap-server localhost:9092
```

by default a consumer will read new messages only. To read all messages even from the past, we can use `--from-beginning` flag

```sh
kafka-console-consumer.sh \
    --from-beginning \
    --topic products.prices.changelog \
    --bootstrap-server localhost:9092
```

## Kafka UI (Kafbat)


