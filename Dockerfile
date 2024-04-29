FROM ruby:3.3.1-slim as base

# Rails app lives here
WORKDIR /app

# Set production environment
ENV RAILS_ENV="production"


# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build gems
RUN apt-get update && apt-get install build-essential yarn

# Copy required files
COPY .ruby-version Gemfile* ./

# Install gems and remove gem cache
RUN gem install bundler -v 2.5.9
RUN bundle config deployment true && \
    bundle config without development test && \
    bundle install --jobs 4 --retry 3

# Install node packages defined in package.json
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --check-files

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile


# Final stage for app image
FROM base

# libpq: required to run postgres, tzdata: required to set timezone
RUN apt-get install tzdata

# Copy built artifacts: gems, application
COPY --from=build /app /app
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /node_modules /nmode_modules

# Add non-root user and group with alpine first available uid, 1000
RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

# Create log and tmp
RUN mkdir -p log tmp
RUN chown -R appuser:appgroup db log tmp

# Set user
USER 1000

ARG APP_BUILD_DATE
ENV APP_BUILD_DATE ${APP_BUILD_DATE}

ARG APP_BUILD_TAG
ENV APP_BUILD_TAG ${APP_BUILD_TAG}

ARG APP_GIT_COMMIT
ENV APP_GIT_COMMIT ${APP_GIT_COMMIT}
