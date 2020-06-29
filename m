Return-Path: <jmoyer@redhat.com>
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v1 0/3] fio: option to make engines load dynamically
References: <cover.1592981060.git.ykorman@gmail.com>
Date: Mon, 29 Jun 2020 11:27:54 -0400
In-Reply-To: <cover.1592981060.git.ykorman@gmail.com> (Yigal Korman's message
	of "Sun, 28 Jun 2020 22:27:55 +0300")
Message-ID: <x49v9j928p1.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
To: Yigal Korman <ykorman@gmail.com>
Cc: axboe@kernel.dk, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Yigal Korman <ykorman@gmail.com> writes:

> Hi,
>
> The following patchset provides a configuration option that converts a
> select set of engines into external engines that are loaded dynamically
> on demand.  The purpose of this option is to provide distribution
> packagers the ability to separate the core fio functionality from the
> addition optional engines.  Some of the optional engines have multiple
> dependencies that increase the footprint of fio considerably even when
> the user requires only the basic 'sync' engine.  See examples of the
> issue below.

Did you forget to include the examples?

I'm not sure I see a benefit to this change.  fio isn't some core system
service--it's a benchmarking tool.  Maybe your examples shed more light
on why this matters?

-Jeff

>
> I've tried to keep the changes as small and unobtrusive as possible.
> The only significant change is the way an engine is defined in the
> Makefile (variables are now prefixed with engine name).  If the option
> is provided, the Makefile will build the engines as external libraries
> and install them in /usr/lib/fio by default.  Fio will then search for
> the engines in that location if the engine is not compiled in.  The last
> patch should help with the migration to the new scheme by suggesting
> that an additional package is required if the engine is not found.
>
> Future work to consider:
> * Move the engine help text from fio to the engines themselves.  Create
> * a whitelist of engines so that only engines that are part of the main
> * codebase are searched and loaded automatically.  Convert more engines
> * to this scheme. The current set of engines was selected based on
> * simplicity and external dependencies. Engines with multiple exported
> * flavors (i.e. glusterfs) are not converted yet.
>
> Branch is also available on github, at
> https://github.com/ykorman/fio/tree/dynamic-libengines.
>
> A sample of how to package fio with this new mode for RPM-based
> distributions is available here:
> https://src.fedoraproject.org/fork/ykorman/rpms/fio/tree/dynamic-libengines
>
> A sample of the packages for Fedora can be found here:
> https://copr.fedorainfracloud.org/coprs/ykorman/fio/
>
> See examples of how this improves our quality of life (tm) below the
> pull summary.
>
>
> Yigal Korman (3):
>   configure/Makefile: engine LIBS consistency
>   configure: new --dynamic-libengines build option
>   fio: suggest installing engine package when missing
>
>  .gitignore         |  1 +
>  Makefile           | 86 +++++++++++++++++++++++++++++++++++++---------
>  configure          | 20 +++++------
>  engines/dev-dax.c  |  2 +-
>  engines/guasi.c    |  2 +-
>  engines/http.c     |  2 +-
>  engines/libaio.c   |  2 +-
>  engines/libhdfs.c  |  6 ++--
>  engines/libiscsi.c |  6 ++--
>  engines/libpmem.c  |  2 +-
>  engines/libzbc.c   |  2 +-
>  engines/nbd.c      |  2 +-
>  engines/pmemblk.c  |  2 +-
>  engines/rados.c    |  2 +-
>  engines/rbd.c      |  2 +-
>  engines/rdma.c     |  9 ++---
>  ioengines.c        | 26 ++++++++++++--
>  ioengines.h        |  6 ++++
>  os/os-linux.h      |  2 ++
>  19 files changed, 131 insertions(+), 51 deletions(-)


