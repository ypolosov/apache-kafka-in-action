# Chapter 5

## ACKs Strategies in Kafka

ACKs strategies refers to the number of replicas that must be in-sync with the leader. More ACKs means more time for data to be distributed across replica hence # of ACKs and performance are usually inversely proportional. I.e. Less ACKs will result in more performance.

### `acks=all`

This means that after successfully receiving a message, the broker or leader of the partition won’t send an ACK back to the producer until the message has been successfully distributed to all in-sync replicas (ISRs)

```sh
kafka-console-producer.sh \
    --topic products.prices.changelog \
    --bootstrap-server localhost:9092 \
    --producer-property acks=all
```

Note: `acks=all` is equivalent to `acks=-1`

### `acks=1`

This setting can be compared very well with TCP. As soon as the leader has received the message, it sends the ACK to the producer, which in turn **slightly improves latency**. However, if the leader fails immediately after sending the ACK and before distributing the messages to the followers, data loss must be expected.

```sh
kafka-console-producer.sh \
    --topic products.prices.changelog \
    --bootstrap-server localhost:9092 \
    --producer-property acks=1
```

### `acks=0`

This configuration is comparable to User Datagram Protocol (UDP). The producer sends its data, but if the data doesn’t arrive, the producer doesn’t care. Messages are thus sent by the producer only once, and Kafka doesn’t guarantee that the message will be successfully persisted. This doesn’t mean that messages don’t arrive, and besides, Kafka still uses TCP in the transport layer. Nevertheless, this ACK strategy obviously provides the lowest reliability and should only be used if data loss can be tolerated.

```sh
kafka-console-producer.sh \
    --topic products.prices.changelog \
    --bootstrap-server localhost:9092 \
    --producer-property acks=0
```

## Min Insync Replica

With `min.insync.replicas`, we specify that at least a certain number of replicas must be in sync before an ACK is sent to the producer on `acks=all`.

```sh
kafka-topics.sh \
    --create \
    --topic products.prices.changelog.min-isr-2 \
    --replication-factor 3 \
    --partitions 3 \
    --config min.insync.replicas=2 \
    --bootstrap-server localhost:9092
```

For a producer to successfully send a message to the `products.prices.changelog.min-isr-2` topic, the message need to be successfuly stored or written in two replicas (i.e. the leader must at least replicate the message to one more replica).

If we shutdown broker with id `2` and `3`

```sh
kafka-broker-stop.sh 3
kafka-broker-stop.sh 2
```

and then describe the topic

```sh
kafka-console-consumer.sh \
    --topic products.prices.changelog.min-isr-2 \
    --from-beginning \
    --bootstrap-server localhost:9092
```

You will be able to see that Broker 1 has taken over from Broker 3 as the leader for Partition 2 and from Broker 2 as the leader for Partition 1. Additionally Broker 2 and Broker 3 no longer appear in the list of ISRs.

```sh
Topic: products.prices.changelog.min-isr-2	TopicId: RgiEbAzdSDifBLU6KxsUqQ	PartitionCount: 3	ReplicationFactor: 3	Configs: min.insync.replicas=2
	Topic: products.prices.changelog.min-isr-2	Partition: 0	Leader: 1	Replicas: 3,1,2	Isr: 1	Elr: 	LastKnownElr:
	Topic: products.prices.changelog.min-isr-2	Partition: 1	Leader: 1	Replicas: 1,2,3	Isr: 1	Elr: 	LastKnownElr:
	Topic: products.prices.changelog.min-isr-2	Partition: 2	Leader: 1	Replicas: 2,3,1	Isr: 1	Elr: 	LastKnownElr:
```

Notice that ...

### Delivery Guarantee

* *at most once* when `acks=0`.
* *at least once* when `min.insync.replica` set to reasonable value (e.g. 2) and `acks=all`.
* *exactly once* when `acks=all` and `enable.idempotence=true`. Since Kafka 3.3+ idempotency is enabled by default.

> [!NOTE]
> TIP: It is strongly recommend keeping idempotence enabled. If you encounter performance problems, they likely aren’t caused by idempotence, so address those problems first.

When __exactly once__ delivery is used, producer need to send messages to topics with a sequence id. Consequently the sequence id also brings another benefit. **It ensures that all messages within a partition will be guaranteed to be in the correct order**.

## Partition Leader Election

When a broker is offline and then comeback online, the broker will not instantaneously becomes the leader of a partition that it was before it went offline. The reason is because the broker must sync itself first then by default it will become a leader again. With the script `kafka-leader-election.sh`, we can trigger this rebalancing of the leaders manually

```sh
kafka-leader-election.sh \
    --election-type=preferred \
    --all-topic-partitions \
    --bootstrap-server localhost:9092
```
