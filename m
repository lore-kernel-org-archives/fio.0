Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44494 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389679AbfETQ5V (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 20 May 2019 12:57:21 -0400
Received: by mail-lj1-f195.google.com with SMTP id e13so13115250ljl.11
        for <fio@vger.kernel.org>; Mon, 20 May 2019 09:57:19 -0700 (PDT)
MIME-Version: 1.0
References: <CANQrb8i=qoGivQuk4nGX-fce7zCf8_hqO=+VJzW7By_uCS1kvg@mail.gmail.com>
 <DM6PR04MB4697DC66770EDDA8B152CA8B81050@DM6PR04MB4697.namprd04.prod.outlook.com>
In-Reply-To: <DM6PR04MB4697DC66770EDDA8B152CA8B81050@DM6PR04MB4697.namprd04.prod.outlook.com>
From: Gary Little <gary.j.little@gmail.com>
Date: Mon, 20 May 2019 12:57:06 -0400
Message-ID: <CANQrb8j=Kxp+NEEbJ7BKNO3G3DEbU9-BNOYDa35FcS2BhX-0JQ@mail.gmail.com>
Subject: Re: Issues with read_iolog trace replay
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kris Davis <Kris.Davis@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Kris,

This looks very promising.  I noticed that Jens has put some work into
some nice features using blktrace replay, so it looks like this is the
way to go.  Do you have this on GitHub or something similar so we
could collaborate?

Thanks again,

Gary.

On Sun, 19 May 2019 at 18:47, Kris Davis <Kris.Davis@wdc.com> wrote:
>
> Gary,
>
> I think the io_replay file wait is referring to a "start_delay" type of w=
ait, not periods between ops, but could be wrong.
> I had a similar need, and found blktrace replay to produce reasonable tim=
ings.  So I created a python3 script to generate the blktrace binary replay=
 file.
> Below is a snippet to create blktrace type binary entries.  It's limited =
to only what was working on, but I'd love to have some help to fill out the=
 known operations and such.
> Hopefully this will help you proceed though.
> (Note: there is an fio bug with replaying Trim operations (https://github=
.com/axboe/fio/issues/771)
>
> Regards,
> Kris
>
> #################################################
> import struct
> import binascii
> from enum import Enum
>
>
> class Ops(Enum):
>     # action value observed in blkparse binary output
>     # unclear on bit meanings, so unclear, but works currently at QD=3D1
>     # TODO: find bit meanings and fill out with other ops
>     # TODO: Might be other implications at higher QDs - experiment
>     TRIM        =3D 0x2012
>     WRITESYNC   =3D 0x001a
>     READ        =3D 0x0011
>
>
> class BlkParserBinFormat():
>     magic =3D 0x65617407
>     def __init__(self):
>         self.fmt =3D struct.Struct(
>                    # defintion from FIO code: blktrace_api.h
>                    # struct blk_io_trace {
>             "I "   #   __u32 magic;        /* MAGIC << 8 | version */
>             "I "   #   __u32 sequence;     /* event number */
>             "Q "   #   __u64 time;         /* in nanoseconds */
>             "Q "   #   __u64 sector;       /* disk offset */
>             "I "   #   __u32 bytes;        /* transfer length */
>             "H H " #   __u32 action;       /* what happened */  Split int=
o action (0x0001 is Q) and command
>             "I "   #   __u32 pid;          /* who did it */
>             "I "   #   __u32 device;       /* device identifier (dev_t) *=
/
>             "I "   #   __u32 cpu;          /* on what cpu did it happen *=
/
>             "H "   #   __u16 error;        /* completion error */
>             "H "   #   __u16 pdu_len;      /* length of data after this t=
race */
>             )
>         self.curSequence =3D 0
>
>     def newEntry(self, time, sector, xferlen, operation):
>         self.curSequence +=3D 1
>         logger.debug(Lazy(lambda: pp.pformat((self.magic, self.curSequenc=
e, time, sector, xferlen, 0x0001, operation, 0, 0x10310001, 0, 0, 0))))
>         return self.fmt.pack(self.magic, self.curSequence, time, sector, =
xferlen, 0x0001, operation, 0, 0x10310001, 0, 0, 0)
> ########################################
>
> Kris Davis
>
> -----Original Message-----
> From: fio-owner@vger.kernel.org <fio-owner@vger.kernel.org> On Behalf Of =
Gary Little
> Sent: Saturday, May 18, 2019 4:10 PM
> To: fio@vger.kernel.org
> Subject: Issues with read_iolog trace replay
>
> Hello,
>
> I am trying to simulate bursty traffic with fo.  I know that I can do thi=
s by tracing a bursty app and then doing a blktrace replay, but I would lik=
e to do something programatic.
>
> I had hoped that I could create an io_replay file that looks like this wh=
ich would read, then pause for 100ms before issuing the next read.
> Once working I could then vary (lower) the "wait" period to generate the =
bursts.
>
> But what seems to happen is that all the "wait" lines are executed sequen=
tially, followed by all the "reads" sequentially, without the 100ms pause i=
n-between.
>
> FWIW, using blktrace input works as expected, and replays the trace at th=
e same iO rate as the traced workload.
>
> [root@arches filebench]# /usr/local/bin/fio --version
> fio-3.13
>
> [root@arches filebench]# /usr/local/bin/fio --name=3Dreplay --read_iolog=
=3Dread100.csv
>
> [gary@arches filebench]$ cat read100.csv fio version 2 iolog /dev/sdc add=
 /dev/sdc open /dev/sdc read 16384 4096 /dev/sdc wait 100000 1 /dev/sdc rea=
d 16384 4096 /dev/sdc wait 100000 1 /dev/sdc read 16384 4096 /dev/sdc wait =
100000 1 /dev/sdc read 16384 4096 /dev/sdc wait 100000 1 /dev/sdc read 1638=
4 4096 /dev/sdc wait 100000 1 /dev/sdc read 16384 4096 /dev/sdc wait 100000=
 1 /dev/sdc read 16384 4096 /dev/sdc wait 100000 1 /dev/sdc read 16384 4096=
 /dev/sdc wait 100000 1 /dev/sdc read 16384 4096 /dev/sdc wait 100000 1 /de=
v/sdc read 16384 4096 /dev/sdc wait 100000 1 /dev/sdc close

