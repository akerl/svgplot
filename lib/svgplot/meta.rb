SVGPlot::SVG_ALIAS = {
  group: :g,
  rectangle: :rect
}

SVGPlot::SVG_EXPANSION = {
  line: [:x1, :y1, :x2, :y2],
  circle: [:cx, :cy, :r],
  image: [:x, :y, :width, :height, :'xlink:href'],
  ellipse: [:cx, :cy, :rx, :ry],
  text: [:x, :y],
  rect: lambda do |args|
    unless [4, 5, 6].include? args.size
      fail ArgumentError 'Wrong unnamed argument count'
    end
    result = {
      x: args[0],
      y: args[1],
      width: args[2],
      height: args[3]
    }
    if args.size > 4
      result[:rx] = args[4]
      result[:ry] = (args[5] || args[4])
    end
    result
  end,
  polygon: lambda do |args|
    args.flatten!
    if args.length.odd?
      fail ArgumentError 'Illegal number of coordinates (should be even)'
    end
    { points: args }
  end,
  polyline: lambda do |args|
    args.flatten!
    if args.length.odd?
      fail ArgumentError 'Illegal number of coordinates (should be even)'
    end
    { points: args }
  end
}

# TODO: move to documentation?
SVGPlot::SVG_TRANSFORM = [
  :matrix,    # expects an array of 6 elements
  :translate, # [tx, ty?]
  :scale,     # [sx, sy?]
  :rotate,    # [angle, (cx, cy)?]
  :skewX,     # angle
  :skewY      # angle
]

SVGPlot::CSS_STYLE = [
  :fill,
  :stroke_width,
  :stroke,
  :fill_opacity,
  :stroke_opacity,
  :opacity,
  :'text-align',
  :font,
  :'white-space',
  :display
]
