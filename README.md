# Reactionetes

Spin up a Kubernetes stack dedicated to Reaction Commerce PDQ

[![Build Status](https://travis-ci.org/joshuacox/reactionetes.svg?branch=master)](https://travis-ci.org/joshuacox/reactionetes)
[![CircleCI](https://circleci.com/gh/joshuacox/reactionetes/tree/master.svg?style=svg)](https://circleci.com/gh/joshuacox/reactionetes/tree/master)
[![Waffle.io - Columns and their card count](https://badge.waffle.io/joshuacox/reactionetes.svg?columns=all)](https://waffle.io/joshuacox/reactionetes)

## TLDR

```
helm install \
  --name my-release-name \
  --set replicaCount=1 \
  --set mongoReplicaCount=3 \
  --set image.repository=reactioncommerce/reaction \
  --set image.tag=latest \
  ./reactioncommerce
```

## Oneliner Autopilot

The oneliner:
```
curl -L https://git.io/reactionetes | bash
```

## [Full Docs](./docs/README.md)

[here](./docs/README.md)
