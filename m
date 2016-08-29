Return-Path: <axboe@kernel.dk>
Subject: Re: fio hanging waiting of Futex lock in 2.12
References: <CALLCBzR9SEF7wMo4m9z4rtimvhNEad17PaNN5w5o2nBo-POeJw@mail.gmail.com>
 <17a9e545-989f-d93f-0d01-70dedac27e9d@kernel.dk>
 <CALLCBzQfCqiqe2ot0FKqu=9b9nXb_dvy903C2U+bd1TpdZYPzQ@mail.gmail.com>
 <CALLCBzR0QCzUp5aM_Z9eST+pTjLtfbh=YZ4zryOXKDsjsEnV_g@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <a57cd78f-391a-b9c7-c68e-badc93be7cc8@kernel.dk>
Date: Mon, 29 Aug 2016 11:37:32 -0600
MIME-Version: 1.0
In-Reply-To: <CALLCBzR0QCzUp5aM_Z9eST+pTjLtfbh=YZ4zryOXKDsjsEnV_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ryan Stiles <ras@datera.io>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 08/29/2016 11:31 AM, Ryan Stiles wrote:
> Good morning,
>
> The test ran over the weekend and did not hang once.  It is currently
> at 550 iterations without hitting the hang.  I would like to say that
> corrected the issue.
>
> Thank you for your help!

Great, thanks for both reporting and subsequent testing! And because I'm
a cocky bastard, I already committed the fix on Friday. So current -git
should just work.


-- 
Jens Axboe

