Return-Path: <axboe@kernel.dk>
Subject: Re: fio with polling mode
References: <CAFiDJ59S0zhHDNbbron+Q1X06kBZ2i24VXYzHrSbrr0ujAR74w@mail.gmail.com>
 <56E85B38.9010904@kernel.dk>
 <CAFiDJ58k7KMZKxqE0OpKq0ckdfoEthKrYyPH3DGvW+S577xG5Q@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56E988DC.9050506@kernel.dk>
Date: Wed, 16 Mar 2016 09:25:00 -0700
MIME-Version: 1.0
In-Reply-To: <CAFiDJ58k7KMZKxqE0OpKq0ckdfoEthKrYyPH3DGvW+S577xG5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ley Foon Tan <lftan.linux@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 03/16/2016 04:18 AM, Ley Foon Tan wrote:
> On Wed, Mar 16, 2016 at 2:58 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 03/15/2016 04:20 AM, Ley Foon Tan wrote:
>>>
>>> Hi
>>>
>>> In the kernel v4.4 above, we can use polling mode for the NVMe data
>>> transfer with command below:
>>>
>>> echo 1 > /sys/block/nvme0n1/queue/io_poll
>>>
>>> We can see NVMe throughput increase with polling mode with dd command.
>>> Can we run fio with polling mode as well? If yes, what are the correct
>>> fio parameters/arguments should we use?
>>
>>
>> direct=1, and use one of the sync IO engines (psync would be a good one). And enable io_poll like you did above, then fio should be in polled mode.
>>
>> --
>> Jens Axboe
> Hi Jens
>
> I have tried fio with direct=1 and ioengine=psync. But the results
> almost the same (low throughput). Below is example command for
> sequential write.
> With your experiences, any clue where is the bottleneck for low
> throughput (based on fio output). Note, kernel v4.4 and ARM platform.

Polled IO helps with latencies, which means that the effects are most 
pronounced on smaller block size IO. You are using 128K, which is pretty 
far outside the realm of "smaller block size".

That said, you do seem to have a reduction in average latency with 
polling. But given the transfer size and time, percentage wise, it's not 
that huge.

-- 
Jens Axboe


