Return-Path: <kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
In-Reply-To: <838dc940-5a0b-fda7-2610-615e3a700c3c@kernel.dk>
References: <838dc940-5a0b-fda7-2610-615e3a700c3c@kernel.dk>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Thu, 16 Mar 2017 22:50:41 +0200
Message-ID: <CAHndrB=YeE6-U2s+STbiXhMPpUt3stJ0PyPFOiriBVQ3XZTU4g@mail.gmail.com>
Subject: Re: fio: forcing file /dev/nvme0n1 size to 4286578688
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi

I added this because I happened to see file(s) with unexpected size
due to this behavior, but I think it should be logged only for
regfiles.
Using cpuio also shows this which does not make much sense just like
it doesn't with block device without size=.



2017-03-16 22:24 GMT+02:00 Jens Axboe <axboe@kernel.dk>:
> Hi,
>
> Commit c4aa2d08 adds this warning message, which triggers all the time
> when used with block devices and no size being set. Why are we logging
> this message?
>
> --
> Jens Axboe
>

