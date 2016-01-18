Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAE9DZUSn3h_03-TiokPg915uibLnNnfHusjFAjzSv4m-Q18=Jw@mail.gmail.com>
References: <CAE9DZUTFeBgZi+sP28RgVpmiVVYyrRj1K2pSZazVjiyQXQeg8g@mail.gmail.com>
	<56991407.1020809@kernel.dk>
	<CAE9DZUT4fRQwn0Jxn+x2J7zt5PLJd6q4_6qau6o9M7r=3M2t9g@mail.gmail.com>
	<CALjAwxhipBau-gjBGNyzkqXJpXSQCtyvjyAcmYqOk_AZtEHZAg@mail.gmail.com>
	<CAE9DZUSn3h_03-TiokPg915uibLnNnfHusjFAjzSv4m-Q18=Jw@mail.gmail.com>
Date: Mon, 18 Jan 2016 18:10:05 +0000
Message-ID: <CALjAwxhU=jMkRFbFx47N4A0GNUBuMSNBM8eTq14aaaUwnqQL=A@mail.gmail.com>
Subject: Re: inflated bandwidth numbers with buffered I/O
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Dallas Clement <dallas.a.clement@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 18 January 2016 at 03:20, Dallas Clement <dallas.a.clement@gmail.com> wrote:
>
> Thanks.  I have been playing around with this fsync parameter.  I have
> tried various numbers ranging from 32 to 128.  I do see reasonable
> numbers now.  However throughput is quite a bit less than I was seeing
> with direct I/O (direct=1).  I was expecting I would actually get
> better performance with buffered I/O.  Am I misguided?

I would expect async direct I/O to be able to go faster (speed is it's
mostly what it's there for...). Direct asynchronous I/O can be faster
because you don't have the overhead of copying things into the page
cache. Additionally, you don't necessarily suffer from head of line
blocking - each I/O can potentially finish independently of any other.

-- 
Sitsofe | http://sucs.org/~sits/

