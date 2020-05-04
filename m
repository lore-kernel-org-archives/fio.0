Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729690AbgEDRSv (ORCPT
        <rfc822;fio@vger.kernel.org>); Mon, 4 May 2020 13:18:51 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C149C061A0E
        for <fio@vger.kernel.org>; Mon,  4 May 2020 10:18:51 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u16so354035wmc.5
        for <fio@vger.kernel.org>; Mon, 04 May 2020 10:18:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAK3+OmX5TX9KPw584_BT0u1Jb+roA=6_13pK5Ra8rwrcL5HecQ@mail.gmail.com>
 <BY5PR04MB690094E00580D5D1D90ADD4FE7D00@BY5PR04MB6900.namprd04.prod.outlook.com>
 <BY5PR04MB6900531561ED9F8EDB35E9C2E7D00@BY5PR04MB6900.namprd04.prod.outlook.com>
 <CAOdGBnHfNb_C3Gc+fpSxy8rCmOcUihguwyoQk+g0k6cYsd40dA@mail.gmail.com>
 <CAK3+OmVVGvOPToJRds+uD3S_inZbbADFFS2t+jx2TYT-E_CUUw@mail.gmail.com>
 <CAOdGBnEA=S+pXJrC2xhgrhp5_SwDS4Fz31C-jZ-8D=ni199uqw@mail.gmail.com> <CAK3+OmXOdhQiNWvCE7Z+YDq+d2GrT2XvHLrwU5DPJrmJCXK4mg@mail.gmail.com>
In-Reply-To: <CAK3+OmXOdhQiNWvCE7Z+YDq+d2GrT2XvHLrwU5DPJrmJCXK4mg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 4 May 2020 18:18:24 +0100
Message-ID: <CALjAwxgjUY3nYxgEPnWHhM1aBH9FhjKvd-E=SXEj44mBFnB1HA@mail.gmail.com>
Subject: Re: Don't benchmark with fio
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Seena Fallah <seenafallah@gmail.com>
Cc: Yigal Korman <ykorman@gmail.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On Sat, 2 May 2020 at 01:05, Seena Fallah <seenafallah@gmail.com> wrote:
>
> On Mon, Apr 27, 2020 at 12:55 AM Yigal Korman <ykorman@gmail.com> wrote:
> >
> > On Sun, Apr 26, 2020 at 4:16 PM Seena Fallah <seenafallah@gmail.com> wrote:
> > >
> > > Thanks all for your replies.
> > >
> > > Maybe if you like it would be a good feature in fio to support this
> > > type of needs :)
> > >
> > > I have one more question about xfs_io, I don't know if it's a right
> > > place but if it not I'm sorry. I have run xfs_io and gets this result:
> > > 100.000000 bytes, 1 ops; 0.0000 sec (1.514 MiB/sec and 15873.0159 ops/sec)
> > > What is the 15873.0159 ops/sec? Did xfs_io really do 15873.0159 iops or 1iops?
> >
> > It did 1 operation, but because it took such a short time, much less
> > than a second, the ops/sec comes out as a large number.
> > I hope that makes sense to you.
> >
> I have tried with 10MB and I get 86897.7297 ops/sec:
> xfs_io -c "pwrite 0 10000000" -f ~/test
> wrote 10000000/10000000 bytes at offset 0
> 10 MiB, 2442 ops; 0.0281 sec (339.362 MiB/sec and 86897.7297 ops/sec)

As stated elsewhere the ops/sec in brackets is an average. As the
total run time was less than a second in this case it is a predicted
average.

You did 2442 ops in 0.0281 sec or if I change the units, 2442 ops in
28.1 millisconds. Now I can work out how how many operations you did
on average per milisecond with maths - 2442 / 28.1 so approximately
86.9 operations per millisecond (I've done some rounding). Now I can
change the units back to seconds (which in this case will cause a
prediction as you never actually did a second or more worth of I/O).
So because there are 1000 miliseconds in a second this will come to
approximately 86.9 * 1000 = 86900 which because I've done some round
earlier approximates the value you gave.

As stated previously suggested have you had a chance to read through the code?

$ cd /tmp
$ git clone --depth 2  git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
Cloning into 'xfsprogs-dev'...
remote: Enumerating objects: 609, done.
remote: Counting objects: 100% (609/609), done.
remote: Compressing objects: 100% (585/585), done.
remote: Total 609 (delta 50), reused 210 (delta 16)
Receiving objects: 100% (609/609), 1.57 MiB | 648.00 KiB/s, done.
Resolving deltas: 100% (50/50), done.
$ cd xfsprogs-dev/
$ git grep -n report_io_times
include/command.h:57:extern void                report_io_times(const
char *verb, struct timeval *t2,
io/pread.c:496: report_io_times("read", &t2, (long long)offset, count,
total, c, Cflag);
io/pwrite.c:468:        report_io_times("wrote", &t2, (long
long)offset, count, total, c,
io/reflink.c:165:       report_io_times("deduped", &t2, (long
long)doffset, count, total, ops,
io/reflink.c:300:       report_io_times("linked", &t2, (long
long)doffset, count, total, ops,
io/sendfile.c:154:      report_io_times("sent", &t2, (long
long)offset, count, total, c, Cflag);
libxcmd/command.c:238:report_io_times(
$ sed -n '238,$p' libxcmd/command.c
report_io_times(
[...]


--
Sitsofe | http://sucs.org/~sits/

