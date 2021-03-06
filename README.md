svgplot
=========

[![Gem Version](https://img.shields.io/gem/v/svgplot.svg)](https://rubygems.org/gems/svgplot)
[![Build Status](https://img.shields.io/travis/com/akerl/svgplot.svg)](https://travis-ci.com/akerl/svgplot)
[![Coverage Status](https://img.shields.io/codecov/c/github/akerl/svgplot.svg)](https://codecov.io/github/akerl/svgplot)
[![Code Quality](https://img.shields.io/codacy/a4ad68dc9c4940b58f9b78ec1996f533.svg)](https://www.codacy.com/app/akerl/svgplot)
[![MIT Licensed](https://img.shields.io/badge/license-MIT-green.svg)](https://tldrlegal.com/license/mit-license)

SVG creation library forked from [xytis's Rasem fork](https://github.com/xytis/rasem).

## Usage

Create an SVG object by initializing it with a size:

```
plot = SVGPlot.new(width: 100, height: 100)
```

SVGPlot is based directly on the SVG spec. Add children by calling their methods on the plot:

```
# Add the text 'foo' at position (1, 2)
plot.text(1, 2) { 'foo' }
```

```
# Add a rectangle
plot.rectangle(1, 1, 10, 10)
```

A good example of the SVG library in practice is [GithubChart](https://github.com/akerl/githubchart/blob/master/lib/githubchart/svg.rb)

### Transformations

To do an SVG transform on an object, just call the desired transform method on it:

```
plot = SVGPlot.new(width: 100, height: 100)
plot.text(1, 1) { 'foobar' }.translate(5, 5)
```

You can call transforms after the fact as well:

```
plot = SVGPlot.new(width: 100, height: 100)
text = plot.text(1, 1) { 'foobar' }
text.scale(2)
```

The list of available transforms:

* translate(x, y = 0)
* scale(x, y = 1)
* rotate(angle, x = nil, y = nil)
* skew_x(angle)
* skew_y(angle)
* matrix(a, b, c, d, e, f)

## Installation

    gem install svgplot

## License

svgplot is released under the MIT License. See the bundled LICENSE file for details.

