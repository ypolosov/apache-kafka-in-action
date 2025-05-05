# Apache Kafka in Action

## Kafka Setup

### JVM Installation

Kafka requires JVM runtime hence you need to ensure that JVM is installed in your machine.

### Kafka Installation

To install Kafka, we can install it locally or with a docker container. In this guide, we will install kafka locally.

Download Kafka and extract it to the directory `~/kafka`

```sh
wget "https://downloads.apache.org/kafka/3.9.0/kafka_2.13-3.9.0.tgz"
tar xfz kafka_2.13-3.9.0.tgz
rm kafka_2.13-3.9.0.tgz
mv kafka_2.13-3.9.0/* ~/kafka
```

inside `~/kafka`, there is a subdirectory called `/bin` which contains all command-line tools to interact with Kafka. To be able to call the command-line tools without providing the full path, it’s best to add the bin directory to the PATH variable:

```sh
export PATH="~/kafka/bin:$PATH"
```

Once kafka is installed, we have to configure the kafka before we could run it. Create `kafka1.properties`, `kafka2.properties`, and `kafka3.properties` inside `~/kafka/config` directory.

```sh
# kafka1.properties
broker.id=1
log.dirs=<PATH-TO-YOUR-USER-DIRECTORY>/kafka/data/kafka1
listeners=PLAINTEXT://:9092,CONTROLLER://:9192
process.roles=broker,controller
controller.quorum.voters=1@localhost:9192,2@localhost:9193,3@localhost:9194
controller.listener.names=CONTROLLER
listener.security.protocol.map=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT

# kafka2.properties
broker.id=2
log.dirs=<PATH-TO-YOUR-USER-DIRECTORY>/kafka/data/kafka2
listeners=PLAINTEXT://:9093,CONTROLLER://:9193
process.roles=broker,controller
controller.quorum.voters=1@localhost:9192,2@localhost:9193,3@localhost:9194
controller.listener.names=CONTROLLER
listener.security.protocol.map=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT

# kafka3.properties
broker.id=3
log.dirs=<PATH-TO-YOUR-USER-DIRECTORY>/kafka/data/kafka3
listeners=PLAINTEXT://:9094,CONTROLLER://:9194
process.roles=broker,controller
controller.quorum.voters=1@localhost:9192,2@localhost:9193,3@localhost:9194
controller.listener.names=CONTROLLER
listener.security.protocol.map=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT
```

Notice the `log.dirs` in each kafka properties. We need to create the directory so each broker could store their data.

```sh
mkdir -p ~/kafka/data/kafka1 ~/kafka/data/kafka2 ~/kafka/data/kafka3
```

Once the data directories are created, run the following command sequentially

```sh
export KAFKA_CLUSTER_ID="$(kafka-storage.sh random-uuid)"

kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c ~/kafka/config/kafka1.properties
kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c ~/kafka/config/kafka2.properties
kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c ~/kafka/config/kafka3.properties
```

If you get the following error while running `kafka-storage.sh random-uuid`

```sh
Error: VM option 'UseG1GC' is experimental and must be enabled via -XX:+UnlockExperimentalVMOptions.
Error: Could not create the Java Virtual Machine.
Error: A fatal exception has occurred. Program will exit.
```

then you could open `~/kafka/bin/kafka-run-class.sh`. Locate `KAFKA_HEAP_OPTS` and `KAFKA_JVM_PERFORMANCE_OPTS` and then add the `-XX:+UnlockExperimentalVMOptions` option.

```sh
export KAFKA_HEAP_OPTS="-XX:+UnlockExperimentalVMOptions ..."
export KAFKA_JVM_PERFORMANCE_OPTS="... -XX:+UnlockExperimentalVMOptions ..."
```

### Starting/Stopping Kafka

To run kafka, run the following command sequentially

```sh
kafka-server-start.sh -daemon ~/kafka/config/kafka2.properties
kafka-server-start.sh -daemon ~/kafka/config/kafka3.properties
kafka-server-start.sh -daemon ~/kafka/config/kafka1.properties
```

or simply run `./start-kafka.sh` script in the root project directory.

To check if kafka is running

```sh
kafka-broker-api-versions.sh --bootstrap-server localhost:9092,localhost:9093,localhost:909
```

or run `./check-kafka.sh`. You should get the following output if kafka run successfully

```sh
localhost:9092 (id: 1 rack: null) -> (
    # A lot of text
)
localhost:9093 (id: 2 rack: null) -> (
    # A lot of text
)
localhost:9094 (id: 3 rack: null) -> (
    # A lot of text
)
```

To stop kafka

```sh
kafka-server-stop.sh
```

or run `./stop-kafka.sh`.
