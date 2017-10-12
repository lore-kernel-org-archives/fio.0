Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjAwxi7cd4RFG7WSz+XWHkouKwvX7iFnU3tNri-MgR1RTstZw@mail.gmail.com>
References: <20171010212710.12526-1-andrzej.jakowski@intel.com>
 <CALjAwxhFr84M6p3SUmJuu8novyP+Wq7fiyPrTd=qGn4ubHwC1w@mail.gmail.com>
 <cf6c368d-110e-7776-bcc8-76e9d024914a@kernel.dk> <28cd47ad-913c-0eaa-ec2d-84ab47763029@gmail.com>
 <CAOmo8DbWZTT=yZE1rDrGBabji83-SwH+p0M5TpFk9awNdvMdGw@mail.gmail.com> <CALjAwxi7cd4RFG7WSz+XWHkouKwvX7iFnU3tNri-MgR1RTstZw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 12 Oct 2017 13:36:19 +0100
Message-ID: <CALjAwxg=GCVbpNhOu1b7zpR-7Rexc1ttzWoUHqmNMfnDk2sZhw@mail.gmail.com>
Subject: Re: [PATCH] Fix overflow in percentile calculation for Windows
Content-Type: text/plain; charset="UTF-8"
To: Andrzej Jakowski <andrzej.jakowski@gmail.com>
Cc: Vincent Fu <vincentfu@gmail.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Andrzej Jakowski <andrzej.jakowski@intel.com>
List-ID: <fio@vger.kernel.org>

On 12 October 2017 at 07:06, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> On 12 October 2017 at 06:28, Andrzej Jakowski
> <andrzej.jakowski@gmail.com> wrote:
>> On Wed, Oct 11, 2017 at 4:36 PM, Vincent Fu <vincentfu@gmail.com> wrote:
>>> Andrzej, does this actually resolve the problem you observed? unsigned long
>>> nr in the parameter list of calc_clat_percentiles() and
>>> show_clat_percentiles() also looks like it will overflow when you have more
>>> than 2^32 IOs.
>> Yes you are right. That original patch is not sufficient. Will get it
>> fixed and post new version soon.
>
> I've got a feeling there are few other 32 bit platform integer
> overflows lurking around. I'm trying a clang sanitizer run...

The following results are from a 32 bit Linux build without your patch:
gettime.c:313:28: runtime error: unsigned integer overflow: 3600 *
2600730 cannot be represented in type 'unsigned long'
gettime.c:353:53: runtime error: unsigned integer overflow:
8796093022208 * 12901928 cannot be represented in type 'unsigned long
long'
overflow: (g=0): rw=read, bs=(R) 32B-32B, (W) 32B-32B, (T) 32B-32B,
ioengine=null, iodepth=32
...
fio-3.1-50-g2b6f
Starting 4 threads
io_u.c:1272:28: runtime error: unsigned integer overflow: 0 - 1 cannot
be represented in type 'unsigned int'
gettime.c:197:35: runtime error: unsigned integer overflow:
1429766471724 * 12901928 cannot be represented in type 'unsigned long
long'
backend.c:345:7: runtime error: unsigned integer overflow: 4294967295
+ 1 cannot be represented in type 'unsigned int'
io_u.c:989:23: runtime error: unsigned integer overflow: 4294967288 +
8 cannot be represented in type 'unsigned int'
io_u.c:1071:24: runtime error: unsigned integer overflow: 4294967295 +
1 cannot be represented in type 'uint32_t' (aka 'unsigned int')
Jobs: 4 (f=4): [R(4)][26.9%][r=102MiB/s,w=0KiB/s][r=3358k,w=0 IOPS][eta 43m:52s]

^C
fio: terminating on signal 2
ioengines.c:270:22: runtime error: unsigned integer overflow: 0 - 7
cannot be represented in type 'unsigned int'
stat.c:1452:18: runtime error: unsigned integer overflow: 12246275151
* 12220497954 cannot be represented in type 'unsigned long long'
stat.c:1529:20: runtime error: unsigned integer overflow: 3656340552 +
3630563360 cannot be represented in type 'unsigned int'
stat.c:1537:22: runtime error: unsigned integer overflow: 3002030688 +
2989903763 cannot be represented in type 'unsigned int'
stat.c:1531:23: runtime error: unsigned integer overflow: 3058346638 +
1520207785 cannot be represented in type 'unsigned int'
stat.c:1533:25: runtime error: unsigned integer overflow: 3058346638 +
1520207785 cannot be represented in type 'unsigned int'

(I've manually removed most of the warnings that look like unsigned
wraparound was expected/desired such as when hashing is being done)

The first gettime.c problem looks like it's easily fixed with "static
unsigned long long cycles_per_msec".
The next gettime.c:353:53 looks more problematic. That value is
gigantic and would need a 128 bit variable to fit. I don't know if
this is spurious because I'm running a VM and manually set
--clocksource=cpu but it would be nice to know for sure.
io_u.c:1272 looks like the standard decrementing counter whose value
is taken before being negated so it's a harmless warning.
backend.c:345:7 I think ts_cache_nr is expected to just keep wrapping
around so this is harmless?
io_u.c:989:23 io_u_map is a uint32_t which means we can only store
2^32 latency entries before we wraparound - this sounds problematic
but I don't know how to handle it (periodically scale everything?).
io_u.c:1071:24 see above but for io_u_lat_u .
stat.c:1452:18 - too many samples means (no pun intended) we have an overflow.
The rest of the stat.c errors appear to be down to to trying to
combine samples when both values are already close to their 32 bit
value maximums and the result can't be kept in 32 bits.

Any thoughts?

-- 
Sitsofe | http://sucs.org/~sits/

