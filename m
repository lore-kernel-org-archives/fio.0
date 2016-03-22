Return-Path: <flashyan83@gmail.com>
MIME-Version: 1.0
In-Reply-To: <56F17326.3000908@kernel.dk>
References: <CADvrUP8gH3S-fLnHU4QXJLO87YzUge8MxKt3WdffN+9uiVpH3w@mail.gmail.com>
	<56F17326.3000908@kernel.dk>
Date: Wed, 23 Mar 2016 07:12:40 +0800
Message-ID: <CADvrUP9duNxzfMuQum-e_YXqVUjG_K8any52e7sQn6ZcBy9o8Q@mail.gmail.com>
Subject: Re: Linux OS killed fio process because fio invoked oom_killer
From: flash yan <flashyan83@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

This issue happened after about 20 minutes. The iscsi device is very
small, only 128MB.
As you said, I have enabled verify= options.
I will try big iscsi device and no verify.

Thanks

Liang Yan

2016-03-23 0:30 GMT+08:00 Jens Axboe <axboe@kernel.dk>:
> On 03/22/2016 08:06 AM, flash yan wrote:
>>
>> Hi all,
>>
>> I have run fio-2.7 to test iscsi device, one unusual issue happened.
>> If I set the io_size to 4096, queue_depth to 16 ,rw to randwrite and
>> run_time to 3000,
>> the fio would invoke oom_killer and the Linux OS would kill the fio
>> process.
>> The machine have about 11 GB memory and I have tried the machine with
>> 23GB, the issue also happened.
>> I think fio have problem when dealing with 4KB io_size then used too
>> many memory.
>
>
> When did this happen - shortly after the job is started, or long after? How
> big is the iscsi device? Did you have verify= options enabled?
>
> --
> Jens Axboe
>

