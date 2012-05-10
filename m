Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34125 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455Ab2EJS6K (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 10 May 2012 14:58:10 -0400
Message-ID: <4FAC0FC0.5050705@kernel.dk>
Date: Thu, 10 May 2012 20:58:08 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: difference between "lat" and "clat"
References: <201205091423.03699.ms@teamix.de> <201205091627.04740.ms@teamix.de>
In-Reply-To: <201205091627.04740.ms@teamix.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <ms@teamix.de>
Cc: fio@vger.kernel.org

On 2012-05-09 16:27, Martin Steigerwald wrote:
> Am Mittwoch, 9. Mai 2012 schrieb Martin Steigerwald:
>> Hi Jens, hi everyone,
>>
>> Well mails from my mail client seem to appear here.
>>
>>
>> I have some questions regarding fio latencies.
>>
>> There are three kind of latencies described in README, from which fio 2.0.7
>> only displays clat and lat:
>>
>> slat = submission latency
>>
>> clat = completion latency
>>
>> lat = I/O completion latency
>>
>>
>> Now I try to understand the README but I am not sure whether I really got
>> the difference.
>>
>> I understand:
>>
>> slat: The time to submit the I/O. This is the time after which a syscall
>> returns to userspace. On sync I/O this will include the completion of the
>> request as sync I/O will wait for the request to land in pagecache. On
>> asynchronous I/O this will be really fast.
>>
>> clat: This is the time to complete handling the I/O request. Then it is at
>> least in the pagecache on buffered I/O.
>>
>> lat: The time it takes till the request has been processed. The HOWTO says:
>> "This is the time from when IO leaves fio and when it gets completed."
>>
>> So how is that completion different from the other completion in clat?
> […]
>> Reads:
>>     clat (usec): min=189 , max=954818 , avg=5423.72, stdev=21529.85
>>      lat (usec): min=190 , max=954818 , avg=5423.90, stdev=21529.85
>>
>>
>> Writes:
>>     clat (usec): min=3 , max=2391.5K, avg=180.47, stdev=8936.82
>>      lat (usec): min=4 , max=2391.5K, avg=180.59, stdev=8936.82
>>
>>
>> So whats the difference here? Is
>>
>> lat = slat + clat?

Yes, lat is the total latency. slat is the time it takes to submit the
IO to the kernel, clat is the time from when slat is over and until the
device has completed it (and the application is notified). Hence lat is
slat + clat.

> Could be (from another job with iodepth 64)
> 
> write:
> slat (usec): min=5 , max=753280 , avg=190.49, stdev=8787.41
> clat (usec): min=677 , max=2178.2K, avg=317831.81, stdev=282569.45
> lat (usec): min=715 , max=2178.2K, avg=318023.20, stdev=282631.85
> 
> read:
> slat (usec): min=5 , max=139 , avg=22.73, stdev= 5.52
> clat (msec): min=8 , max=1756 , avg=203.10, stdev=174.58
> lat (msec): min=8 , max=1756 , avg=203.13, stdev=174.58
> 
> Hmmm, on read averages don't add up.

How so? slat is 22.73usec, or 0.002273msec. 203.10 + 0.0023 is roughly
203.13.

-- 
Jens Axboe

