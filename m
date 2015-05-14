Return-Path: <axboe@kernel.dk>
Message-ID: <5554C050.80703@kernel.dk>
Date: Thu, 14 May 2015 11:33:36 -0400
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: --thinktime seems not work
References: <CAD09ZYSOkoXdHmYPfiF+pQReU1U+UHKfPL=52p818wikTtJDEw@mail.gmail.com>	<555360BE.6010303@kernel.dk> <CAD09ZYR6FG7tbSYjXXjKj14ocJNijm=mvcvE06TFY7WEODajyg@mail.gmail.com> <555369BA.4040101@kernel.dk> <5553D7B0.2010306@cran.org.uk>
In-Reply-To: <5553D7B0.2010306@cran.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Bruce Cran <bruce@cran.org.uk>, Rodrigo Ribeiro Gomes <rodrigorigomes@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 05/13/2015 07:01 PM, Bruce Cran wrote:
> On 5/13/2015 9:11 AM, Jens Axboe wrote:
>>
>> It's possible, the Windows part does have its own nanosleep()
>> function, which fio calls for this part. That's the only OS dependent
>> bit in this equation.
>>
>> Bruce?
>>
>
> Well, on Windows the nanosleep() function appears to be working with the
> latest fio code, so I'm not sure what might be going wrong.

I did read the code, and it looked OK to me. So ditto, no real idea on 
what is going on here. Rodrigo, are you using a 32-bit build? Maybe the 
ints overflow. Does it work if you use smaller delays, the 10s delay per 
IO is pretty massive.

-- 
Jens Axboe


