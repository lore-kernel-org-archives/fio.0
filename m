Return-Path: <ykorman@gmail.com>
Return-Path: <ykorman@gmail.com>
From: Yigal Korman <ykorman@gmail.com>
Subject: [PATCH v1 0/3] fio: option to make engines load dynamically
Date: Sun, 28 Jun 2020 22:27:55 +0300
Message-Id: <cover.1592981060.git.ykorman@gmail.com>
To: axboe@kernel.dk
Cc: Yigal Korman <ykorman@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi,

The following patchset provides a configuration option that converts a
select set of engines into external engines that are loaded dynamically
on demand.  The purpose of this option is to provide distribution
packagers the ability to separate the core fio functionality from the
addition optional engines.  Some of the optional engines have multiple
dependencies that increase the footprint of fio considerably even when
the user requires only the basic 'sync' engine.  See examples of the
issue below.

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

See examples of how this improves our quality of life (tm) below the
pull summary.


Yigal Korman (3):
  configure/Makefile: engine LIBS consistency
  configure: new --dynamic-libengines build option
  fio: suggest installing engine package when missing

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
 ioengines.c        | 26 ++++++++++++--
 ioengines.h        |  6 ++++
 os/os-linux.h      |  2 ++
 19 files changed, 131 insertions(+), 51 deletions(-)

-- 
2.17.1



Fedora 31 install of fio, before the the patches (redacted for brevity):

[root@host ~]# dnf install  fio
Dependencies resolved.
==========================================================
 Package                   Version                   Size
==========================================================
Installing:
 fio                       3.14-3.fc31              524 k
Installing dependencies:
 cpio                      2.12-12.fc31             260 k
 daxctl-libs               68-1.fc31                 38 k
 dracut                    050-26.git20200316.fc31  321 k
 findutils                 1:4.6.0-25.fc31          517 k
 hwdata                    0.336-1.fc31             1.4 M
 kbd-legacy                2.0.4-14.fc31            464 k
 kbd-misc                  2.0.4-14.fc31            1.5 M
 kmod                      26-4.fc31                122 k
 libaio                    0.3.111-6.fc31            24 k
 libibverbs                20.1-6.fc31              256 k
 libkcapi                  1.1.5-1.fc31              47 k
 libkcapi-hmaccalc         1.1.5-1.fc31              29 k
 libnl3                    3.5.0-1.fc31             331 k
 libpmem                   1.7-1.fc31                80 k
 libpmemblk                1.7-1.fc31                92 k
 librados2                 2:14.2.9-2.fc31          3.5 M
 librbd1                   2:14.2.9-2.fc31          1.8 M
 librdmacm                 20.1-6.fc31               66 k
 lttng-ust                 2.10.4-2.fc31            271 k
 ndctl-libs                68-1.fc31                 77 k
 nspr                      4.25.0-1.fc31            137 k
 nss                       3.53.0-1.fc31            677 k
 nss-softokn               3.53.0-1.fc31            441 k
 nss-softokn-freebl        3.53.0-1.fc31            248 k
 nss-sysinit               3.53.0-1.fc31             20 k
 nss-util                  3.53.0-1.fc31             89 k
 numactl-libs              2.0.12-3.fc31             30 k
 pciutils                  3.6.4-1.fc31              90 k
 pciutils-libs             3.6.4-1.fc31              41 k
 procps-ng                 3.3.15-6.fc31            326 k
 rdma-core                 20.1-6.fc31               51 k
 systemd-udev              243.8-1.fc31             1.3 M
 userspace-rcu             0.11.1-2.fc31            104 k
 xz                        5.2.4-6.fc31             147 k
Installing weak dependenc
 kbd                       2.0.4-14.fc31            391 k
 kpartx                    0.8.0-3.fc31              55 k
 pigz                      2.4-5.fc31                78 k
 systemd-bootchart         233-5.fc31                71 k

Transaction Summary
=========================================================
Install  39 Packages

Total download size: 16 M
Installed size: 57 M

After this patchset:

[root@host ~]# dnf install fio
===============================================
 Package                  Version         Size
===============================================
Installing:
 fio                      3.20-1.fc33    526 k
Installing dependencies:
 numactl-libs             2.0.12-3.fc31   30 k

Transaction Summary
===============================================
Install  2 Packages

Total size: 557 k
Total download size: 30 k
Installed size: 2.1 M

And when a specific engine is needed:
[root@host ~]# dnf install fio-engine-rados
Dependencies resolved.
========================================================
 Package                 Version                   Size
========================================================
Installing:
 fio-engine-rados        3.20-1.fc33               15 k
Installing dependencies:
 cpio                    2.12-12.fc31             260 k
 dracut                  050-26.git20200316.fc31  321 k
 findutils               1:4.6.0-25.fc31          517 k
 hwdata                  0.336-1.fc31             1.4 M
 kbd-legacy              2.0.4-14.fc31            464 k
 kbd-misc                2.0.4-14.fc31            1.5 M
 kmod                    26-4.fc31                122 k
 libibverbs              20.1-6.fc31              256 k
 libkcapi                1.1.5-1.fc31              47 k
 libkcapi-hmaccalc       1.1.5-1.fc31              29 k
 libnl3                  3.5.0-1.fc31             331 k
 librados2               2:14.2.9-2.fc31          3.5 M
 librdmacm               20.1-6.fc31               66 k
 lttng-ust               2.10.4-2.fc31            271 k
 nspr                    4.25.0-1.fc31            137 k
 nss                     3.53.0-1.fc31            677 k
 nss-softokn             3.53.0-1.fc31            441 k
 nss-softokn-freebl      3.53.0-1.fc31            248 k
 nss-sysinit             3.53.0-1.fc31             20 k
 nss-util                3.53.0-1.fc31             89 k
 pciutils                3.6.4-1.fc31              90 k
 pciutils-libs           3.6.4-1.fc31              41 k
 procps-ng               3.3.15-6.fc31            326 k
 rdma-core               20.1-6.fc31               51 k
 systemd-udev            243.8-1.fc31             1.3 M
 userspace-rcu           0.11.1-2.fc31            104 k
 xz                      5.2.4-6.fc31             147 k
Installing weak dependenc
 kbd                     2.0.4-14.fc31            391 k
 kpartx                  0.8.0-3.fc31              55 k
 pigz                    2.4-5.fc31                78 k
 systemd-bootchart       233-5.fc31                71 k

Transaction Summary
========================================================
Install  32 Packages

Total size: 13 M
Total download size: 13 M
Installed size: 48 M


