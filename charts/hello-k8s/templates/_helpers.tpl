# This file contains helper templates for the hello-k8s chart.
# It defines reusable template snippets that can be used across the chart.
# These snippets help in maintaining consistency and reducing duplication.

{{/*
Return the full name of the release
*/}}
{{- define "hello-k8s.fullname" -}}
{{- printf "%s-%s" .Release.Name "hello-k8s" | trunc 63 | trimSuffix "-" -}}
{{- end -}}