Return-Path: <michael.mattsson@gmail.com>
MIME-Version: 1.0
In-Reply-To: <53BE5286.2060203@kernel.dk>
References: <CAE56cDuAUkhEnjMqCSWDcWrdwJrbffMcDG+FeCw6+7GN+jrWUg@mail.gmail.com>
 <53BE5286.2060203@kernel.dk>
From: Michael Mattsson <michael.mattsson@gmail.com>
Date: Thu, 10 Jul 2014 07:55:38 -0700
Message-ID: <CAE56cDvPKq31NrawN_KZF2+eDHiMY2A7azsx8z_DQfG1=-_cnw@mail.gmail.com>
Subject: Re: fio hangs with --status-interval
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hey,
Thanks for the patch. I got log output but I had two clients hanging
in the same way with the attached patch.

$ patch -p0 < stat.patch
patching file b/stat.c
patching file b/stat.h
Hunk #1 succeeded at 213 (offset -5 lines).

I was using --output <filename>

Worth mentioning here is that on the NFS server the output file is
written to is issuing a stat(1) on the above output file once per
second. Could it cause any prolems?

Thanks!
Michael


On Thu, Jul 10, 2014 at 1:44 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-07-10 00:56, Michael Mattsson wrote:
>>
>> Hey,
>> I've got 8 identical CentOS 6.5 clients that randomly keeps hanging
>> fio when using --status-interval. I've tried fio 2.1.4 and fio 2.1.10
>> they both behave the same. I've also tried piping the output to tee
>> instead of redirecting to a file. I also tried --output and specified
>> output file, still same problem. My fio command runs through its tests
>> flawlessly without --status-interval and exits cleanly every time.
>> There could be anywhere from 0 to 5 clients that gets affected.
>> Running strace on the process that seem hung yields the following
>> output:
>>
>> $ strace -p 31055
>> Process 31055 attached - interrupt to quit
>> futex(0x7f346ede802c, FUTEX_WAIT, 1, NULL
>
>
> Strange, it must be stuck on the stat mutex, but I don't immediately see why
> that would happen. Does the attached patch make any difference for you, both
> in getting rid of the hang but still producing output at the desired
> intervals?
>
> --
> Jens Axboe
>

