Return-Path: <ykorman@gmail.com>
MIME-Version: 1.0
References: <cover.1592981060.git.ykorman@gmail.com> <x49v9j928p1.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49v9j928p1.fsf@segfault.boston.devel.redhat.com>
From: Yigal Korman <ykorman@gmail.com>
Date: Mon, 29 Jun 2020 21:47:20 +0300
Message-ID: <CAOdGBnGJatAiXZ8PjfeK1s7Y5+kVh-S3cqwPNncS0NoMSutpYw@mail.gmail.com>
Subject: Re: [PATCH v1 0/3] fio: option to make engines load dynamically
Content-Type: text/plain; charset="UTF-8"
To: Jeff Moyer <jmoyer@redhat.com>
Cc: axboe@kernel.dk, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi Jeff,

Thanks for taking a look at this.
Answers (this time in plain text, sorry about that) inline below.

On Mon, Jun 29, 2020 at 6:28 PM Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Yigal Korman <ykorman@gmail.com> writes:
>
> > Hi,
> >
> > The following patchset provides a configuration option that converts a
> > select set of engines into external engines that are loaded dynamically
> > on demand.  The purpose of this option is to provide distribution
> > packagers the ability to separate the core fio functionality from the
> > addition optional engines.  Some of the optional engines have multiple
> > dependencies that increase the footprint of fio considerably even when
> > the user requires only the basic 'sync' engine.  See examples of the
> > issue below.
>
> Did you forget to include the examples?

Sorry, I didn't, it's easy to miss though, they're below the pull summary.

They are a bit verbose, so I'll recap here:
Without the patchset, on a Fedora 31 system, installing fio brings a
total of 38 package dependencies, the installed size is 57MB.
With the patchset, installing fio brings a single dependency
(numactl-libs) and the installed size is 2.1MB.

These numbers are relatively small but when one needs to bring fio to
an offline server, collecting these dependencies is a hassle.
Also, bundling fio into a container where the base image is small
(Fedora 31 is ~200MB), the install size becomes more prominent.

>
> I'm not sure I see a benefit to this change.  fio isn't some core system
> service--it's a benchmarking tool.  Maybe your examples shed more light
> on why this matters?

I actually think that although fio is a benchmarking tool, it became
so ubiquitous in the storage world that I'd consider it a core tool.
I think all recent storage-related research papers and product
brochures that I saw have always included fio performance numbers.
Perhaps, if it will be possible to reduce its footprint, we might
start seeing it on the distro's base install.

Regards,
Yigal

>
> -Jeff
>
> >
> > I've tried to keep the changes as small and unobtrusive as possible.
> > The only significant change is the way an engine is defined in the
> > Makefile (variables are now prefixed with engine name).  If the option
> > is provided, the Makefile will build the engines as external libraries
> > and install them in /usr/lib/fio by default.  Fio will then search for
> > the engines in that location if the engine is not compiled in.  The last
> > patch should help with the migration to the new scheme by suggesting
> > that an additional package is required if the engine is not found.
> >
> > Future work to consider:
> > * Move the engine help text from fio to the engines themselves.  Create
> > * a whitelist of engines so that only engines that are part of the main
> > * codebase are searched and loaded automatically.  Convert more engines
> > * to this scheme. The current set of engines was selected based on
> > * simplicity and external dependencies. Engines with multiple exported
> > * flavors (i.e. glusterfs) are not converted yet.
> >
> > Branch is also available on github, at
> > https://github.com/ykorman/fio/tree/dynamic-libengines.
> >
> > A sample of how to package fio with this new mode for RPM-based
> > distributions is available here:
> > https://src.fedoraproject.org/fork/ykorman/rpms/fio/tree/dynamic-libengines
> >
> > A sample of the packages for Fedora can be found here:
> > https://copr.fedorainfracloud.org/coprs/ykorman/fio/
> >
> > See examples of how this improves our quality of life (tm) below the
> > pull summary.
> >
> >
> > Yigal Korman (3):
> >   configure/Makefile: engine LIBS consistency
> >   configure: new --dynamic-libengines build option
> >   fio: suggest installing engine package when missing
> >
> >  .gitignore         |  1 +
> >  Makefile           | 86 +++++++++++++++++++++++++++++++++++++---------
> >  configure          | 20 +++++------
> >  engines/dev-dax.c  |  2 +-
> >  engines/guasi.c    |  2 +-
> >  engines/http.c     |  2 +-
> >  engines/libaio.c   |  2 +-
> >  engines/libhdfs.c  |  6 ++--
> >  engines/libiscsi.c |  6 ++--
> >  engines/libpmem.c  |  2 +-
> >  engines/libzbc.c   |  2 +-
> >  engines/nbd.c      |  2 +-
> >  engines/pmemblk.c  |  2 +-
> >  engines/rados.c    |  2 +-
> >  engines/rbd.c      |  2 +-
> >  engines/rdma.c     |  9 ++---
> >  ioengines.c        | 26 ++++++++++++--
> >  ioengines.h        |  6 ++++
> >  os/os-linux.h      |  2 ++
> >  19 files changed, 131 insertions(+), 51 deletions(-)
>

