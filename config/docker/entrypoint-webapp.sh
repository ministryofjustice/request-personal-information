#!/bin/sh
set +ex

# Make these available via Settings in the app
export SETTINGS__GIT_COMMIT="$APP_GIT_COMMIT"
export SETTINGS__BUILD_DATE="$APP_BUILD_DATE"
export SETTINGS__GIT_SOURCE="$APP_BUILD_TAG"

printf '\e[33mINFO: Launching Puma\e[0m\n'
printf "\n\e[33mINFO: http://%s/\e[0m\n\n" "$VIRTUAL_HOST"
bundle exec puma -C config/puma.rb -e "${RAILS_ENV}"
set -ex
