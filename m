Return-Path: <axboe@kernel.dk>
Subject: Re: what is the sample logger doing when the buffer fills up?
References: <CAJ9yE1DPWmV0Hx_AAS5cKZR5qSFeqmqJVg7dgikQK=ZBje-e3A@mail.gmail.com>
 <20160707183605.GB8567@kernel.dk>
 <CAJ9yE1Ayvzkq5iNYCWEfhzunA7pLoJrS-YBb9TtBR3RM1xyWDg@mail.gmail.com>
 <BN3PR0401MB1457BF2D349098BBF7F579A2F73B0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <577ECD29.2090204@kernel.dk>
 <BN3PR0401MB1457786D4450A0AA7A6571D1F73B0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <577ECE94.2080105@kernel.dk>
 <CAF+0mvnTM6Rv3Vh1oOZd=9TQ1wVtWWrHMVkbKxdisufiYvZ0Zw@mail.gmail.com>
 <BN3PR0401MB1457463C7131E975F7ED0812F7370@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CAJ9yE1CkoXrkK2PowRkSyby6zbb+ngWFAD-AariWcp64FNTZNw@mail.gmail.com>
 <BN3PR0401MB145725E84C509D7F14BC2C2FF7080@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <BN3PR0401MB14573F44F190D9B11CCF836FF7080@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <805ada82-a3be-5b0f-226c-258d7e6f7711@kernel.dk>
Date: Wed, 20 Jul 2016 17:46:52 -0600
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB14573F44F190D9B11CCF836FF7080@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
To: Jeff Furlong <jeff.furlong@hgst.com>, Karl Cronburg <kcronbur@redhat.com>
Cc: Matthew Eaton <m.eaton82@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

I was suspicious that the drift fix would be something else. But at 
least that's another bug fixed.

The question is if we're waking up in the helper_thread at the right 
time, and not deciding to do anything for whatever reason (which would 
be a bug), or if we're not waking at all due to the math being wrong 
(which would be another bug). It has to be one of those.


On 07/20/2016 03:28 PM, Jeff Furlong wrote:
> Retrying the iops log output format (missing 3000 and 13000 is drifted):
>
> 1000, 299636, 0, 0
> 2000, 354388, 0, 0
> 4000, 337972, 0, 0
> 5000, 323825, 0, 0
> 6000, 337457, 0, 0
> 7000, 327775, 0, 0
> 8000, 361275, 0, 0
> 9000, 348060, 0, 0
> 10000, 340273, 0, 0
> 11000, 349127, 0, 0
> 12000, 329088, 0, 0
> 12999, 349604, 0, 0
> 14000, 322321, 0, 0
> 15000, 319467, 0, 0
>
> Regards,
> Jeff
>
> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of Jeff Furlong
> Sent: Wednesday, July 20, 2016 2:23 PM
> To: Karl Cronburg <kcronbur@redhat.com>
> Cc: Matthew Eaton <m.eaton82@gmail.com>; Jens Axboe <axboe@kernel.dk>; fio@vger.kernel.org
> Subject: RE: what is the sample logger doing when the buffer fills up?
>
> I still see some samples as dropped.
>
> # fio -version
> fio-2.12-23-gc165
>
> 1000, 299636, 0, 0
> 2000, 354388, 0, 0 --> missing 3000 below 4000, 337972, 0, 0 5000, 323825, 0, 0 6000, 337457, 0, 0 7000, 327775, 0, 0 8000, 361275, 0, 0 9000, 348060, 0, 0 10000, 340273, 0, 0 11000, 349127, 0, 0 12000, 329088, 0, 0 12999, 349604, 0, 0 --> mild clock drift 14000, 322321, 0, 0 15000, 319467, 0, 0
>
> Regards,
> Jeff
>
> -----Original Message-----
> From: Karl Cronburg [mailto:kcronbur@redhat.com]
> Sent: Wednesday, July 20, 2016 1:29 PM
> To: Jeff Furlong <jeff.furlong@hgst.com>
> Cc: Matthew Eaton <m.eaton82@gmail.com>; Jens Axboe <axboe@kernel.dk>; fio@vger.kernel.org
> Subject: Re: what is the sample logger doing when the buffer fills up?
>
> PR 211 is one possible solution: https://github.com/axboe/fio/pull/211
>
> The gaps in the IOPs logs are caused by drift in the value of avg_last forward in time, e.g. if there's a drift of 1 millisecond every time we output a sample and log_avg_msec=100, then every 100th IOP average gets a gap.
>
> On Mon, Jul 18, 2016 at 8:09 PM, Jeff Furlong <jeff.furlong@hgst.com> wrote:
>> I haven't been able to debug the issue all the way, but notice that the reported time logs around the missing entries are not perfect.  After time 5001us, the 6000us entry is missing.  After time 21001us, the 22000us entry is missing.
>>
>> On my workloads, I see time 11999us, but time 11000 is missing.  So the time logs go: 10000, 11999, 13000, 14000, etc.
>>
>> I suspect the issue to be in or near stat.c:
>>
>> static void add_log_sample(struct thread_data *td, struct io_log *iolog,
>>                            unsigned long val, enum fio_ddir ddir,
>>                            unsigned int bs, uint64_t offset) {
>>         unsigned long elapsed, this_window;
>>
>>         if (!ddir_rw(ddir))
>>                 return;
>>
>>         elapsed = mtime_since_now(&td->epoch);
>>
>>         /*
>>          * If no time averaging, just add the log sample.
>>          */
>>         if (!iolog->avg_msec) {
>>                 __add_log_sample(iolog, val, ddir, bs, elapsed, offset);
>>                 return;
>>         }
>>
>>         /*
>>          * Add the sample. If the time period has passed, then
>>          * add that entry to the log and clear.
>>          */
>>         add_stat_sample(&iolog->avg_window[ddir], val);
>>
>>         /*
>>          * If period hasn't passed, adding the above sample is all we
>>          * need to do.
>>          */
>>         this_window = elapsed - iolog->avg_last;
>>         if (this_window < iolog->avg_msec)
>>                 return;
>>
>>         _add_stat_to_log(iolog, elapsed, td->o.log_max != 0);
>>
>>         iolog->avg_last = elapsed;
>> }
>>
>> Regards,
>> Jeff
>>
>> -----Original Message-----
>> From: Matthew Eaton [mailto:m.eaton82@gmail.com]
>> Sent: Monday, July 18, 2016 11:24 AM
>> To: Jens Axboe <axboe@kernel.dk>
>> Cc: Jeff Furlong <jeff.furlong@hgst.com>; Karl Cronburg
>> <kcronbur@redhat.com>; fio@vger.kernel.org
>> Subject: Re: what is the sample logger doing when the buffer fills up?
>>
>> I am also seeing this bug but with numjobs = 1.
>>
>> fio --numjobs=1 --iodepth=32 --ramp_time=1800 --runtime=1810
>> --time_based --rw=randwrite --bs=4k --ioengine=libaio --direct=1
>> --refill_buffers --norandommap --randrepeat=0 --log_avg_msec=1000
>> --write_iops_log=write --name=write-iops --filename=/dev/sdb
>>
>> fio-2.12-12-g45213
>>
>> 3000, 23033, 1, 0
>> 4000, 23035, 1, 0
>> 5001, 25463, 1, 0 <<<
>> 7000, 24649, 1, 0 <<<
>> 8000, 27103, 1, 0
>> 9000, 23004, 1, 0
>> 10000, 23064, 1, 0
>> 11000, 26199, 1, 0
>> 12000, 23107, 1, 0
>> 13000, 28734, 1, 0
>> 14000, 23853, 1, 0
>> 15000, 28739, 1, 0
>> 16000, 27061, 1, 0
>> 17000, 25504, 1, 0
>> 18000, 29550, 1, 0
>> 19000, 23842, 1, 0
>> 20000, 23056, 1, 0
>> 21001, 23010, 1, 0 <<<
>> 23000, 24236, 1, 0 <<<
>> 24000, 23867, 1, 0
>> 25000, 25459, 1, 0
>>
>> On Thu, Jul 7, 2016 at 2:50 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>> On 07/07/2016 03:47 PM, Jeff Furlong wrote:
>>>>
>>>> There are more.  In a 60s test, logging every 1s, I see 6 to 7
>>>> samples get dropped.  But I only see it when numjobs > 1.
>>>
>>>
>>> OK, I'll take a look.
>>>
>>>
>>> --
>>> Jens Axboe
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe fio" in the
>>> body of a message to majordomo@vger.kernel.org More majordomo info at
>>> http://vger.kernel.org/majordomo-info.html
>> Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:
>>
>> This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.
> Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:
>
> This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.
>  {.n +       +%  lzwm  b 맲  r  y   {ay ʇڙ ,j   f   h   z  w       j:+v   w j m         zZ+     ݢj"  ! i
> Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:
>
> This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.
>

-- 
Jens Axboe


