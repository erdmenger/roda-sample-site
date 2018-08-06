require 'rack'
require 'roda'
require 'pony'    #to sent mail
require 'date'

class Webapp < Roda
  plugin :static, ["/images", "/css", "/js"]
  plugin :render
  plugin :head
  plugin :multi_view
  plugin :cookies, domain: 'localhost', path: '/'


  route do |r|
    # GET / request
    r.root do
      view :welcome
    end

    r.get "homepage" do
      view :homepage
    end

    r.get "about" do
      view("about")
    end

    r.get "contact" do
      view("contact")
    end

    r.get "cookie-guide" do
      view("cookie-guide")
    end

    r.get "signup-mail" do
      @sender = ENV.fetch('SMTP_SENDER')         # something like 'flood.prevention.bb@gmail.com'
      @smtp_secret = ENV.fetch('SMTP_SECRET')    # the corresponding secret
      Pony.mail(:to => 'you@example.com', :via => :smtp, :smtp => {
                  :host     => 'smtp.googlemail.com',
                  :port     => '25',
                  :user     => '#{@sender}',
                  :password => '#{@smtp_secret}',
                  :auth     => :plain,           # :plain, :login, :cram_md5, no auth by default
                  :domain   => "example.com"     # the HELO domain provided by the client to the server
                })
      @receiver = 'register-me@maildrop.cc'
      @subject = 'Dear Conrributer, happy welcom to flowin!'
      Pony.mail :to => '#{@Receiver}',
                :from => '#{@sender}',
                :subject => '#{@subject}'
      @say = "An email was sent by #{@sender} to #{@receiver} with subject: #(@subject) !"
      puts "#{@say}"
      "#{@say}"
    end

    # /cookies branch
    r.on "cookies" do
      req = Rack::Request.new(env)
      if req.get?() then
        puts "req type GET"
      else
        puts "req not a GET request"
      end
      puts req.GET()

      cookies = req.cookies()
      if cookies.empty?() then
        puts "> NO cookies set"
        #set a cookie
        response.set_cookie('foo', 'bar')
      else
        puts "> there are cookies set"
        # response.delete_cookie('foo')
        
      end

      puts "#{cookies}"
      response.write( "</BR> #{cookies}" )

      r.get "add" do
        #add another cookie
        @time = DateTime.now()
        puts @time
        @requester_ip = req.ip()
        puts @requester_ip
        @cookie_content = "#{@time}--#{@requester_ip}"
        puts "setting cookie 'opt_in_time' with content: #{@cookie_content} ."
        response.set_cookie('opt_in_time', @cookie_content )
        response.write("</BR> set cookie 'opt_in_time' with content: #{@cookie_content} .")
      end

      r.get "delete" do
        if cookies.empty?() then
          puts "> NO cookies to delete"
        else
          puts "> there are cookies to delete"
          #delete ALL cookies
          cookies.each do |key, value|
            puts "delete cookie #{key} with value #{value}"
            response.delete_cookie( @key )
            response.write("</BR> deleted cookie #{key} with value #{value}")
          end
        end
        puts "deleted all cookies"
        "delete done"
      end
      response.write( "</BR> -------------------------------------------------------------------" )
      response.finish()
    end

    
    r.on "hello" do
      # Set variable for all routes in /hello branch
      @greeting = 'Hello'

      # GET /hello/world request
      r.get "world" do
        "#{@greeting} world!"
      end

      # /hello request
      r.is do
        # GET /hello request
        r.get do
          "#{@Greeting}!"
        end

        # POST /hello request
        r.post do
          puts "Someone said #{@greeting}!"
          r.redirect
        end
      end
    end
    response.finish()
  end
end

