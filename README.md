## High Level Architecture
The diagram below rappresent the architecture of objects 
that can be deployed using the common chart

## Common chart implementation reference
This repository contains example for implementing
helm (it is helm3 compatible too) based microservices 
configuration using library approach.

This approach allows reusing kubernetes objects configuration
logic decreasing the code duplication and simplyfying helm 
adoption among the service developers.

This approach was taken from multiple best practices from multiple sources,
with one of the main sources being technosophos common chart.

The core value added is in Istio objects integration and additional refactoring 
of the chart. This approach is unique and developed by SoftServe + Google.

## Core concept
The core concept of this approach is the use of predefined
helm templates with the ability of override 

The full documentation for template objects used from technosophos 
chart and incubator common chart is available here:
https://github.com/technosophos/common-chart/blob/master/docs/index.md
https://github.com/helm/charts/tree/master/incubator/common

The most important piece is the understaning of helm
object definition merge, template definition and usage.

This is how a template is defined. A template can use 
other templates for the specific sections.

Definition:
```
{{- define "common.configmap.tpl" -}}
apiVersion: v1
kind: ConfigMap
{{ template "common.metadata" . }}
{{- end -}}
{{- define "common.configmap" -}}
{{- template "common.util.merge" (append . "common.configmap.tpl") -}}
{{- end -}}
```

This is how a specific template is rendered in a chart:
```
{{ template "common.configmap" (list . "chart.configmap") -}}
{{ end }}
{{- define "chart.configmap" -}}
data:
{{- range $name, $value := .Values.env }}
{{- if not (empty $value) }}
  {{ $name }}: "{{ $value }}"
{{- end }}
{{- end }}
```

The core logic is embedded in the below function that does the
recursive object merging.
```
{{- /*
common.util.merge will merge two YAML templates and output the result.
This takes an array of three values:
- the top context
- the template name of the overrides (destination)
- the template name of the base (source)
*/ -}}
{{- define "common.util.merge" -}}
{{- $top := first . -}}
{{- $overrides := fromYaml (include (index . 1) $top) | default (dict ) -}}
{{- $tpl := fromYaml (include (index . 2) $top) | default (dict ) -}}
{{- toYaml (merge $overrides $tpl) -}}
{{- end -}}
```

## Chart usage example
The examples on how to use the common chart templates
are provided in portal and shipment service charts.

