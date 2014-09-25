Return-Path: <akashv@google.com>
MIME-Version: 1.0
In-Reply-To: <CAFFT=UkPhmUHD0EAH1_KDviB9909=NwqNSeCXWiOz=0Fp6phhA@mail.gmail.com>
References: <CAFFT=UkPhmUHD0EAH1_KDviB9909=NwqNSeCXWiOz=0Fp6phhA@mail.gmail.com>
From: Akash Verma <akashv@google.com>
Date: Thu, 25 Sep 2014 10:36:22 -0700
Message-ID: <CAFFT=Ukkh3E7tkJkVQ09VMiribNtTt+ZKi8w3VRf7ovS5xw4ww@mail.gmail.com>
Subject: Re: If loops= is specified, zone state is unexpectedly retained
 across iterations.
Content-Type: text/plain; charset=UTF-8
To: fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Allen Schade <aschade@google.com>
List-ID: <fio@vger.kernel.org>

Adding Jens on cc.

On Tue, Sep 23, 2014 at 6:02 PM, Akash Verma <akashv@google.com> wrote:
> I'm wondering if this is desired behavior or accidental. If I use this
> control file:
>
> [sdb-zoned-and-looped]
> rw=write
> bs=4k
> size=24k
> zonesize=12k
> zonerange=512k
> zoneskip=512k
> ioengine=sync
> direct=1
> thread=1
> loops=10
> filename=/dev/sdb
> write_iolog=sdb_iolog.txt
>
> sdb_iolog.txt shows:
> fio version 2 iolog
> /dev/sdb add
> /dev/sdb open
> /dev/sdb write 0 4096
> /dev/sdb write 4096 4096
> /dev/sdb write 8192 4096
> /dev/sdb write 1048576 4096
> /dev/sdb write 1052672 4096
> /dev/sdb write 1056768 4096
> /dev/sdb close
> /dev/sdb open
> /dev/sdb write 1048576 4096
> /dev/sdb write 1052672 4096
> /dev/sdb write 1056768 4096
> /dev/sdb write 2097152 4096
> /dev/sdb write 2101248 4096
> /dev/sdb write 2105344 4096
> ...
>
> I'd expect each iteration of the loop to be identical, rather than
> resuming from the zone offset of the previous iteration. Would it be
> okay to change this behavior?

