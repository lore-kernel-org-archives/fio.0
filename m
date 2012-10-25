Return-Path: <bruce@cran.org.uk>
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Anyone doing async I/O on FreeBSD?
From: Bruce Cran <bruce@cran.org.uk>
In-Reply-To: <5088F648.4010606@kernel.dk>
Date: Thu, 25 Oct 2012 11:58:29 +0100
Content-Transfer-Encoding: quoted-printable
Message-Id: <9688A91D-52A1-41E8-A9BD-90486CAF8C22@cran.org.uk>
References: <CAEQv8RE=W_7RShF-ce1kV1V9VaFSBC4hq=QbxEy9GNHYXDo+uw@mail.gmail.com> <5088F648.4010606@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tom Blamer <blamer@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


On 25 Oct 2012, at 09:20, Jens Axboe <axboe@kernel.dk> wrote:

> That's aio_read or aio_write returning -1/ENOSYS, which means that =
it's
> not implemented. =46rom a quick google, on FreeBSD, it seems you need =
to
> have a kernel compiled with VFS_AIO enabled. Not sure why that isn't =
the
> default=85


There was a discussion about it a few months ago - =
http://freebsd.1045724.n5.nabble.com/aio-in-GENERIC-td5727900.html .
For now you need to 'kldload aio'.

--=20
Bruce Cran=

