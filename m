Return-Path: <axboe@kernel.dk>
Message-ID: <548F9E4B.2010103@kernel.dk>
Date: Mon, 15 Dec 2014 19:51:55 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio main thread got stuck over the weekend
References: <20140811154423.GE7486@beardog.cce.hp.com> <20140811160418.GG7486@beardog.cce.hp.com> <53F79442.6010500@kernel.dk> <20140822190924.GQ19666@beardog.cce.hp.com> <53F795E0.3090806@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B40295940B8A0@G4W3202.americas.hpqcorp.net> <548BC55F.9020706@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B40295940EEC5@G4W3202.americas.hpqcorp.net> <548F1C65.2070501@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B40295940F1BF@G4W3202.americas.hpqcorp.net> <548F40A8.3010405@kernel.dk> <548F452D.7040401@kernel.dk> <548F495F.7090200@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B40295940F830@G4W3202.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295940F830@G4W3202.americas.hpqcorp.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "stephenmcameron@gmail.com" <stephenmcameron@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/15/2014 05:52 PM, Elliott, Robert (Server Storage) wrote:
>
>
>> -----Original Message-----
>> From: Jens Axboe [mailto:axboe@kernel.dk]
>> Sent: Monday, 15 December, 2014 2:50 PM
>> To: Elliott, Robert (Server Storage); stephenmcameron@gmail.com
>> Cc: fio@vger.kernel.org
>> Subject: Re: fio main thread got stuck over the weekend
>>
>> On 12/15/2014 01:31 PM, Jens Axboe wrote:
>>> On 12/15/2014 01:12 PM, Jens Axboe wrote:
>>>>> (gdb) thread 212
>>>>> [Switching to thread 212 (Thread 0x7fa9a086e700 (LWP 6509))]#0
>> 0x0000003974c0b98e in pthread_cond_timedwait@@GLIBC_2.3.2 () from
>> /lib64/libpthread.so.0
>>>>> (gdb) bt
>>>>> #0  0x0000003974c0b98e in pthread_cond_timedwait@@GLIBC_2.3.2 () from
>> /lib64/libpthread.so.0
>>>>> #1  0x0000000000449381 in helper_thread_main (data=<value optimized
>> out>) at backend.c:2127
>>>>> #2  0x0000003974c079d1 in start_thread () from /lib64/libpthread.so.0
>>>>> #3  0x00000039748e8b7d in clone () from /lib64/libc.so.6
>>>>> (gdb) select-frame 1
>>>>> (gdb) info local
>>>>> ts = {tv_sec = 1418658662, tv_nsec = 980074000}
>>>>> tv = {tv_sec = 1418658662, tv_usec = 730074}
>>>>> ret = <value optimized out>
>>>>> (gdb) print helper_exit
>>>>> $36 = 0
>>>>> (gdb) print nr_thread
>>>>> $37 = 224
>>>>> (gdb) print nr_process
>>>>> $38 = 0
>>>>
>>>> This is the helper thread, this is what will output the ETA etc stats.
>>>> There's a signal handler that runs and sets/wakes it to do so. So it
>>>> would be interesting if you could see what it is up to, set a break
>>>> point in there and check what the control flow ends up being.
>>>>
>>>> It's backend.c:helper_thread_main()
>>>>
>>>> backend.c:sig_show_status() should repeatedly fire and end up waking
>>>> this thread.
>>>
>>> So that referred to the output status, your bug was on the ETA, correct?
>
> Yes, the first anomaly was no ETAs incrementing, while IO was still
> occurring.
>
> The second anomaly was running forever.

Gotcha

>>> For that, we never get woken up by someone signaling our condvar, we
>>> just wake up every second to do the ETA display. The time conversion
>>> looks wrong, though:
>>>
>>> gettimeofday(&tv, NULL);
>>> ts.tv_sec = tv.tv_sec + sec;
>>> ts.tv_nsec = (tv.tv_usec * 1000) + nsec;
>>> if (ts.tv_nsec > 1000000000ULL) {
>>> 	ts.tv_nsec -= 1000000000ULL;
>>> 	ts.tv_sec++;
>>> }
>>>
>>> I wonder what happens if ts.tv_nsec == 10^6, that check really should be
>>> on >= instead. Not sure if this explains it though, I'll conjure up a
>>> test case...
>>
>> On my system, pthread_cond_timedwait() returns EINVAL if nsec is 10^9 or
>> higher, which is the sane thing to do. I wonder if it does that at your
>> end too, or whether it hangs? If it hangs indefinitely, that could
>> explain it. Test case attached, I checked in a fix for the off-by-one.
>
> That program results in EINVAL here:
> will wait
> done wait 22

OK, which is the sane way to handle it, but who knows what bugs there 
might have been there.

> In backend.c helper_thread_main():
> * should the gettimeofday() return value be checked?

Should not really fail, since we know 'tv' is valid.

> * should fio_gettime() be used instead of gettimeofday() to honor
> the clocksource setting?

That would be the case if we used it internally, but we do not. It's 
only used for passing to the condvar timedwait.

> In this pool of machines, I have occasionally seen time issues where
> some timeserver communication is messed up and "make" complains that
> files are newer than expected.  Maybe some time warp occurred during
> the test?

That could definitely explain it, not sure what else could. That could 
cause both the run to continue, and the timedwait to not return. I'll 
switch it to use clock_gettime, if we have it, otherwise we really have 
no other option than to use gettimeofday()...

-- 
Jens Axboe


