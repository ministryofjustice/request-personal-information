FROM ruby:3.3.6-alpine as base

# Rails app lives here
WORKDIR /app

# tzdata: required to set timezone
RUN apk add --no-cache \
    tzdata \
    postgresql-client

# Ensure latest rubygems is installed
RUN gem update --system

# Throw-away build stage to reduce size of final image
FROM base as builder

# Install packages needed to build gems
RUN apk --no-cache add \
    ruby-dev \
    build-base \
    postgresql-dev \
    tzdata \
    yarn

# Copy required files
COPY .ruby-version Gemfile* package.json yarn.lock ./

# Install gems and node packages
RUN bundle config deployment true && \
    bundle config without development test && \
    bundle install --jobs 4 --retry 3 && \
    yarn install --frozen-lockfile --production

# Copy application code
COPY . .

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 \
    bundle exec rails assets:precompile

# Cleanup to save space in the production image
RUN rm -rf node_modules log/* tmp/* /tmp && \
    rm -rf /usr/local/bundle/cache

# Final stage for app image
FROM base

# Copy built artifacts: gems, application
COPY --from=builder /app /app
COPY --from=builder /usr/local/bundle /usr/local/bundle

# Add non-root user and group with alpine first available uid, 1000
RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

# Create log and tmp
RUN mkdir -p log tmp
RUN chown -R appuser:appgroup ./*

# Set user
USER 1000

ARG APP_BUILD_DATE
ENV APP_BUILD_DATE ${APP_BUILD_DATE}

ARG APP_BUILD_TAG
ENV APP_BUILD_TAG ${APP_BUILD_TAG}

ARG APP_GIT_COMMIT
ENV APP_GIT_COMMIT ${APP_GIT_COMMIT}
