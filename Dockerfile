FROM ruby:2.2.1

RUN apt-get update
RUN gem install sinatra trollop

COPY server.rb /
COPY monitor.rb /

CMD ruby /server.rb
EXPOSE 4567
