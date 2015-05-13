Return-Path: <axboe@kernel.dk>
Message-ID: <555369BA.4040101@kernel.dk>
Date: Wed, 13 May 2015 11:11:54 -0400
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: --thinktime seems not work
References: <CAD09ZYSOkoXdHmYPfiF+pQReU1U+UHKfPL=52p818wikTtJDEw@mail.gmail.com>	<555360BE.6010303@kernel.dk> <CAD09ZYR6FG7tbSYjXXjKj14ocJNijm=mvcvE06TFY7WEODajyg@mail.gmail.com>
In-Reply-To: <CAD09ZYR6FG7tbSYjXXjKj14ocJNijm=mvcvE06TFY7WEODajyg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Rodrigo Ribeiro Gomes <rodrigorigomes@gmail.com>
Cc: fio@vger.kernel.org, Bruce Cran <bruce@cran.org.uk>
List-ID: <fio@vger.kernel.org>

On 05/13/2015 10:37 AM, Rodrigo Ribeiro Gomes wrote:
>
> On Wed, May 13, 2015 at 11:33 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 05/13/2015 10:23 AM, Rodrigo Ribeiro Gomes wrote:
>>>
>>> HI guys!
>>>
>>> I'm trying use the --thinktime parameter to sleep between each io
>>> request for ten seconds.
>>>
>>> But, it seems not working... I'm doing  something incorrect?
>>>
>>> fio --name disktst  ... --thinktime 10000000
>>>
>>> In HOWTO, this param is described as 'Stall the job x microseconds'...
>>> But fio dont stop between each request and continues issuing. This is
>>> complete command line that i used:
>>>
>>>
>>> fio --name IoRequestDelayTest --directory J\:\  --iodepth 1 --bs 4k
>>> --size 1G --io_size 1G --direct 1 --thread --runtime 1h --time_based
>>> --rw randread --thinktime 10000000
>>>
>>> The J: is mounted on a USB flash drive (Kingston SE9 32GB)
>>
>>
>> Works fine for me:
>>
>> ./fio --name=think --size=1g --bs=4k --rw=randread --direct=1
>> [...]
>>    read : io=130244KB, bw=30114KB/s, iops=7528, runt=  4325msec
>>
>> ./fio --name=think --size=1g --bs=4k --rw=randread --direct=1
>> --thinktime=1000
>> [...]
>>    read : io=17668KB, bw=3340.6KB/s, iops=835, runt=  5289msec
>>
>> I tried your 10s as well, works too.
 >
 > Interesting. It Windows version?

(please don't top post!)

It's possible, the Windows part does have its own nanosleep() function, 
which fio calls for this part. That's the only OS dependent bit in this 
equation.

Bruce?

-- 
Jens Axboe


