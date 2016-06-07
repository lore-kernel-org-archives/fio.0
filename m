Return-Path: <axboe@kernel.dk>
Subject: Re: fio hang (sleep forever) after first job with ramp_time?
References: <CAMGffEkGs5imFNH6T7uU07fDp_UX+RdbY-n2c8FrdzqmipLi3w@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <57563A8A.2020904@kernel.dk>
Date: Mon, 6 Jun 2016 21:07:54 -0600
MIME-Version: 1.0
In-Reply-To: <CAMGffEkGs5imFNH6T7uU07fDp_UX+RdbY-n2c8FrdzqmipLi3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jinpu Wang <jinpu.wang@profitbricks.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 06/06/2016 06:44 AM, Jinpu Wang wrote:
> Hi all,
>
> We run into fio hang (sleep forever) all the time with latest fio (fio --version
> fio-2.11-12-g82e6)
>
> Kernel 4.4.5 on Debian Jessie
> Configuration:
> cat test.ini
> [global]
> ioengine=libaio
> direct=1
> time_based=1
>
> # runtime options
> runtime=5
> ramp_time=5
> filename=/dev/ram0
> [job1]
> blocksize=32k
>
> [job2]
> blocksize=128k
> stonewall
>
> Fio process is sleep in:
> cat /proc/9891/stack
> [<ffffffff810ba469>] hrtimer_nanosleep+0xc9/0x1b0
> [<ffffffff810ba5a7>] SyS_nanosleep+0x57/0x70
> [<ffffffff81810757>] entry_SYSCALL_64_fastpath+0x12/0x6a
> [<ffffffffffffffff>] 0xffffffffffffffff

For the edification of people on the list, this fix was committed:

http://git.kernel.dk/cgit/fio/commit/?id=356014ff351c6eb69339652650af5f6af72e5c22

-- 
Jens Axboe


