require 'rack'
require 'twitter'
require './configure'

class Twittapp

  def call env
    req = Rack::Request.new(env)
    res = Rack::Response.new 
    res['Content-Type'] = 'text/html'
    username = (req["user"] && req["user"] != '') ? req["user"] :''
    user_tweets = (!username.empty?) ? usuario_registrado?(username) : "¡Introduzca un nombre de usuario!"
    res.write <<-"EOS"
      <!DOCTYPE HTML>
      <html>
        <head>
        <title> TwittApp </title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        </head>
        <body>
          <h1>TwittApp</h1>
          <p>Práctica 2: Accediendo a Twitter y mostrando los últimos twitts en una página.</p>
          <h4>Instrucciones:</h4>
          <form action="/" method="post">
            Introduzca un nombre de usuario registrado en Twitter para mostrar su último tweet: <input type="text" name="user" autofocus>
            <br>
            <input type="submit" value="Confirmar usuario">
          </form>
          <h4>Visualizar último tweet:</h4>
          Usuario: #{username}
          <br>
          Último tweet del usuario: #{user_tweets}
          <br>
          <br>
          <p id="copyright">&copy; Sergio Afonso García - Sistemas y Tecnologías Web 2013-14</p>
        </body>
      </html>
    EOS
    res.finish
  end

  def usuario_registrado?(user)
    begin
      Twitter.user_timeline(user).first.text
      rescue
        "Error: ¡El usuario introducido no tiene una cuenta en Twitter!"
    end
  end
end

Rack::Server.start(
  :app => Twittapp.new,
  :Port => 8080,
  :server => 'thin'
)