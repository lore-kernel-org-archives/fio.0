Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728018AbgLCQHP (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Dec 2020 11:07:15 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA257C061A4E
        for <fio@vger.kernel.org>; Thu,  3 Dec 2020 08:06:28 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id u12so2438747wrt.0
        for <fio@vger.kernel.org>; Thu, 03 Dec 2020 08:06:28 -0800 (PST)
MIME-Version: 1.0
References: <CAMzroCjoMa0LD5tZhVvrkNPG=c_vGW0A1RVKQYN8jgY8LX7=HQ@mail.gmail.com>
 <TU4PR8401MB1055DA7E884402B6267CF682ABF20@TU4PR8401MB1055.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <TU4PR8401MB1055DA7E884402B6267CF682ABF20@TU4PR8401MB1055.NAMPRD84.PROD.OUTLOOK.COM>
From: David Pineau <david.pineau@blade-group.com>
Date: Thu, 3 Dec 2020 17:06:16 +0100
Message-ID: <CAMzroCi05rKS_a8g5aHPaxM1b3m1sk0f5ETtzOwzLFv8GEwV9g@mail.gmail.com>
Subject: Re: Difficulties pushing FIO towards many small files and WORM-style use-case
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Servers)" <elliott@hpe.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Thu, Dec 3, 2020 at 4:43 PM Elliott, Robert (Servers)
<elliott@hpe.com> wrote:
>
>
>
> > -----Original Message-----
> > From: David Pineau <david.pineau@blade-group.com>
> > Sent: Wednesday, December 02, 2020 8:32 AM
> > To: fio@vger.kernel.org
> > Subject: Difficulties pushing FIO towards many small files and WORM-
> > style use-case
> >
> > Hello,
> >
> ...
> > As we have data on the actual usage of this current software, we know
> > the spread of accesses to various size ranges, and we rely on a huge
> > number of files accessed by the multi-threaded service. As the pieces
> > of data can live a long time on this service and are immutable, I'm
> > trying to go for a WORM-style workload with FIO.
> >
> > With this information in mind, I build the following FIO
> > configuration file:
> >
> > >>>>
> > [global]
> > # File-related config
> > directory=/mnt/test-mountpoint
> > nrfiles=3000
>
> I don't think most systems can handle 3000 open files at a time for
> one process. Try
>         ulimit -n
>
> which might report that the default is 1024 open files per process.
>
> The fio openfiles=<int> option can be used to limit how many files it
> keeps open at a time.

The number of open file descriptors is tuned on our servers (the
system is usually running between 30-40k open files constantly
according to our monitoring), so I'm not limited on that side, but I
had indeed noticed the "openfiles" option, thanks for hinting at that.

>
>

