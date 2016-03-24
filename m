Return-Path: <axboe@kernel.dk>
Subject: Re: Linux OS killed fio process because fio invoked oom_killer
References: <CADvrUP8gH3S-fLnHU4QXJLO87YzUge8MxKt3WdffN+9uiVpH3w@mail.gmail.com>
 <56F17326.3000908@kernel.dk>
 <CADvrUP9duNxzfMuQum-e_YXqVUjG_K8any52e7sQn6ZcBy9o8Q@mail.gmail.com>
 <61A20AC4-3F8E-4B1E-A2C9-81BE827B188F@kernel.dk>
 <CADvrUP-C-Sm_kGbQTNZRitVMi8ory4GrMNy7+oXFeE=fYRJnvQ@mail.gmail.com>
 <BN3PR0401MB145719A81EC72FA99E7BB8A3F7810@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CADvrUP-Lz4WSzx6H+0bWpRtF5rp+FFSq0Atso8uaar=mt08zHQ@mail.gmail.com>
 <BN3PR0401MB145727B4551C1144668618CDF7810@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CADvrUP-x8Ur+K1WvUuFBr8P9og4183CRYj7+ihhWNrb9iPU3NA@mail.gmail.com>
 <56F3F481.6050508@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56F44286.8000706@kernel.dk>
Date: Thu, 24 Mar 2016 13:39:50 -0600
MIME-Version: 1.0
In-Reply-To: <56F3F481.6050508@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: flash yan <flashyan83@gmail.com>, Jeff Furlong <jeff.furlong@hgst.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

I took a look, and it's a regression introduced by this change in 2012:

commit c04e4661e4da3b6079f415897e4507cf8e610c54
Author: Daniel Ehrenberg <dehrenberg@google.com>
Date:   Fri Mar 16 18:54:15 2012 +0100

     time_based: Avoid restarting main I/O loop

that patch tries to keep us in the main loop and reset while going, 
which is a good thing for short jobs as it keeps the overhead low. But 
it breaks verification for short jobs! I've checked in this fix:

http://git.kernel.dk/cgit/fio/commit/?id=f1a32461c844c7ba9314f66dd28b5a01ca7cb69a

Please try and see if that fixes things for you. You ran into OOM 
because you had async verify enabled, yet we never go to run it. So we 
just kept piling on buffers to verify, but we never did...


On 03/24/2016 08:06 AM, Jens Axboe wrote:
> I'll take a look at it. The device is only 128MB? Did you mean GB?
>
> What version of fio are you running?
>
> On 03/24/2016 06:50 AM, flash yan wrote:
>> Another thing is that older version fio don't have this issue.
>>
>> 2016-03-24 7:32 GMT+08:00 Jeff Furlong <jeff.furlong@hgst.com>:
>>> I believe only the CRC is buffered in DRAM.  So if your IO's size
>>> (bs=X) is large or small, the buffered CRC is the same size per IO.
>>> But, as you increase the bs, the IOPs decreases.  As you decrease the
>>> bs, the IOPs increases.  The total amount of buffered CRC's in DRAM
>>> increases with more IOPs (with a fixed runtime).  You can calculate
>>> out how many IO's times your CRC size will fit into DRAM, then set
>>> your verify_backlog value to be less than that.
>>>
>>> Regards,
>>> Jeff
>>>
>>> -----Original Message-----
>>> From: flash yan [mailto:flashyan83@gmail.com]
>>> Sent: Wednesday, March 23, 2016 3:52 PM
>>> To: Jeff Furlong <jeff.furlong@hgst.com>
>>> Cc: Jens Axboe <axboe@kernel.dk>; fio@vger.kernel.org
>>> Subject: Re: Linux OS killed fio process because fio invoked oom_killer
>>>
>>> I will try verify_backlog option.
>>> I have a question. Why it happened with io_size to 4096 not other
>>> io_size? Other io_size should have same problem.
>>>
>>> 2016-03-24 3:29 GMT+08:00 Jeff Furlong <jeff.furlong@hgst.com>:
>>>> I believe you are seeing expected behavior.  When verify is enabled,
>>>> the written data is buffered in DRAM until the job is finished, then
>>>> compared by reading data from the device.  If the device capacity is
>>>> large, or if the device capacity is small but you set the runtime,
>>>> you will buffer many IO's.  So the oom_killer sees the process as
>>>> hogging most of the DRAM, then kills it.  When verify is disabled,
>>>> no buffering takes place, so no oom_killer.
>>>>
>>>> Try the verify_backlog option.  If you have a 4KB bs, and you set
>>>> verify_backlog=1048576, then you'll write out 4GB of data, then read
>>>> it back and compare with the DRAM buffer, then start again.  Just be
>>>> sure the verify_backlog value is less than your free DRAM.
>>>>
>>>> Regards,
>>>> Jeff
>>>>
>>>>
>>>> -----Original Message-----
>>>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
>>>> Behalf Of flash yan
>>>> Sent: Wednesday, March 23, 2016 8:10 AM
>>>> To: Jens Axboe <axboe@kernel.dk>
>>>> Cc: fio@vger.kernel.org
>>>> Subject: Re: Linux OS killed fio process because fio invoked
>>>> oom_killer
>>>>
>>>> I have run fio without verify and this issue didn't happen. So it
>>>> should be verify issue.
>>>> The fio job file is as below:
>>>>
>>>> [global]
>>>> thread=1
>>>> invalidate=1
>>>> rw=randwrite
>>>> time_based=1
>>>> runtime=3000
>>>> rwmixread=50
>>>> ioengine=libaio
>>>> direct=1
>>>> bs=4096
>>>> iodepth=16
>>>> verify_dump=1
>>>> verify_async=10
>>>> do_verify=1
>>>> verify=meta
>>>> verify_pattern="meta"
>>>> [job0]
>>>> filename=/dev/sda
>>>> [job1]
>>>> filename=/dev/sdb
>>>>
>>>> I think you can use ram disk(ubuntu have ram disk /dev/ram*) to
>>>> reproduce this issue.
>>>> It happened with devices which have high speed.
>>>>
>>>> 2016-03-23 8:42 GMT+08:00 Jens Axboe <axboe@kernel.dk>:
>>>>> What job did you run? When reporting a potential issue, always
>>>>> include that. Hard to help or advise otherwise.
>>>>>
>>>>>> On Mar 22, 2016, at 5:12 PM, flash yan <flashyan83@gmail.com> wrote:
>>>>>>
>>>>>> This issue happened after about 20 minutes. The iscsi device is very
>>>>>> small, only 128MB.
>>>>>> As you said, I have enabled verify= options.
>>>>>> I will try big iscsi device and no verify.
>>>>>>
>>>>>> Thanks
>>>>>>
>>>>>> Liang Yan
>>>>>>
>>>>>> 2016-03-23 0:30 GMT+08:00 Jens Axboe <axboe@kernel.dk>:
>>>>>>>> On 03/22/2016 08:06 AM, flash yan wrote:
>>>>>>>>
>>>>>>>> Hi all,
>>>>>>>>
>>>>>>>> I have run fio-2.7 to test iscsi device, one unusual issue
>>>>>>>> happened.
>>>>>>>> If I set the io_size to 4096, queue_depth to 16 ,rw to randwrite
>>>>>>>> and run_time to 3000, the fio would invoke oom_killer and the
>>>>>>>> Linux OS would kill the fio process.
>>>>>>>> The machine have about 11 GB memory and I have tried the machine
>>>>>>>> with 23GB, the issue also happened.
>>>>>>>> I think fio have problem when dealing with 4KB io_size then used
>>>>>>>> too many memory.
>>>>>>>
>>>>>>>
>>>>>>> When did this happen - shortly after the job is started, or long
>>>>>>> after? How big is the iscsi device? Did you have verify= options
>>>>>>> enabled?
>>>>>>>
>>>>>>> --
>>>>>>> Jens Axboe
>>>>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe fio" in the
>>>> body of a message to majordomo@vger.kernel.org More majordomo info at
>>>> http://vger.kernel.org/majordomo-info.html
>>>> Western Digital Corporation (and its subsidiaries) E-mail
>>>> Confidentiality Notice & Disclaimer:
>>>>
>>>> This e-mail and any files transmitted with it may contain
>>>> confidential or legally privileged information of WDC and/or its
>>>> affiliates, and are intended solely for the use of the individual or
>>>> entity to which they are addressed. If you are not the intended
>>>> recipient, any disclosure, copying, distribution or any action taken
>>>> or omitted to be taken in reliance on it, is prohibited. If you have
>>>> received this e-mail in error, please notify the sender immediately
>>>> and delete the e-mail in its entirety from your system.
>>> Western Digital Corporation (and its subsidiaries) E-mail
>>> Confidentiality Notice & Disclaimer:
>>>
>>> This e-mail and any files transmitted with it may contain
>>> confidential or legally privileged information of WDC and/or its
>>> affiliates, and are intended solely for the use of the individual or
>>> entity to which they are addressed. If you are not the intended
>>> recipient, any disclosure, copying, distribution or any action taken
>>> or omitted to be taken in reliance on it, is prohibited. If you have
>>> received this e-mail in error, please notify the sender immediately
>>> and delete the e-mail in its entirety from your system.
>
>


-- 
Jens Axboe


