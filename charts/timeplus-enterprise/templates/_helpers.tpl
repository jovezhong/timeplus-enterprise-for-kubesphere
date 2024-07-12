{{/*
Expand the name of the chart.
*/}}
{{- define "timeplus.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "timeplus.fullname" -}}
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
{{- define "timeplus.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Pod labels. It includes selectorLabels and extraLabels. Used by pod and pod template
*/}}
{{- define "timeplus.podLabels" -}}
{{ include "timeplus.selectorLabels" . }}
{{- with .Values.global.extraLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}


{{/*
Common labels. It includes selectorLabels and extraLabels.
*/}}
{{- define "timeplus.labels" -}}
helm.sh/chart: {{ include "timeplus.chart" . }}
{{ include "timeplus.selectorLabels" . }}
{{- with .Values.global.extraLabels }}
{{ toYaml . }}
{{- end }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: timeplus
{{- end }}

{{/*
Selector labels. Since they are immutable so we'd better make it minimal and stable
*/}}
{{- define "timeplus.selectorLabels" -}}
app.kubernetes.io/name: {{ include "timeplus.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create full image name
*/}}
{{- define "timeplus.fullImage" -}}
{{ if .imageRegistry }}{{ .imageRegistry }}/{{ .image }}:{{ .tag }}{{ else }}{{ .image }}:{{ .tag }}{{ end }}
{{- end }}


{{/*
Render rules for how a pod should be scheduled to a node, including nodeSelector, affinity, and tolerations.
*/}}
{{- define "timeplus.nodeAssignment" }}
{{- if or .self.affinity .global.affinity }}
affinity:
  {{ or .self.affinity .global.affinity | toYaml | nindent 2 }}
{{- end }}
{{- if or .self.nodeSelector .global.nodeSelector }}
nodeSelector:
  {{ or .self.nodeSelector .global.nodeSelector | toYaml | nindent 2 }}
{{- end }}
{{- if or .self.tolerations .global.tolerations }}
tolerations:
  {{ or .self.tolerations .global.tolerations | toYaml | nindent 2 }}
{{- end }}
{{- end }}
