Return-Path: <sectorsize512@gmail.com>
MIME-Version: 1.0
Sender: sectorsize512@gmail.com
In-Reply-To: <545E44C6.5060505@kernel.dk>
References: <20141105171024.GC25731@vass-desktop>
	<545E44C6.5060505@kernel.dk>
Date: Mon, 10 Nov 2014 09:19:11 -0500
Message-ID: <CAFTzLMNOYv+8uP2wiQOPcLjhZG9zoQiOCNn8_69dYV45Ex8aTQ@mail.gmail.com>
Subject: Re: Fix for a race when fio prints I/O statistics periodically
From: Vasily Tarasov <tarasov@vasily.name>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Michael Mattsson <michael.mattsson@gmail.com>
List-ID: <fio@vger.kernel.org>

Hi Jens,

td->start is used in  __show_running_run_stats() to compute the time
that passed since the beginning of the loop (stored in td->start) to
the moment when periodical statistics need to be printed. Then
td->ts.runtime[] is temporarily updated based on the computed value.

In thread_main(), similar actions are taken to update td->ts.runtime[]
based on the td->start and the loop's elapsed time. Without the patch,
td->start is set in the very beginning of the loop in thread_main().
So, it leaves a time window between the end of the current loop and
the beginning of the next loop when td->ts.runtime[] is already
updated while td->start still stores the start of the previous lop. If
__show_running_run_stats() is called during that window - the time can
be (temporarily) added twice to td->ts.runtime[].

However, if we reset the start time in the end of the loop under the
stat_mutex it should not happen.

I would agree that having a per-td mutex might be an overkill
considering that people usually print statistics periodically with
relatively long intervals: 1, 5, 10, 60 seconds.

Vasily

On Sat, Nov 8, 2014 at 11:28 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-11-05 10:10, Vasily Tarasov wrote:
>>
>> Below is the demonstration for the latest code in git:
>>
>> Job-file:
>>
>> [job]
>> filename=/dev/sda
>> rw=randread
>> blocksize=4096
>> direct=1
>> time_based=1
>> runtime=300
>> numjobs=16
>>
>> Command line:
>>
>> fio --output-format=json --status-interval=10  /tmp/job.file | tee
>> /tmp/fio.out
>>
>> After parsing json and printing per-job "read->runtime" and "read->iops"
>> in two
>> columns, one can see this:
>>
>> runtime iops
>> 9854 4762
>> 19861 4724
>> 29867 4711
>> 39873 4705
>> 49880 4701
>> 59886 4698
>> 69894 4696
>> 79900 4694
>> 89907 4693
>> 99913 4692
>> 109919 4692
>> 119926 4691
>> 129933 4691
>> 139940 4691
>> 149946 4691
>> 159953 4690
>> 169959 4690
>> 179966 4690
>> 189972 4690
>> 199978 4690
>> 209984 4690
>> 219990 4690
>> 229996 4690
>> 240002 4690
>> 250009 4690
>> 260015 4690
>> 270021 4690
>> 280027 4690
>> 290033 4690
>> 600043 2344 <--- You can see a spurious jump in runtime here
>> 300001 4690
>>
>> The problem is two-fold, IMHO:
>>
>> 1) td->ts.runtime[DDIR_READ/DDIR_WRITE/DDIR_TRIM] are set in microseconds
>>     instead of milliseconds in thread_main() function. The values are
>> later
>>     converted to milliseconds (after exiting from the loop in
>> thread_main()),
>>     but it is too late for the out-of-band access by the helper_thread
>>     (the one that prints periodic statistics).
>>
>> 2) The helper_thread in __show_running_run_stats() temporarily adds to
>>     td->ts.runtime[DDIR_READ/DDIR_WRITE/DDIR_TRIM]
>>     the time that has passed since the beginning of the loop (td->start).
>>     However, the same addition happens in thread_main() by the job
>>     thread and td->start is not reset atomically with this addition.
>>     As a result, the runtime can be added twice. (That's why in the output
>>     we see 600043, which is approximately twice larger than the
>>     previous reading).
>>
>> My proposal is to make the job threads updating both td->ts.runtime and
>> td->start atomically by using an already existing stat_mutex.
>> __show_running_run_stats() already takes this mutex where needed.
>>
>> A proposed patch is attached.
>
>
> Patch looks pretty good, probably not worth it to make this a per-td mutex
> instead. But why the extra setting of td->start?
>
> Michael, did you get a chance to test this?
>
> --
> Jens Axboe
>

