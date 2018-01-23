Return-Path: <axboe@kernel.dk>
Subject: Re: FIO's rdma engine...
References: <CAH6SkxpsXtS3AFCkOwKPG-JeZB_aH7yf3LgepYB=cAfg3fbvbQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <e06182ba-6ac7-57b1-5f32-67c8756401b9@kernel.dk>
Date: Tue, 23 Jan 2018 10:50:18 -0700
MIME-Version: 1.0
In-Reply-To: <CAH6SkxpsXtS3AFCkOwKPG-JeZB_aH7yf3LgepYB=cAfg3fbvbQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Kip Ingram <kip.ingram@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 1/23/18 10:48 AM, Kip Ingram wrote:
> Hi Jens.  I'm trying to do some NVME over IB testing, and it seemed
> appropriate to use the rdma engine in FIO.  However, it's complaining
> in various ways:
> 
> 1. It says I have to specify the device size.  That's not a
> show-stopper, but it surprised me.
> 2. It says I have to use either read or write traffic - not mixed.
> That is a problem.
> 3. It says I can't use random addressing.  That's also a problem.
> 
> Colleagues have set up devices this way and used one of our internal
> tools to do mixed and random traffic.
> 
> I don't see anything in the documents that imply mixed and random
> shouldn't work - is there something I'm overlooking?

CC'ing the fio list, please direct questions there and not to me
directly.

-- 
Jens Axboe


