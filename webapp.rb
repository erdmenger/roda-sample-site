require "roda"
require 'pony'

class Webapp < Roda
  plugin :static, ["/images", "/css", "/js"]
  plugin :render
  plugin :head
  plugin :multi_view


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

    r.get "signup-mail" do
      @sender = 'flood.prevention.bb@gmail.com'
      @smtp_secret = ENV.fetch('SMTP_SECRET')
      Pony.mail(:to => 'you@example.com', :via => :smtp, :smtp => {
                  :host     => 'smtp.googlemail.com',
                  :port     => '25',
                  :user     => '#{@sender}',
                  :password => '#{@smtp_secret}',
                  :auth     => :plain,           # :plain, :login, :cram_md5, no auth by default
                  :domain   => "example.com"     # the HELO domain provided by the client to the server
                }
      @receiver = 'register-me@maildrop.cc'
      @subject = 'Dear Conrributer, happy welcom to flowin!'
      Pony.mail :to => '#{@receiver}',
                :from => '#{@sender}',
                :subject => '#{@subject}'
      @say = "An email was sent by #{@sender} to #{@receiver} with subject: !"
      puts "#{@say}"
      "#{@say}"
    end

    # /hello branch
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
          "#{@greeting}!"
        end

        # POST /hello request
        r.post do
          puts "Someone said #{@greeting}!"
          r.redirect
        end
      end
    end
  end
end

