Return-Path: <dallas.a.clement@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjAwxhU=jMkRFbFx47N4A0GNUBuMSNBM8eTq14aaaUwnqQL=A@mail.gmail.com>
References: <CAE9DZUTFeBgZi+sP28RgVpmiVVYyrRj1K2pSZazVjiyQXQeg8g@mail.gmail.com>
	<56991407.1020809@kernel.dk>
	<CAE9DZUT4fRQwn0Jxn+x2J7zt5PLJd6q4_6qau6o9M7r=3M2t9g@mail.gmail.com>
	<CALjAwxhipBau-gjBGNyzkqXJpXSQCtyvjyAcmYqOk_AZtEHZAg@mail.gmail.com>
	<CAE9DZUSn3h_03-TiokPg915uibLnNnfHusjFAjzSv4m-Q18=Jw@mail.gmail.com>
	<CALjAwxhU=jMkRFbFx47N4A0GNUBuMSNBM8eTq14aaaUwnqQL=A@mail.gmail.com>
Date: Mon, 18 Jan 2016 12:13:37 -0600
Message-ID: <CAE9DZUTGThrupdmPL0gqthQ8MWfd+SQHFhoGKw8Qotc88nV6iQ@mail.gmail.com>
Subject: Re: inflated bandwidth numbers with buffered I/O
From: Dallas Clement <dallas.a.clement@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

> I would expect async direct I/O to be able to go faster (speed is it's
> mostly what it's there for...). Direct asynchronous I/O can be faster
> because you don't have the overhead of copying things into the page
> cache. Additionally, you don't necessarily suffer from head of line
> blocking - each I/O can potentially finish independently of any other.

Okay, makes sense and definitely jives with my measurements.  Thanks
for explaining.

