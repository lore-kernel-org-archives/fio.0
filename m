Return-Path: <flashyan83@gmail.com>
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB145719A81EC72FA99E7BB8A3F7810@BN3PR0401MB1457.namprd04.prod.outlook.com>
References: <CADvrUP8gH3S-fLnHU4QXJLO87YzUge8MxKt3WdffN+9uiVpH3w@mail.gmail.com>
	<56F17326.3000908@kernel.dk>
	<CADvrUP9duNxzfMuQum-e_YXqVUjG_K8any52e7sQn6ZcBy9o8Q@mail.gmail.com>
	<61A20AC4-3F8E-4B1E-A2C9-81BE827B188F@kernel.dk>
	<CADvrUP-C-Sm_kGbQTNZRitVMi8ory4GrMNy7+oXFeE=fYRJnvQ@mail.gmail.com>
	<BN3PR0401MB145719A81EC72FA99E7BB8A3F7810@BN3PR0401MB1457.namprd04.prod.outlook.com>
Date: Thu, 24 Mar 2016 06:51:32 +0800
Message-ID: <CADvrUP-Lz4WSzx6H+0bWpRtF5rp+FFSq0Atso8uaar=mt08zHQ@mail.gmail.com>
Subject: Re: Linux OS killed fio process because fio invoked oom_killer
From: flash yan <flashyan83@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Jeff Furlong <jeff.furlong@hgst.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

I will try verify_backlog option.
I have a question. Why it happened with io_size to 4096 not other
io_size? Other io_size should have same problem.

2016-03-24 3:29 GMT+08:00 Jeff Furlong <jeff.furlong@hgst.com>:
> I believe you are seeing expected behavior.  When verify is enabled, the =
written data is buffered in DRAM until the job is finished, then compared b=
y reading data from the device.  If the device capacity is large, or if the=
 device capacity is small but you set the runtime, you will buffer many IO'=
s.  So the oom_killer sees the process as hogging most of the DRAM, then ki=
lls it.  When verify is disabled, no buffering takes place, so no oom_kille=
r.
>
> Try the verify_backlog option.  If you have a 4KB bs, and you set verify_=
backlog=3D1048576, then you'll write out 4GB of data, then read it back and=
 compare with the DRAM buffer, then start again.  Just be sure the verify_b=
acklog value is less than your free DRAM.
>
> Regards,
> Jeff
>
>
> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Beh=
alf Of flash yan
> Sent: Wednesday, March 23, 2016 8:10 AM
> To: Jens Axboe <axboe@kernel.dk>
> Cc: fio@vger.kernel.org
> Subject: Re: Linux OS killed fio process because fio invoked oom_killer
>
> I have run fio without verify and this issue didn't happen. So it should =
be verify issue.
> The fio job file is as below:
>
> [global]
> thread=3D1
> invalidate=3D1
> rw=3Drandwrite
> time_based=3D1
> runtime=3D3000
> rwmixread=3D50
> ioengine=3Dlibaio
> direct=3D1
> bs=3D4096
> iodepth=3D16
> verify_dump=3D1
> verify_async=3D10
> do_verify=3D1
> verify=3Dmeta
> verify_pattern=3D"meta"
> [job0]
> filename=3D/dev/sda
> [job1]
> filename=3D/dev/sdb
>
> I think you can use ram disk(ubuntu have ram disk /dev/ram*) to reproduce=
 this issue.
> It happened with devices which have high speed.
>
> 2016-03-23 8:42 GMT+08:00 Jens Axboe <axboe@kernel.dk>:
>> What job did you run? When reporting a potential issue, always include t=
hat. Hard to help or advise otherwise.
>>
>>> On Mar 22, 2016, at 5:12 PM, flash yan <flashyan83@gmail.com> wrote:
>>>
>>> This issue happened after about 20 minutes. The iscsi device is very
>>> small, only 128MB.
>>> As you said, I have enabled verify=3D options.
>>> I will try big iscsi device and no verify.
>>>
>>> Thanks
>>>
>>> Liang Yan
>>>
>>> 2016-03-23 0:30 GMT+08:00 Jens Axboe <axboe@kernel.dk>:
>>>>> On 03/22/2016 08:06 AM, flash yan wrote:
>>>>>
>>>>> Hi all,
>>>>>
>>>>> I have run fio-2.7 to test iscsi device, one unusual issue happened.
>>>>> If I set the io_size to 4096, queue_depth to 16 ,rw to randwrite
>>>>> and run_time to 3000, the fio would invoke oom_killer and the Linux
>>>>> OS would kill the fio process.
>>>>> The machine have about 11 GB memory and I have tried the machine
>>>>> with 23GB, the issue also happened.
>>>>> I think fio have problem when dealing with 4KB io_size then used
>>>>> too many memory.
>>>>
>>>>
>>>> When did this happen - shortly after the job is started, or long
>>>> after? How big is the iscsi device? Did you have verify=3D options ena=
bled?
>>>>
>>>> --
>>>> Jens Axboe
>>>>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in the bod=
y of a message to majordomo@vger.kernel.org More majordomo info at  http://=
vger.kernel.org/majordomo-info.html
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

