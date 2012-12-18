Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55404
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754072Ab2LRHV4 (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 18 Dec 2012 02:21:56 -0500
Message-ID: <50D01990.7080102@kernel.dk>
Date: Tue, 18 Dec 2012 08:21:52 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Latency spikes with 'thread' option
References: <80B89753B40C5141A3E2D53FE7A2A8A930030D7E@NTXBOIMBX02.micron.com> <50C9D5CA.9000904@kernel.dk> <80B89753B40C5141A3E2D53FE7A2A8A930031AC5@NTXBOIMBX02.micron.com>
In-Reply-To: <80B89753B40C5141A3E2D53FE7A2A8A930031AC5@NTXBOIMBX02.micron.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "Mike Berhan (mberhan)" <mberhan@micron.com>

On 2012-12-17 23:23, Sam Bradshaw (sbradshaw) wrote:
> 
>> -----Original Message-----
>> From: Jens Axboe [mailto:axboe@kernel.dk]
>> Sent: Thursday, December 13, 2012 5:19 AM
>> To: Sam Bradshaw (sbradshaw)
>> Cc: fio@vger.kernel.org
>> Subject: Re: Latency spikes with 'thread' option
>>
>> On 2012-12-12 21:11, Sam Bradshaw (sbradshaw) wrote:
>>> Hi All,
>>>
>>> We're running queue depth sweeps with a 4k random read workload (sample config
>>> below) against a high performance PCIe SSD - the Micron p320h.  We're seeing
>>> latency spikes to 1 sec when the 'thread' option is used.  Instrumenting the
>>> driver, we see max latencies from driver entry point to block layer completion
>>> callback of <20 ms at high queue depths.  If 'thread' is not used, the max
>>> latencies reported by fio align almost exactly with that seen by the driver.
>>> There are typically only one or two of these latency outliers during a 40 sec
>>> run, for example, but they represent a significant enough excursion to pull
>>> our std. dev. very high.
>>>
>>> Has anyone witnessed this sort of behavior?  We see it with all the versions
>>> of fio that we have used (2.0.5+) with a variety of kernels.  It's also very
>>> suspicious that the max latency is either almost exactly 1 sec or aligns with
>>> our hardware incurred latency for the given queue depth.
>>
>> I've seen that happen before as well, but I never got to the bottom of
>> it. I just tried, and I can trigger it fairly easily that dell box. If I
>> beat on two devices, it doesn't happen easily. Add the third, and it
>> hits almost immediately after starting up the threads.
>>
>> For fio, the only difference between a thread and process is how they
>> are kicked off. So it would seem unlikely to be something in fio.
>> Perhaps it's a scheduling bug? But then it seems odd that nobody else
>> has seen this. I see exactly the same latencies you report, very close
>> to precisely 1s latencies. That is indeed very odd.
> 
> I've spent some time poking around and I have some more data points and a
> suggestion.
> 
> First, the 1 second latency events come in batches and those batches occur 
> suspiciously close to a usec wrap (0.999999 us -> 1.000000 us).  Second, if you
> subtract exactly 1 second from these outlier latencies, the remaining amount is
> very close to what our instrumented low level driver records for the IO latency
> and consistent with the expected latencies of our SSD.  Similarly, the tv_usec
> portion of the timeval structs shows increasing values.  See snippet below.
> 
> Format is like    start: <start_time.tv_sec>.<start_time.tv_usec>
> 
> latency: 1004657 us, lba: 1111289192, start: 1355776806.995294 issue: 1355776806.995312 complete: 1355776807.999969
> latency: 1000494 us, lba: 203093568, start: 1355776806.999456 issue: 1355776806.999475 complete: 1355776807.999969
> latency: 1000404 us, lba: 551350992, start: 1355776806.999546 issue: 1355776806.999565 complete: 1355776807.999969
> latency: 1000477 us, lba: 449672928, start: 1355776806.999484 issue: 1355776806.999492 complete: 1355776807.999969
> 
> All this pointed to the time collection code being buggy.  Reviewing the 
> code, I spotted this in fio_gettime():
> 
> 	/*
> 	 * If Linux is using the tsc clock on non-synced processors,
> 	 * sometimes time can appear to drift backwards. Fix that up.
> 	 */
> 	if (last_tv_valid) {
> 		if (tp->tv_sec < last_tv.tv_sec)
> 			tp->tv_sec = last_tv.tv_sec;
> 		else if (last_tv.tv_sec == tp->tv_sec &&
> 			 tp->tv_usec < last_tv.tv_usec)
> 			tp->tv_usec = last_tv.tv_usec;
> 	}
> 	last_tv_valid = 1;
> 	memcpy(&last_tv, tp, sizeof(*tp));
> 
> This does not appear to be multi-thread safe.  Pre-emption can occur between 
> either comparison and the subsequent update.  Commenting it out makes the
> problem go away (at the expense of being subject to drift).  How about
> making last_tv & last_tv_valid thread-local?

Good analysis and I believe you are correct. It's not safely shared and
should be thread local. A quick test here with the below seems to
indicate that that is indeed the issue, I don't see any time weirdness
with that applied.


diff --git a/gettime.c b/gettime.c
index f5be6bd..1a7af37 100644
--- a/gettime.c
+++ b/gettime.c
@@ -18,8 +18,8 @@ static unsigned long cycles_per_usec;
 static unsigned long last_cycles;
 int tsc_reliable = 0;
 #endif
-static struct timeval last_tv;
-static int last_tv_valid;
+static __thread struct timeval last_tv;
+static __thread int last_tv_valid;
 
 enum fio_cs fio_clock_source = FIO_PREFERRED_CLOCK_SOURCE;
 int fio_clock_source_set = 0;

-- 
Jens Axboe

