Return-Path: <sbradshaw@micron.com>
Message-ID: <50D365AA.9080202@micron.com>
Date: Thu, 20 Dec 2012 11:23:22 -0800
From: Sam Bradshaw <sbradshaw@micron.com>
MIME-Version: 1.0
Subject: Re: [PATCH] gettime: minimize integer division
References: <50D26157.5020802@micron.com> <50D2C8FD.2070901@kernel.dk> <50D3487E.7000402@micron.com> <50D352D7.2090901@kernel.dk>
In-Reply-To: <50D352D7.2090901@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>


>> diff --git a/gettime.c b/gettime.c
>> index 035d275..89f3e27 100644
>> --- a/gettime.c
>> +++ b/gettime.c
>> @@ -168,17 +168,23 @@ void fio_gettime(struct timeval *tp, void
>> fio_unused *caller)
>>  		}
>>  #ifdef ARCH_HAVE_CPU_CLOCK
>>  	case CS_CPUCLOCK: {
>> -		unsigned long long usecs, t;
>> +		unsigned long long usecs, t, delta = 0;
>>
>>  		t = get_cpu_clock();
>>  		if (tv && t < tv->last_cycles) {
>>  			dprint(FD_TIME, "CPU clock going back in time\n");
>>  			t = tv->last_cycles;
>> -		} else if (tv)
>> +		} else if (tv) {
>> +			if (tv->last_tv_valid)
>> +				delta = t - tv->last_cycles;
>>  			tv->last_cycles = t;
>> +		}
>>
>>  		usecs = t / cycles_per_usec;
>> -		tp->tv_sec = usecs / 1000000;
>> +		if (delta && delta < 1000000)
>> +			tp->tv_sec = tv->last_tv.tv_sec;
>> +		else
>> +			tp->tv_sec = usecs / 1000000;
>>  		tp->tv_usec = usecs % 1000000;
>>  		break;
>>  		}
> 
> I was thinking about this... Is it actually guarenteed to work. If
> tv->last_tv.tv_usec is eg 900,000, you'd only need a 100k usec diff to
> need to wrap, not 1000k. And since this is about avoiding costly divs,
> since we know the number of cycles last time, it might make more sense
> to just do the single div to go from cycles to usecs, then add that to
> the tv->last_tv.
> 



Something like this might work, though that amount of logic may
be equivalent in terms of cycles to the divide.

diff --git a/gettime.c b/gettime.c
index 035d275..955a0a1 100644
--- a/gettime.c
+++ b/gettime.c
@@ -168,18 +168,25 @@ void fio_gettime(struct timeval *tp, void
fio_unused *caller)
 		}
 #ifdef ARCH_HAVE_CPU_CLOCK
 	case CS_CPUCLOCK: {
-		unsigned long long usecs, t;
+		unsigned long long usecs, t, delta = 0;

 		t = get_cpu_clock();
 		if (tv && t < tv->last_cycles) {
 			dprint(FD_TIME, "CPU clock going back in time\n");
 			t = tv->last_cycles;
-		} else if (tv)
+		} else if (tv) {
+			if (tv->last_tv_valid)
+				delta = t - tv->last_cycles;
 			tv->last_cycles = t;
+		}

 		usecs = t / cycles_per_usec;
-		tp->tv_sec = usecs / 1000000;
 		tp->tv_usec = usecs % 1000000;
+		if (delta && delta < 1000000 &&
+			tv->last_tv.tv_usec < tp->tv_usec)
+			tp->tv_sec = tv->last_tv.tv_sec;
+		else
+			tp->tv_sec = usecs / 1000000;
 		break;
 		}
 #endif



