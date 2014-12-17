Return-Path: <axboe@kernel.dk>
Message-ID: <54919A81.8010007@kernel.dk>
Date: Wed, 17 Dec 2014 08:00:17 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: SSD write latency lower than read latency
References: <2028599731.63796.1418644100540.JavaMail.zimbra@thomas-krenn.com> <548EFB15.8080704@kernel.dk> <54915786.3010009@enovance.com>
In-Reply-To: <54915786.3010009@enovance.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
To: Erwan Velu <erwan@enovance.com>, =?UTF-8?B?R2VvcmcgU2Now7ZuYmVyZ2Vy?= <gschoenberger@thomas-krenn.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 12/17/2014 03:14 AM, Erwan Velu wrote:
>
> Le 15/12/2014 16:15, Jens Axboe a écrit :
>> Your guess is exactly right, that's what most flash based devices
>> (worth their salt) do. That's also why sync write latencies are mostly
>> independent of the type of nand used, whereas the read latency will
>> easily reflect that.
> But here the runtime is very limited to 60. I can imagine that if we
> push the runtime to a longer time, the cache will not be enough to hide
> the real latency of the device. The cache is said to be 1GB by
> disassembling the device, maybe if we push the devices with bigger
> iodepth & a longer run, maybe we can show the performance of the NAND :
> once the cache is getting new data faster than it can write, the cache
> will be more occupied, if we can achieve at feeding it completely then
> we are done. I had the case with a poor MLC (128GB) that had 500MB of
> SLC cache. On some pattern I was hitting the MLC at 5MB/sec ...
>
> Note that in theirs specs, the write latency (65µs) is very close to the
> read latency (50 µs):
> http://ark.intel.com/products/75679/Intel-SSD-DC-S3500-Series-160GB-2_5in-SATA-6Gbs-20nm-MLC
>
>
> On the pdf
> (http://www.intel.fr/content/dam/www/public/us/en/documents/product-specifications/ssd-dc-s3500-spec.pdf),
> we also see in the QoS sheet, that writes are said to be slower than
> reads (up to 10x with iodepth=32).

Yes, that's a given, there's a potentially huge difference between the 
single write sync latency (which can be shaved down to the cost of issue 
+ irq + complete + wakeup), and eg write at steady state where you might 
have to delay/stall writes if GC can't keep up.


-- 
Jens Axboe


