Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:47989 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab3DLInB (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 12 Apr 2013 04:43:01 -0400
Date: Fri, 12 Apr 2013 10:42:36 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Unable to Configure latest build
Message-ID: <20130412084236.GM12244@kernel.dk>
References: <CANUChTygO-6HnaDU+eufAAtJoGCn9J0UgcEd16+7dgeOXa-92Q@mail.gmail.com>
 <20130412081324.GL12244@kernel.dk>
 <CANUChTysujbj-TQR3MK8_CErA68sVP=H9-+3TXri4S4v5Zs9ZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANUChTysujbj-TQR3MK8_CErA68sVP=H9-+3TXri4S4v5Zs9ZA@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gavin Martin <gavin_martin@xyratex.com>
Cc: fio@vger.kernel.org

On Fri, Apr 12 2013, Gavin Martin wrote:
> On 12 April 2013 09:13, Jens Axboe <axboe@kernel.dk> wrote:
> > On Fri, Apr 12 2013, Gavin Martin wrote:
> >> Hi Jens,
> >>
> >> I grabbed the 2.0.15 when it came out and it configured and compiled
> >> fine, but the latest one from today (12/04) displays errors when
> >> trying to configure.
> >>
> >> I'm not doing anything different to what I was doing for the previous
> >> builds.  Just running ./configure, below is the output from
> >> config.log;
> >>
> >> # FIO configure log Fri Apr 12 08:25:30 BST 2013
> >> # Configured with: './configure'
> >> #
> >> gcc -D_GNU_SOURCE -include config-host.h -c -o
> >> /tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
> >> /tmp/fio-conf-27676-20722-14401.c:2:2: error: #error __ANDROID__ not defined
> >> gcc -D_GNU_SOURCE -include config-host.h -c -o
> >> /tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
> >> gcc -D_GNU_SOURCE -include config-host.h -c -o
> >> /tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
> >> /tmp/fio-conf-27676-20722-14401.c:2:2: error: #error __i386__ not defined
> >> gcc -D_GNU_SOURCE -include config-host.h -c -o
> >> /tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
> >> Compiling test case cross
> >> gcc -D_GNU_SOURCE -include config-host.h -o
> >> /tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
> >> Compiling test case endian
> >> gcc -D_GNU_SOURCE -include config-host.h -o
> >> /tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
> >> Compiling test case wordsize
> >> gcc -D_GNU_SOURCE -include config-host.h -DWORDSIZE=32 -o
> >> /tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
> >> /tmp/fio-conf-27676-20722-14401.c: In function āmainā:
> >> /tmp/fio-conf-27676-20722-14401.c:5: error: size of array ātype nameā
> >> is negative
> >> Compiling test case wordsize
> >> gcc -D_GNU_SOURCE -include config-host.h -DWORDSIZE=64 -o
> >> /tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
> >> Compiling test case zlib
> >> gcc -D_GNU_SOURCE -include config-host.h -o
> >> /tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
> >> -lz
> >> /tmp/fio-conf-27676-20722-14401.c:1:18: error: zlib.h: No such file or directory
> >> /tmp/fio-conf-27676-20722-14401.c: In function āmainā:
> >> /tmp/fio-conf-27676-20722-14401.c:4: error: āz_streamā undeclared
> >> (first use in this function)
> >> /tmp/fio-conf-27676-20722-14401.c:4: error: (Each undeclared
> >> identifier is reported only once
> >> /tmp/fio-conf-27676-20722-14401.c:4: error: for each function it appears in.)
> >> /tmp/fio-conf-27676-20722-14401.c:4: error: expected ā;ā before āstreamā
> >> /tmp/fio-conf-27676-20722-14401.c:5: error: āstreamā undeclared (first
> >> use in this function)
> >> /tmp/fio-conf-27676-20722-14401.c:5: error: āZ_OKā undeclared (first
> >> use in this function)
> >>
> >> This is on a SLES11 SP1 x86_64 machine, I don't know enough to see if
> >> I am doing something wrong, but it has worked on previous builds.
> >
> > You need the zlib devel libraries installed, configure should have told
> > you that. Ala:
> >
> > ERROR
> > ERROR: User requested feature zlib
> > ERROR: configure was not able to find it
> > ERROR
> > Configure failed, check config.log and/or the above output
> >
> > Not sure what that package is called on SLES, but probably zlib-devel.
> >
> > --
> > Jens Axboe
> >
> 
> Thanks, this must be a new requirement as I have never needed it for
> previous builds.

It is a new requirement. It's because I merged the gfio base into the
master branch, and gfio client/server uses compression for bigger
transmissions. It could be made optional, but zlib-devel should be
available on all platforms (I think). A decision will be made regarding
that before 2.0.16 (or 2.1, I think it'l be).

-- 
Jens Axboe

