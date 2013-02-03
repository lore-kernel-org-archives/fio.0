Return-Path: <greg.sullivan@sullivang.net>
MIME-Version: 1.0
In-Reply-To: <20130127153925.GO15635@kernel.dk>
References: <CAJdxx76y1m6NG9_D86XXY4xz2mJc4guP1Qa_DCqNQNamNPxK7w@mail.gmail.com>
	<50F3CB5F.8070507@kernel.dk>
	<CAJdxx75-H7LOQ3Kf13U6h7TskpvCKuwL4pbkG16PzHinYwHRsw@mail.gmail.com>
	<CAJdxx77Yq=Df4eS-iQVfFNXzjBusF3zG+ZLhLnGQVuVHhdkA=g@mail.gmail.com>
	<CAJdxx74Tu3LHhJ9LUOTg=K3NfiwY6iD9mrDS=_3EXcqEKNaENg@mail.gmail.com>
	<CAN2qFaotYBVvJyvac0L8EUJAiJAbnYjFtmXgPNCe2ey6P_ZHFA@mail.gmail.com>
	<CAJdxx77U9ULtqV3sSGzwX0Pi7pZeyP1avuVzxkLm-pLhS1vncQ@mail.gmail.com>
	<CAHaS=QwrKy7ZmmzZ2UCEx1qUT8GNJ9u+TwTw2Pe4nU030gyOAw@mail.gmail.com>
	<20130127153925.GO15635@kernel.dk>
Date: Sun, 3 Feb 2013 17:56:39 +1100
Message-ID: <CAHaS=Qw=MdDAwqsSKZdrgKF070KZmjCBh49n2L-xson-P94unw@mail.gmail.com>
Subject: Re: asking for an example job file
From: Greg Sullivan <greg.sullivan@sullivang.net>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 28 January 2013 02:39, Jens Axboe <axboe@kernel.dk> wrote:
>
> On Thu, Jan 24 2013, Greg Sullivan wrote:
> > (resending in plain text - sigh)
> >
> > I tried to use the "rate" functionality on Windows some time ago, and
> > it was extremely erratic. As I recall, the Windows maintainer couldn't
> > reproduce the behaviour I was observing, and since the work I was
> > doing was not critical, I gave up. (yes - I know - boo hiss! :) :)
>
> It might have something to do with some of the timing functions on
> Windows, which are way too coarse to be used for rate limiting. If you
> have the job file that you used handy, I can try and take a look at it.
>
> --

Thanks Jens - here it is:
<read.ini>
[read]
bs=128K
direct=1
size=100M

rate=1M
rw=read
<end read.ini>

Running against a 7200rpm SATA drive. It is very erratic, and locks up
completely. However, if I up the rate to, say, 10MB/s, it works much
better. Also, this is bizarre - it seems to work much better when I
have my browser (Chrome) open! If I close down all the chrome.exe
processes, it then locks up, but only if the rate is low (1MByte/s).
I'll try to create some disk activity using another application and
re-test!

System:
Dell E6500 Latitude laptop, Win7 32-bit, 4GB memory, 7200rpm internal
SATA drive.

Greg.

