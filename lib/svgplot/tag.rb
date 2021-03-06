module SVGPlot
  ##
  # Tag object, represents a single SVG tag
  class Tag
    include Parsers::Tag
    include Transform
    include Expansion

    attr_reader :tag, :attributes, :children
    attr_writer :defaults

    def initialize(tag, attributes = {}, &block)
      @tag = parse_tag tag
      @attributes = parse_attributes attributes
      @children = []

      instance_exec(&block) if block
    end

    def raw(data)
      append_child Raw.new(@img, data)
    end

    def path(attributes = {}, &block)
      append_child Path.new(@img, attributes, &block)
    end

    def defaults
      @defaults ||= {}
    end

    def use(id, attributes = {})
      id = id.attributes[:id] if id.is_a? Tag
      attributes['xlink:href'] = "##{id}"
      append_child ChildTag.new(@img, 'use', attributes)
    end

    def append_child(child)
      @children.push(child)
      child.defaults = defaults
      child
    end

    def to_s
      str = ''
      write(str)
      str
    end

    def write(output)
      output << "<#{@tag}"
      @attributes.each { |attr, value| output << %( #{attr}="#{value}") }
      if @children.empty?
        output << '/>'
      else
        output << '>'
        @children.each { |c| c.write(output) }
        output << "</#{@tag}>"
      end
    end

    def spawn_child(tag, *args, &block)
      parameters = args.first.is_a?(Hash) ? args.unshift : {}
      if parameters.empty?
        parameters = args.last.is_a?(Hash) ? args.pop : {}
        parameters.merge! expand(tag, args)
      end
      parameters = defaults.dup.merge! parameters

      append_child ChildTag.new(@img, tag, parameters, &block)
    end

    def respond_to_missing?(method)
      return true if parse_method_name(method) || parse_child_name(meth)
      super
    end

    def method_missing(method, *args, &block)
      check = parse_method_name(method)
      return parse_method_op(check[:op], check[:name], args, &block) if check
      child_name = parse_child_name(method)
      return spawn_child(child_name, *args, &block) if child_name
      super
    end
  end

  ##
  # Child tag, used for tags within another tag
  class ChildTag < Tag
    attr_reader :img

    def initialize(img, tag, params = {}, &block)
      @img = img
      super(tag, params, &block)
    end

    def linear_gradient(id, attributes = {}, if_exists = :skip, &block)
      @img.add_def(id, LinearGradient.new(@img, attributes), if_exists, &block)
    end

    def radial_gradient(id, attributes = {}, if_exists = :skip, &block)
      @img.add_def(id, RadialGradient.new(@img, attributes), if_exists, &block)
    end
  end

  ##
  # Raw child, just prints data provided
  class Raw < ChildTag
    def initialize(img, data)
      @img = img
      @data = data
    end

    def write(output)
      output << @data.to_s
    end
  end
end
