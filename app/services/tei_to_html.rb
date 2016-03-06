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
    return "" if node.nil?
    return node.text if node.text?

    case node.name
    when "front" then build_tag(node, "section", class: "front")
    when "body"  then build_tag(node, "section", class: "body")
    when "p"     then build_tag(node, "p")
    when "note"  then build_note(node)
    when "hi"    then build_tag(node, "span")
    when "table" then build_tag(node, "table", class: "table")
    when "row"   then build_tag(node, "tr")
    when "cell"  then build_tag(node, "td")
    else
      puts "WARNING: Unknown tag #{node.name}"
      build_tag(node, "span")
    end
  end

  def convert_children(node)
    node.children.map { |node| convert_node(node) }.join.html_safe
  end

  def build_tag(node, name, attrs={})
    attrs[:class] ||= ""
    attrs[:class] += " #{html_class(node)}"

    if node.children.present?
      content_tag(name, convert_children(node), attrs)
    else
      tag(name, attrs)
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

  def html_class(node)
    render_method = node["rend"]
    return unless render_method

    render_method.split(/\s+/).map do |method|
      case method
      when "bold"      then "text-bold"
      when "italic"    then "text-italic"
      when "smallcaps" then "text-smallcaps"
      when "center"    then "text-center"
      else puts "WARNING: Unknown render method #{render_method}"
      end
    end.compact.join(" ")
  end
end
