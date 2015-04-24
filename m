Return-Path: <axboe@kernel.dk>
Message-ID: <553A5B92.2060009@kernel.dk>
Date: Fri, 24 Apr 2015 09:04:50 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Unable to replay blktrace with mixed workload
References: <CADAGN7VV15pQBpXVv=OptqZxjnz3-nkNHpXpotzCxeGUWDvFmA@mail.gmail.com>
In-Reply-To: <CADAGN7VV15pQBpXVv=OptqZxjnz3-nkNHpXpotzCxeGUWDvFmA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Brandon Schwartz <schwartz.xn@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 04/23/2015 01:55 PM, Brandon Schwartz wrote:
> Using FIO 2.2.7, I'm trying to replay the following workload
> (capturing it with blktrace and replaying with FIO on the same device)
>
>   sudo fio --name=rwmix --filename=/dev/sdd --blocksize=128k
> --readwrite=randrw --rwmixread=75 --rwmixwrite=25 --runtime=60
>
> And I get the following error:
>
> fio: pid=21428, err=12/file:memory.c:242, func=iomem allocation,
> error=Cannot allocate memory
>
> Older versions of FIO (2.1.*) seem to be able to replay the blktrace
> without that error, but those versions of FIO don't always seem to
> respect the timing of IOs (if there is idle time for example).
>
> Any idea what could be causing the problem?

There were a few bugs in there. Can you try current -git? Just committed 
a change that should improve things for you.

-- 
Jens Axboe


