# QA Test Automation (QATA) framework
for UC Berkeley Student Information Systems (SIS).

[![Build Status](https://travis-ci.org/ucberkeley/sis-qa-test-auto.svg)](https://travis-ci.org/ucberkeley/sis-qa-test-auto)


## Installation

The QA Test Automation framework is itself highly automated. There are a number of ways to set
up and run the framework. The two main components: server and dashboard have been
[Docker](https://www.docker.com/)ized. Local installation is also possible but not recommended.

The framework is intended to work on an Ubuntu server. But it can be set up to work on
macOS/Windows as well inside a Ubuntu VM.

**Note** that this section explains how to install the framework locally for running tests
locally before pushing to the testing server. The testing server itself is an Ubuntu 14.04
machine with Docker installed. Therefore, the
[Installation on Linux using Docker Engine](#installation-on-linux-using-docker-engine)
installation method has been followed on it.


### <a name="installation-on-macos-windows"></a>On macOS/Windows

1. Install a VM manager like [VirtualBox](https://www.virtualbox.org/wiki/Downloads).

1. Set up a VM using a [Ubuntu 14.04](http://releases.ubuntu.com/14.04/) 64-bit Desktop image.

1. Start up the VM and follow instructions for [installation on Linux](#installation-on-linux)
inside it.


### <a name="installation-on-linux"></a>On Linux

1. Clone this repository.

2. Follow instructions in one of these sections.

#### <a name="installation-on-linux-using-docker-engine"></a> Using Docker Engine _[preferred method]_
This method uses pre-built images from the
[ucberkeley public Docker registry](https://hub.docker.com/r/ucberkeley/). Alternatively, images
can be built locally by running `scripts/build.sh` (after installing Docker Engine).

1. [Install Docker Engine](https://docs.docker.com/installation/).

1. Install the QATA framework with `scripts/install.sh`. This will create a symlink to the server
script in /usr/bin.

1. Run the service with `qata start` (may required sudo). The first run will take longer since the
docker container will be downloaded and then run.

1. When required, stop the service with `qata stop`, or restart with `qata restart`

1. If required, attach to the service with `qata attach`.

#### <a name="installation-on-linux-using-docker-compose"></a>Using Docker Compose (along with Docker Engine)
This method uses Docker Compose to automate the process of building and running images.

1. [Install Docker Compose](https://docs.docker.com/compose/install/) (in addition to [Docker
Engine](https://docs.docker.com/installation/)).

1. In the project directory, run `source env.sh` followed by `docker-compose up` (May require sudo.
Run as `sudo -E docker-compose up` to pass in environment variables). The first run will take
longer since the Docker images will be built and then run.

### <a name="installation-using-vagrant"></a>Using Vagrant _[experimental]_
This method runs Docker Engine inside a Vagrant VM.

1. Install [Vagrant](https://www.vagrantup.com/downloads.html).

1. In the project directory, run `vagrant up`. This will also build the Docker images inside the
VM and set all environment variables.

1. `vagrant ssh` into the VM and then start the service with `sudo -E qata start`.

### Installing locally
This method may speed up testing, but is otherwise not recommended. Follow instructions in
[qatserver/README.md](qatserver/README.md) and [dashboard/README.md](dashboard/README.md).


## Update
Updates to the framework can take a number of forms.

- tests: This refers to the Cucumber features (and associated files) that are being executed on
every run of the framework. No special steps needs to be followed to update the framework while
running on your own machine. These will get automatically picked up the next time tests are run.

- credentials: This refers to the credentials used to access various pages when tests are run.
Once again no special steps need to be followed to update the framework while running on your
own machine.

- code: This refers to code changes in the qatserver or the dashboard. These would be very rare.
In this case, the framework needs to be restarted for the code changes to be reflected. This can
be done with `qata restart` (may require sudo).


## Troubleshoot

## Additional notes
1. Keep the test execution server files and Gemfile (and Gemfile.lock) in docker/sis-qa-test-auto
in sync with corresponding file(s) in the server directory and the test directory by running
`scripts/sync.sh`. The up-to-date Gemfile will ensure that all required gems are installed when
the sis-qa-test-auto docker container is being built. Though all dependencies are checked for
during test execution, and installed if not satisfied, having them pre-installed will speed up
test execution considerably.

1. You can clean up the logs folder by running `scripts/cleanup.sh`.
