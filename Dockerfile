# Use the official Ruby 3.3 image based on Debian's Trixie release
FROM ruby:3.3-bookworm

# Install Jekyll's build dependencies.
# The 'build-essential' package includes tools like 'gcc' and 'make'
# which are required to compile some of the gems.
# 'zlib1g-dev' and 'libxml2-dev' are specifically needed for gems like 'nokogiri'.
RUN set -eux \
    apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    libxml2-dev \
    # build-essential \ this is included in the buildpack-deps base image
    # zlib1g-dev \

    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container.

WORKDIR /site

# Install bundler & github-pages (which includes Jekyll + plugins used by GitHub Pages)

RUN gem install bundler && \
gem install github-pages --no-document && \

# Other required gems
gem install rubygems-update --no-document && \
gem install faraday-retry --no-document && \
gem install tzinfo-data --no-document

# Expose port 4000, which Jekyll's server uses by default.
EXPOSE 4000

# Define the default command to run when the container starts.
# 'bundle exec jekyll serve' runs the Jekyll server.
# '--livereload' automatically reloads your browser when files change.
# '--host 0.0.0.0' makes the server accessible from outside the container,
# which is necessary for you to view the site from your host machine.
ENTRYPOINT ["bundle", "exec", "jekyll"]

CMD ["serve", "--host", "0.0.0.0"]

