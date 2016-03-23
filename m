Return-Path: <flashyan83@gmail.com>
MIME-Version: 1.0
In-Reply-To: <61A20AC4-3F8E-4B1E-A2C9-81BE827B188F@kernel.dk>
References: <CADvrUP8gH3S-fLnHU4QXJLO87YzUge8MxKt3WdffN+9uiVpH3w@mail.gmail.com>
	<56F17326.3000908@kernel.dk>
	<CADvrUP9duNxzfMuQum-e_YXqVUjG_K8any52e7sQn6ZcBy9o8Q@mail.gmail.com>
	<61A20AC4-3F8E-4B1E-A2C9-81BE827B188F@kernel.dk>
Date: Wed, 23 Mar 2016 23:10:10 +0800
Message-ID: <CADvrUP-C-Sm_kGbQTNZRitVMi8ory4GrMNy7+oXFeE=fYRJnvQ@mail.gmail.com>
Subject: Re: Linux OS killed fio process because fio invoked oom_killer
From: flash yan <flashyan83@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

I have run fio without verify and this issue didn't happen. So it
should be verify issue.
The fio job file is as below:

[global]
thread=1
invalidate=1
rw=randwrite
time_based=1
runtime=3000
rwmixread=50
ioengine=libaio
direct=1
bs=4096
iodepth=16
verify_dump=1
verify_async=10
do_verify=1
verify=meta
verify_pattern="meta"
[job0]
filename=/dev/sda
[job1]
filename=/dev/sdb

I think you can use ram disk(ubuntu have ram disk /dev/ram*) to
reproduce this issue.
It happened with devices which have high speed.

2016-03-23 8:42 GMT+08:00 Jens Axboe <axboe@kernel.dk>:
> What job did you run? When reporting a potential issue, always include that. Hard to help or advise otherwise.
>
>> On Mar 22, 2016, at 5:12 PM, flash yan <flashyan83@gmail.com> wrote:
>>
>> This issue happened after about 20 minutes. The iscsi device is very
>> small, only 128MB.
>> As you said, I have enabled verify= options.
>> I will try big iscsi device and no verify.
>>
>> Thanks
>>
>> Liang Yan
>>
>> 2016-03-23 0:30 GMT+08:00 Jens Axboe <axboe@kernel.dk>:
>>>> On 03/22/2016 08:06 AM, flash yan wrote:
>>>>
>>>> Hi all,
>>>>
>>>> I have run fio-2.7 to test iscsi device, one unusual issue happened.
>>>> If I set the io_size to 4096, queue_depth to 16 ,rw to randwrite and
>>>> run_time to 3000,
>>>> the fio would invoke oom_killer and the Linux OS would kill the fio
>>>> process.
>>>> The machine have about 11 GB memory and I have tried the machine with
>>>> 23GB, the issue also happened.
>>>> I think fio have problem when dealing with 4KB io_size then used too
>>>> many memory.
>>>
>>>
>>> When did this happen - shortly after the job is started, or long after? How
>>> big is the iscsi device? Did you have verify= options enabled?
>>>
>>> --
>>> Jens Axboe
>>>

