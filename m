Return-Path: <axboe@kernel.dk>
Subject: Re: Running a separate fio process for each disk?
References: <CADp+U7ibiKciX8_cpzGzob4oL-UF-H+W7kYuiujovD0ba=hM6A@mail.gmail.com>
 <56464ACC.9030605@kernel.dk>
 <CADp+U7gHq5VJgRFzGXvHTKN8Tyz9NDUZGePDWQ548ciyJmGr7A@mail.gmail.com>
 <56465F00.1060504@kernel.dk>
 <CADp+U7i=OPhuF9+nB1MW0ScaPv5sX3mL4ASdJ-8AGrDMfX71oA@mail.gmail.com>
 <CAFXh1QgZNghYY9CKJY5BZA4=ARGzXWYVHBBpHxV724qu2Wd5Hw@mail.gmail.com>
 <564F798A.8050009@kernel.dk>
 <CAFFT=UnmqonF2LSb9HNoiBQXeuWTA+La=B-fp54miv_NnTjg3Q@mail.gmail.com>
 <CAKb3OG9GfNrypxFPMMRR1W2QTi=Pnt0AXnFzzjDv4cJ9k0ZuVA@mail.gmail.com>
 <564FB905.7060609@kernel.dk> <5654876F.9080803@kernel.dk>
 <CAFFT=UnYcVN4s=eZ8Uj63VonEcuApfAQz1AoiOaVZqdrwgZLYw@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56550C49.4070700@kernel.dk>
Date: Tue, 24 Nov 2015 18:18:01 -0700
MIME-Version: 1.0
In-Reply-To: <CAFFT=UnYcVN4s=eZ8Uj63VonEcuApfAQz1AoiOaVZqdrwgZLYw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Akash Verma <akashv@google.com>, Michael Bella <mbella@google.com>
Cc: Caio Villela <caio@google.com>, Allen Schade <aschade@google.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

No worries, I know this week is a bit more problematic than usual. I'll 
hold off on the new release until I know.


On 11/24/2015 01:51 PM, Akash Verma wrote:
> Sorry for not getting back - I didn't get a chance to try the latest
> git, and I'm off on vacation soon; I'm ccing Michael and Caio who
> might have a chance to try it out before Thursday. Michael or Caio,
> could you try run the two things Jens asked (the cpuclock test using
> the FIO we've been currently using as well as the latest from Git; and
> the regular multi-process FIO run with the latest git)?
>
> On Tue, Nov 24, 2015 at 7:51 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> Did you try current -git yet? I think it should work for both scenarios.
>> It's a silly bug, would be great to have confirmation that it's fixed. Then
>> I'll spin a new release.
>>
>>
>>
>> On 11/20/2015 05:21 PM, Jens Axboe wrote:
>>>
>>> And finally, there's a potential fix, if you run commit
>>> 99afcdb53dc3 or later. So please do try that as well, and
>>> see if that behaves any better for you.
>>>
>>>
>>> On 11/20/2015 05:03 PM, Jens Axboe wrote:
>>>>
>>>> Hi,
>>>>
>>>> OK, I see. Can you pull the latest -git, and then run fio
>>>> --cpuclock-test on one of the boxes where you see the issue? It should
>>>> have commit 5896d827e1e2 or later.
>>>>
>>>>
>>>> On Fri, Nov 20, 2015 at 3:20 PM, Akash Verma <akashv@google.com
>>>> <mailto:akashv@google.com>> wrote:
>>>>
>>>>      Hi Jens,
>>>>      The issue is not seen with non-cpu clock sources, or when using a
>>>>      single process (with individual threads, the only config I tried). We
>>>>      only see the issue when using multiple processes and the cpu clock
>>>>      source.
>>>>
>>>>      On Fri, Nov 20, 2015 at 11:50 AM, Jens Axboe <axboe@kernel.dk
>>>>      <mailto:axboe@kernel.dk>> wrote:
>>>>       > On 11/20/2015 12:37 PM, Caio Villela wrote:
>>>>       >>
>>>>       >> Hello Allen and Jens,
>>>>       >>
>>>>       >> Sorry for the long output, this is just in case you want the
>>>>      details.
>>>>       >> Here is a simple explanation for the problem. I want to run a 15
>>>>      minute
>>>>       >> random write, using 1 Meg requests, and measure throughput and
>>>>      latency.
>>>>       >> What seems to be the problem is that if the test system has a
>>>> large
>>>>       >> number of drives - the system that I am testing here has 28
>>>> drives -
>>>>       >> then the time accounting seems to go bad for some of the
>>>> processes.
>>>>       >> What you see below is that during the 15 minutes from start, all
>>>>      disks
>>>>       >> are getting hit the same, as they should. Then, after 15
>>>>      minutes, there
>>>>       >> are 15 drives that are still running.... after 5 minutes over the
>>>>       >> specified 15 minutes, there is still one drive running. Then
>>>>      looking at
>>>>       >> the amount of IOs sent to each drive, the ones that ran on that
>>>>      excess
>>>>       >> time have much more IOs. FIO still reports that all drives ran
>>>>      for 15
>>>>       >> minutes, although some ran for more than 20 minutes.
>>>>       >>
>>>>       >> We will attempt to run a single process instead of 28 instances
>>>>      of FIO
>>>>       >> to see if this goes away.
>>>>       >
>>>>       >
>>>>       > Could you also check if adding clocksource=gettimeofday makes any
>>>>       > difference? This sounds very odd.
>>>>       >
>>>>       > Assuming this was run with fio -git?
>>>>       >
>>>>       >
>>>>       > --
>>>>       > Jens Axboe
>>>>       >
>>>>      > --
>>>>      > To unsubscribe from this list: send the line "unsubscribe fio" in
>>>>      > the body of a message tomajordomo@vger.kernel.org
>>>> <mailto:majordomo@vger.kernel.org>
>>>>      > More majordomo info athttp://vger.kernel.org/majordomo-info.html
>>>>
>>>>
>>>
>>>
>>
>>
>> --
>> Jens Axboe
>>


-- 
Jens Axboe


