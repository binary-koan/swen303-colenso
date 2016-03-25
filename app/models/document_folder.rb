class DocumentFolder
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def name
    (/[^\/]+$/.match(path) || ["All"])[0]
  end

  def folder?
    true
  end
end
