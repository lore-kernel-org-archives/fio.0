Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ye0-f174.google.com ([209.85.213.174]:63305 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab3DLKzg (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 12 Apr 2013 06:55:36 -0400
Received: by mail-ye0-f174.google.com with SMTP id l2so372382yen.33
        for <fio@vger.kernel.org>; Fri, 12 Apr 2013 03:55:36 -0700 (PDT)
In-Reply-To: <CANUChTygO-6HnaDU+eufAAtJoGCn9J0UgcEd16+7dgeOXa-92Q@mail.gmail.com>
References: <CANUChTygO-6HnaDU+eufAAtJoGCn9J0UgcEd16+7dgeOXa-92Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: Unable to Configure latest build
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Fri, 12 Apr 2013 06:55:42 -0400
Message-ID: <53b87397-46b4-49d7-bbb6-8637d83c1bb6@email.android.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gavin Martin <gavin_martin@xyratex.com>, fio@vger.kernel.org



Gavin Martin <gavin_martin@xyratex.com> wrote:

>Hi Jens,
>
>I grabbed the 2.0.15 when it came out and it configured and compiled
>fine, but the latest one from today (12/04) displays errors when
>trying to configure.
>
>I'm not doing anything different to what I was doing for the previous
>builds.  Just running ./configure, below is the output from
>config.log;
>
># FIO configure log Fri Apr 12 08:25:30 BST 2013
># Configured with: './configure'
>#
>gcc -D_GNU_SOURCE -include config-host.h -c -o
>/tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
>/tmp/fio-conf-27676-20722-14401.c:2:2: error: #error __ANDROID__ not
>defined
>gcc -D_GNU_SOURCE -include config-host.h -c -o
>/tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
>gcc -D_GNU_SOURCE -include config-host.h -c -o
>/tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
>/tmp/fio-conf-27676-20722-14401.c:2:2: error: #error __i386__ not
>defined
>gcc -D_GNU_SOURCE -include config-host.h -c -o
>/tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
>Compiling test case cross
>gcc -D_GNU_SOURCE -include config-host.h -o
>/tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
>Compiling test case endian
>gcc -D_GNU_SOURCE -include config-host.h -o
>/tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
>Compiling test case wordsize
>gcc -D_GNU_SOURCE -include config-host.h -DWORDSIZE=32 -o
>/tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
>/tmp/fio-conf-27676-20722-14401.c: In function âmainâ:
>/tmp/fio-conf-27676-20722-14401.c:5: error: size of array âtype nameâ
>is negative
>Compiling test case wordsize
>gcc -D_GNU_SOURCE -include config-host.h -DWORDSIZE=64 -o
>/tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
>Compiling test case zlib
>gcc -D_GNU_SOURCE -include config-host.h -o
>/tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
>-lz
>/tmp/fio-conf-27676-20722-14401.c:1:18: error: zlib.h: No such file or
>directory
>/tmp/fio-conf-27676-20722-14401.c: In function âmainâ:
>/tmp/fio-conf-27676-20722-14401.c:4: error: âz_streamâ undeclared
>(first use in this function)
>/tmp/fio-conf-27676-20722-14401.c:4: error: (Each undeclared
>identifier is reported only once
>/tmp/fio-conf-27676-20722-14401.c:4: error: for each function it
>appears in.)
>/tmp/fio-conf-27676-20722-14401.c:4: error: expected â;â before
>âstreamâ
>/tmp/fio-conf-27676-20722-14401.c:5: error: âstreamâ undeclared (first
>use in this function)
>/tmp/fio-conf-27676-20722-14401.c:5: error: âZ_OKâ undeclared (first
>use in this function)
>
>This is on a SLES11 SP1 x86_64 machine, I don't know enough to see if
>I am doing something wrong, but it has worked on previous builds.
>
>Thanks,
>Gavin

Gavin,

I have commit rights to the opensuse fio package in the benchmark repo.

V2.0.15 is already there.  There should be a sles rpm you can just install.

Do the fio builds from the opensuse benchmark repo not work for you?

Why are you self compiling?

Greg
-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
