Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43191
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432Ab2LUPd4 (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 21 Dec 2012 10:33:56 -0500
Message-ID: <50D48139.30601@kernel.dk>
Date: Fri, 21 Dec 2012 16:33:13 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] gettime: minimize integer division
References: <50D26157.5020802@micron.com> <50D2C8FD.2070901@kernel.dk> <50D3487E.7000402@micron.com> <50D352D7.2090901@kernel.dk> <50D365AA.9080202@micron.com>
In-Reply-To: <50D365AA.9080202@micron.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sam Bradshaw <sbradshaw@micron.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2012-12-20 20:23, Sam Bradshaw wrote:
> 
>>> diff --git a/gettime.c b/gettime.c
>>> index 035d275..89f3e27 100644
>>> --- a/gettime.c
>>> +++ b/gettime.c
>>> @@ -168,17 +168,23 @@ void fio_gettime(struct timeval *tp, void
>>> fio_unused *caller)
>>>  		}
>>>  #ifdef ARCH_HAVE_CPU_CLOCK
>>>  	case CS_CPUCLOCK: {
>>> -		unsigned long long usecs, t;
>>> +		unsigned long long usecs, t, delta = 0;
>>>
>>>  		t = get_cpu_clock();
>>>  		if (tv && t < tv->last_cycles) {
>>>  			dprint(FD_TIME, "CPU clock going back in time\n");
>>>  			t = tv->last_cycles;
>>> -		} else if (tv)
>>> +		} else if (tv) {
>>> +			if (tv->last_tv_valid)
>>> +				delta = t - tv->last_cycles;
>>>  			tv->last_cycles = t;
>>> +		}
>>>
>>>  		usecs = t / cycles_per_usec;
>>> -		tp->tv_sec = usecs / 1000000;
>>> +		if (delta && delta < 1000000)
>>> +			tp->tv_sec = tv->last_tv.tv_sec;
>>> +		else
>>> +			tp->tv_sec = usecs / 1000000;
>>>  		tp->tv_usec = usecs % 1000000;
>>>  		break;
>>>  		}
>>
>> I was thinking about this... Is it actually guarenteed to work. If
>> tv->last_tv.tv_usec is eg 900,000, you'd only need a 100k usec diff to
>> need to wrap, not 1000k. And since this is about avoiding costly divs,
>> since we know the number of cycles last time, it might make more sense
>> to just do the single div to go from cycles to usecs, then add that to
>> the tv->last_tv.
>>
> 
> 
> 
> Something like this might work, though that amount of logic may
> be equivalent in terms of cycles to the divide.

So I took a look at it. The costly bit is the division by
cycles_per_usec, which the compiler has no other option than turn into a
divq. The modulo and divide by 1M can be turned into something more
clever, basically shifts and imull.

So how about the below? It turns the divq into multiplication and
division by 10M, which should be considerably less expensive. Can you
test and see how that works for you?

diff --git a/gettime.c b/gettime.c
index 035d275..56703e1 100644
--- a/gettime.c
+++ b/gettime.c
@@ -15,6 +15,7 @@
 
 #ifdef ARCH_HAVE_CPU_CLOCK
 static unsigned long cycles_per_usec;
+static unsigned long inv_cycles_per_usec;
 int tsc_reliable = 0;
 #endif
 
@@ -177,7 +178,7 @@ void fio_gettime(struct timeval *tp, void fio_unused *caller)
 		} else if (tv)
 			tv->last_cycles = t;
 
-		usecs = t / cycles_per_usec;
+		usecs = (t * inv_cycles_per_usec) / 10000000UL;
 		tp->tv_sec = usecs / 1000000;
 		tp->tv_usec = usecs % 1000000;
 		break;
@@ -277,6 +278,8 @@ static void calibrate_cpu_clock(void)
 	dprint(FD_TIME, "mean=%f, S=%f\n", mean, S);
 
 	cycles_per_usec = avg;
+	inv_cycles_per_usec = 10000000UL / cycles_per_usec;
+	dprint(FD_TIME, "inv_cycles_per_usec=%lu\n", inv_cycles_per_usec);
 }
 #else
 static void calibrate_cpu_clock(void)

-- 
Jens Axboe

