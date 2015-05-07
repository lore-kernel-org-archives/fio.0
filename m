Return-Path: <axboe@kernel.dk>
Message-ID: <554B766A.2090703@kernel.dk>
Date: Thu, 07 May 2015 08:27:54 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: achieving a workload to get specific unique duplicate blocks
References: <CABtFm2U5t2=sM4MDKhaPn7n9nsJTSBUCSUeZ=9irt8EEBTogBQ@mail.gmail.com>	<5547D8F3.6090408@kernel.dk>	<CABtFm2Xwk7krWgobsW0JfCMuGvjFaUzeORggei7+gdVqg2rjhg@mail.gmail.com>	<CAF+0mvkxEvMfjE3r2ffAz6QWMrHMLfmJOhNU5_3kcYO9Qdm9dg@mail.gmail.com> <CABtFm2VhjHURUMHfB=iPoXZfa+_m8xm9qpBCQmv=2UB+Rd-BYA@mail.gmail.com>
In-Reply-To: <CABtFm2VhjHURUMHfB=iPoXZfa+_m8xm9qpBCQmv=2UB+Rd-BYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Srinivasa Chamarthy <chamarthy.raju@gmail.com>, Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 05/06/2015 09:58 PM, Srinivasa Chamarthy wrote:
> Thanks Eaton. One question thought. From the man page for refill_buffers:
>
> "If this option is given, fio will refill the IO buffers on every
> submit. The default is to only fill it at init time and reuse that
> data. Only makes sense if zero_buffers isn't specified, naturally. If
> data verification is enabled, refill_buffers is also automatically
> enabled."
>
> Every IO submitted will have a new pattern for repeated workloads?
> using refill_buffers, i seem to get same pattern repeatedly. Is that
> how it should be? i was under the impression that refill will use new
> pattern every time.
>
> # fio --filename=test_refill --readwrite=randwrite --size=1m
> --refill_buffers --bs=256k --norandommap --name=refill
> # for each in {0..3}; do dd if=test_refill bs=262144 count=1
> skip=$each 2>/dev/null | md5sum; done
> 86c3e47e173a58ad93470fd8db856f8c  -
> 6fe5ce86d04522889c99809d6d97cb94  -
> 9113ce00f3781861afc41aaf6da32428  -
> f0b575c40e9da23b524f585723cbea4e  -
>
> # fio --filename=test_refill --readwrite=randwrite --size=1m
> --refill_buffers --bs=256k --norandommap --name=refill
> # for each in {0..3}; do dd if=test_refill bs=262144 count=1
> skip=$each 2>/dev/null | md5sum; done
> 86c3e47e173a58ad93470fd8db856f8c  -
> 6fe5ce86d04522889c99809d6d97cb94  -
> 9113ce00f3781861afc41aaf6da32428  -
> f0b575c40e9da23b524f585723cbea4e  -

First of all, please stop top posting. It breaks the flow of conversations.

Secondly, this is expected behavior, and it's done to get identical 
behavior between runs. If you had longer runs, each buffer would be 
different. But if you did a new run after that, the sequence of buffers 
would be the same. Same thing happens with the offsets generated, the 
buffer lengths generated, etc.

If you want a truly different run everytime, you have a few options. One 
is to simply set randrepeat=0, then OS entropy will seed the random 
generators. Or you can use randseed= to set a specific seed, which would 
allow you to reproduce a specific run.


-- 
Jens Axboe


