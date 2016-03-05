Return-Path: <vst@vlnb.net>
Message-ID: <56DA31DB.5090507@vlnb.net>
Date: Fri, 04 Mar 2016 17:09:47 -0800
From: Vladislav Bolkhovitin <vst@vlnb.net>
MIME-Version: 1.0
Subject: Re: Fio high IOPS measurement mistake
References: <56D525E1.6010407@vlnb.net> <CALjAwxjLb7L8sZCensSNXZ4kDyHb683bu-zuwDvgk5sFoeMckw@mail.gmail.com> <56D66B1C.6050506@vlnb.net> <56D7A97F.9080800@vlnb.net> <CALjAwxgU06EEYCw9VV7S8UzDtgpo-KUQtS90HK=KpfffkCKn2A@mail.gmail.com> <20160303162037.GD22164@kernel.dk> <56D91110.8080203@vlnb.net> <56D9AADC.3070600@kernel.dk> <56DA2C92.5030508@vlnb.net> <56DA2E49.2050207@kernel.dk>
In-Reply-To: <56DA2E49.2050207@kernel.dk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Jens Axboe wrote on 03/04/2016 04:54 PM:
>>> I've seen you bring up this contention idea before.
>>
>> Yes, it was when I forgot to short circuit lseek calls in the sync engine. Usually, if
>> you see performance dropping from certain number of threads, it is safe to guess there
>> is a lock contention somewhere.
> 
> That is true, the lseek() part is not in fio though, that's a kernel issue. But for
> this case, avoiding lseek through one of the sync variants with offset is the best
> solution. Might actually makes sense to make that the default.

BTW, as far as I can see, fio is using independent, fully dedicated file handles for
each job. Shouldn't independent file handles, ever for the same block device, behave
fully independently with nothing shared, hence protected by locks?

In my naive understanding, lseek should be just changing internal offset, a single
variable. Perhaps, translation fd (integer) -> corresponding internal structure is what
to blame here (also pure guess).

>>> Is that pure guesswork on your end, or have you profiled any contention?
>>
>> Pure guesswork. I'm looking at fio in details only few days, so it is still pretty much
>> a black box for me. Generally, if you see performance drop with another thread, it must
>> be either locks contention, or communication overhead. Nowadays the former is more
>> common, hence the guess.
> 
> Right, but that contention can be anywhere from the application to the driver. So some
> more details would be great, when you have them.
> 
> One thing I've seen for higher IOPS cases is that the bdev inode inc/dec for every IO,
> that hurts scalability. That was fixed here:
> 
> http://git.kernel.dk/cgit/linux-block/commit/?id=fe0f07d08ee35
> 
> but you might already be running a kernel with that included (what are you running?).
> Another one is the io stats collected, that tends to cause poorer scaling than you
> would expect, you can turn that off through sysfs (/sys/block/<dev>/queue/iostats).

Thanks, I'm planning to update to the latest kernel and try with it.

Vlad


