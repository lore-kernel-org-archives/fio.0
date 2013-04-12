Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:40913 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab3DLLQX convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 12 Apr 2013 07:16:23 -0400
Received: by mail-wg0-f46.google.com with SMTP id e11so389554wgh.1
        for <fio@vger.kernel.org>; Fri, 12 Apr 2013 04:16:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53b87397-46b4-49d7-bbb6-8637d83c1bb6@email.android.com>
References: <CANUChTygO-6HnaDU+eufAAtJoGCn9J0UgcEd16+7dgeOXa-92Q@mail.gmail.com>
 <53b87397-46b4-49d7-bbb6-8637d83c1bb6@email.android.com>
From: Gavin Martin <gavin_martin@xyratex.com>
Date: Fri, 12 Apr 2013 12:16:01 +0100
Message-ID: <CANUChTxpr+cAjzRQvbrJCrbT=h4Ui7UvJnXio6H_3EA7V46kxQ@mail.gmail.com>
Subject: Re: Unable to Configure latest build
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: fio@vger.kernel.org

On 12 April 2013 11:55, Greg Freemyer <greg.freemyer@gmail.com> wrote:
>
>
> Gavin Martin <gavin_martin@xyratex.com> wrote:
>
>>Hi Jens,
>>
>>I grabbed the 2.0.15 when it came out and it configured and compiled
>>fine, but the latest one from today (12/04) displays errors when
>>trying to configure.
>>
>>I'm not doing anything different to what I was doing for the previous
>>builds.  Just running ./configure, below is the output from
>>config.log;
>>
>># FIO configure log Fri Apr 12 08:25:30 BST 2013
>># Configured with: './configure'
>>#
>>gcc -D_GNU_SOURCE -include config-host.h -c -o
>>/tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
>>/tmp/fio-conf-27676-20722-14401.c:2:2: error: #error __ANDROID__ not
>>defined
>>gcc -D_GNU_SOURCE -include config-host.h -c -o
>>/tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
>>gcc -D_GNU_SOURCE -include config-host.h -c -o
>>/tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
>>/tmp/fio-conf-27676-20722-14401.c:2:2: error: #error __i386__ not
>>defined
>>gcc -D_GNU_SOURCE -include config-host.h -c -o
>>/tmp/fio-conf-9434-20722-5490.o /tmp/fio-conf-27676-20722-14401.c
>>Compiling test case cross
>>gcc -D_GNU_SOURCE -include config-host.h -o
>>/tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
>>Compiling test case endian
>>gcc -D_GNU_SOURCE -include config-host.h -o
>>/tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
>>Compiling test case wordsize
>>gcc -D_GNU_SOURCE -include config-host.h -DWORDSIZE=3D32 -o
>>/tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
>>/tmp/fio-conf-27676-20722-14401.c: In function =EF=BF=BDmain=EF=BF=BD:
>>/tmp/fio-conf-27676-20722-14401.c:5: error: size of array =EF=BF=BDtype n=
ame=EF=BF=BD
>>is negative
>>Compiling test case wordsize
>>gcc -D_GNU_SOURCE -include config-host.h -DWORDSIZE=3D64 -o
>>/tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
>>Compiling test case zlib
>>gcc -D_GNU_SOURCE -include config-host.h -o
>>/tmp/fio-conf-3040-20722-23652.exe /tmp/fio-conf-27676-20722-14401.c
>>-lz
>>/tmp/fio-conf-27676-20722-14401.c:1:18: error: zlib.h: No such file or
>>directory
>>/tmp/fio-conf-27676-20722-14401.c: In function =EF=BF=BDmain=EF=BF=BD:
>>/tmp/fio-conf-27676-20722-14401.c:4: error: =EF=BF=BDz_stream=EF=BF=BD un=
declared
>>(first use in this function)
>>/tmp/fio-conf-27676-20722-14401.c:4: error: (Each undeclared
>>identifier is reported only once
>>/tmp/fio-conf-27676-20722-14401.c:4: error: for each function it
>>appears in.)
>>/tmp/fio-conf-27676-20722-14401.c:4: error: expected =EF=BF=BD;=EF=BF=BD =
before
>>=EF=BF=BDstream=EF=BF=BD
>>/tmp/fio-conf-27676-20722-14401.c:5: error: =EF=BF=BDstream=EF=BF=BD unde=
clared (first
>>use in this function)
>>/tmp/fio-conf-27676-20722-14401.c:5: error: =EF=BF=BDZ_OK=EF=BF=BD undecl=
ared (first
>>use in this function)
>>
>>This is on a SLES11 SP1 x86_64 machine, I don't know enough to see if
>>I am doing something wrong, but it has worked on previous builds.
>>
>>Thanks,
>>Gavin
>
> Gavin,
>
> I have commit rights to the opensuse fio package in the benchmark repo.
>
> V2.0.15 is already there.  There should be a sles rpm you can just instal=
l.
>
> Do the fio builds from the opensuse benchmark repo not work for you?
>
> Why are you self compiling?
>
> Greg
> --
> Sent from my Android phone with K-9 Mail. Please excuse my brevity.

Thanks Greg,

Possibly because I didn't know of any other way, thanks for that.

But also I was interested in giving gfio a try, and I don't think that
has been pre compiled by anybody yet, will probably be proven wrong
now!

Regards,
Gavin

--=20


------------------------------
For additional information including the registered office and the treatmen=
t of Xyratex confidential information please visit www.xyratex.com

------------------------------
