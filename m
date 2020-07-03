Return-Path: <ykorman@gmail.com>
Return-Path: <ykorman@gmail.com>
From: Yigal Korman <ykorman@gmail.com>
Subject: [PATCH v2 0/4] fio: option to make engines load dynamically
Date: Fri,  3 Jul 2020 15:38:39 +0300
Message-Id: <cover.1593761533.git.ykorman@gmail.com>
To: axboe@kernel.dk
Cc: Yigal Korman <ykorman@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

The following patchset provides a configuration option that converts a
select set of engines into external engines that are loaded dynamically
on demand.  The purpose of this option is to provide distribution
packagers the ability to separate the core fio functionality from the
additional optional engines.  Some of the optional engines have multiple
dependencies that increase the footprint of fio considerably even when
the user requires only the basic 'sync' engine.

For example, without the patchset, on a Fedora 31 system, installing fio
brings a total of 38 package dependencies, the installed size is 57MB.
With the patchset, installing fio brings a single dependency
(numactl-libs) and the installed size is 2.1MB.

These numbers are relatively small but when one needs to bring fio to
an offline server, collecting these dependencies is a hassle.
Also, bundling fio into a container where the base image is small
(Fedora 31 is ~200MB), the install size becomes more prominent.

I've tried to keep the changes as small and unobtrusive as possible.
The only significant change is the way an engine is defined in the
Makefile (variables are now prefixed with engine name).  If the option
is provided, the Makefile will build the engines as external libraries
and install them in /usr/lib/fio by default.  Fio will then search for
the engines in that location if the engine is not compiled in.  The last
patch should help with the migration to the new scheme by suggesting
that an additional package is required if the engine is not found.

Future work to consider:
* Move the engine help text from fio to the engines themselves.  Create
* a whitelist of engines so that only engines that are part of the main
* codebase are searched and loaded automatically.  Convert more engines
* to this scheme. The current set of engines was selected based on
* simplicity and external dependencies. Engines with multiple exported
* flavors (i.e. glusterfs) are not converted yet.

Branch is also available on github, at
https://github.com/ykorman/fio/tree/dynamic-libengines.

A sample of how to package fio with this new mode for RPM-based
distributions is available here:
https://src.fedoraproject.org/fork/ykorman/rpms/fio/tree/dynamic-libengines

A sample of the packages for Fedora can be found here:
https://copr.fedorainfracloud.org/coprs/ykorman/fio/

Changes since v1:
- updated the description above with a concise example instead of a big
  blob of mess below the pull summary.
- added a patch that fixes meaningless retry of engine loading when
  engine is not found.
  updated the info message of the last patch based on a suggestion by
  Jens.

Yigal Korman (4):
  fio: don't retry engine search on failure
  configure/Makefile: engine LIBS consistency
  configure: new --dynamic-libengines build option
  fio: better info when engine not found

 .gitignore         |  1 +
 Makefile           | 86 +++++++++++++++++++++++++++++++++++++---------
 configure          | 20 +++++------
 engines/dev-dax.c  |  2 +-
 engines/guasi.c    |  2 +-
 engines/http.c     |  2 +-
 engines/libaio.c   |  2 +-
 engines/libhdfs.c  |  6 ++--
 engines/libiscsi.c |  6 ++--
 engines/libpmem.c  |  2 +-
 engines/libzbc.c   |  2 +-
 engines/nbd.c      |  2 +-
 engines/pmemblk.c  |  2 +-
 engines/rados.c    |  2 +-
 engines/rbd.c      |  2 +-
 engines/rdma.c     |  9 ++---
 init.c             | 14 +++++---
 ioengines.c        | 26 ++++++++++++--
 ioengines.h        |  6 ++++
 os/os-linux.h      |  2 ++
 20 files changed, 141 insertions(+), 55 deletions(-)

-- 
2.17.1


