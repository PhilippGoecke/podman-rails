#FROM ruby:3.0
FROM docker.io/ruby:3.0

#RUN apt install libsqlite3-dev

WORKDIR /usr/src/app

RUN bundle init \
  && bundle add rails \
  && bundle install

RUN bundle exec rails new . --force --skip-git --database=sqlite3 --minimal

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN bundle exec rails generate controller welcome index \
  && sed -i 's/end/\n  root to: "welcome#index"\nend/g' config/routes.rb

#RUN sed -i 's/end/\n  get "healthcheck", to: proc { [200, {}, ['success']] }\nend/g' config/routes.rb
RUN sed -i 's+end+\n  get "/healthcheck", to: ->(env) { [204, {}, ['']] }\nend+g' config/routes.rb

ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true

RUN bundle exec rails assets:precompile

HEALTHCHECK --interval=35s --timeout=4s CMD curl -f http://localhost:3000/healthcheck || exit 1

EXPOSE 3000

CMD bundle exec rails server -b 0.0.0.0 -p 3000