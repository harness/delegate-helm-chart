# delegate-helm-chart

## Contributor License Agreement

In order to clarify the intellectual property license granted with Contributions from any person or entity, Harness Inc. ("Harness") must have a Contributor License Agreement ("CLA") on file that has been read and followed by each contributor, indicating an agreement to the license terms [here](https://github.com/harness-apps/delegate-helm-chart/blob/main/Contributor_license_agreement.md). This license is for your protection as a Contributor as well as the protection of Harness; it does not change your rights to use your own Contributions for any other purpose.

## Instructions to publish new chart
1. Update version field in `Chart.yaml`
2. Package chart: `helm package <chart_dir>`
3. Update index file: `helm repo index . --merge index.yaml`
4. Git Commit and push changes for PR (excluding packaged chart)
    
