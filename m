Return-Path: <bruce@cran.org.uk>
Message-ID: <5553D7B0.2010306@cran.org.uk>
Date: Wed, 13 May 2015 17:01:04 -0600
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: --thinktime seems not work
References: <CAD09ZYSOkoXdHmYPfiF+pQReU1U+UHKfPL=52p818wikTtJDEw@mail.gmail.com>	<555360BE.6010303@kernel.dk> <CAD09ZYR6FG7tbSYjXXjKj14ocJNijm=mvcvE06TFY7WEODajyg@mail.gmail.com> <555369BA.4040101@kernel.dk>
In-Reply-To: <555369BA.4040101@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Rodrigo Ribeiro Gomes <rodrigorigomes@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 5/13/2015 9:11 AM, Jens Axboe wrote:
>
> It's possible, the Windows part does have its own nanosleep() 
> function, which fio calls for this part. That's the only OS dependent 
> bit in this equation.
>
> Bruce?
>

Well, on Windows the nanosleep() function appears to be working with the 
latest fio code, so I'm not sure what might be going wrong.

-- 
Bruce

