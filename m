Return-Path: <akashv@google.com>
MIME-Version: 1.0
In-Reply-To: <564F798A.8050009@kernel.dk>
References: <CADp+U7ibiKciX8_cpzGzob4oL-UF-H+W7kYuiujovD0ba=hM6A@mail.gmail.com>
 <56464ACC.9030605@kernel.dk> <CADp+U7gHq5VJgRFzGXvHTKN8Tyz9NDUZGePDWQ548ciyJmGr7A@mail.gmail.com>
 <56465F00.1060504@kernel.dk> <CADp+U7i=OPhuF9+nB1MW0ScaPv5sX3mL4ASdJ-8AGrDMfX71oA@mail.gmail.com>
 <CAFXh1QgZNghYY9CKJY5BZA4=ARGzXWYVHBBpHxV724qu2Wd5Hw@mail.gmail.com> <564F798A.8050009@kernel.dk>
From: Akash Verma <akashv@google.com>
Date: Fri, 20 Nov 2015 14:20:13 -0800
Message-ID: <CAFFT=UnmqonF2LSb9HNoiBQXeuWTA+La=B-fp54miv_NnTjg3Q@mail.gmail.com>
Subject: Re: Running a separate fio process for each disk?
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Caio Villela <caio@google.com>, Allen Schade <aschade@google.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi Jens,
The issue is not seen with non-cpu clock sources, or when using a
single process (with individual threads, the only config I tried). We
only see the issue when using multiple processes and the cpu clock
source.

On Fri, Nov 20, 2015 at 11:50 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 11/20/2015 12:37 PM, Caio Villela wrote:
>>
>> Hello Allen and Jens,
>>
>> Sorry for the long output, this is just in case you want the details.
>> Here is a simple explanation for the problem. I want to run a 15 minute
>> random write, using 1 Meg requests, and measure throughput and latency.
>> What seems to be the problem is that if the test system has a large
>> number of drives - the system that I am testing here has 28 drives -
>> then the time accounting seems to go bad for some of the processes.
>> What you see below is that during the 15 minutes from start, all disks
>> are getting hit the same, as they should. Then, after 15 minutes, there
>> are 15 drives that are still running.... after 5 minutes over the
>> specified 15 minutes, there is still one drive running. Then looking at
>> the amount of IOs sent to each drive, the ones that ran on that excess
>> time have much more IOs. FIO still reports that all drives ran for 15
>> minutes, although some ran for more than 20 minutes.
>>
>> We will attempt to run a single process instead of 28 instances of FIO
>> to see if this goes away.
>
>
> Could you also check if adding clocksource=gettimeofday makes any
> difference? This sounds very odd.
>
> Assuming this was run with fio -git?
>
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

