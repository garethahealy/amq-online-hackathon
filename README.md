[![License](https://img.shields.io/hexpm/l/plug.svg?maxAge=2592000)]()

# amq-online-hackathon
AMQ Online Hackathon in Munich, April 2019

## install
Config to install AMQ Online on OCP

## components
Config to setup AMQ Online for scenario 1

online
```
    java -jar cli-qpid-jms-1.2.2-SNAPSHOT-0.41.0.redhat-00003.jar sender --broker-uri "amqps://messaging-2kdvzj33zq-enmasse-infra.apps.amqhackfest-emea01.openshift.opentlc.com:443?jms.username=extamq1&jms.password=password&amqp.saslMechanisms=PLAIN&transport.trustAll=True&transport.verifyHost=False" --log-msgs dict  --log-lib debug --address inputonline
    
    java -jar cli-qpid-jms-1.2.2-SNAPSHOT-0.41.0.redhat-00003.jar receiver --broker-uri "amqps://messaging-2kdvzj33zq-enmasse-infra.apps.amqhackfest-emea01.openshift.opentlc.com:443?jms.username=intamq1&jms.password=password&amqp.saslMechanisms=PLAIN&transport.trustAll=True&transport.verifyHost=False" --log-msgs dict  --log-lib debug --address inputonline
```

batch
```
    java -jar cli-qpid-jms-1.2.2-SNAPSHOT-0.41.0.redhat-00003.jar sender --broker-uri "amqps://messaging-2kdvzj33zq-enmasse-infra.apps.amqhackfest-emea01.openshift.opentlc.com:443?jms.username=extamq1&jms.password=password&amqp.saslMechanisms=PLAIN&transport.trustAll=True&transport.verifyHost=False" --log-msgs dict  --log-lib debug --address inputbatch

    java -jar cli-qpid-jms-1.2.2-SNAPSHOT-0.41.0.redhat-00003.jar receiver --broker-uri "amqps://messaging-2kdvzj33zq-enmasse-infra.apps.amqhackfest-emea01.openshift.opentlc.com:443?jms.username=intamq1&jms.password=password&amqp.saslMechanisms=PLAIN&transport.trustAll=True&transport.verifyHost=False" --log-msgs dict  --log-lib debug --address inputbatch
```

patch for night/day
```
    oc patch Address default.inputbatch -p '{"spec":{"plan":"anycastrouternight"}}' -n enmasse-is-great
    
    oc patch Address default.inputonline -p '{"spec":{"plan":"queuepartitionsnight"}}' -n enmasse-is-great
```