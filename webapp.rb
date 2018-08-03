require "roda"

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

