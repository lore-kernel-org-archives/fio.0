Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726176AbgDZUZ3 (ORCPT
        <rfc822;fio@vger.kernel.org>); Sun, 26 Apr 2020 16:25:29 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE75BC061A0F
        for <fio@vger.kernel.org>; Sun, 26 Apr 2020 13:25:28 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id u10so12082856lfo.8
        for <fio@vger.kernel.org>; Sun, 26 Apr 2020 13:25:28 -0700 (PDT)
MIME-Version: 1.0
References: <CAK3+OmX5TX9KPw584_BT0u1Jb+roA=6_13pK5Ra8rwrcL5HecQ@mail.gmail.com>
 <BY5PR04MB690094E00580D5D1D90ADD4FE7D00@BY5PR04MB6900.namprd04.prod.outlook.com>
 <BY5PR04MB6900531561ED9F8EDB35E9C2E7D00@BY5PR04MB6900.namprd04.prod.outlook.com>
 <CAOdGBnHfNb_C3Gc+fpSxy8rCmOcUihguwyoQk+g0k6cYsd40dA@mail.gmail.com> <CAK3+OmVVGvOPToJRds+uD3S_inZbbADFFS2t+jx2TYT-E_CUUw@mail.gmail.com>
In-Reply-To: <CAK3+OmVVGvOPToJRds+uD3S_inZbbADFFS2t+jx2TYT-E_CUUw@mail.gmail.com>
From: Yigal Korman <ykorman@gmail.com>
Date: Sun, 26 Apr 2020 23:25:16 +0300
Message-ID: <CAOdGBnEA=S+pXJrC2xhgrhp5_SwDS4Fz31C-jZ-8D=ni199uqw@mail.gmail.com>
Subject: Re: Don't benchmark with fio
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Seena Fallah <seenafallah@gmail.com>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Sun, Apr 26, 2020 at 4:16 PM Seena Fallah <seenafallah@gmail.com> wrote:
>
> Thanks all for your replies.
>
> Maybe if you like it would be a good feature in fio to support this
> type of needs :)
>
> I have one more question about xfs_io, I don't know if it's a right
> place but if it not I'm sorry. I have run xfs_io and gets this result:
> 100.000000 bytes, 1 ops; 0.0000 sec (1.514 MiB/sec and 15873.0159 ops/sec)
> What is the 15873.0159 ops/sec? Did xfs_io really do 15873.0159 iops or 1iops?

It did 1 operation, but because it took such a short time, much less
than a second, the ops/sec comes out as a large number.
I hope that makes sense to you.

Y

>
>
> On Fri, Apr 24, 2020 at 11:39 AM Yigal Korman <ykorman@gmail.com> wrote:
> >
> > On Fri, Apr 24, 2020 at 6:16 AM Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
> > >
> > > On 2020/04/24 12:11, Damien Le Moal wrote:
> > > > On 2020/04/23 23:41, Seena Fallah wrote:
> > > >> Hi all.
> > > >>
> > > >> I'm trying to probe my file system with fio. I don't want to benchmark
> > > >> my file system. The only thing I want do is to for example write 100K
> > > >> file on a file system and then check how much IO does it take to write
> > > >> and the bandwidth and the runtime.
> > > >> The main thing I want is to just write that file size and don't bench on that.
> > > >> Can anyone help me which ioengine or which args should I use to do this probe?
> > > >>
> > > >> Thanks.
> > > >>
> > > >
> > > > dd if=/dev/zero of=/path/to/your/file/to/write bs=100K count=i conv=fsync
> > > >
> > >
> > > Oops... Should be:
> > >
> > > dd if=/dev/zero of=/path/to/your/file/to/write bs=100K count=1 conv=fsync
> > >
> > > obviously for 100K :)
> > >
> > > You will get the write bandwidth with this. For knowing how many IOs this take,
> > > you will need to trace the kernel IO stack (blktrace). No way to know this
> > > exactly from user space, that is, if by "IO" you mean "storage device commands".
> > > If by "IO" you mean "system calls", then with the above command, it will be
> > > exactly 1 "write()" call (use strace to see it).
> > >
> > > --
> > > Damien Le Moal
> > > Western Digital Research
> >
> > Yeah, fio might not be the best tool for this purpose.
> > As Damien said - 'dd' is a good alternative.
> > You could also use the xfs_io tool.
> > It's not really xfs related, it's a general i/o and filesystem operations tool.
> > It's part of the xfsprogs package and most likely already installed on
> > your host.
> > Here's an example:
> >
> > xfs_io -c "pwrite 0 100" -f /path/to/file
> >
> > Writes 100 bytes at offset 0 to the file.
> > It will give you some timing info and bandwidth stats.
> >
> > Yigal

