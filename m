Return-Path: <axboe@kernel.dk>
Message-ID: <5495CF1E.1090704@kernel.dk>
Date: Sat, 20 Dec 2014 12:33:50 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: SSD write latency lower than read latency
References: <2028599731.63796.1418644100540.JavaMail.zimbra@thomas-krenn.com> <548EFB15.8080704@kernel.dk> <54915786.3010009@enovance.com> <54919A81.8010007@kernel.dk> <1921541814.317725.1419063992558.JavaMail.zimbra@thomas-krenn.com>
In-Reply-To: <1921541814.317725.1419063992558.JavaMail.zimbra@thomas-krenn.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
To: =?UTF-8?B?R2VvcmcgU2Now7ZuYmVyZ2Vy?= <gschoenberger@thomas-krenn.com>, fio@vger.kernel.org
Cc: Erwan Velu <erwan@enovance.com>
List-ID: <fio@vger.kernel.org>

On 12/20/2014 01:26 AM, Georg Schönberger wrote:
> ----- Original Message -----
>> From: "Jens Axboe" <axboe@kernel.dk>
>> To: "Erwan Velu" <erwan@enovance.com>, "Georg Schönberger" <gschoenberger@thomas-krenn.com>, fio@vger.kernel.org
>> Sent: Wednesday, 17 December, 2014 4:00:17 PM
>> Subject: Re: SSD write latency lower than read latency
>>
>> On 12/17/2014 03:14 AM, Erwan Velu wrote:
>>>
>>> Le 15/12/2014 16:15, Jens Axboe a écrit :
>>>> Your guess is exactly right, that's what most flash based devices
>>>> (worth their salt) do. That's also why sync write latencies are mostly
>>>> independent of the type of nand used, whereas the read latency will
>>>> easily reflect that.
>>> But here the runtime is very limited to 60. I can imagine that if we
>>> push the runtime to a longer time, the cache will not be enough to hide
>>> the real latency of the device. The cache is said to be 1GB by
>>> disassembling the device, maybe if we push the devices with bigger
>>> iodepth & a longer run, maybe we can show the performance of the NAND :
>>> once the cache is getting new data faster than it can write, the cache
>>> will be more occupied, if we can achieve at feeding it completely then
>>> we are done. I had the case with a poor MLC (128GB) that had 500MB of
>>> SLC cache. On some pattern I was hitting the MLC at 5MB/sec ...
>>>
>>> Note that in theirs specs, the write latency (65µs) is very close to the
>>> read latency (50 µs):
>>> http://ark.intel.com/products/75679/Intel-SSD-DC-S3500-Series-160GB-2_5in-SATA-6Gbs-20nm-MLC
>>>
>>>
>>> On the pdf
>>> (http://www.intel.fr/content/dam/www/public/us/en/documents/product-specifications/ssd-dc-s3500-spec.pdf),
>>> we also see in the QoS sheet, that writes are said to be slower than
>>> reads (up to 10x with iodepth=32).
>>
>> Yes, that's a given, there's a potentially huge difference between the
>> single write sync latency (which can be shaved down to the cost of issue
>> + irq + complete + wakeup), and eg write at steady state where you might
>> have to delay/stall writes if GC can't keep up.
>>
>>
>
> Thanks for your confirmation about the write cache, it's always good to know where
> things come from. According to steady state and GC, I am testing according to the SNIA
> specification:
> * http://www.snia.org/sites/default/files/SSS_PTS_Enterprise_v1.0.pdf
> with TKperf, my report is at
> * http://www.thomas-krenn.com/de/wikiDE/images/5/52/TKperf-Report-IntelDCS3500.pdf
>
> Regarding iodepth, I am using 1 job with 1 outstanding IO - as stated in the specification -
> to circumvent IO scheduler influences. I thought higher queue depths will always lead to
> higher latencies, correct? (https://www.kernel.org/doc/Documentation/block/stat.txt)
> Therefore testing with 1 nj/1 iod will generate comparable latency results, or not?

That's not necessarily true. There's a saturation point where using 
higher depth will cause higher latencies, but until you reach that 
point, it's not uncommon that you'll decrease latencies slightly by 
upping the depth. This is due to the fact that you can amortize certain 
costs across multiple IOs. At some point increasing the queue depth will 
not make the device go any faster, and at that point, increased 
latencies are expected.

> Another question, is there a chance to turn off this cache?
> It seems it is not the regular device write cache, as I turned it off with "hdparm -W"
> and latencies seem to produce the same results (just on a quick test).

It's not a simple as that. Some devices may utilize a bigger buffer used 
roughly like a writeback cache on hard drives, these are often that ones 
that have a larger super cap for power cut safety, enabling the device 
to keep running for many seconds while the buffer is drained. Others may 
simply have a smaller page buffer that they stream writes into as part 
of the design, needing much smaller powercut backing to stream that out 
to non-volatile flash. The point is that the cache setups can be very 
different and can be inherently tied to the architecture of the device, 
so there's generic way to utilize them or to turn them off. Of the 
devices that have more of a classic bigger write cache, some of them may 
come with vendor tools that allow you to switch them to write through.

-- 
Jens Axboe


