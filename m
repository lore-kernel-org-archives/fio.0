Return-Path: <axboe@kernel.dk>
Message-ID: <5407CA4D.6030002@kernel.dk>
Date: Wed, 03 Sep 2014 20:11:25 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] fio: fix hangs due to iodepth_low
References: <20140904002343.24650.74664.stgit@beardog.cce.hp.com> <5407C19C.1030202@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402958C4C27B@G4W3202.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C4C27B@G4W3202.americas.hpqcorp.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>
List-ID: <fio@vger.kernel.org>

On 2014-09-03 20:08, Elliott, Robert (Server Storage) wrote:
>
>
>> -----Original Message-----
>> From: Jens Axboe [mailto:axboe@kernel.dk]
>> Sent: Wednesday, September 03, 2014 8:34 PM
>> To: Elliott, Robert (Server Storage); fio@vger.kernel.org;
>> scameron@beardog.cce.hp.com
>> Subject: Re: [PATCH] fio: fix hangs due to iodepth_low
>>
>> On 2014-09-03 18:23, Robert Elliott wrote:
>>> With some combinations of iodepth, iodepth_batch,
>> iodepth_batch_complete,
>>> and io_depth_low, do_io hangs after reaping the first set of
>> completions
>>> since io_u_queued_complete is called requesting more completions than
>>> td->cur_depth.
>>>
>>> Example printing min_evts and td->cur_depth in the do/while loop:
>>> waiting on min=96 cd=627
>>> waiting on min=96 cd=531
>>> waiting on min=96 cd=435
>>> waiting on min=96 cd=339
>>> waiting on min=96 cd=243
>>> waiting on min=96 cd=147
>>> waiting on min=96 cd=51
>>> Jobs: 12 (f=12): [r(12)] [43.8% done] [0KB/0KB/0KB /s] [0/0/0 iops]
>> [eta 00m:09s]
>>> ...
>>> Jobs: 12 (f=12): [r(12)] [0.0% done] [0KB/0KB/0KB /s] [0/0/0 iops]
>> [eta 2863d:18h:28m:38s]
>>> <fio never exits>
>>>
>>> Fix this by adjusting min_evts to the current_depth if that is
>> smaller.
>>>
>>> Tested with a jobfile including:
>>> iodepth=1011
>>> iodepth_batch=96
>>> iodepth_batch_complete=96
>>> iodepth_low=1
>>> runtime=15
>>> time_based
>>>
>>> Made the same change to do_verify, but not tested there.
>>>
>>> Signed-off-by: Robert Elliott <elliott@hp.com>
>>> ---
>>>    backend.c |    4 ++++
>>>    1 files changed, 4 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/backend.c b/backend.c
>>> index 7cb0a39..ce97f6d 100644
>>> --- a/backend.c
>>> +++ b/backend.c
>>> @@ -606,6 +606,8 @@ reap:
>>>    				 * and do the verification on them through
>>>    				 * the callback handler
>>>    				 */
>>> +				if (min_events < td->cur_depth)
>>> +					min_events = td->cur_depth;
>>
>> Did you reverse these? From the description and debug output, seems it
>> should be:
>>
>> 	if (min_events > td->cur_depth)
>> 		min_events = td->cur_depth;
>>
>> and we should probably put this logic in io_u_queued_complete(), I think
>> that would be a safer alternative instead of near the callers.
>>
>> --
>> Jens Axboe
>
> Sorry, yes - I didn't put it back right after adding code
> to inject the error.
>
> I will send an updated patch tomorrow putting the check into
> io_u_queued_complete (if that has access to td).

Thanks, much appreciated! The fix is the easy part, the diagnosing was 
the hard part.

-- 
Jens Axboe


