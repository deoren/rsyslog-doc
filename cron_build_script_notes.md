# Cron build script scratch notes

## Summary

Here are some of my scratch notes as I worked out the direction the next
version of the script was going to take.

## Mirrors

With a mirror, you areil mited to just the one remote. With a colone, you can
add multiple remotes. If using mirrors, you have to build from a separate
mirror for each fork.

More local storage, less bandwidth needed. A tradeoff.

Mirrors are hard to corrupt because they reset or update. You clone from them
and throw away the clone when finished.

Using mirrors allows swapping out file paths for URLs. The "sync" function
can check the source value for http prefix and sync the mirror on a match.
If no match, then no sync and direct clone.

Example of a URL structure to host docs for multiple projects based on
main project / fork / branch:

    http://docs.whyaskwhy.org/rsyslog/deoren/master/

### Maintaining mirrors

One script can handle setting up mirrors and updating them. The other approach
is manual effort to set up everything in advance and configuring the script
to use them. If the list of mirrors is kept in the repo, it can be managed
there.

- conf file included early, values become global
- lose the controller script
- use logger to log to syslog
- specify base dir
- specify virtualenv (pre-create?)

- If using Docker, virtualenv is not needed.
- Early version of the script does not need worry with creating virtualenv.
  That can be done manually.

Things the controller script does (or just misc details about it):

- called directly
- sets WIP flag for active builds (to keep them from stepping on each other)
- logs all output
- sets up build dirs
- syncs content to web root

The main script can do all of this with modification.

Note: The SQLite db support is crucial to keep from rebuilding everything.


SQLite db schema:

- id (table row)
- fork
- branch
- commit
- status (0=success, 1=failed, 2=running)
- start
- finish

Status page could be generated from db contents. Nagios could also monitor
based on those details.


Docker image:

- include Git
- pip install before or after?

behavior:

1. boot
1. clone
1. attach remotes
1. fetch everything
- local SQLite db for state


## build directly to web root?

Right now intermediate directory is used


- External conf file
- External functions include file

Early test version can use local mirrors (presumably to speed things up)

Mirrors are more complex and require syncing, just as a regular repo. However
using that as a base can be useful. How much bandwidth is saved by using
a local mirror vs a standard clone?

Perhaps standard "source" or "master" local clone that is itself cloned (
with the new clone severed from pushing back?). If you clone a clone, are
the remotes brought in as well? (I don't think so).

Perhaps a mirrors dir structure?

$HOME/rsyslog-doc/venv
$HOME/rsyslog-doc/build
$HOME/rsyslog-doc/output
$HOME/rsyslog-doc/mirrors/rgerhards
$HOME/rsyslog-doc/mirrors/deoren
$HOME/rsyslog-doc/mirrors/jgerhards
$HOME/rsyslog-doc/mirrors/...

The mirror dirs could be looped over and cloned, using the dir names
as names for output dirs.

- Build all tags for official mirror only
- Disable tarball creation by default (save time, not needed since release
  script handles this)

Prereqs (cron script does not handle):

- install pip package
- install virtualenv package
- install sqlite3 command-line tool

To begin with, I will manually setup the virtual environment.

**EDIT**: Perhaps this is the best approach regardless.

A docker image would make setting up a buildbox easier for team members
who wish to run locally, but would not be needed if running centrally.

Do we use the "edit on GitHub" Sphinx extension? If not, perhaps disable
it in order to enable multi-threaded build jobs.

## Docker design

Point at source directory and execute.

This only happens for builds that are needed? e.g., spin up and down the Docker
image as needed instead of continuously running?

Move forward with existing notes and revisit this idea once I learn more
about using Docker as a general utility.
