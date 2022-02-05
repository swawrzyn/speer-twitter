FROM ruby:3.0.3-slim

# env variables
ENV APP_USER_UID=1000
ENV APP_USER_GID=1000
ENV BUNDLER_VERSION=2.3.6

ARG CHINA_MIRROR=false

RUN addgroup --system user --gid ${APP_USER_GID} && adduser --uid ${APP_USER_UID} --system --group user

# image os update (china mirror) and deps if in china
RUN if [ "$CHINA_MIRROR" = "true" ]; then sed -i s@deb.debian.org@mirrors.tuna.tsinghua.edu.cn@g /etc/apt/sources.list; fi
RUN if [ "$CHINA_MIRROR" = "true" ]; then sed -i s@security.debian.org@mirrors.tuna.tsinghua.edu.cn@g /etc/apt/sources.list; fi

# need deps for yarn
RUN apt-get update -qq && apt-get install -y curl gnupg nano

# sort out yarn repo
RUN curl https://deb.nodesource.com/setup_12.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# get deps
RUN apt-get update -qq && apt-get install -y nodejs yarn build-essential git wget libsqlite3-dev

# update ruby/bundle sources to china
RUN if [ "$CHINA_MIRROR" = "true" ]; then gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/; fi
RUN if [ "$CHINA_MIRROR" = "true" ]; then bundle config mirror.https://rubygems.org https://gems.ruby-china.com; fi

# update yarn registry to china
RUN if [ "$CHINA_MIRROR" = "true" ]; then yarn config set registry https://registry.npm.taobao.org/; fi

WORKDIR /app

COPY --chown=user:user Gemfile /app/Gemfile
COPY --chown=user:user Gemfile.lock /myapp/Gemfile.lock
COPY --chown=user:user . /app

RUN mkdir /bundle
RUN chown -R user:user /bundle

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

RUN gem update --system && \
    gem install bundler -v $BUNDLER_VERSION && \
    bundle install

ENTRYPOINT ["entrypoint.sh"]

ENV PATH="${BUNDLE_BIN}:${PATH}"

USER user

EXPOSE 3000


# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]