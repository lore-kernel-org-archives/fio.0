Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAKapHkMc1GpyrvyUoprPEC=iOsbtbz7gxWESrakV+WGN=9Ne+w@mail.gmail.com>
References: <CAKapHkMhGrnb1g=b9Pz_D_Frx8OSP65aiXBBM_KgVy5wpSz-kw@mail.gmail.com>
 <5756D05D.2050205@kernel.dk> <CAKapHkMc1GpyrvyUoprPEC=iOsbtbz7gxWESrakV+WGN=9Ne+w@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 8 Jun 2016 06:52:06 +0100
Message-ID: <CALjAwxiUcs84bCK8kPVT8jtqAsd7rWTFFn9JMv6x8A_7W8ATGA@mail.gmail.com>
Subject: Re: System IOPS vs. fio IOPS
Content-Type: text/plain; charset=UTF-8
To: Karan Singh <karan@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 7 June 2016 at 22:01, Karan Singh <karan@redhat.com> wrote:
> Thanks Jens for answering
>
> You said kernel merges / divides IO into 512k chunk.
>
> #1 How can i verify this (512k) value, any command or file to look this into ?

You could turn on blktrace block tracing
(http://www.cse.unsw.edu.au/~aaronc/iosched/doc/blktrace.html ) and
parse the log. This would allow to see events such as splits and
merges. You could also use the kernel's generic tracing to watch key
functions (but this is more work).

> #2 Out of curiosity is there a way to disable this merging / division
> of IO ? it might be not efficient but just want to play around this.

You can disable merging by writing 2 to the block device's nomerges
parameter - see the nomerges section in
https://www.kernel.org/doc/Documentation/block/queue-sysfs.txt for
details. I don't believe you can turn off splitting without manually
modifying the kernel code.

> #3 Is it true that merging /division of IO is irrespective of pattern
> ( sequential or random ) i.e kernel will perform this whether the IO
> is seq. or random ?

Splitting has to happen when the I/O is bigger than the device's
maximum single I/O request size (see attributes like max_hw_sectors_kb
in https://www.kernel.org/doc/Documentation/block/queue-sysfs.txt )
and might also happen if it's bigger than its optimal size (if the
kernel has the choice). Merging can happen when the I/O scheduler is
in its wait period before submitting I/O and consecutive I/Os are
spotted. If you think about it, there's no reason why random I/O
couldn't produce mergable sequences (e.g. if you do random I/O in a
very small region such that all of the region is hit while the I/O
scheduler was waiting) - it just less likely. See
https://www.kernel.org/doc/Documentation/block/ *iosched.txt for
individual scheduler details and see the above answer to #2 above for
turning it off.

These types of question might be also worth asking on the Kernel
Newbies list (http://kernelnewbies.org/ML ).

-- 
Sitsofe | http://sucs.org/~sits/

