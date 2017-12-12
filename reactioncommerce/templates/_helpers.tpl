{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "reactioncommerce.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "reactioncommerce.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "mongodb_replicaset_url" -}}
  {{- printf "mongodb://" -}}
  {{- range $mongocount, $e := until (.Values.mongodbReplicaCount|int) -}}
    {{- printf "%s-mongodb-replicaset-%d." $.Values.mongodbReleaseName $mongocount -}}
    {{- printf "%s-mongodb-replicaset:%d" $.Values.mongodbReleaseName ($.Values.mongodbPort|int) -}}
    {{- if lt $mongocount  ( sub ($.Values.mongodbReplicaCount|int) 1 ) -}}
      {{- printf "," -}}
    {{- end -}}
  {{- end -}}
  {{- printf "/%s?replicaSet=%s" $.Values.mongodbName  $.Values.mongodbReplicaSet -}}
{{- end -}}
