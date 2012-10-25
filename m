Return-Path: <blamer@gmail.com>
MIME-Version: 1.0
In-Reply-To: <508930F0.50205@kernel.dk>
References: <CAEQv8RE=W_7RShF-ce1kV1V9VaFSBC4hq=QbxEy9GNHYXDo+uw@mail.gmail.com>
	<5088F648.4010606@kernel.dk>
	<9688A91D-52A1-41E8-A9BD-90486CAF8C22@cran.org.uk>
	<508930F0.50205@kernel.dk>
Date: Thu, 25 Oct 2012 16:43:38 -0500
Message-ID: <CAEQv8REMHm1CCCZAcfucciBpSb3Dw8=v-SBFfDOF8fxehEv7gg@mail.gmail.com>
Subject: Re: Anyone doing async I/O on FreeBSD?
From: Tom Blamer <blamer@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: Bruce Cran <bruce@cran.org.uk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Thu, Oct 25, 2012 at 7:30 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2012-10-25 12:58, Bruce Cran wrote:
>>
>> On 25 Oct 2012, at 09:20, Jens Axboe <axboe@kernel.dk> wrote:
>>
>>> That's aio_read or aio_write returning -1/ENOSYS, which means that it's
>>> not implemented. From a quick google, on FreeBSD, it seems you need to
>>> have a kernel compiled with VFS_AIO enabled. Not sure why that isn't th=
e
>>> default=85
>>
>>
>> There was a discussion about it a few months ago - http://freebsd.104572=
4.n5.nabble.com/aio-in-GENERIC-td5727900.html .
>> For now you need to 'kldload aio'.
>
> Thanks Bruce, helps with somebody from the camp :-)
>
> "Someone" should collect all these questions and turn them into an
> FAQ...
>
> --
> Jens Axboe
>

Thanks for the quick responses. I tried 'kldload aio' and that worked
for me. Shows how much I know...

