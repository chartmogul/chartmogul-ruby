module ChartMogul
  class Summary < ChartMogul::Object
    readonly_attr :current
    readonly_attr :previous
    readonly_attr :percentage_change
  end
end
