Return-Path: <axboe@kernel.dk>
Message-ID: <555389D0.9000700@kernel.dk>
Date: Wed, 13 May 2015 13:28:48 -0400
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: --thinktime seems not work
References: <CAD09ZYSOkoXdHmYPfiF+pQReU1U+UHKfPL=52p818wikTtJDEw@mail.gmail.com>	<555360BE.6010303@kernel.dk>	<CAD09ZYR6FG7tbSYjXXjKj14ocJNijm=mvcvE06TFY7WEODajyg@mail.gmail.com>	<555369BA.4040101@kernel.dk> <CAD09ZYSmGDDAw8d=BMNGPV3d+KMNG2=VnQVfLE=NuzeP5FxArA@mail.gmail.com>
In-Reply-To: <CAD09ZYSmGDDAw8d=BMNGPV3d+KMNG2=VnQVfLE=NuzeP5FxArA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Rodrigo Ribeiro Gomes <rodrigorigomes@gmail.com>
Cc: fio@vger.kernel.org, Bruce Cran <bruce@cran.org.uk>
List-ID: <fio@vger.kernel.org>

On 05/13/2015 11:33 AM, Rodrigo Ribeiro Gomes wrote:
> I did some new test and removed the parameters '--runtime' and
> '--time_based' .... Without it, the thinktime works!
> (sorry for top post)

Neither of those should have any impact on the thinktime. Doesn't 
reproduce for me. What version of fio are you using?

-- 
Jens Axboe


