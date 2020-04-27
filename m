Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726221AbgD0GFn (ORCPT
        <rfc822;fio@vger.kernel.org>); Mon, 27 Apr 2020 02:05:43 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79E21C061A0F
        for <fio@vger.kernel.org>; Sun, 26 Apr 2020 23:05:43 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j2so19002241wrs.9
        for <fio@vger.kernel.org>; Sun, 26 Apr 2020 23:05:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAK3+OmX5TX9KPw584_BT0u1Jb+roA=6_13pK5Ra8rwrcL5HecQ@mail.gmail.com>
 <BY5PR04MB690094E00580D5D1D90ADD4FE7D00@BY5PR04MB6900.namprd04.prod.outlook.com>
 <BY5PR04MB6900531561ED9F8EDB35E9C2E7D00@BY5PR04MB6900.namprd04.prod.outlook.com>
 <CAOdGBnHfNb_C3Gc+fpSxy8rCmOcUihguwyoQk+g0k6cYsd40dA@mail.gmail.com>
 <CAK3+OmVVGvOPToJRds+uD3S_inZbbADFFS2t+jx2TYT-E_CUUw@mail.gmail.com>
 <CALjAwxjyaf+D6pgmeEf-ZZV-kpMrn75Z7pxU_oSg6tvSaxm3Og@mail.gmail.com> <CAK3+OmUMi_XEmn3Q17YGMNB20ORw3_VAoAL7mjCEo4jg8hA9=w@mail.gmail.com>
In-Reply-To: <CAK3+OmUMi_XEmn3Q17YGMNB20ORw3_VAoAL7mjCEo4jg8hA9=w@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 27 Apr 2020 07:05:16 +0100
Message-ID: <CALjAwxixWj9mLRM+j7upjfuYkHF0EBbN_jVFOHXTbN0f9SQKzg@mail.gmail.com>
Subject: Re: Don't benchmark with fio
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Seena Fallah <seenafallah@gmail.com>
Cc: Yigal Korman <ykorman@gmail.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Sun, 26 Apr 2020 at 16:30, Seena Fallah <seenafallah@gmail.com> wrote:
>
> On Sun, Apr 26, 2020 at 7:33 PM Sitsofe Wheeler <sitsofe@gmail.com> wrote=
:
> >
> > On Sun, 26 Apr 2020 at 14:17, Seena Fallah <seenafallah@gmail.com> wrot=
e:
> > >
> > > Thanks all for your replies.
> > >
> > > Maybe if you like it would be a good feature in fio to support this
> > > type of needs :)
> > >
> >
> > cd /to/filesystem; fio --size=3D100k --bs=3D4k --rw=3Dwrite --name=3Dno=
tabenchmark
> >
> > ? Obviously this could go only to the cache so maybe you want
> > end_fsync=3D1 (https://fio.readthedocs.io/en/latest/fio_man.html#cmdopt=
ion-arg-end-fsync
> > ) etc. If you really want to do only one I/O I suppose you could
> > change the block size to 100k...
>
> I have tried it but still going to benchmark. I just want to
> read/write for example 4 IO to see how long does it take?

You could try and use something like thinktime=3D1s thinktime_blocks=3D4
time_based=3D1 runtime=3D1m but you still wouldn't see live latency of
only the just completed events (see below)...

> > > I have one more question about xfs_io, I don't know if it's a right
> > > place but if it not I'm sorry. I have run xfs_io and gets this result=
:
> > > 100.000000 bytes, 1 ops; 0.0000 sec (1.514 MiB/sec and 15873.0159 ops=
/sec)
> > > What is the 15873.0159 ops/sec? Did xfs_io really do 15873.0159 iops =
or 1iops?
> >
> > What if it did only 1 op but timed how long it took to do all the I/O
> > (e.g. around 63 microseconds)? When you average that out...
>
> The main goal is I am writing a prober for my file system that is
> attack to a vm for example and I don't want to load on my file system.
> I just want to probe it and see if it writes 4 IO in a time that was
> done last time or not?

Ah OK I see what you mean: "I want to know the live and ongoing
/latency/ of writing 100k" (=C3=A0 la ping for networks as opposed to
netperf). The other mail mentioning ioping sounds like what you need
and for what you are saying I'd focus on around the time it took for
the I/O complete.. I'd argue you will never know the bandwidth (i.e.
the maximum I/O you could send at a given instance) because in your
scenario simply aren't sending enough data to reach it (unless your
disk is incredibly weak) - extrapolation from a couple of tiny
requests won't reflect the true saturation point.

> > You can see the code here:
> > https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/io/pwrite.c=
#n468
>
> I see the code but it wasn't in a pattern I have sent to you. Am I wrong?

Did you read through the report_io_times() function too?

--=20
Sitsofe | http://sucs.org/~sits/

