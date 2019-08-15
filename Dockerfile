FROM ruby:2.6.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN apt-get update \
  && apt-get install libxi6 \
  libnss3 \
  libgconf-2-4 \
  fonts-liberation \
  libappindicator3-1 \
  libasound2 \
  libatk-bridge2.0-0 \
  libatk1.0-0 \
  libcups2 \
  libgtk-3-0 \
  libx11-xcb1 \
  libxss1 \
  lsb-release \
  xdg-utils \
  libxcomposite1 -y
RUN curl -L -o google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome.deb
RUN sed -i 's|HERE/chrome\"|HERE/chrome\" --no-sandbox|g' /opt/google/chrome/google-chrome
RUN rm google-chrome.deb

RUN mkdir /usr/src/myapp
RUN mkdir /usr/src/myapp/output
WORKDIR /usr/src/myapp
COPY Gemfile /usr/src/myapp/Gemfile
COPY Gemfile.lock /usr/src/myapp/Gemfile.lock
RUN bundle install
COPY . /usr/src/myapp
