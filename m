Return-Path: <lftan.linux@gmail.com>
MIME-Version: 1.0
In-Reply-To: <56EAD8E0.7080604@kernel.dk>
References: <CAFiDJ59S0zhHDNbbron+Q1X06kBZ2i24VXYzHrSbrr0ujAR74w@mail.gmail.com>
	<56E85B38.9010904@kernel.dk>
	<CAFiDJ58k7KMZKxqE0OpKq0ckdfoEthKrYyPH3DGvW+S577xG5Q@mail.gmail.com>
	<56E988DC.9050506@kernel.dk>
	<CAFiDJ59P-eGKHcrdWAdpR-aJf=oe43G67bGaSY-zPnK-r8P__Q@mail.gmail.com>
	<56EAD8E0.7080604@kernel.dk>
Date: Fri, 18 Mar 2016 15:09:32 +0800
Message-ID: <CAFiDJ5_kr-gesHe_ybaUnNaazMZZEg-B0Xhpvt6JFqJTYCgK_g@mail.gmail.com>
Subject: Re: fio with polling mode
From: Ley Foon Tan <lftan.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Fri, Mar 18, 2016 at 12:18 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 03/17/2016 02:39 AM, Ley Foon Tan wrote:
>>
>> On Thu, Mar 17, 2016 at 12:25 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 03/16/2016 04:18 AM, Ley Foon Tan wrote:
>>>>
>>>>
>>>> On Wed, Mar 16, 2016 at 2:58 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>>
>>>>>
>>>>> On 03/15/2016 04:20 AM, Ley Foon Tan wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> Hi
>>>>>>
>>>>>> In the kernel v4.4 above, we can use polling mode for the NVMe data
>>>>>> transfer with command below:
>>>>>>
>>>>>> echo 1 > /sys/block/nvme0n1/queue/io_poll
>>>>>>
>>>>>> We can see NVMe throughput increase with polling mode with dd command.
>>>>>> Can we run fio with polling mode as well? If yes, what are the correct
>>>>>> fio parameters/arguments should we use?
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> direct=1, and use one of the sync IO engines (psync would be a good
>>>>> one).
>>>>> And enable io_poll like you did above, then fio should be in polled
>>>>> mode.
>>>>>
>>>>> --
>>>>> Jens Axboe
>>>>
>>>>
>>>> Hi Jens
>>>>
>>>> I have tried fio with direct=1 and ioengine=psync. But the results
>>>> almost the same (low throughput). Below is example command for
>>>> sequential write.
>>>> With your experiences, any clue where is the bottleneck for low
>>>> throughput (based on fio output). Note, kernel v4.4 and ARM platform.
>>>
>>>
>>>
>>> Polled IO helps with latencies, which means that the effects are most
>>> pronounced on smaller block size IO. You are using 128K, which is pretty
>>> far
>>> outside the realm of "smaller block size".
>>>
>>> That said, you do seem to have a reduction in average latency with
>>> polling.
>>> But given the transfer size and time, percentage wise, it's not that
>>> huge.
>>>
>> Yes, you are right. We can see about 20% throughput gain with 4KB
>> block size. But, block size greater than 4KB doesn't have much
>> improvement.
>> Do you know any other fio or OS settings that can help on the NVMe
>> throughput? Tried set scheduler to NOOP mode doesn't help too.
>
>
> Polling isn't really going to help your throughput, it'll only do that if
> you are IOPS bound. If you are missing bandwidth, you probably need to look
> closer at why that is.
Yes, we are looking at this now.
Let me know if you know any part that will impact this.

BTW, thanks for your help!


Regards
Ley Foon

