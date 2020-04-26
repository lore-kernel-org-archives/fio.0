Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgDZPak (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 26 Apr 2020 11:30:40 -0400
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8A2C061A0F
        for <fio@vger.kernel.org>; Sun, 26 Apr 2020 08:30:40 -0700 (PDT)
Received: by mail-vk1-xa43.google.com with SMTP id g129so4116588vkh.9
        for <fio@vger.kernel.org>; Sun, 26 Apr 2020 08:30:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAK3+OmX5TX9KPw584_BT0u1Jb+roA=6_13pK5Ra8rwrcL5HecQ@mail.gmail.com>
 <BY5PR04MB690094E00580D5D1D90ADD4FE7D00@BY5PR04MB6900.namprd04.prod.outlook.com>
 <BY5PR04MB6900531561ED9F8EDB35E9C2E7D00@BY5PR04MB6900.namprd04.prod.outlook.com>
 <CAOdGBnHfNb_C3Gc+fpSxy8rCmOcUihguwyoQk+g0k6cYsd40dA@mail.gmail.com>
 <CAK3+OmVVGvOPToJRds+uD3S_inZbbADFFS2t+jx2TYT-E_CUUw@mail.gmail.com> <CALjAwxjyaf+D6pgmeEf-ZZV-kpMrn75Z7pxU_oSg6tvSaxm3Og@mail.gmail.com>
In-Reply-To: <CALjAwxjyaf+D6pgmeEf-ZZV-kpMrn75Z7pxU_oSg6tvSaxm3Og@mail.gmail.com>
From: Seena Fallah <seenafallah@gmail.com>
Date: Sun, 26 Apr 2020 20:00:28 +0430
Message-ID: <CAK3+OmUMi_XEmn3Q17YGMNB20ORw3_VAoAL7mjCEo4jg8hA9=w@mail.gmail.com>
Subject: Re: Don't benchmark with fio
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Yigal Korman <ykorman@gmail.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Sun, Apr 26, 2020 at 7:33 PM Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
> On Sun, 26 Apr 2020 at 14:17, Seena Fallah <seenafallah@gmail.com> wrote:
> >
> > Thanks all for your replies.
> >
> > Maybe if you like it would be a good feature in fio to support this
> > type of needs :)
> >
>
> cd /to/filesystem; fio --size=100k --bs=4k --rw=write --name=notabenchmark
>
> ? Obviously this could go only to the cache so maybe you want
> end_fsync=1 (https://fio.readthedocs.io/en/latest/fio_man.html#cmdoption-arg-end-fsync
> ) etc. If you really want to do only one I/O I suppose you could
> change the block size to 100k...

I have tried it but still going to benchmark. I just want to
read/write for example 4 IO to see how long does it take?

> > I have one more question about xfs_io, I don't know if it's a right
> > place but if it not I'm sorry. I have run xfs_io and gets this result:
> > 100.000000 bytes, 1 ops; 0.0000 sec (1.514 MiB/sec and 15873.0159 ops/sec)
> > What is the 15873.0159 ops/sec? Did xfs_io really do 15873.0159 iops or 1iops?
>
> What if it did only 1 op but timed how long it took to do all the I/O
> (e.g. around 63 microseconds)? When you average that out...

The main goal is I am writing a prober for my file system that is
attack to a vm for example and I don't want to load on my file system.
I just want to probe it and see if it writes 4 IO in a time that was
done last time or not?

> You can see the code here:
> https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/io/pwrite.c#n468

I see the code but it wasn't in a pattern I have sent to you. Am I wrong?
 .
>
> > On Fri, Apr 24, 2020 at 11:39 AM Yigal Korman <ykorman@gmail.com> wrote:
> > >
> > > On Fri, Apr 24, 2020 at 6:16 AM Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
> > > >
> > > > On 2020/04/24 12:11, Damien Le Moal wrote:
> > > > > On 2020/04/23 23:41, Seena Fallah wrote:
> > > > >> Hi all.
> > > > >>
> > > > >> I'm trying to probe my file system with fio. I don't want to benchmark
> > > > >> my file system. The only thing I want do is to for example write 100K
> > > > >> file on a file system and then check how much IO does it take to write
> > > > >> and the bandwidth and the runtime.
> > > > >> The main thing I want is to just write that file size and don't bench on that.
> > > > >> Can anyone help me which ioengine or which args should I use to do this probe?
> > > > >>
> > > > >> Thanks.
> > > > >>
> > > > >
> > > > > dd if=/dev/zero of=/path/to/your/file/to/write bs=100K count=i conv=fsync
> > > > >
> > > >
> > > > Oops... Should be:
> > > >
> > > > dd if=/dev/zero of=/path/to/your/file/to/write bs=100K count=1 conv=fsync
> > > >
> > > > obviously for 100K :)
> > > >
> > > > You will get the write bandwidth with this. For knowing how many IOs this take,
> > > > you will need to trace the kernel IO stack (blktrace). No way to know this
> > > > exactly from user space, that is, if by "IO" you mean "storage device commands".
> > > > If by "IO" you mean "system calls", then with the above command, it will be
> > > > exactly 1 "write()" call (use strace to see it).
> > > >
> > > > --
> > > > Damien Le Moal
> > > > Western Digital Research
> > >
> > > Yeah, fio might not be the best tool for this purpose.
> > > As Damien said - 'dd' is a good alternative.
> > > You could also use the xfs_io tool.
> > > It's not really xfs related, it's a general i/o and filesystem operations tool.
> > > It's part of the xfsprogs package and most likely already installed on
> > > your host.
> > > Here's an example:
> > >
> > > xfs_io -c "pwrite 0 100" -f /path/to/file
> > >
> > > Writes 100 bytes at offset 0 to the file.
> > > It will give you some timing info and bandwidth stats.
> > >
> > > Yigal
>
> --
> Sitsofe | http://sucs.org/~sits/

