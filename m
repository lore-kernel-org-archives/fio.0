Return-Path: <kcronbur@redhat.com>
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB1457463C7131E975F7ED0812F7370@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <CAJ9yE1DPWmV0Hx_AAS5cKZR5qSFeqmqJVg7dgikQK=ZBje-e3A@mail.gmail.com>
 <20160707183605.GB8567@kernel.dk> <CAJ9yE1Ayvzkq5iNYCWEfhzunA7pLoJrS-YBb9TtBR3RM1xyWDg@mail.gmail.com>
 <BN3PR0401MB1457BF2D349098BBF7F579A2F73B0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <577ECD29.2090204@kernel.dk> <BN3PR0401MB1457786D4450A0AA7A6571D1F73B0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <577ECE94.2080105@kernel.dk> <CAF+0mvnTM6Rv3Vh1oOZd=9TQ1wVtWWrHMVkbKxdisufiYvZ0Zw@mail.gmail.com>
 <BN3PR0401MB1457463C7131E975F7ED0812F7370@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Karl Cronburg <kcronbur@redhat.com>
Date: Wed, 20 Jul 2016 16:29:00 -0400
Message-ID: <CAJ9yE1CkoXrkK2PowRkSyby6zbb+ngWFAD-AariWcp64FNTZNw@mail.gmail.com>
Subject: Re: what is the sample logger doing when the buffer fills up?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Jeff Furlong <jeff.furlong@hgst.com>
Cc: Matthew Eaton <m.eaton82@gmail.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

PR 211 is one possible solution: https://github.com/axboe/fio/pull/211

The gaps in the IOPs logs are caused by drift in the value of avg_last
forward in time, e.g. if there's a drift of 1 millisecond every time
we output a sample and log_avg_msec=3D100, then every 100th IOP average
gets a gap.

On Mon, Jul 18, 2016 at 8:09 PM, Jeff Furlong <jeff.furlong@hgst.com> wrote=
:
> I haven't been able to debug the issue all the way, but notice that the r=
eported time logs around the missing entries are not perfect.  After time 5=
001us, the 6000us entry is missing.  After time 21001us, the 22000us entry =
is missing.
>
> On my workloads, I see time 11999us, but time 11000 is missing.  So the t=
ime logs go: 10000, 11999, 13000, 14000, etc.
>
> I suspect the issue to be in or near stat.c:
>
> static void add_log_sample(struct thread_data *td, struct io_log *iolog,
>                            unsigned long val, enum fio_ddir ddir,
>                            unsigned int bs, uint64_t offset)
> {
>         unsigned long elapsed, this_window;
>
>         if (!ddir_rw(ddir))
>                 return;
>
>         elapsed =3D mtime_since_now(&td->epoch);
>
>         /*
>          * If no time averaging, just add the log sample.
>          */
>         if (!iolog->avg_msec) {
>                 __add_log_sample(iolog, val, ddir, bs, elapsed, offset);
>                 return;
>         }
>
>         /*
>          * Add the sample. If the time period has passed, then
>          * add that entry to the log and clear.
>          */
>         add_stat_sample(&iolog->avg_window[ddir], val);
>
>         /*
>          * If period hasn't passed, adding the above sample is all we
>          * need to do.
>          */
>         this_window =3D elapsed - iolog->avg_last;
>         if (this_window < iolog->avg_msec)
>                 return;
>
>         _add_stat_to_log(iolog, elapsed, td->o.log_max !=3D 0);
>
>         iolog->avg_last =3D elapsed;
> }
>
> Regards,
> Jeff
>
> -----Original Message-----
> From: Matthew Eaton [mailto:m.eaton82@gmail.com]
> Sent: Monday, July 18, 2016 11:24 AM
> To: Jens Axboe <axboe@kernel.dk>
> Cc: Jeff Furlong <jeff.furlong@hgst.com>; Karl Cronburg <kcronbur@redhat.=
com>; fio@vger.kernel.org
> Subject: Re: what is the sample logger doing when the buffer fills up?
>
> I am also seeing this bug but with numjobs =3D 1.
>
> fio --numjobs=3D1 --iodepth=3D32 --ramp_time=3D1800 --runtime=3D1810 --ti=
me_based --rw=3Drandwrite --bs=3D4k --ioengine=3Dlibaio --direct=3D1 --refi=
ll_buffers --norandommap --randrepeat=3D0 --log_avg_msec=3D1000 --write_iop=
s_log=3Dwrite --name=3Dwrite-iops --filename=3D/dev/sdb
>
> fio-2.12-12-g45213
>
> 3000, 23033, 1, 0
> 4000, 23035, 1, 0
> 5001, 25463, 1, 0 <<<
> 7000, 24649, 1, 0 <<<
> 8000, 27103, 1, 0
> 9000, 23004, 1, 0
> 10000, 23064, 1, 0
> 11000, 26199, 1, 0
> 12000, 23107, 1, 0
> 13000, 28734, 1, 0
> 14000, 23853, 1, 0
> 15000, 28739, 1, 0
> 16000, 27061, 1, 0
> 17000, 25504, 1, 0
> 18000, 29550, 1, 0
> 19000, 23842, 1, 0
> 20000, 23056, 1, 0
> 21001, 23010, 1, 0 <<<
> 23000, 24236, 1, 0 <<<
> 24000, 23867, 1, 0
> 25000, 25459, 1, 0
>
> On Thu, Jul 7, 2016 at 2:50 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 07/07/2016 03:47 PM, Jeff Furlong wrote:
>>>
>>> There are more.  In a 60s test, logging every 1s, I see 6 to 7
>>> samples get dropped.  But I only see it when numjobs > 1.
>>
>>
>> OK, I'll take a look.
>>
>>
>> --
>> Jens Axboe
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in the
>> body of a message to majordomo@vger.kernel.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
> Western Digital Corporation (and its subsidiaries) E-mail Confidentiality=
 Notice & Disclaimer:
>
> This e-mail and any files transmitted with it may contain confidential or=
 legally privileged information of WDC and/or its affiliates, and are inten=
ded solely for the use of the individual or entity to which they are addres=
sed. If you are not the intended recipient, any disclosure, copying, distri=
bution or any action taken or omitted to be taken in reliance on it, is pro=
hibited. If you have received this e-mail in error, please notify the sende=
r immediately and delete the e-mail in its entirety from your system.

