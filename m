Return-Path: <axboe@kernel.dk>
Subject: Re: Unlink after each loop in job
References: <CAG6KGPRQf7Mii35T1drhL=u0mZB8PQEeOMnmuBFWSNgBy4E31A@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <48aea5d8-12a5-58ca-9008-913e13bc7a8d@kernel.dk>
Date: Wed, 3 Aug 2016 08:38:48 -0700
MIME-Version: 1.0
In-Reply-To: <CAG6KGPRQf7Mii35T1drhL=u0mZB8PQEeOMnmuBFWSNgBy4E31A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Martin Dev <mrturtledev@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 08/02/2016 11:21 PM, Martin Dev wrote:
> I'm after the following data pattern from a job, which is 1 out of 4
> jobs run at the same time:
>
> Targeted at the filesystem level
> Write Xgb of verifiable data to file
> Verify file
> Delete file
> Loop
>
> The idea is we want to test trim at the file system level, whilst also
> having 3 other jobs that perform different workloads.
>
> Unlink=1 will only trigger after all loops of a job are complete
> exec_post_run will only trigger after all loops of a job are complete

Correct.

> I have implemented the functionality I'm after, by adding a
> unlink_each_loop paremeter to options.c, and in backend.c under the
> while(keep_running) I've added an unlink() to both the if block
> checking verify is false (before the loop continue) and after the
> verification, if the flag is set.
>
> The problem is, I'm not a C programmer (in the slightest), and I don't
> know FIO at all well. My code probably does not live up to the
> standard, or understand the internals of FIO well enough to handle
> errors in the correct way etc.

Don't worry about that! You've already done way more than most people
that would like changes to be made, or features to be added. Send out
what you have, and we can help you drive it to completion.

> So I guess I have 2 questions,
>
> 1) Have I missed something which already does what I need (delete file
> on each loop of a write job)

I don't think we currently have it.

> 2) How can I get someone who actually knows what they're doing to
> implement this feature :)

See above :-)

-- 
Jens Axboe


