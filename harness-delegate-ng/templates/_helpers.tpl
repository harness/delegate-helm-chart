{{/*
The release name, default is set to chart name if delegate name is not specified.
*/}}
{{- define "harness-delegate-ng.name" -}}
{{- default .Chart.Name .Values.delegateName | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name, this is same as delegate name unless an override is specified.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If delegateName is not provided chart name would be used by default.
*/}}
{{- define "harness-delegate-ng.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.delegateName }}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "harness-delegate-ng.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "harness-delegate-ng.labels" -}}
helm.sh/chart: {{ include "harness-delegate-ng.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.additionalLabels }}
{{ toYaml .Values.additionalLabels }}
{{- end }}
{{ include "harness-delegate-ng.selectorLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "harness-delegate-ng.selectorLabels" -}}
app.kubernetes.io/name: {{ include "harness-delegate-ng.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
harness.io/name: {{ template "harness-delegate-ng.name" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "harness-delegate-ng.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "harness-delegate-ng.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Fetch access level using kubernetes permission value
*/}}
{{- define "harness-delegate-ng.accessLevel" -}}
  {{- if eq .Values.k8sPermissionsType "CLUSTER_ADMIN" }}
    {{- print "cluster-admin" }}
  {{- else if eq .Values.k8sPermissionsType "CLUSTER_VIEWER" -}}
    {{- print "view" }}
  {{- else if eq .Values.k8sPermissionsType "NAMESPACE_ADMIN" }}
    {{- print "namespace-admin" }}
  {{- end }}
{{- end }}


{{/*
Check if custom role is provided in k8sPermissionsType
*/}}
{{- define "harness-delegate-ng.useCustomRole" -}}
  {{- if or (or (eq .Values.k8sPermissionsType "CLUSTER_ADMIN") (eq .Values.k8sPermissionsType "CLUSTER_VIEWER") ) (eq .Values.k8sPermissionsType "NAMESPACE_ADMIN") }}
  {{- print "false" }}
  {{- else }}
  {{- print "true" }}
  {{- end }}
{{- end }}

{{/*
Memory assigned to container in Mi
*/}}
{{- define "harness-delegate-ng.assignedMemory" -}}
  {{- $allocatedRam := .Values.memory | toString }}
  {{- printf "%s%s" $allocatedRam "Mi" }}
{{- end }}

{{/*
Generate a list of default certificate path with certificate target location
*/}}
{{- define "certificate_mount_volumes" -}}

  {{- $default_certs_path := .certs_path }}
  {{- $mount_volumes := list -}}

  {{- range .ci_mount_targets }}
    {{- $mount_volumes = append $mount_volumes (printf "%s:%s" $default_certs_path .) -}}
  {{- end }}
  {{- join "," $mount_volumes -}}
{{- end }}

{{/*
Define the delegate token name
*/}}
{{- define "harness-delegate-ng.delegateToken" -}}
{{- if not .Values.existingDelegateToken }}
{{- include "harness-delegate-ng.fullname" . }}
{{- else }}
{{- .Values.existingDelegateToken | trunc 63 | toString }}
{{- end }}
{{- end }}

{{/*
Compute the upgrader job name with 52-character limit validation.
CronJob names must be <= 52 characters because Kubernetes appends up to 11 characters
for Job names created from CronJobs (total must be <= 63).
*/}}
{{- define "harness-delegate-ng.upgraderJobName" -}}
{{- $name := "" -}}
{{- if .Values.upgrader.jobName -}}
{{- $name = .Values.upgrader.jobName -}}
{{- else -}}
{{- $name = printf "%s-upgrader-job" (include "harness-delegate-ng.fullname" .) -}}
{{- end -}}
{{- if gt (len $name) 52 -}}
{{- fail (printf "upgrader job name '%s' is %d characters, which exceeds the 52-character limit. CronJob names must be <= 52 characters because Kubernetes appends up to 11 characters for generated Job names. Set .Values.upgrader.jobName to a shorter name." $name (len $name)) -}}
{{- end -}}
{{- $name -}}
{{- end -}}

{{/*
Define the upgrader token name
*/}}
{{- define "harness-delegate-ng.upgraderDelegateToken" -}}
{{- if not .Values.upgrader.existingUpgraderToken }}
{{- include "harness-delegate-ng.fullname" . }}-upgrader-token
{{- else }}
{{- .Values.upgrader.existingUpgraderToken | trunc 63 | toString }}
{{- end }}
{{- end }}

{{/*
Renders a value that contains template.
Usage:
{{ include "harness-delegate-ng.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "harness-delegate-ng.tplvalues.render" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- if .value }}
            {{- tpl (.value | toYaml) .context }}
        {{- end }}
    {{- end }}
{{- end -}}