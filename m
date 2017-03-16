Return-Path: <axboe@kernel.dk>
Subject: Re: fio: forcing file /dev/nvme0n1 size to 4286578688
References: <838dc940-5a0b-fda7-2610-615e3a700c3c@kernel.dk>
 <CAHndrB=YeE6-U2s+STbiXhMPpUt3stJ0PyPFOiriBVQ3XZTU4g@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <ad189fe1-798a-673f-2ee5-f77d352221e9@kernel.dk>
Date: Thu, 16 Mar 2017 14:54:01 -0600
MIME-Version: 1.0
In-Reply-To: <CAHndrB=YeE6-U2s+STbiXhMPpUt3stJ0PyPFOiriBVQ3XZTU4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 03/16/2017 02:50 PM, Tomohiro Kusumi wrote:
> Hi
> 
> I added this because I happened to see file(s) with unexpected size
> due to this behavior, but I think it should be logged only for
> regfiles.
> Using cpuio also shows this which does not make much sense just like
> it doesn't with block device without size=.

Yeah, it doesn't make sense for most files, just regular ones. Feel
free to re-instate it (I killed it) for just regular files.


-- 
Jens Axboe


