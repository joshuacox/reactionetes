{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "gymongonasium.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "gymongonasium.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "mongodb_replicaset_url" -}}
  {{- printf "mongodb://" -}}
  {{- range $mongocount, $e := until (.Values.mongodbReplicaCount|int) -}}
    {{- printf "%s-mongodb-replicaset-%d:%d" $.Values.mongodbReleaseName $mongocount ($.Values.mongodbPort|int) -}}
    {{- if lt $mongocount  ( sub $.Values.mongodbReplicantCount 1 ) -}}
      {{- printf "," -}}
    {{- end -}}
    {{- printf "/%s?replicaSet=%s" $.Values.mongodbName  $.Values.mongodbReplicaSet -}}
  {{- end -}}
{{- end -}}
