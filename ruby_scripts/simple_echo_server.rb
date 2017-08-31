require 'webrick'

# This is to echo the request, ie simply returns whatever it receives as part
# in the request.
# In future, it may be extended to return the repsonse expected.
class EchoServer

  def initialize(base_uri: 'localhost', port: 8000, url: '/')
    @base_uri = base_uri
    @port = port
    @url = url
    @server = WEBrick::HTTPServer.new :BindAddrees => @base_uri, :Port => @port
    
    trap 'INT' do @server.shutdown end
  end

  def start
    @pid = fork
    unless @pid
      @server.mount_proc @url do |req, res|
        res.body = 'hello'
      end
      @server.start
      Process.exit(0)
    end
  end

  def stop
    Process.kill(:INT, @pid)
  end
end
