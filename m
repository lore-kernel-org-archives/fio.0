Return-Path: <dallas.a.clement@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjAwxhipBau-gjBGNyzkqXJpXSQCtyvjyAcmYqOk_AZtEHZAg@mail.gmail.com>
References: <CAE9DZUTFeBgZi+sP28RgVpmiVVYyrRj1K2pSZazVjiyQXQeg8g@mail.gmail.com>
	<56991407.1020809@kernel.dk>
	<CAE9DZUT4fRQwn0Jxn+x2J7zt5PLJd6q4_6qau6o9M7r=3M2t9g@mail.gmail.com>
	<CALjAwxhipBau-gjBGNyzkqXJpXSQCtyvjyAcmYqOk_AZtEHZAg@mail.gmail.com>
Date: Sun, 17 Jan 2016 21:20:01 -0600
Message-ID: <CAE9DZUSn3h_03-TiokPg915uibLnNnfHusjFAjzSv4m-Q18=Jw@mail.gmail.com>
Subject: Re: inflated bandwidth numbers with buffered I/O
From: Dallas Clement <dallas.a.clement@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Sun, Jan 17, 2016 at 12:00 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> On 15 January 2016 at 16:09, Dallas Clement <dallas.a.clement@gmail.com> wrote:
>>
>> I suspected that might be the case.  Is this dirty memory on the
>> client side where fio is running or on the target host where the data
>> has been written to?
>

Hi Sitsofe,

> It will be on the client side - you aren't waiting for anything to
> flush so it can even just queue in the kernel's page cache.
>

Thanks for confirming that.  That definitely explains what I'm seeing then.

>> I would like to make fio sync in a similar fashion to what real
>> applications would do.  Setting sync=1 is probably too aggressive.
>> Probably a sync after a given number of blocks would seem more
>> realistic.
>
> Try taking a look at the fsync parameter in the HOWTO:
> https://github.com/axboe/fio/blob/fio-2.3/HOWTO#L909 .

Thanks.  I have been playing around with this fsync parameter.  I have
tried various numbers ranging from 32 to 128.  I do see reasonable
numbers now.  However throughput is quite a bit less than I was seeing
with direct I/O (direct=1).  I was expecting I would actually get
better performance with buffered I/O.  Am I misguided?

