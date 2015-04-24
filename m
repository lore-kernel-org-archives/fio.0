Return-Path: <schwartz.xn@gmail.com>
MIME-Version: 1.0
In-Reply-To: <553A5B92.2060009@kernel.dk>
References: <CADAGN7VV15pQBpXVv=OptqZxjnz3-nkNHpXpotzCxeGUWDvFmA@mail.gmail.com>
 <553A5B92.2060009@kernel.dk>
From: Brandon Schwartz <schwartz.xn@gmail.com>
Date: Fri, 24 Apr 2015 12:14:07 -0600
Message-ID: <CADAGN7W9ehVwBoLdUEQ1bg=wahsw2XTbQBVAqpyyWnALbR5RaQ@mail.gmail.com>
Subject: Re: Unable to replay blktrace with mixed workload
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Thanks, but now it seems to convert the blktrace replay into all reads
and increase the run time to 20minutes (from 60seconds).

fio-2.2.7-24-g7c30 is the latest right?



On Fri, Apr 24, 2015 at 9:04 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 04/23/2015 01:55 PM, Brandon Schwartz wrote:
>>
>> Using FIO 2.2.7, I'm trying to replay the following workload
>> (capturing it with blktrace and replaying with FIO on the same device)
>>
>>   sudo fio --name=rwmix --filename=/dev/sdd --blocksize=128k
>> --readwrite=randrw --rwmixread=75 --rwmixwrite=25 --runtime=60
>>
>> And I get the following error:
>>
>> fio: pid=21428, err=12/file:memory.c:242, func=iomem allocation,
>> error=Cannot allocate memory
>>
>> Older versions of FIO (2.1.*) seem to be able to replay the blktrace
>> without that error, but those versions of FIO don't always seem to
>> respect the timing of IOs (if there is idle time for example).
>>
>> Any idea what could be causing the problem?
>
>
> There were a few bugs in there. Can you try current -git? Just committed a
> change that should improve things for you.
>
> --
> Jens Axboe
>

