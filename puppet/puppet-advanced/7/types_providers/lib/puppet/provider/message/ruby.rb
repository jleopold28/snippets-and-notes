Puppet::Type.type(:message).provide(:ruby) do
  desc 'The provider for the message type.'

  confine kernel: 'linux'

  def exists?
    false
  end

  def create
    message = resource[:output]

    if sym2bool(resource[:capitalize])
      message.upcase!
    elsif sym2bool(resource[:lowercase])
      message.downcase!
    end

    message.reverse! if sym2bool(resource[:reverse])

    puts message
  end

  def destroy
    #
  end

  private

  def sym2bool(symbol)
    symbol == :true ? true : false
  end
end
