Return-Path: <greg.freemyer@gmail.com>
MIME-Version: 1.0
In-Reply-To: <543E8BFA.7090207@kernel.dk>
References: <CAMA-6iaCvppOLvBOP6K2+Gt-BEo5x_m_BXvq8xs8K8ezgt132w@mail.gmail.com>
 <543D907B.3080005@kernel.dk> <CADzpL0T6cQ=pWr4iM=0JoV_e-3wfO65s-PgYXC-YPr1mYvzuFQ@mail.gmail.com>
 <543E84BD.9040303@kernel.dk> <CAGpXXZJk2YJQug6pmA0rHY4xAhhgjFxFxStPWB5tF+-bKrEdiQ@mail.gmail.com>
 <543E8BFA.7090207@kernel.dk>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Thu, 16 Oct 2014 16:35:01 -0400
Message-ID: <CAGpXXZLudYQruD_WXZ1VggFXvYWu7UToYe-Tv=njQ+LqdEiYFw@mail.gmail.com>
Subject: Re: BUG - Cannot build fio on redhat 5
Content-Type: multipart/alternative; boundary=047d7b6246642e516205059031c6
To: Jens Axboe <axboe@kernel.dk>
Cc: Stephen Cameron <stephenmcameron@gmail.com>, Tim Delaney <2timdelaney@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--047d7b6246642e516205059031c6
Content-Type: text/plain; charset=UTF-8

On Wed, Oct 15, 2014 at 11:00 AM, Jens Axboe <axboe@kernel.dk> wrote:

> That would be absolutely wonderful. I do some of these manually before
> release, especially if changes have gone in that could affect build on
> various distros. But would be great to have it automated. Unfortunately
> I'm not a rpmfile/deb wizard, and I lack the motivation (and time) to
> take the time to do this. So if anyone would like to step up and help
> out with this, that would be awesome.
>
> Currently the deb and rpm spec files are not included with fio, but they
> do exist in the debian (ish) and rpm based packages that people roll for
> distributions. So hopefully it should not be too much work. It might
> even be a good idea to include them with fio, especially if we're going
> to automate some of this building/testing.
>

If someone will send me a RedHat specfile or Debian deb file I can try
doing a test build.

======== brief background ====
The opensuse build server (and associated local build tool "osc") basically
takes as input the latest tarball and an updated specfile / deb control
file.  If the specfiles and/or deb files were within the tarball a simple
script could be used to extract them and run a test build.

The biggest issue would be if any of the distros require patches to the
tarball for them to build.

opensuse is not carrying any fio patches, so it is clean:

https://build.opensuse.org/package/show/benchmark/fio

Assuming a test build setup was functioning, the build script would just
need lines like:

--------------
 osc build --local-package --alternative-project RedHat:RHEL-5
x86_64 fio.redhat.spec
 osc build --local-package --alternative-project openSUSE:13.1
x86_64 fio.opensuse.spec
...
--------------
Similar for Debian based systems, but I don't know what the control file
name is

To run the test build the user would need to have "osc" installed.  It is
available for several distros:

http://software.opensuse.org/download.html?project=openSUSE%3ATools&package=osc

------------ need a volunteer to do a test openSUSE build via the linux
platform of their choice (assuming it is in the supported list) ------

Step 1: install osc from:
http://software.opensuse.org/download.html?project=openSUSE%3ATools&package=osc

Step 2: Download the 3 fio files (tarball, changes file and specfile) from:
https://build.opensuse.org/package/show/benchmark/fio

Put those 3 files in a test folder and cd into it.

Step 3:
Then attempt a test build of an openSUSE rpm:
osc build --local-package --alternative-project openSUSE:13.1
x86_64 fio.spec

That "osc build" will take several minutes because about 250 packages have
to be downloaded and installed in a chroot jail prior to the actual build
starting.  Those packages will be cached so subsequent builds will be much
faster.

------------ more details ---------
I've only used osc under openSUSE, so I can only state with confidence that
from within openSUSE I can tell osc to do test builds for the various
distros supported.

I "think" that same is true from within any of the supported distros.  As
an example, if I have osc installed in a RedHat box I can use it to do a
cross build of Ubuntu.  If anyone does the test build above we will have a
second data point.

Osc works by creating a chroot jail that it installs the packages needed to
build with into.

As an example "osc build --local-package --alternative-project
RedHat:RHEL-5 x86_64 fio.redhat.spec" will attempt to build a 64-bit Red
Hat rpm from within openSUSE.  The first thing it does is download the
needed packages and install them in a chroot jail.  It assumes the file
fio.redhat.spec exists and has the right content to drive the build.

The PC doing the test builds does have to be on the Internet to be able to
pull down the various packages needed to do the test build.

I provided the list of "alternative-project" options in my last email, but
here it is again:

distribution              project
------------              -------
openSUSE Factory          openSUSE:Factory
openSUSE 13.2             openSUSE:13.2
openSUSE 13.1             openSUSE:13.1
openSUSE 12.3             openSUSE:12.3
openSUSE 12.2             openSUSE:12.2
openSUSE Factory ARM      openSUSE:Factory:ARM
openSUSE Tumbleweed       openSUSE:Tumbleweed
SUSE SLE-11 SP 3          SUSE:SLE-11:SP3
SUSE SLE-11 SP 2          SUSE:SLE-11:SP2
SUSE SLE-10               SUSE:SLE-10:SDK
Arch Core                 Arch:Core
Arch Extra                Arch:Extra
Debian 7.0                Debian:7.0
Debian 6.0                Debian:6.0
Fedora 20                 Fedora:20
Fedora 19                 Fedora:19
Fedora 18                 Fedora:18
ScientificLinux 7         ScientificLinux:7
ScientificLinux 6         ScientificLinux:6
RedHat RHEL-7             RedHat:RHEL-7
RedHat RHEL-6             RedHat:RHEL-6
RedHat RHEL-5             RedHat:RHEL-5
RedHat RHEL-4             RedHat:RHEL-4
CentOS CentOS-7           CentOS:CentOS-7
CentOS CentOS-6           CentOS:CentOS-6
CentOS CentOS-5           CentOS:CentOS-5
Ubuntu 14.04              Ubuntu:14.04
Ubuntu 13.10              Ubuntu:13.10
Ubuntu 12.10              Ubuntu:12.10
Ubuntu 12.04              Ubuntu:12.04
Ubuntu 11.10              Ubuntu:11.10
Ubuntu 10.04              Ubuntu:10.04
Univention UCS 3.2        Univention:3.2
Univention UCS 3.1        Univention:3.1

Greg
--
Greg Freemyer

--047d7b6246642e516205059031c6
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">=
On Wed, Oct 15, 2014 at 11:00 AM, Jens Axboe <span dir=3D"ltr">&lt;<a href=
=3D"mailto:axboe@kernel.dk" target=3D"_blank">axboe@kernel.dk</a>&gt;</span=
> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0=
.8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-left-s=
tyle:solid;padding-left:1ex"><div id=3D":4sd" class=3D"" style=3D"overflow:=
hidden">That would be absolutely wonderful. I do some of these manually bef=
ore<br>
release, especially if changes have gone in that could affect build on<br>
various distros. But would be great to have it automated. Unfortunately<br>
I&#39;m not a rpmfile/deb wizard, and I lack the motivation (and time) to<b=
r>
take the time to do this. So if anyone would like to step up and help<br>
out with this, that would be awesome.<br>
<br>
Currently the deb and rpm spec files are not included with <span class=3D""=
>fio</span>, but they<br>
do exist in the debian (ish) and rpm based packages that people roll for<br=
>
distributions. So hopefully it should not be too much work. It might<br>
even be a good idea to include them with <span class=3D"">fio</span>, espec=
ially if we&#39;re going<br>
to automate some of this building/testing.</div></blockquote></div><div cla=
ss=3D"gmail_extra"><br></div>If someone will send me a RedHat specfile or D=
ebian deb file I can try doing a test build.</div><div class=3D"gmail_extra=
"><br></div><div class=3D"gmail_extra">=3D=3D=3D=3D=3D=3D=3D=3D brief backg=
round =3D=3D=3D=3D<br>The opensuse build server (and associated local build=
 tool &quot;osc&quot;) basically takes as input the latest tarball and an u=
pdated specfile / deb control file.=C2=A0 If the specfiles and/or deb files=
 were within the tarball a simple script could be used to extract them and =
run a test build.</div><div class=3D"gmail_extra"><br></div><div class=3D"g=
mail_extra">The biggest issue would be if any of the distros require patche=
s to the tarball for them to build.</div><div class=3D"gmail_extra"><br></d=
iv><div class=3D"gmail_extra">opensuse is not carrying any fio patches, so =
it is clean:</div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_=
extra"><a href=3D"https://build.opensuse.org/package/show/benchmark/fio">ht=
tps://build.opensuse.org/package/show/benchmark/fio</a><br></div><div class=
=3D"gmail_extra"><br></div><div class=3D"gmail_extra">Assuming a test build=
 setup was functioning, the build script would just need lines like:</div><=
div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">------------=
--</div><div class=3D"gmail_extra"><div>=C2=A0osc build --local-package --a=
lternative-project RedHat:RHEL-5 x86_64=C2=A0fio.redhat.spec</div><div><div=
>=C2=A0osc build --local-package --alternative-project openSUSE:13.1 x86_64=
=C2=A0fio.opensuse.spec</div></div><div>...</div><div>--------------<br></d=
iv></div><div class=3D"gmail_extra"><div>Similar for Debian based systems, =
but I don&#39;t know what the control file name is</div><div></div></div><d=
iv class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">To run the te=
st build the user would need to have &quot;osc&quot; installed.=C2=A0 It is=
 available for several distros:</div><div class=3D"gmail_extra"><br></div><=
div class=3D"gmail_extra"><a href=3D"http://software.opensuse.org/download.=
html?project=3DopenSUSE%3ATools&amp;package=3Dosc">http://software.opensuse=
.org/download.html?project=3DopenSUSE%3ATools&amp;package=3Dosc</a><br></di=
v><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">---------=
--- need a volunteer to do a test openSUSE build via the linux platform of =
their choice (assuming it is in the supported list) ------</div><div class=
=3D"gmail_extra"><br></div><div class=3D"gmail_extra">Step 1: install osc f=
rom:</div><div class=3D"gmail_extra"><a href=3D"http://software.opensuse.or=
g/download.html?project=3DopenSUSE%3ATools&amp;package=3Dosc">http://softwa=
re.opensuse.org/download.html?project=3DopenSUSE%3ATools&amp;package=3Dosc<=
/a></div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">St=
ep 2: Download the 3 fio files (tarball, changes file and specfile) from:</=
div><div class=3D"gmail_extra"><a href=3D"https://build.opensuse.org/packag=
e/show/benchmark/fio">https://build.opensuse.org/package/show/benchmark/fio=
</a><br></div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extr=
a">Put those 3 files in a test folder and cd into it.</div><div class=3D"gm=
ail_extra"><br></div><div class=3D"gmail_extra">Step 3:</div><div class=3D"=
gmail_extra">Then attempt a test build of an openSUSE rpm:</div><div class=
=3D"gmail_extra">osc build --local-package --alternative-project openSUSE:1=
3.1 x86_64=C2=A0fio.spec<br></div><div class=3D"gmail_extra"><br></div><div=
 class=3D"gmail_extra">That &quot;osc build&quot; will take several minutes=
 because about 250 packages have to be downloaded and installed in a chroot=
 jail prior to the actual build starting.=C2=A0 Those packages will be cach=
ed so subsequent builds will be much faster.</div><div class=3D"gmail_extra=
"><br></div><div class=3D"gmail_extra">------------ more details ---------<=
/div><div class=3D"gmail_extra">I&#39;ve only used osc under openSUSE, so I=
 can only state with confidence that from within openSUSE I can tell osc to=
 do test builds for the various distros supported.</div><div class=3D"gmail=
_extra"><br></div><div class=3D"gmail_extra">I &quot;think&quot; that same =
is true from within any of the supported distros.=C2=A0 As an example, if I=
 have osc installed in a RedHat box I can use it to do a cross build of Ubu=
ntu.=C2=A0 If anyone does the test build above we will have a second data p=
oint.</div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">=
Osc works by creating a chroot jail that it installs the packages needed to=
 build with into.</div><div class=3D"gmail_extra"><br></div><div class=3D"g=
mail_extra">As an example &quot;osc build --local-package --alternative-pro=
ject RedHat:RHEL-5 x86_64=C2=A0fio.redhat.spec&quot; will attempt to build =
a 64-bit Red Hat rpm from within openSUSE.=C2=A0 The first thing it does is=
 download the needed packages and install them in a chroot jail.=C2=A0 It a=
ssumes the file fio.redhat.spec exists and has the right content to drive t=
he build.</div><div class=3D"gmail_extra"><br></div><div class=3D"gmail_ext=
ra">The PC doing the test builds does have to be on the Internet to be able=
 to pull down the various packages needed to do the test build.<br></div><d=
iv class=3D"gmail_extra"><br></div><div class=3D"gmail_extra">I provided th=
e list of &quot;alternative-project&quot; options in my last email, but her=
e it is again:</div><div class=3D"gmail_extra"><br></div><div class=3D"gmai=
l_extra">distribution =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0proje=
ct</div><div class=3D"gmail_extra">------------ =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0-------</div><div class=3D"gmail_extra">openSUSE Facto=
ry =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0openSUSE:Factory</div><div class=3D"gm=
ail_extra">openSUSE 13.2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 openSUSE=
:13.2</div><div class=3D"gmail_extra">openSUSE 13.1 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 openSUSE:13.1</div><div class=3D"gmail_extra">openSUSE=
 12.3 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 openSUSE:12.3</div><div cla=
ss=3D"gmail_extra">openSUSE 12.2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
openSUSE:12.2</div><div class=3D"gmail_extra">openSUSE Factory ARM =C2=A0 =
=C2=A0 =C2=A0openSUSE:Factory:ARM</div><div class=3D"gmail_extra">openSUSE =
Tumbleweed =C2=A0 =C2=A0 =C2=A0 openSUSE:Tumbleweed</div><div class=3D"gmai=
l_extra">SUSE SLE-11 SP 3 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0SUSE:SLE-11:SP3=
</div><div class=3D"gmail_extra">SUSE SLE-11 SP 2 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0SUSE:SLE-11:SP2</div><div class=3D"gmail_extra">SUSE SLE-10 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 SUSE:SLE-10:SDK</div><div cla=
ss=3D"gmail_extra">Arch Core =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 Arch:Core</div><div class=3D"gmail_extra">Arch Extra =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Arch:Extra</div><div class=3D"=
gmail_extra">Debian 7.0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0Debian:7.0</div><div class=3D"gmail_extra">Debian 6.0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Debian:6.0</div><div class=3D"gmai=
l_extra">Fedora 20 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
Fedora:20</div><div class=3D"gmail_extra">Fedora 19 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Fedora:19</div><div class=3D"gmail_extra=
">Fedora 18 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Fedora:=
18</div><div class=3D"gmail_extra">ScientificLinux 7 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 ScientificLinux:7</div><div class=3D"gmail_extra">ScientificLinux 6 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ScientificLinux:6</div><div class=3D"gmail_extr=
a">RedHat RHEL-7 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 RedHat:RHEL-7</d=
iv><div class=3D"gmail_extra">RedHat RHEL-6 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 RedHat:RHEL-6</div><div class=3D"gmail_extra">RedHat RHEL-5 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 RedHat:RHEL-5</div><div class=3D"gma=
il_extra">RedHat RHEL-4 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 RedHat:RH=
EL-4</div><div class=3D"gmail_extra">CentOS CentOS-7 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 CentOS:CentOS-7</div><div class=3D"gmail_extra">CentOS CentOS=
-6 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CentOS:CentOS-6</div><div><div>CentOS=
 CentOS-5 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 CentOS:CentOS-5 =C2=A0=C2=A0<b=
r></div><div>Ubuntu 14.04 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0U=
buntu:14.04 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0</div><div>Ubuntu 13.10 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Ubuntu:13.10 =C2=A0 =C2=A0=C2=
=A0</div><div>Ubuntu 12.10 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
Ubuntu:12.10 =C2=A0 =C2=A0=C2=A0</div><div>Ubuntu 12.04 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Ubuntu:12.04 =C2=A0 =C2=A0=C2=A0</div><div>U=
buntu 11.10 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Ubuntu:11.10 =
=C2=A0 =C2=A0=C2=A0</div><div>Ubuntu 10.04 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0Ubuntu:10.04 =C2=A0 =C2=A0=C2=A0</div><div>Univention UCS =
3.2 =C2=A0 =C2=A0 =C2=A0 =C2=A0Univention:3.2 =C2=A0 =C2=A0 =C2=A0</div><di=
v>Univention UCS 3.1 =C2=A0 =C2=A0 =C2=A0 =C2=A0Univention:3.1 =C2=A0 =C2=
=A0 =C2=A0</div></div><div><br></div><div class=3D"gmail_extra">Greg</div><=
div class=3D"gmail_extra"><div>--<br>Greg Freemyer</div>
</div></div>

--047d7b6246642e516205059031c6--

