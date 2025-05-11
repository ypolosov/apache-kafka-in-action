# Chapter 5

## Describing a Topic

When a broker is offline and then comeback online, the broker will not instantaneously becomes the leader of a partition that it was before it went offline. The reason is because the broker must sync itself first then by default it will become a leader again. With the script `kafka-leader-election.sh`, we can trigger this rebalancing of the leaders manually

```sh
kafka-leader-election.sh \
    --election-type=preferred \
    --all-topic-partitions \
    --bootstrap-server localhost:9092
```
