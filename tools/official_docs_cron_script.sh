#!/bin/bash



#####################################################################
# Functions
#####################################################################

get_release_version() {

	# Retrieve the list of Git tags and return the newest without
    # the leading 'v' prefix character
	git tag --list 'v*' | \
	sort --version-sort | \
	grep -Eo '^v[.0-9]+$' | \
	tail -n 1 |\
	sed "s/[A-Za-z]//g"
}


#####################################################################
# Setup
#####################################################################

# The latest stable tag, but without the leading 'v'
# Format: X.Y.Z
release=$(get_release_version)

# The release version, but without the trailing '.0'
# Format: X.Y
version=$(echo $release | sed 's/.0//')

# This is the set of sphinx-build options that will be passed into
# the Docker container for use during doc builds. We pass these
# values in to override the dev build behavior of using
# extended/verbose attributes in the doc title so that standard
# version and release values are used instead.
sphinx_stable_build_variables="-D version=${version} -D release=${release}"

# Which docker image should be used for the build?
# https://hub.docker.com/r/rsyslog/rsyslog_doc_gen/
docker_image="rsyslog/rsyslog_doc_gen"

# What additional options should be used for the build?
sphinx_extra_options="-q"

# Remote server or web root here
# Note: placeholder value provided for testing
rsync_destination="/tmp/rsyslog-build-output"

# The new docs created by sphinx-build
rsync_source="build"

# TODO: Needs a better default
docs_source_dir="$HOME/rsyslog-doc"



#####################################################################
# Script body
#####################################################################

echo "======starting doc generation======="
docker pull rsyslog/rsyslog_doc_gen # get fresh version
export DOC_HOME="$docs_source_dir"
cd $DOC_HOME

for branch in v5-stable v7-stable v8-stable master;
do
        echo "**** $branch ****"
        rm -rf build
        git reset --hard
        git checkout -f $branch

        # We depend on local tags being present in order to calculate
        # the latest stable version
        git pull --tags

        # change config to use rsyslog site theme
        sed -i "s/^[ ]*html_theme = '.*'/from better import better_theme_path\\n\
html_theme_path = \[better_theme_path\]\\n\
html_theme = 'better'/" source/conf.py

        sed -i "s/^.*html_theme_options = {.*}/html_theme_options = {\
        'inlinecss': ' @media (max-width: 820px) { div.sphinxsidebar { visibility: hidden; } }',\
        }/" source/conf.py

        # Use stable tag version/release info only for v8-stable branch
        if [[ "$branch" == "v8-stable" ]]; then
            sphinx_build_variables="$sphinx_stable_build_variables"
        else
            sphinx_build_variables=""
        fi

        docker run -ti --rm \
                -u `id -u`:`id -g` \
                -e STRICT="" \
                -e SPHINX_EXTRA_OPTS="$sphinx_extra_options $sphinx_build_variables" \
                -v "$DOC_HOME":/rsyslog-doc \
                $docker_image
        rsync -rz $rsync_source/* $rsync_destination/$branch/
done
