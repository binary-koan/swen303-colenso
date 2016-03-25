class TeiToHtml
  include ActionView::Helpers::TagHelper

  attr_reader :root, :note_count

  def initialize(root)
    @root = root
  end

  def call
    convert_node(root)
  end

  private

  def convert_node(node)
    return if node.nil? || node.comment?
    return node.text if node.text?

    case node.name
    when "front" then build_tag(node, "section", class: "tei-front")
    when "body"  then build_tag(node, "section", class: "tei-body")
    when "div"   then build_tag(node, "div")
    when "p"     then build_tag(node, "p")
    when "note"  then build_note(node)
    when "table" then build_tag(node, "table", class: "table")
    when "row"   then build_tag(node, "tr")
    when "cell"  then build_tag(node, "td")
    when "lb"    then build_tag(node, "br")
    when "list"  then build_list(node)
    when "item"  then build_tag(node, "li")
    when "anchor", "ptr", "hi", "date"
      # Hard to see how these could be translated meaningfully into HTML
      build_tag(node, "span")
    else
      puts "WARNING: Unknown tag #{node.name}"
      build_tag(node, "span")
    end
  end

  def convert_children(node)
    node.children.map { |node| convert_node(node) }.join.html_safe
  end

  def build_tag(node, name, attrs={})
    name, attrs = transform_with_render_method(node, name, attrs)

    if node.children.present?
      content_tag(name, convert_children(node), attrs)
    else
      tag(name, attrs)
    end
  end

  def build_list(node)
    if node["type"] == "ordered"
      build_tag(node, "ol")
    else
      build_tag(node, "ul")
    end
  end

  def build_note(node)
    content_tag("a", content_tag("sup", "(note) "),
      "href"         => "#",
      "class"        => "tei-note",
      "data-toggle"  => "popover",
      "data-content" => convert_children(node).to_str
    )
  end

  def transform_with_render_method(node, name, attrs)
    render_method = node["rend"]
    return [name, attrs] unless render_method

    render_method.split(/\s+/).map do |method|
      case method
      when "bold"            then add_class(attrs, "tei-bold")
      when "italic"          then add_class(attrs, "tei-italic")
      when "underline"       then add_class(attrs, "tei-underline")
      when "doubleunderline" then add_class(attrs, "tei-doubleunderline")
      when "strikethrough"   then add_class(attrs, "tei-strikethrough")
      when "smallcaps"       then add_class(attrs, "tei-smallcaps")
      when "sup", "sub"      then name = method
      when "center"          then add_class(attrs, "tei-center")
      when "justify"         then add_class(attrs, "tei-justify")
      when "frame"           then add_class(attrs, "tei-frame")
      when "end"             # ignore
      else puts "WARNING: Unknown render method #{method}"
      end
    end.compact.join(" ")

    [name, attrs]
  end

  def add_class(attrs, class_name)
    attrs[:class] ||= ""
    attrs[:class] += " #{class_name}"
  end
end
