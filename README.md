# Delegate-helm-chart

## Contributor License Agreement

In order to clarify the intellectual property license granted with Contributions from any person or entity, Harness Inc. ("Harness") must have a Contributor License Agreement ("CLA") on file that has been read and followed by each contributor, indicating an agreement to the license terms [here](https://github.com/harness-apps/delegate-helm-chart/blob/main/Contributor_license_agreement.md). This license is for your protection as a Contributor as well as the protection of Harness; it does not change your rights to use your own Contributions for any other purpose.

## Testing chart changes
1. Fetch your accountId and delegateToken from Harness. For more information about delegate tokens, refer documentation [delegate tokens](https://developer.harness.io/docs/platform/delegates/secure-delegates/secure-delegates-with-tokens/).
2. If delegateDockerImage is not set in your chart, pick latest available tag from [delegate docker-hub](https://hub.docker.com/repository/docker/harness/delegate/tags?page=1&ordering=last_updated).
3. From root directory of chart repo, execute below command to install delegate using helm chart.
```console
helm upgrade -i <release_name> --namespace <namespace> --create-namespace \
  ./harness-delegate-ng \
  --set delegateName=<delegate_name> \
  --set accountId=<account_id> \
  --set delegateToken=<delegate_token> \
  --set delegateDockerImage=<delegate_docker_image>
```

You can refer below Sample:
```console
helm upgrade -i helm-delegate --namespace harness-delegate-ng --create-namespace \
  ./harness-delegate-ng \
  --set delegateName=helm-delegate \
  --set accountId=<account_id> \
  --set delegateToken=<delegate_token> \
  --set delegateDockerImage=harness/delegate:23.06.79707
```
4. Once delegate is installed, test your changes.
5. For further debugging, you can refer [this](https://helm.sh/docs/chart_template_guide/debugging/).

## Raising Pull request
1. If you are adding a new variable, please provide a description of variable in values.yaml.
2. Once changes are tested, raise a pull request **without changing chart.yaml and index.yaml**



