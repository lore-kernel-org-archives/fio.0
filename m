Return-Path: <jeff.furlong@hgst.com>
From: Jeff Furlong <jeff.furlong@hgst.com>
Subject: RE: fio signal 11
Date: Wed, 3 Aug 2016 15:02:05 +0000
Message-ID: <BN3PR0401MB14579C4C4CBA876602C121DCF7060@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <BN3PR0401MB1457415455A5B0CEFB84447DF75F0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CALjAwxhv8pCLJe0uT6PX1r7g4Mu=d8gA19VUFu0pUE9LkHTkrw@mail.gmail.com>
 <BN3PR0401MB145737C5D3670374BE0D29E5F7500@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <575CCF51.8020704@kernel.dk> <575CD738.1050505@kernel.dk>
 <20160615144502.GH1607@quack2.suse.cz> <5762500B.2040202@kernel.dk>
 <20160720050832.GA3918@quack2.suse.cz>
 <8683247d-429c-e639-78a5-912316ea9e21@kernel.dk>
 <20160726084307.GA6860@quack2.suse.cz>
 <2bd421b5-7d16-e948-e86f-da19f5ae297e@kernel.dk>
 <BN3PR0401MB145754C178C47051247B5B59F70E0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <a59fa122-2ed2-0194-f961-84566e3166da@kernel.dk>
 <BN3PR0401MB1457ADC13254E4C80473E489F7040@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <f9e632e7-849f-9e4e-0615-2feb18da358a@kernel.dk>
In-Reply-To: <f9e632e7-849f-9e4e-0615-2feb18da358a@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

# fio -version
fio-2.13-28-g059b6

# fio --name=3Dtest_job --ioengine=3Dlibaio --direct=3D1 --rw=3Drandread --=
iodepth=3D256 --size=3D100% --numjobs=3D4 --bs=3D4k --filename=3D/dev/nvme0=
n1 --group_reporting --write_bw_log=3Dtest_job --write_iops_log=3Dtest_job =
--write_lat_log=3Dtest_job --log_avg_msec=3D1000 --disable_lat=3D0 --disabl=
e_clat=3D0 --disable_slat=3D0 --runtime=3D10s --time_based --output=3Dtest_=
job --ramp_time=3D1s

# ls -l
-rw-r--r-- 1 root root     1748 Aug  3 07:57 test_job
-rw-r--r-- 1 root root      201 Aug  3 07:57 test_job_bw.1.log
-rw-r--r-- 1 root root      196 Aug  3 07:57 test_job_bw.2.log
-rw-r--r-- 1 root root      192 Aug  3 07:57 test_job_bw.3.log
-rw-r--r-- 1 root root      201 Aug  3 07:57 test_job_bw.4.log
-rw-r--r-- 1 root root      179 Aug  3 07:57 test_job_clat.1.log
-rw-r--r-- 1 root root      181 Aug  3 07:57 test_job_clat.2.log
-rw-r--r-- 1 root root      186 Aug  3 07:57 test_job_clat.3.log
-rw-r--r-- 1 root root      178 Aug  3 07:57 test_job_clat.4.log
-rw-r--r-- 1 root root      191 Aug  3 07:57 test_job_iops.1.log
-rw-r--r-- 1 root root      187 Aug  3 07:57 test_job_iops.2.log
-rw-r--r-- 1 root root      184 Aug  3 07:57 test_job_iops.3.log
-rw-r--r-- 1 root root      191 Aug  3 07:57 test_job_iops.4.log
-rw-r--r-- 1 root root      179 Aug  3 07:57 test_job_lat.1.log
-rw-r--r-- 1 root root      181 Aug  3 07:57 test_job_lat.2.log
-rw-r--r-- 1 root root      186 Aug  3 07:57 test_job_lat.3.log
-rw-r--r-- 1 root root      178 Aug  3 07:57 test_job_lat.4.log
-rw-r--r-- 1 root root 49597737 Aug  3 07:57 test_job_slat.1.log
-rw-r--r-- 1 root root 42065243 Aug  3 07:57 test_job_slat.2.log
-rw-r--r-- 1 root root 24407670 Aug  3 07:57 test_job_slat.3.log
-rw-r--r-- 1 root root 47090233 Aug  3 07:57 test_job_slat.4.log

Above we can see the slat log files are huge for a 10s runtime.  Not sure i=
f it's a factor of total runtime or IOs during that runtime.  I can also cr=
eate the issue when I reduce the runtime to 1s.

Regards,
Jeff

-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk] =

Sent: Wednesday, August 3, 2016 7:56 AM
To: Jeff Furlong <jeff.furlong@hgst.com>; Jan Kara <jack@suse.cz>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>; fio@vger.kernel.org
Subject: Re: fio signal 11

What version did you test? Works fine for me.


On 08/01/2016 03:57 PM, Jeff Furlong wrote:
> Sorry to open this item back up.  However, it appears when we add the ram=
p_time option, we break the logging.  Specifically, slat will log every ent=
ry, regardless of log_avg_msec.
>
> This example works as intended:
> # fio --name=3Dtest_job --ioengine=3Dlibaio --direct=3D1 --rw=3Drandread =

> --iodepth=3D256 --size=3D100% --numjobs=3D4 --bs=3D4k --filename=3D/dev/n=
vme0n1 =

> --group_reporting --write_bw_log=3Dtest_job --write_iops_log=3Dtest_job =

> --write_lat_log=3Dtest_job --log_avg_msec=3D1000 --disable_lat=3D0 =

> --disable_clat=3D0 --disable_slat=3D0 --runtime=3D10s --time_based =

> --output=3Dtest_job
>
> This example is the same, but adds a ramp_time, but the slat log is full =
of all entries:
> # fio --name=3Dtest_job --ioengine=3Dlibaio --direct=3D1 --rw=3Drandread =

> --iodepth=3D256 --size=3D100% --numjobs=3D4 --bs=3D4k --filename=3D/dev/n=
vme0n1 =

> --group_reporting --write_bw_log=3Dtest_job --write_iops_log=3Dtest_job =

> --write_lat_log=3Dtest_job --log_avg_msec=3D1000 --disable_lat=3D0 =

> --disable_clat=3D0 --disable_slat=3D0 --runtime=3D10s --time_based =

> --output=3Dtest_job --ramp_time=3D1s
>
> Regards,
> Jeff
>
> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Tuesday, July 26, 2016 11:35 AM
> To: Jeff Furlong <jeff.furlong@hgst.com>; Jan Kara <jack@suse.cz>
> Cc: Sitsofe Wheeler <sitsofe@gmail.com>; fio@vger.kernel.org
> Subject: Re: fio signal 11
>
> Perfect, thanks for testing!
>
>
> On 07/26/2016 12:33 PM, Jeff Furlong wrote:
>> FYI, with the patch back in version fio-2.13-1-gce8b, I re-ran my prior =
workload that caused the signal 11.  The workload now completes without iss=
ue.
>>
>> Regards,
>> Jeff
>>
>>
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On =

>> Behalf Of Jens Axboe
>> Sent: Tuesday, July 26, 2016 7:17 AM
>> To: Jan Kara <jack@suse.cz>
>> Cc: Jeff Furlong <jeff.furlong@hgst.com>; Sitsofe Wheeler =

>> <sitsofe@gmail.com>; fio@vger.kernel.org
>> Subject: Re: fio signal 11
>>
>> On 07/26/2016 02:43 AM, Jan Kara wrote:
>>> On Mon 25-07-16 09:21:00, Jens Axboe wrote:
>>>> On 07/19/2016 11:08 PM, Jan Kara wrote:
>>>>> On Thu 16-06-16 09:06:51, Jens Axboe wrote:
>>>>>> On 06/15/2016 04:45 PM, Jan Kara wrote:
>>>>>>> On Sat 11-06-16 21:30:00, Jens Axboe wrote:
>>>>>>>> On 06/11/2016 08:56 PM, Jens Axboe wrote:
>>>>>>>>> On 06/10/2016 12:42 PM, Jeff Furlong wrote:
>>>>>>>>>> Good point.  Here is the trace:
>>>>>>>>>>
>>>>>>>>>> [New LWP 59231]
>>>>>>>>>> [Thread debugging using libthread_db enabled] Using host =

>>>>>>>>>> libthread_db library "/lib64/libthread_db.so.1".
>>>>>>>>>> Core was generated by `fio --name=3Dtest_job --ioengine=3Dlibaio
>>>>>>>>>> --direct=3D1 --rw=3Dwrite --iodepth=3D32'.
>>>>>>>>>> Program terminated with signal 11, Segmentation fault.
>>>>>>>>>> #0  0x0000000000421e39 in regrow_log (iolog=3D0x7f828c0c5ad0) =

>>>>>>>>>> at
>>>>>>>>>> stat.c:1909
>>>>>>>>>> 1909        if (!cur_log) {
>>>>>>>>>>
>>>>>>>>>> (gdb) bt
>>>>>>>>>> #0  0x0000000000421e39 in regrow_log (iolog=3D0x7f828c0c5ad0) =

>>>>>>>>>> at
>>>>>>>>>> stat.c:1909
>>>>>>>>>> #1  0x000000000042d4df in regrow_logs
>>>>>>>>>> (td=3Dtd@entry=3D0x7f8277de0000) at
>>>>>>>>>> stat.c:1965
>>>>>>>>>> #2  0x000000000040ca90 in wait_for_completions =

>>>>>>>>>> (td=3Dtd@entry=3D0x7f8277de0000, time=3Dtime@entry=3D0x7fffcfb6b=
300) =

>>>>>>>>>> at
>>>>>>>>>> backend.c:446
>>>>>>>>>> #3  0x000000000045ade7 in do_io (bytes_done=3D<synthetic
>>>>>>>>>> pointer>,
>>>>>>>>>> td=3D0x7f8277de0000) at backend.c:991
>>>>>>>>>> #4  thread_main (data=3Ddata@entry=3D0x264d450) at backend.c:1667
>>>>>>>>>> #5  0x000000000045cfec in run_threads
>>>>>>>>>> (sk_out=3Dsk_out@entry=3D0x0) at
>>>>>>>>>> backend.c:2217
>>>>>>>>>> #6  0x000000000045d2cd in fio_backend
>>>>>>>>>> (sk_out=3Dsk_out@entry=3D0x0) at
>>>>>>>>>> backend.c:2349
>>>>>>>>>> #7  0x000000000040d09c in main (argc=3D22, argv=3D0x7fffcfb6f638=
, =

>>>>>>>>>> envp=3D<optimized out>) at fio.c:63
>>>>>>>>>
>>>>>>>>> That looks odd, thanks for reporting this. I'll see if I can =

>>>>>>>>> get to this on Monday, if not, it'll have to wait until after =

>>>>>>>>> my vacation... So while I appreciate people running -git and =

>>>>>>>>> finding issues like these before they show up in a release, =

>>>>>>>>> might be best to revert back to 2.2.11 until I can get this debug=
ged.
>>>>>>>>
>>>>>>>> I take that back - continue using -git! Just pull a fresh copy, =

>>>>>>>> should be fixed now.
>>>>>>>>
>>>>>>>> Jan, the reporter is right, 2.11 works and -git does not. So I =

>>>>>>>> just ran a quick bisect, changing the logging from every second =

>>>>>>>> to every 100ms to make it reproduce faster. I don't have time =

>>>>>>>> to look into why yet, so I just reverted the commit.
>>>>>>>>
>>>>>>>> commit d7982dd0ab2a1a315b5f9859c67a02414ce6274f
>>>>>>>> Author: Jan Kara <jack@suse.cz>
>>>>>>>> Date:   Tue May 24 17:03:21 2016 +0200
>>>>>>>>
>>>>>>>>    fio: Simplify forking of processes
>>>>>>>
>>>>>>> Hum, I've tried reproducing this but failed (I've tried using
>>>>>>> /dev/ram0 and
>>>>>>> /dev/sda4 as devices for fio). Is it somehow dependent on the =

>>>>>>> device fio works with? I have used commit
>>>>>>> 54d0a3150d44adca3ee4047fabd85651c6ea2db1 (just before you =

>>>>>>> reverted my
>>>>>>> patch) for testing.
>>>>>>
>>>>>> On vacation right now, I'll check when I get back. It is possible =

>>>>>> that it was just a fluke, since there was another bug there =

>>>>>> related to shared memory, but it was predictably crashing at the sam=
e time for the bisect.
>>>>>>
>>>>>> It doesn't make a lot of sense, however.
>>>>>
>>>>> Did you have a chance to look into this?
>>>>
>>>> I have not, unfortunately, but I'm suspecting the patch is fine and =

>>>> the later fix to allocate the cur_log out of the shared pool was =

>>>> the real fix and that the original patch was fine.
>>>
>>> So that's what I'd suspect as well but I'm not able to reproduce =

>>> even the original crash so I cannot verify this theory... What's the =

>>> plan going forward? Will you re-apply the patch? Frankly, I don't =

>>> care much, it was just a small cleanup. I'm just curious whether it =

>>> was really that other bug or whether I miss something.
>>
>> Yes, I think re-applying would be the best way forward. Especially since=
 that 2.13 was just released, so we'll have a while to iron out any issues.=
 But I really don't see how it could be the reason for the issue, I'm guess=
ing it just exacerbated it somehow.
>>
>> --
>> Jens Axboe
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in the =

>> body of a message to majordomo@vger.kernel.org More majordomo info at =

>> http://vger.kernel.org/majordomo-info.html
>> Western Digital Corporation (and its subsidiaries) E-mail Confidentialit=
y Notice & Disclaimer:
>>
>> This e-mail and any files transmitted with it may contain confidential o=
r legally privileged information of WDC and/or its affiliates, and are inte=
nded solely for the use of the individual or entity to which they are addre=
ssed. If you are not the intended recipient, any disclosure, copying, distr=
ibution or any action taken or omitted to be taken in reliance on it, is pr=
ohibited. If you have received this e-mail in error, please notify the send=
er immediately and delete the e-mail in its entirety from your system.
>>
>
>
> --
> Jens Axboe
>
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
>


--
Jens Axboe

Western Digital Corporation (and its subsidiaries) E-mail Confidentiality N=
otice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or l=
egally privileged information of WDC and/or its affiliates, and are intende=
d solely for the use of the individual or entity to which they are addresse=
d. If you are not the intended recipient, any disclosure, copying, distribu=
tion or any action taken or omitted to be taken in reliance on it, is prohi=
bited. If you have received this e-mail in error, please notify the sender =
immediately and delete the e-mail in its entirety from your system.


