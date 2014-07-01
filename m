Return-Path: <agayev@gmail.com>
Return-Path: <agayev@gmail.com>
References: <87pphr7g5d.fsf@gmail.com> <53B1DBB8.4080901@kernel.dk> <87d2dqcak6.fsf@gmail.com> <53B1E257.5070405@kernel.dk> <53B2243F.4080901@kernel.dk>
From: Abutalib Aghayev <agayev@gmail.com>
Subject: Re: [PATCH] Log offsets of I/O operations
Date: Tue, 01 Jul 2014 03:51:48 -0400
In-reply-to: <53B2243F.4080901@kernel.dk>
Message-ID: <87a98t7bxo.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


On Mon, Jun 30 2014 at 23:00 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-06-30 16:19, Jens Axboe wrote:
>> On 2014-06-30 16:09, Abutalib Aghayev wrote:
>>>
>>> On Mon, Jun 30 2014 at 17:50 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 2014-06-29 11:43, Abutalib Aghayev wrote:
>>>>>
>>>>> This is a quick and dirty patch to log offsets of I/O operations as
>>>>> well.  It is useful if you would like to make offset vs latency plot
>>>>> for
>>>>> random I/O, which may not be interesting to many people, so feel
>>>>> free to
>>>>> ignore it.
>>>>
>>>> I can definitely see this being useful. But adding 8 bytes to every log
>>>> entry complicates things, as fio is already memory intensive there when
>>>> logging longer runs.
>>>>
>>>> I'd suggest having two logging types:
>>>>
>>>> struct io_sample {
>>>>             uint64_t time;
>>>>             uint64_t val;
>>>>             uint32_t ddir;
>>>>             uint32_t bs;
>>>>             uint64_t offset;
>>>
>>> I assume you didn't mean offset being here as well.
>>
>> Ah no, of course not.
>>
>>>> struct io_sample_offset {
>>>>             struct io_sample s;
>>>>             uint64_t offset;
>>>> };
>>>>
>>>> and using the right type for what you are logging. This means you'd need
>>>> an option to switch on the offset logging, and that you'd need to store
>>>> this in the iolog struct (whether to log offset or not) and use the
>>>> appropriate size for allocating and extending the log entries when
>>>> needed.
>>>>
>>>> Make sense?
>>>
>>> Yes, let me rework the patch.
>>
>> Thanks! Note that you also need to handle the client/server part.
>> Half-assed attempt attached, not tested at all. Still needs the client
>> part update.
>
> I finished off the client bit and committed it, it was just a few lines
> of change and it was done. Also added documentation, etc. So current
> -git should be complete.

Great, thank you!

