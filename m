Return-Path: <axboe@kernel.dk>
Subject: Re: testing thin provisioned block device
References: <CANo=J15Pt4+=G4dmq+hwUGH+3-OP4wWvqO44dbZLNOZaQYcmRQ@mail.gmail.com>
 <CANvN+enHvuNd5TC=Qxte22k52qR3XdLzyeGxQ5OLihwOM0XDRQ@mail.gmail.com>
 <CALjAwxgtwP+6K0qLnNzm2Z72gLGasd_oG6EH66bjV-Rc6rOEpw@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <57446C01.9080806@kernel.dk>
Date: Tue, 24 May 2016 08:58:09 -0600
MIME-Version: 1.0
In-Reply-To: <CALjAwxgtwP+6K0qLnNzm2Z72gLGasd_oG6EH66bjV-Rc6rOEpw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>, Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: Tim Walker <tim.t.walker@seagate.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 05/23/2016 11:41 AM, Sitsofe Wheeler wrote:
> On 23 May 2016 at 16:02, Andrey Kuzmin <andrey.v.kuzmin@gmail.com> wrote:
>>
>> To my knowledge, there's no prebuilt configuration to read only those blocks
>> that have been written before.
>>
>> At the same time, when randommap is on, FIO keeps track of the blocks written,
>> so it may be possible to limit the read generation to those by adding
>> a bit of code.
>
> I thought this type of facility had to exist so that verification
> triggers (https://github.com/axboe/fio/blob/fio-2.10/HOWTO#L2214 ) via
> verify_state_load could work?

Definitely. Similarly to what Alireza suggested, using the same random 
seed for a reader would read the exact same blocks that fio previously 
wrote. You don't strictly need the random map for that. If you seed 
things the same way, then the offsets/sizes/etc will be generated 
identically. The random map can help with verifies if you overwrite 
blocks or need to trim, but for a pure write-then-read setup, it's not 
needed.

For instance, if you do verifies, you can have a write job file that you 
run to completion. Then you take that exact same job file, and change 
the write (random or sequential) to the equivalent read, and run fio 
again. The same thing is of course possible without doing the 
verification, but just using that same mechanism to read only the parts 
that were written.

-- 
Jens Axboe


