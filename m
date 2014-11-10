Return-Path: <axboe@kernel.dk>
Message-ID: <5460DAC3.8000000@kernel.dk>
Date: Mon, 10 Nov 2014 08:33:23 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Fix for a race when fio prints I/O statistics periodically
References: <20141105171024.GC25731@vass-desktop>	<545E44C6.5060505@kernel.dk> <CAFTzLMNOYv+8uP2wiQOPcLjhZG9zoQiOCNn8_69dYV45Ex8aTQ@mail.gmail.com>
In-Reply-To: <CAFTzLMNOYv+8uP2wiQOPcLjhZG9zoQiOCNn8_69dYV45Ex8aTQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Vasily Tarasov <tarasov@vasily.name>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Michael Mattsson <michael.mattsson@gmail.com>
List-ID: <fio@vger.kernel.org>

On 2014-11-10 07:19, Vasily Tarasov wrote:
> Hi Jens,
>
> td->start is used in  __show_running_run_stats() to compute the time
> that passed since the beginning of the loop (stored in td->start) to
> the moment when periodical statistics need to be printed. Then
> td->ts.runtime[] is temporarily updated based on the computed value.
>
> In thread_main(), similar actions are taken to update td->ts.runtime[]
> based on the td->start and the loop's elapsed time. Without the patch,
> td->start is set in the very beginning of the loop in thread_main().
> So, it leaves a time window between the end of the current loop and
> the beginning of the next loop when td->ts.runtime[] is already
> updated while td->start still stores the start of the previous lop. If
> __show_running_run_stats() is called during that window - the time can
> be (temporarily) added twice to td->ts.runtime[].
>
> However, if we reset the start time in the end of the loop under the
> stat_mutex it should not happen.
>
> I would agree that having a per-td mutex might be an overkill
> considering that people usually print statistics periodically with
> relatively long intervals: 1, 5, 10, 60 seconds.

Thanks, I missed the change in addition after IO was done, hence the 
question on ->start. I did commit the patch as-is yesterday, thanks!

-- 
Jens Axboe


