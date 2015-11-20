Return-Path: <axboe@kernel.dk>
Subject: Re: Running a separate fio process for each disk?
References: <CADp+U7ibiKciX8_cpzGzob4oL-UF-H+W7kYuiujovD0ba=hM6A@mail.gmail.com>
 <56464ACC.9030605@kernel.dk>
 <CADp+U7gHq5VJgRFzGXvHTKN8Tyz9NDUZGePDWQ548ciyJmGr7A@mail.gmail.com>
 <56465F00.1060504@kernel.dk>
 <CADp+U7i=OPhuF9+nB1MW0ScaPv5sX3mL4ASdJ-8AGrDMfX71oA@mail.gmail.com>
 <CAFXh1QgZNghYY9CKJY5BZA4=ARGzXWYVHBBpHxV724qu2Wd5Hw@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <564F798A.8050009@kernel.dk>
Date: Fri, 20 Nov 2015 12:50:34 -0700
MIME-Version: 1.0
In-Reply-To: <CAFXh1QgZNghYY9CKJY5BZA4=ARGzXWYVHBBpHxV724qu2Wd5Hw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Caio Villela <caio@google.com>, Allen Schade <aschade@google.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 11/20/2015 12:37 PM, Caio Villela wrote:
> Hello Allen and Jens,
>
> Sorry for the long output, this is just in case you want the details.
> Here is a simple explanation for the problem. I want to run a 15 minute
> random write, using 1 Meg requests, and measure throughput and latency.
> What seems to be the problem is that if the test system has a large
> number of drives - the system that I am testing here has 28 drives -
> then the time accounting seems to go bad for some of the processes.
> What you see below is that during the 15 minutes from start, all disks
> are getting hit the same, as they should. Then, after 15 minutes, there
> are 15 drives that are still running.... after 5 minutes over the
> specified 15 minutes, there is still one drive running. Then looking at
> the amount of IOs sent to each drive, the ones that ran on that excess
> time have much more IOs. FIO still reports that all drives ran for 15
> minutes, although some ran for more than 20 minutes.
>
> We will attempt to run a single process instead of 28 instances of FIO
> to see if this goes away.

Could you also check if adding clocksource=gettimeofday makes any 
difference? This sounds very odd.

Assuming this was run with fio -git?

-- 
Jens Axboe


