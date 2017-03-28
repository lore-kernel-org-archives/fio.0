Return-Path: <kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
In-Reply-To: <a0c00913-954f-0bc7-a0fa-abbcd87bff7e@kernel.dk>
References: <20170328200301.8622-1-tkusumi@tuxera.com> <20170328200301.8622-2-tkusumi@tuxera.com>
 <a0c00913-954f-0bc7-a0fa-abbcd87bff7e@kernel.dk>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Wed, 29 Mar 2017 00:17:18 +0300
Message-ID: <CAHndrBmX18v5sS7DSuj--m1LHe-2R8543SN=OaRy5cmkptqg2g@mail.gmail.com>
Subject: Re: [PATCH 02/13] Use GOLDEN_RATIO_PRIME
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

Hi

Sorry, I thought using 64bit version on 64bit was the intention..

2017-03-28 23:44 GMT+03:00 Jens Axboe <axboe@kernel.dk>:
> On 03/28/2017 02:02 PM, kusumi.tomohiro@gmail.com wrote:
>> From: Tomohiro Kusumi <tkusumi@tuxera.com>
>>
>> Using this macro (originally for hash in Linux kernel) for rand seed
>> instead of hard-coded value should make sense. rdma ioengine uses
>> this for the seed as well.
>
> This will change the seed behavior for 64-bit builds. I don't think
> we should do that in the name of a cleanup.
>
> --
> Jens Axboe
>

