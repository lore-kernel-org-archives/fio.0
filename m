Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51950 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbaJPUob (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 16 Oct 2014 16:44:31 -0400
Received: by mail-wi0-f173.google.com with SMTP id fb4so460565wid.12
        for <fio@vger.kernel.org>; Thu, 16 Oct 2014 13:44:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGpXXZLudYQruD_WXZ1VggFXvYWu7UToYe-Tv=njQ+LqdEiYFw@mail.gmail.com>
References: <CAMA-6iaCvppOLvBOP6K2+Gt-BEo5x_m_BXvq8xs8K8ezgt132w@mail.gmail.com>
 <543D907B.3080005@kernel.dk> <CADzpL0T6cQ=pWr4iM=0JoV_e-3wfO65s-PgYXC-YPr1mYvzuFQ@mail.gmail.com>
 <543E84BD.9040303@kernel.dk> <CAGpXXZJk2YJQug6pmA0rHY4xAhhgjFxFxStPWB5tF+-bKrEdiQ@mail.gmail.com>
 <543E8BFA.7090207@kernel.dk> <CAGpXXZLudYQruD_WXZ1VggFXvYWu7UToYe-Tv=njQ+LqdEiYFw@mail.gmail.com>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Thu, 16 Oct 2014 16:43:49 -0400
Message-ID: <CAGpXXZ+tXW_+=BiA8=VSpJM_vBi8wbBufaQigX+ohx1Dv6Q9Ng@mail.gmail.com>
Subject: Fwd: BUG - Cannot build fio on redhat 5
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

(Resend as plain text.  HTML version bounced)

On Wed, Oct 15, 2014 at 11:00 AM, Jens Axboe <axboe@kernel.dk> wrote:
>
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


If someone will send me a RedHat specfile or Debian deb file I can try
doing a test build.

======== brief background ====
The opensuse build server (and associated local build tool "osc")
basically takes as input the latest tarball and an updated specfile /
deb control file.  If the specfiles and/or deb files were within the
tarball a simple script could be used to extract them and run a test
build.

The biggest issue would be if any of the distros require patches to
the tarball for them to build.

opensuse is not carrying any fio patches, so it is clean:

https://build.opensuse.org/package/show/benchmark/fio

Assuming a test build setup was functioning, the build script would
just need lines like:

--------------
 osc build --local-package --alternative-project RedHat:RHEL-5 x86_64
fio.redhat.spec
 osc build --local-package --alternative-project openSUSE:13.1 x86_64
fio.opensuse.spec
...
--------------
Similar for Debian based systems, but I don't know what the control file name is

To run the test build the user would need to have "osc" installed.  It
is available for several distros:

http://software.opensuse.org/download.html?project=openSUSE%3ATools&package=osc

------------ need a volunteer to do a test openSUSE build via the
linux platform of their choice (assuming it is in the supported list)
------

Step 1: install osc from:
http://software.opensuse.org/download.html?project=openSUSE%3ATools&package=osc

Step 2: Download the 3 fio files (tarball, changes file and specfile) from:
https://build.opensuse.org/package/show/benchmark/fio

Put those 3 files in a test folder and cd into it.

Step 3:
Then attempt a test build of an openSUSE rpm:
osc build --local-package --alternative-project openSUSE:13.1 x86_64 fio.spec

That "osc build" will take several minutes because about 250 packages
have to be downloaded and installed in a chroot jail prior to the
actual build starting.  Those packages will be cached so subsequent
builds will be much faster.

------------ more details ---------
I've only used osc under openSUSE, so I can only state with confidence
that from within openSUSE I can tell osc to do test builds for the
various distros supported.

I "think" that same is true from within any of the supported distros.
As an example, if I have osc installed in a RedHat box I can use it to
do a cross build of Ubuntu.  If anyone does the test build above we
will have a second data point.

Osc works by creating a chroot jail that it installs the packages
needed to build with into.

As an example "osc build --local-package --alternative-project
RedHat:RHEL-5 x86_64 fio.redhat.spec" will attempt to build a 64-bit
Red Hat rpm from within openSUSE.  The first thing it does is download
the needed packages and install them in a chroot jail.  It assumes the
file fio.redhat.spec exists and has the right content to drive the
build.

The PC doing the test builds does have to be on the Internet to be
able to pull down the various packages needed to do the test build.

I provided the list of "alternative-project" options in my last email,
but here it is again:

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
