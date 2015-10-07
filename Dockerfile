FROM ctrails

ADD . /code
WORKDIR /code
RUN ping -c 2 localhost
RUN cat /etc/hosts
RUN ping -c 2 toyapp_db_1
RUN bundle install
RUN bundle exec rake db:create
RUN bundle exec rake db:migrate
CMD bundle exec rails s
