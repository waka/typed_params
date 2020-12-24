class TypedParams::Config
  attr_accessor :sig_path, :strict

  def initialize
    @sig_path = nil
    @strict = true
  end

  def sig_path=(path)
    case path
    when Pathname
      @sig_path = path
    when String
      @sig_path = Pathname(path)
    else
      raise "sig_path must be Pathname or String."
    end
  end
end
