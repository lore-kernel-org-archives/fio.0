Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <e06182ba-6ac7-57b1-5f32-67c8756401b9@kernel.dk>
References: <CAH6SkxpsXtS3AFCkOwKPG-JeZB_aH7yf3LgepYB=cAfg3fbvbQ@mail.gmail.com>
 <e06182ba-6ac7-57b1-5f32-67c8756401b9@kernel.dk>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 17 Mar 2018 08:48:06 +0000
Message-ID: <CALjAwxhy81B+Q7SJUnpfaiQMaHUDZVonUUT=+UH7F+Ey3aLP1A@mail.gmail.com>
Subject: Re: FIO's rdma engine...
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: Kip Ingram <kip.ingram@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Stephen Bates <sbates@raithlin.com>, logang@deltatee.com
List-ID: <fio@vger.kernel.org>

On 23 January 2018 at 17:50, Jens Axboe <axboe@kernel.dk> wrote:
> On 1/23/18 10:48 AM, Kip Ingram wrote:
>> Hi Jens.  I'm trying to do some NVME over IB testing, and it seemed
>> appropriate to use the rdma engine in FIO.  However, it's complaining
>> in various ways:
>>
>> 1. It says I have to specify the device size.  That's not a
>> show-stopper, but it surprised me.
>> 2. It says I have to use either read or write traffic - not mixed.
>> That is a problem.
>> 3. It says I can't use random addressing.  That's also a problem.
>>
>> Colleagues have set up devices this way and used one of our internal
>> tools to do mixed and random traffic.
>>
>> I don't see anything in the documents that imply mixed and random
>> shouldn't work - is there something I'm overlooking?
>
> CC'ing the fio list, please direct questions there and not to me
> directly.

CC'ing some RDMA folks.

-- 
Sitsofe | http://sucs.org/~sits/

