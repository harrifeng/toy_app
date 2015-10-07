FROM ctrails

ADD . /code
WORKDIR /code
RUN bundle install
RUN bundle exec rake db:create
RUN bundle exec rake db:migrate
CMD bundle exec rails s
