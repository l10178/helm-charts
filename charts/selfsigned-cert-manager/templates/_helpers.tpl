{{/*
Expand the name of the chart.
*/}}
{{- define "selfsigned-cert-manager.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "selfsigned-cert-manager.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "selfsigned-cert-manager.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "selfsigned-cert-manager.labels" -}}
helm.sh/chart: {{ include "selfsigned-cert-manager.chart" . }}
{{ include "selfsigned-cert-manager.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "selfsigned-cert-manager.selectorLabels" -}}
app.kubernetes.io/name: {{ include "selfsigned-cert-manager.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "selfsigned-cert-manager.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "selfsigned-cert-manager.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "selfsigned-cert-manager.secretName" -}}
{{- default (include "selfsigned-cert-manager.fullname" .) .Values.secretName | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "selfsigned-cert-manager.commonName" -}}
{{- default "selfsigned.local" .Values.commonName | trunc 63 | trimSuffix "-" }}
{{- end }}