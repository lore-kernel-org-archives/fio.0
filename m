Return-Path: <fio-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:62068 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbcCBEZG (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 1 Mar 2016 23:25:06 -0500
Message-ID: <56D66B1C.6050506@vlnb.net>
Date: Tue, 01 Mar 2016 20:25:00 -0800
From: Vladislav Bolkhovitin <vst@vlnb.net>
MIME-Version: 1.0
Subject: Re: Fio high IOPS measurement mistake
References: <56D525E1.6010407@vlnb.net> <CALjAwxjLb7L8sZCensSNXZ4kDyHb683bu-zuwDvgk5sFoeMckw@mail.gmail.com>
In-Reply-To: <CALjAwxjLb7L8sZCensSNXZ4kDyHb683bu-zuwDvgk5sFoeMckw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Sitsofe Wheeler wrote on 02/29/2016 10:01 PM:
> Hi,
> 
> On 1 March 2016 at 05:17, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
>> Hello,
>>
>> I'm currently looking at one NVRAM device, and during fio tests noticed that each fio
>> thread consumes 30% of user space CPU. I'm using ioengine=libaio, buffered=0, sync=0
>> and direct=1, so user space CPU consumption should be virtually zero.
>>
>> That 30% user CPU consumption makes me suspect that this is overhead for internal fio
>> housekeeping, i.e., scientifically speaking, fio instrumental measurement mistake (I
>> hope, I'm using correct English terms).
>>
>> Can anybody comment it and suggest how to decrease this user space CPU consumption?
>>
>> Here is my full fio job:
>>
>> [global]
>> ioengine=libaio
>> buffered=0
>> sync=0
>> direct=1
>> randrepeat=1
>> softrandommap=1
>> rw=randread
>> bs=4k
>> filename=./nvram (it's a link to a block device)
>> exitall=1
>> thread=1
>> disable_lat=1
>> disable_slat=1
>> disable_clat=1
>> loops=10
>> iodepth=16
> 
> You appear to be missing gtod_reduce
> (https://github.com/axboe/fio/blob/fio-2.6/HOWTO#L1668 ) or
> gettimeofday cpu pinning. You also aren't using batching
> (https://github.com/axboe/fio/blob/fio-2.6/HOWTO#L815 ).

Thanks, I tried them, but they did not make any significant difference. The biggest
difference I had was when I changed CPU governor to "performance". Now I have 20-25%
user space, measured by fio itself, it's coherent with top. Note, I'm considering
per-thread CPU consumption, to see it in top you need to press '1' (one line per each CPU).

I also tried to short circuit the sync engine by calling fio_io_end() directly from top
of fio_syncio_queue(), so no actual IO is done. The results were interesting enough to
publish here in details (%% are per job):

Jobs	IOPS(M)	%user	%sys
1	4.3	78	22
2	7.6	67	33
3	10.5	65	35
4	7.7	61	38
5	4.8	78	22
6	4.7	83	17
7	4.8	84	15

Results were very consistent between runs. CPU - 8 cores Intel Xeon E5-2667 v3 @
3.20GHz with 20M L3 cache and HT. Fio is the latest git.

Obviously, if fio had zero overhead, i.e. instrumental mistake, IOPS level in this test
should sky rocket to hundreds of millions IOPS to have few %% overhead on multi-million
IOPS measurements. But we only have 4.3M per thread and 10.5M overall, which are,
apparently, max fio is capable to measure in the current implementation doesn't matter
how fast the storage stack is (it simply doesn't have more CPU cycles to run).

Also, apparently, there is some lock contention for something inside fio, which is
severely limiting multi-jobs performance.

Interesting that gtod_cpu for the single job case decreased IOPS to 3.8M with the same
user/sys %%: 22/78. Explicit clocksource=cpu didn't make any difference.

Another observation is why the sys CPU consumption is so high, if TSC clock is used?
Apparently, it was not used ever despite of explicit clocksource=cpu.

I checked perf for the single job case, which is the most interesting case where to
start optimizing from, and it reported 69% of time was spent in clock_thread_fn() and
3.2% in memset(). The latter also rises question, why is memset for the READs test?
Apparently, this memset is on high IO path.

The full job file was:

[global]
ioengine=sync
buffered=0
sync=0
direct=1
randrepeat=0
norandommap
softrandommap=1
random_generator=lfsr /* does not really matter */
rw=randread
bs=4K /* it does not matter, since it's short circuit */
filename=./nvram /* does not matter */
exitall=1
thread=1
gtod_reduce=1
loops=10
iodepth=8 /* does not matter */

[file1]

[file2]

...

The consumed user space CPU roughly could be considered the instrumental mistake.
Generally speaking, we have 3 components: load generator, measurement infrastructure
("a gauge") and load processor (storage). The storage is the object whose performance
we are measuring by applying load from the load generator and using the measurement
infrastructure to get the results. Since the storage stack is entirely in the kernel,
what we can see as the user space CPU consumption is the aggregated load generator and
measurement infrastructure CPU consumption, i.e. fio overhead, i.e. instrumental
mistake. (Obviously, this is true only when CPU is the bottleneck as you can see in top
with one line per each CPU output, which is pretty much always true for high IOPS tests.)

Thus, I'm afraid, looks like currently fio, being a really great tool, has severe
limitations for high IOPS measurements, because it has too big internal load generation
and measurement overheads. It's like having a thermometer, which has mistake 0-infinity
depending from temperature you are measuring. If it's low enough, you will have 100%
accuracy, but if it's too high, it might start measuring something internal instead of
what it is supposed to measure. To be fair, all thermometers behave like this ;).
However, this analyze shows that fio accuracy significantly declining starting from few
hundreds K IOPS, where for me it has with libaio and my NVRAM card 22% overhead on 612K
IOPS (QD 8, single job). Adding more jobs increases IOPS up to the card's limit, but
the per thread overhead remains about the same.

Just a friendly analyze in a hope to improve the great tool. Multi-million IOPS storage
is coming, so this is important. Or did I miss anything?

> You may want to look at what fio settings your flash vendor recommends
> for benchmarking purposes...

Those where I started from. However, being a person with an experimental physics
background, I started from very basics: calibrating my tools to figure out instrumental
mistakes I have with them. My checks with fio led to this thread.

Thanks,
Vlad


