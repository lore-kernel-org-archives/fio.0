Return-Path: <bruce@cran.org.uk>
Subject: Re: Fio 2.0 coming (was "Re: Recent changes")
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=iso-8859-1
From: Bruce Cran <bruce@cran.org.uk>
In-Reply-To: <4E97D492.8080305@kernel.dk>
Date: Fri, 14 Oct 2011 17:55:44 +0100
Content-Transfer-Encoding: quoted-printable
Message-Id: <DA4ADF0A-3461-46AD-B5B7-E24CBAF4D1E9@cran.org.uk>
References: <20111014040002.95902484001@kernel.dk> <4E97D492.8080305@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


On 14 Oct 2011, at 07:20, Jens Axboe wrote:

> And folks running on non-linux, please try and build it at least =
(extra
> brownie points for actually running it, too).

It seems the latest version still has problems on non-Linux platforms =
when running in client/server mode:

> ./fio -S
fio: server listening on 0.0.0.0:8765

> ./fio -C localhost examples/tiobench-example
hostname=3Dvfreebsd_amd64, be=3D0, 64-bit, os=3DFreeBSD, arch=3Dx64-64, =
fio=3D1.99.7
>

--=20
Bruce Cran=

