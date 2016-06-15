#!/usr/bin/env bash

project_dir=$(dirname $(readlink -f "$0"))

# SIS_TEST_DIR
#
# The directory in which all tests are stored.
# This is by default set to <project_dir>/test, and should be changed
# if an external location is to be used instead.
export SIS_TEST_DIR=${project_dir}/test

# SIS_LOGS_DIR
#
# The directory in which output logs from test executions are stored.
# This is by default set to <project_dir/logs>, and should be changed
# if an external location is to be used instead.
export SIS_LOGS_DIR=${project_dir}/logs

# SIS_QATSERVER_PORT
#
# The port on which qatserver listens (and therefore the port on which
# the dashboard server sends requests for test executions).
# This is by default set to 8421. Change this if this port is currently
# being used by another program.
export SIS_QATSERVER_PORT=8421

# SIS_QATSERVER_EXTRA_ARGS
#
# Extra command line flags that are directly passed to the qatserver
# executable when it is started inside its Docker container (check
# qatserver/run_server.sh).
export SIS_QATSERVER_EXTRA_ARGS=""

# SIS_DASHBOARD_PORT
#
# The port on which the dashboard server listens ie. the QAT Dashboard
# is accessed at http://localhost:${SIS_DASHBOARD_PORT}.
# This is by default set to the default for Rails servers, 3000. Change
# this if this port is currently being used by another program, for
# instance, another Rails server.
export SIS_DASHBOARD_PORT=3000

# SIS_DASHBOARD_EXTRA_ARGS
#
# Extra command line flags that are directly passed to the dashboard
# server executable when it is started inside its Docker container
# (check dashboard/run_dashboard.sh).
export SIS_DASHBOARD_EXTRA_ARGS=""

# SIS_TEST_WEBDRIVER
#
# The webdriver that is used to run the Cucumber tests.
# There are two choices for this:
# - selenium: The Selenium WebDriver
#   (http://www.seleniumhq.org/docs/03_webdriver.jsp) starts up a
#   Firefox Browser tab and allows for programmatic control over the
#   webpage. Inside a Docker container, the prior installed version of
#   Firefox (docker/firefox-browser-gui) is used. WHen run outside a
#   Docker container, the version of Firefox installed on the user's
#   computer is used.
#   This allows the user to see the results of steps in the test as they
#   are being executed. This is therefore the default choice.
# - poltergeist: THe Poltergeist WebDriver
#   (https://github.com/teampoltergeist/poltergeist) sits on top of
#   PhantomJS, a headless browser that allows for manipulating webpages
#   without having to render them.
#   As a result, test executions are invisible to the user. Headless
#   browsers are the only way in which webpages can be displayed on a
#   remote server, since the server does not have a display attached to
#   render the webpages on. Therefore, on the remote testing server, this
#   option must be selected.
export SIS_TEST_WEBDRIVER=selenium

# SIS_DOCKER_NAMESPACE
#
# The namespace under which Docker images for the project are stored.
# The images are pushed to this namespace (and can be pulled out from it)
# They can be found on the Docker Hub at
# https://hub.docker.com/u/${SIS_DOCKER_NAMESPACE}
export SIS_DOCKER_NAMESPACE=ucberkeley
