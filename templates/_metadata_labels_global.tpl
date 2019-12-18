{{- /*
common.labelize takes a dict or map and generates labels.

Values will be quoted. Keys will not.

Example output:

  first: "Matt"
  last: "Butcher"

This template creates the global metadata for resources
that can be used by objects shared amond multiple 
releases of a service. E.g. a global VirtualService

*/ -}}
{{- define "common.labelize" -}}
{{- range $k, $v := . }}
{{ $k }}: {{ $v | quote }}
{{- end -}}
{{- end -}}

{{- /*
common.labels.standard prints the standard Helm labels.

The standard labels are frequently used in metadata.
*/ -}}
{{- define "common.labels_global.standard" -}}
app: {{ template "common.name" . }}
chart: {{ template "common.chartref" . }}
heritage: {{ .Release.Service | quote }}
{{- end -}}
