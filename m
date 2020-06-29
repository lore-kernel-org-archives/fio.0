Return-Path: <ykorman@gmail.com>
MIME-Version: 1.0
References: <cover.1592981060.git.ykorman@gmail.com> <x49v9j928p1.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49v9j928p1.fsf@segfault.boston.devel.redhat.com>
From: Yigal Korman <ykorman@gmail.com>
Date: Mon, 29 Jun 2020 21:44:19 +0300
Message-ID: <CAOdGBnF_uFjTc13nHp0YNuQVrPrMC0xk-rJsGysymuew7HJy_A@mail.gmail.com>
Subject: Re: [PATCH v1 0/3] fio: option to make engines load dynamically
Content-Type: multipart/alternative; boundary="000000000000051a7205a93d73a1"
To: Jeff Moyer <jmoyer@redhat.com>
Cc: axboe@kernel.dk, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--000000000000051a7205a93d73a1
Content-Type: text/plain; charset="UTF-8"

Hi Jeff,

Thanks for taking a look at this.
Answers inline below.

On Mon, Jun 29, 2020 at 6:28 PM Jeff Moyer <jmoyer@redhat.com> wrote:

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
>

Sorry, I didn't, it's easy to miss though, they're below the pull summary.

They are a bit verbose, so I'll recap here:
Without the patchset, on a Fedora 31 system, installing fio brings a total
of 38 package dependencies, the installed size is 57MB.
With the patchset, installing fio brings a single dependency (numactl-libs)
and the installed size is 2.1MB.

These numbers are relatively small but when one needs to bring fio to an
offline server, collecting these dependencies is a hassle.
Also, bundling fio into a container where the base image is small (Fedora
31 is ~200MB), the install size becomes more prominent.


> I'm not sure I see a benefit to this change.  fio isn't some core system
> service--it's a benchmarking tool.  Maybe your examples shed more light
> on why this matters?
>

I actually think that although fio is a benchmarking tool, it became so
ubiquitous in the storage world that I'd consider it a core tool.
I think all recent storage-related research papers and product brochures
that I saw have always included fio performance numbers.
Perhaps, if it will be possible to reduce its footprint, we might
start seeing it on the distro's base install.

Regards,
Yigal


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
> >
> https://src.fedoraproject.org/fork/ykorman/rpms/fio/tree/dynamic-libengines
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
>

--000000000000051a7205a93d73a1
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Jeff,</div><div><br></div><div>Thanks for taking a=
 look at this.</div><div>Answers inline below.</div><br><div class=3D"gmail=
_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Mon, Jun 29, 2020 at 6:28 =
PM Jeff Moyer &lt;<a href=3D"mailto:jmoyer@redhat.com">jmoyer@redhat.com</a=
>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px=
 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">Yig=
al Korman &lt;<a href=3D"mailto:ykorman@gmail.com" target=3D"_blank">ykorma=
n@gmail.com</a>&gt; writes:<br>
<br>
&gt; Hi,<br>
&gt;<br>
&gt; The following patchset provides a configuration option that converts a=
<br>
&gt; select set of engines into external engines that are loaded dynamicall=
y<br>
&gt; on demand.=C2=A0 The purpose of this option is to provide distribution=
<br>
&gt; packagers the ability to separate the core fio functionality from the<=
br>
&gt; addition optional engines.=C2=A0 Some of the optional engines have mul=
tiple<br>
&gt; dependencies that increase the footprint of fio considerably even when=
<br>
&gt; the user requires only the basic &#39;sync&#39; engine.=C2=A0 See exam=
ples of the<br>
&gt; issue below.<br>
<br>
Did you forget to include the examples?<br></blockquote><div><br></div><div=
>Sorry, I didn&#39;t, it&#39;s easy to miss though, they&#39;re below the p=
ull summary.</div><div><br></div><div>They are a bit verbose, so I&#39;ll r=
ecap here:</div><div>Without the patchset, on a Fedora 31 system, installin=
g fio brings a total of 38 package dependencies, the installed size is 57MB=
.<br></div><div>With the patchset, installing fio brings a single dependenc=
y (numactl-libs) and the installed size is 2.1MB.</div><div><br></div><div>=
These numbers are relatively small but when one needs to bring fio to an of=
fline server, collecting these dependencies is a hassle.</div><div>Also, bu=
ndling fio into a container where the base image is small (Fedora 31 is ~20=
0MB), the install size becomes more prominent.</div><div><br></div><blockqu=
ote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px=
 solid rgb(204,204,204);padding-left:1ex">
<br>
I&#39;m not sure I see a benefit to this change.=C2=A0 fio isn&#39;t some c=
ore system<br>
service--it&#39;s a benchmarking tool.=C2=A0 Maybe your examples shed more =
light<br>
on why this matters?<br></blockquote><div><br></div><div>I actually think t=
hat although fio is a benchmarking tool, it became so ubiquitous=C2=A0in th=
e storage world that I&#39;d consider it a core tool.</div><div>I think all=
 recent storage-related research=C2=A0papers and product brochures that I s=
aw have always included fio performance numbers.</div><div>Perhaps, if it w=
ill be possible to reduce its footprint, we might start=C2=A0seeing it on t=
he distro&#39;s base install.</div><div><br></div><div>Regards,</div><div>Y=
igal</div><div><br></div><blockquote class=3D"gmail_quote" style=3D"margin:=
0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
<br>
-Jeff<br>
<br>
&gt;<br>
&gt; I&#39;ve tried to keep the changes as small and unobtrusive as possibl=
e.<br>
&gt; The only significant change is the way an engine is defined in the<br>
&gt; Makefile (variables are now prefixed with engine name).=C2=A0 If the o=
ption<br>
&gt; is provided, the Makefile will build the engines as external libraries=
<br>
&gt; and install them in /usr/lib/fio by default.=C2=A0 Fio will then searc=
h for<br>
&gt; the engines in that location if the engine is not compiled in.=C2=A0 T=
he last<br>
&gt; patch should help with the migration to the new scheme by suggesting<b=
r>
&gt; that an additional package is required if the engine is not found.<br>
&gt;<br>
&gt; Future work to consider:<br>
&gt; * Move the engine help text from fio to the engines themselves.=C2=A0 =
Create<br>
&gt; * a whitelist of engines so that only engines that are part of the mai=
n<br>
&gt; * codebase are searched and loaded automatically.=C2=A0 Convert more e=
ngines<br>
&gt; * to this scheme. The current set of engines was selected based on<br>
&gt; * simplicity and external dependencies. Engines with multiple exported=
<br>
&gt; * flavors (i.e. glusterfs) are not converted yet.<br>
&gt;<br>
&gt; Branch is also available on github, at<br>
&gt; <a href=3D"https://github.com/ykorman/fio/tree/dynamic-libengines" rel=
=3D"noreferrer" target=3D"_blank">https://github.com/ykorman/fio/tree/dynam=
ic-libengines</a>.<br>
&gt;<br>
&gt; A sample of how to package fio with this new mode for RPM-based<br>
&gt; distributions is available here:<br>
&gt; <a href=3D"https://src.fedoraproject.org/fork/ykorman/rpms/fio/tree/dy=
namic-libengines" rel=3D"noreferrer" target=3D"_blank">https://src.fedorapr=
oject.org/fork/ykorman/rpms/fio/tree/dynamic-libengines</a><br>
&gt;<br>
&gt; A sample of the packages for Fedora can be found here:<br>
&gt; <a href=3D"https://copr.fedorainfracloud.org/coprs/ykorman/fio/" rel=
=3D"noreferrer" target=3D"_blank">https://copr.fedorainfracloud.org/coprs/y=
korman/fio/</a><br>
&gt;<br>
&gt; See examples of how this improves our quality of life (tm) below the<b=
r>
&gt; pull summary.<br>
&gt;<br>
&gt;<br>
&gt; Yigal Korman (3):<br>
&gt;=C2=A0 =C2=A0configure/Makefile: engine LIBS consistency<br>
&gt;=C2=A0 =C2=A0configure: new --dynamic-libengines build option<br>
&gt;=C2=A0 =C2=A0fio: suggest installing engine package when missing<br>
&gt;<br>
&gt;=C2=A0 .gitignore=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=C2=A0 1 +<br>
&gt;=C2=A0 Makefile=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 86 ++++++++++=
+++++++++++++++++++++++++++---------<br>
&gt;=C2=A0 configure=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 20 +++++------<br>
&gt;=C2=A0 engines/dev-dax.c=C2=A0 |=C2=A0 2 +-<br>
&gt;=C2=A0 engines/guasi.c=C2=A0 =C2=A0 |=C2=A0 2 +-<br>
&gt;=C2=A0 engines/http.c=C2=A0 =C2=A0 =C2=A0|=C2=A0 2 +-<br>
&gt;=C2=A0 engines/libaio.c=C2=A0 =C2=A0|=C2=A0 2 +-<br>
&gt;=C2=A0 engines/libhdfs.c=C2=A0 |=C2=A0 6 ++--<br>
&gt;=C2=A0 engines/libiscsi.c |=C2=A0 6 ++--<br>
&gt;=C2=A0 engines/libpmem.c=C2=A0 |=C2=A0 2 +-<br>
&gt;=C2=A0 engines/libzbc.c=C2=A0 =C2=A0|=C2=A0 2 +-<br>
&gt;=C2=A0 engines/nbd.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 2 +-<br>
&gt;=C2=A0 engines/pmemblk.c=C2=A0 |=C2=A0 2 +-<br>
&gt;=C2=A0 engines/rados.c=C2=A0 =C2=A0 |=C2=A0 2 +-<br>
&gt;=C2=A0 engines/rbd.c=C2=A0 =C2=A0 =C2=A0 |=C2=A0 2 +-<br>
&gt;=C2=A0 engines/rdma.c=C2=A0 =C2=A0 =C2=A0|=C2=A0 9 ++---<br>
&gt;=C2=A0 ioengines.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 | 26 ++++++++++++--<br>
&gt;=C2=A0 ioengines.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 6 ++++<br>
&gt;=C2=A0 os/os-linux.h=C2=A0 =C2=A0 =C2=A0 |=C2=A0 2 ++<br>
&gt;=C2=A0 19 files changed, 131 insertions(+), 51 deletions(-)<br>
<br>
</blockquote></div></div>

--000000000000051a7205a93d73a1--

