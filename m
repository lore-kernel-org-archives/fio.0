Return-Path: <rodrigorigomes@gmail.com>
MIME-Version: 1.0
In-Reply-To: <555360BE.6010303@kernel.dk>
References: <CAD09ZYSOkoXdHmYPfiF+pQReU1U+UHKfPL=52p818wikTtJDEw@mail.gmail.com>
	<555360BE.6010303@kernel.dk>
Date: Wed, 13 May 2015 11:37:50 -0300
Message-ID: <CAD09ZYR6FG7tbSYjXXjKj14ocJNijm=mvcvE06TFY7WEODajyg@mail.gmail.com>
Subject: Re: --thinktime seems not work
From: Rodrigo Ribeiro Gomes <rodrigorigomes@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Interesting. It Windows version?

On Wed, May 13, 2015 at 11:33 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 05/13/2015 10:23 AM, Rodrigo Ribeiro Gomes wrote:
>>
>> HI guys!
>>
>> I'm trying use the --thinktime parameter to sleep between each io
>> request for ten seconds.
>>
>> But, it seems not working... I'm doing  something incorrect?
>>
>> fio --name disktst  ... --thinktime 10000000
>>
>> In HOWTO, this param is described as 'Stall the job x microseconds'...
>> But fio dont stop between each request and continues issuing. This is
>> complete command line that i used:
>>
>>
>> fio --name IoRequestDelayTest --directory J\:\  --iodepth 1 --bs 4k
>> --size 1G --io_size 1G --direct 1 --thread --runtime 1h --time_based
>> --rw randread --thinktime 10000000
>>
>> The J: is mounted on a USB flash drive (Kingston SE9 32GB)
>
>
> Works fine for me:
>
> ./fio --name=think --size=1g --bs=4k --rw=randread --direct=1
> [...]
>   read : io=130244KB, bw=30114KB/s, iops=7528, runt=  4325msec
>
> ./fio --name=think --size=1g --bs=4k --rw=randread --direct=1
> --thinktime=1000
> [...]
>   read : io=17668KB, bw=3340.6KB/s, iops=835, runt=  5289msec
>
> I tried your 10s as well, works too.
>
> --
> Jens Axboe
>



-- 

[]'s Rodrigo Ribeiro Gomes
MCITP: Database Administrator 2008
MCITP: Database Developer 2008

061 8106-2710
(Acesse o blog THE SQL TIMES | http://www.thesqltimes.com)

