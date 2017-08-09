FROM ruby:2.3
WORKDIR /app
ARG LITA_ENV
ENV PORT=80

RUN apt-get update && \
    apt-get install --no-install-recommends -y git curl supervisor && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ADD ./Gemfile /app/
ADD ./Gemfile.lock /app/

RUN if [ "$LITA_ENV" = "development" ]; then bundle install; else bundle install --without development test; fi

ADD ./docker/supervisord.conf /etc/supervisor/conf.d/app.conf
ADD ./ /app

RUN (cd /app && git log --format="%H" -n 1 > commit_id.txt)

EXPOSE 80

CMD ["bash", "/app/docker/start.sh"]
