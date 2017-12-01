Return-Path: <axboe@kernel.dk>
Subject: Re: memcpy test
References: <0aa59e33-54d4-cd80-350a-0f13bfa74a98@kernel.dk>
 <AT5PR8401MB038721B93CF3CF3DE4361A7AAB390@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <aba29420-0049-5537-7efe-c6f5f7093b4f@kernel.dk>
Date: Fri, 1 Dec 2017 13:50:37 -0700
MIME-Version: 1.0
In-Reply-To: <AT5PR8401MB038721B93CF3CF3DE4361A7AAB390@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "Robert Elliott (Persistent Memory)" <elliott@hpe.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Rebecca Cran <rebecca@bluestop.org>, Sitsofe Wheeler <sitsofe@gmail.com>
List-ID: <fio@vger.kernel.org>

On 12/01/2017 01:45 PM, Robert Elliott (Persistent Memory) wrote:
> 
> 
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
>> Behalf Of Jens Axboe
>> Sent: Friday, December 1, 2017 12:20 PM
>> To: fio@vger.kernel.org
>> Cc: Rebecca Cran <rebecca@bluestop.org>; Sitsofe Wheeler
>> <sitsofe@gmail.com>; Robert Elliott (Persistent Memory) <elliott@hpe.com>
>> Subject: memcpy test
>>
>> Hi,
>>
>> Reviving this topic, since I think it's interesting in the presence
>> of persistent memory engines that rely heavily on optimized memcpy
>> to be fast.
>>
>> Similar to how we have --crctest, I added --memcpytest. Very basic,
>> just wanted to get the ball rolling. Basically it just copies between
>> two 32MB chunks, using whatever implementation you would like, and in
>> increments of some defined size. This is what it spits out on my
>> laptop:
>>
>> memcpy
>> 	8 bytes:	 3360.94 MiB/sec
>> 	16 bytes:	 4363.47 MiB/sec
>> 	96 bytes:	 6804.46 MiB/sec
>> 	128 bytes:	 6391.39 MiB/sec
>> 	256 bytes:	 6571.09 MiB/sec
>> 	512 bytes:	 6962.77 MiB/sec
>> 	2048 bytes:	 6212.73 MiB/sec
>> 	8192 bytes:	 6465.14 MiB/sec
>> 	131072 bytes:	 6412.24 MiB/sec
>> 	262144 bytes:	 6607.03 MiB/sec
>> 	524288 bytes:	 6372.90 MiB/sec
>> memmove
>> 	8 bytes:	 2503.90 MiB/sec
>> 	16 bytes:	 4311.81 MiB/sec
>> 	96 bytes:	 6734.74 MiB/sec
>> 	128 bytes:	 6080.16 MiB/sec
>> 	256 bytes:	 6162.92 MiB/sec
>> 	512 bytes:	 7309.80 MiB/sec
>> 	2048 bytes:	 6931.94 MiB/sec
>> 	8192 bytes:	 6878.97 MiB/sec
>> 	131072 bytes:	 6787.05 MiB/sec
>> 	262144 bytes:	 6877.77 MiB/sec
>> 	524288 bytes:	 6695.26 MiB/sec
>> simple
>> 	8 bytes:	 1813.59 MiB/sec
>> 	16 bytes:	 2191.63 MiB/sec
>> 	96 bytes:	 7360.76 MiB/sec
>> 	128 bytes:	 7192.63 MiB/sec
>> 	256 bytes:	 7340.00 MiB/sec
>> 	512 bytes:	 7158.04 MiB/sec
>> 	2048 bytes:	 7495.96 MiB/sec
>> 	8192 bytes:	 7315.30 MiB/sec
>> 	131072 bytes:	 7565.82 MiB/sec
>> 	262144 bytes:	 7410.95 MiB/sec
>> 	524288 bytes:	 7537.09 MiB/sec
>>
>> which is kind of depressing, since the fastest for larger sizes is the
>> very dumb and basic implementation that you'll find in any text book
>> under the section of "my first memcpy".
>>
>> Anyway, for evaluating implementations, we need a way to test them,
>> and now we have. I'll be happy to take input/patches on the test
>> itself.
> 
> Some considerations/points:
> * lock down the thread to a CPU core so the kernel doesn't move it around
> * ensure the memory buffer is allocated on the local node (unless intentionally
>   testing remote bandwidth)

You can do that when invoking fio, we don't have to support that.

> * CPU caches will distort results; it's important to flush both source and
>   destination addresses out of the caches before starting, then start the timer,
>   do the copy, flush the caches again, then stop the timer.
>   If the copy function uses non-temporal stores, though, the second cache
>   flush is not needed and would unfairly penalize it.

I'm not looking to micro benchmark to that extreme, it's just a basic test
to see if there are massive differences between implementations.

> * one CPU will be limited to about 10 GB/s for various interesting reasons;
>   you need multiple CPUs active to saturate memory channels

Ditto, this isn't a full memory copying framework, it's just a simple memcpy
test.

> * integrating Agner Fog's assembly language memory function library might
>   be a good option, if fio can take GPLv3 code.  That way fio would show
>   what the processors are capable of achieving, for comparison to what
>   the installed system libraries do. See http://www.agner.org/optimize -
>   section 17.9 of "Optimizing assembly"  discusses the memcpy functions.

My goal would be to find if there's something simple we can do to provide
a fairly optimized version we can use for larger copies, which is
essentially just for mmap and libpmem/dev-dax and friends. 

-- 
Jens Axboe


