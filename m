Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50867 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932770Ab2JYMap (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 25 Oct 2012 08:30:45 -0400
Message-ID: <508930F0.50205@kernel.dk>
Date: Thu, 25 Oct 2012 14:30:40 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Anyone doing async I/O on FreeBSD?
References: <CAEQv8RE=W_7RShF-ce1kV1V9VaFSBC4hq=QbxEy9GNHYXDo+uw@mail.gmail.com> <5088F648.4010606@kernel.dk> <9688A91D-52A1-41E8-A9BD-90486CAF8C22@cran.org.uk>
In-Reply-To: <9688A91D-52A1-41E8-A9BD-90486CAF8C22@cran.org.uk>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bruce Cran <bruce@cran.org.uk>
Cc: Tom Blamer <blamer@gmail.com>, fio@vger.kernel.org

On 2012-10-25 12:58, Bruce Cran wrote:
>=20
> On 25 Oct 2012, at 09:20, Jens Axboe <axboe@kernel.dk> wrote:
>=20
>> That's aio_read or aio_write returning -1/ENOSYS, which means that it's
>> not implemented. From a quick google, on FreeBSD, it seems you need to
>> have a kernel compiled with VFS_AIO enabled. Not sure why that isn't the
>> default=EF=BF=BD
>=20
>=20
> There was a discussion about it a few months ago - http://freebsd.1045724=
.n5.nabble.com/aio-in-GENERIC-td5727900.html .
> For now you need to 'kldload aio'.

Thanks Bruce, helps with somebody from the camp :-)

"Someone" should collect all these questions and turn them into an
FAQ...

--=20
Jens Axboe

