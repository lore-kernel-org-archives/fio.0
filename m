Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAE9DZUT4fRQwn0Jxn+x2J7zt5PLJd6q4_6qau6o9M7r=3M2t9g@mail.gmail.com>
References: <CAE9DZUTFeBgZi+sP28RgVpmiVVYyrRj1K2pSZazVjiyQXQeg8g@mail.gmail.com>
	<56991407.1020809@kernel.dk>
	<CAE9DZUT4fRQwn0Jxn+x2J7zt5PLJd6q4_6qau6o9M7r=3M2t9g@mail.gmail.com>
Date: Sun, 17 Jan 2016 18:00:47 +0000
Message-ID: <CALjAwxhipBau-gjBGNyzkqXJpXSQCtyvjyAcmYqOk_AZtEHZAg@mail.gmail.com>
Subject: Re: inflated bandwidth numbers with buffered I/O
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Dallas Clement <dallas.a.clement@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 15 January 2016 at 16:09, Dallas Clement <dallas.a.clement@gmail.com> wrote:
>
> I suspected that might be the case.  Is this dirty memory on the
> client side where fio is running or on the target host where the data
> has been written to?

It will be on the client side - you aren't waiting for anything to
flush so it can even just queue in the kernel's page cache.

> I would like to make fio sync in a similar fashion to what real
> applications would do.  Setting sync=1 is probably too aggressive.
> Probably a sync after a given number of blocks would seem more
> realistic.

Try taking a look at the fsync parameter in the HOWTO:
https://github.com/axboe/fio/blob/fio-2.3/HOWTO#L909 .

-- 
Sitsofe | http://sucs.org/~sits/

