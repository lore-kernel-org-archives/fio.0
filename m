Return-Path: <sitsofe@gmail.com>
Return-Path: <sitsofe@gmail.com>
Date: Sun, 28 Sep 2014 20:44:19 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: [Question] How to perform stride access?
Message-ID: <20140928194419.GA24724@sucs.org>
References: <542179FA.5040106@gmail.com>
 <CANvN+enrUD45Zp1CJKQ3kxQncHLyhp7hE1jr4AnzRD65oDTUvg@mail.gmail.com>
 <54228237.5000805@gmail.com>
 <CALjAwxg+o05=3YDOmXaKskrdg3AHU88T-pkqZw=QFQkwRTjdwA@mail.gmail.com>
 <CALjAwxirUW+v662QZ9zQG-2zuTNtE8xkpfaJqv=5ArLviqjhGw@mail.gmail.com>
 <5427716A.1080407@kernel.dk>
 <20140928103616.GA9991@sucs.org>
 <54281A0A.8050905@kernel.dk>
 <5428246F.7020506@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5428246F.7020506@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: Akira Hayakawa <ruby.wktk@gmail.com>, Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Sun, Sep 28, 2014 at 09:08:31AM -0600, Jens Axboe wrote:
> On 2014-09-28 08:24, Jens Axboe wrote:
> >On 2014-09-28 04:36, Sitsofe Wheeler wrote:
> >>I guess I would have thought io_limit always forced wraparound. For
> >>example:
> >>
> >># dd if=/dev/zero of=/dev/shm/1M bs=1M count=1 # fio --bs=4k
> >>--filename=/dev/shm/1M --name=go1 --rw=write [...] Run status group
> >>0 (all jobs): WRITE: io=1024KB, aggrb=341333KB/s, minb=341333KB/s,
> >>maxb=341333KB/s, mint=3msec, maxt=3msec # fio --bs=4k
> >>--filename=/dev/shm/1M --name=go2 --io_limit=2M --rw=write Run
> >>status group 0 (all jobs): WRITE: io=2048KB, aggrb=341333KB/s,
> >>minb=341333KB/s, maxb=341333KB/s, mint=6msec, maxt=6msec [...] # fio
> >>--bs=4k --filename=/dev/shm/1M --name=go3 --io_limit=2M
> >>--rw=write:4k [...] WRITE: io=512KB, aggrb=256000KB/s,
> >>minb=256000KB/s, maxb=256000KB/s, mint=2msec, maxt=2msec Run status
> >>group 0 (all jobs): # fio --bs=4k --filename=/dev/shm/1M --name=go4
> >>--io_limit=2M --rw=write:4k [...] Run status group 0 (all jobs):
> >>WRITE: io=512KB, aggrb=256000KB/s, minb=256000KB/s, maxb=256000KB/s,
> >>mint=2msec, maxt=2msec
> >>
> >>go2 is a plain sequential job that does twice as much I/O as go1.
> >>Given that the size of the file being written to has not changed
> >>between the runs one could guess that fio simply wrapped around and
> >>started from the first offset (0) to write the second MB of data.
> >>Given this isn't it a fair assumption that when doing a skipping
> >>workload if io_limit is used (as in go4) and an offset beyond the
> >>end of the device is produced the same wraparound behaviour as go2
> >>should occur and the total io done should match that specified in
> >>io_limit?
> >
> >I would agree on that, behavior for those cases _should_ be the same.
> >Without the holed IO, it closes/reopens the file and repeats the 1M
> >writes. With it, it does not. I will take a look.
> 
> Does the attached fix it up?

The patch fixes
fio --bs=4k --rw=write:4k --filename=/dev/shm/1M --name=go --io_limit=2M
but not
fio --bs=512k --rw=write --filename=/dev/shm/1M --name=go --number_io=4
or
fio --bs=4k --rw=write --filename=/dev/shm/1M --name=go --zoneskip=4k --zonesize=4k --io_limit=2M

-- 
Sitsofe | http://sucs.org/~sits/

