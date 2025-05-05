#!/bin/bash

~/kafka/bin/kafka-server-start.sh -daemon ~/kafka/config/kafka2.properties
~/kafka/bin/kafka-server-start.sh -daemon ~/kafka/config/kafka3.properties
~/kafka/bin/kafka-server-start.sh -daemon ~/kafka/config/kafka1.properties
