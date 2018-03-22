Return-Path: <axboe@kernel.dk>
Subject: Re: valgrind spews
References: <a7527854-7ed3-a074-278e-e75f75cec4e7@kernel.dk>
 <CALjAwxgaVddxmgzkM6S7d6SP0FTdBT9y6QeO58L870qxBYDqAg@mail.gmail.com>
 <ed74b20d-cd3b-2b0a-89d1-188be58a5dae@kernel.dk>
 <1521738727.2637.14.camel@sandisk.com>
 <3e6568da-0dfe-7d4a-138d-f04e43a3dd7b@kernel.dk>
 <1521739678.2637.16.camel@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <baec1170-03fc-7b43-85e6-8e80f2d11006@kernel.dk>
Date: Thu, 22 Mar 2018 11:29:49 -0600
MIME-Version: 1.0
In-Reply-To: <1521739678.2637.16.camel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "sitsofe@gmail.com" <sitsofe@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 3/22/18 11:27 AM, Bart Van Assche wrote:
> On Thu, 2018-03-22 at 11:23 -0600, Jens Axboe wrote:
>> On 3/22/18 11:12 AM, Bart Van Assche wrote:
>>> Where is the sk_out structure allocated? Can Valgrind know whether or not
>>> that structure has been initialized?
>>
>> In server.c:accept_loop() and that structure is memset at alloc
>> time as it's coming out of smalloc().
> 
> Would you be OK with changing that smalloc() call into scalloc() such that
> Valgrind knows that that structure is initialized? On my laptop the following
> is sufficient to suppress the complaints mentioned in my previous e-mail:

Sure, done.


-- 
Jens Axboe


