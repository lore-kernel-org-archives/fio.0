Return-Path: <sitsofe@gmail.com>
Return-Path: <sitsofe@gmail.com>
Date: Mon, 29 Sep 2014 08:41:11 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: [Question] How to perform stride access?
Message-ID: <20140929074038.GA12377@sucs.org>
References: <CANvN+enrUD45Zp1CJKQ3kxQncHLyhp7hE1jr4AnzRD65oDTUvg@mail.gmail.com>
 <54228237.5000805@gmail.com>
 <CALjAwxg+o05=3YDOmXaKskrdg3AHU88T-pkqZw=QFQkwRTjdwA@mail.gmail.com>
 <CALjAwxirUW+v662QZ9zQG-2zuTNtE8xkpfaJqv=5ArLviqjhGw@mail.gmail.com>
 <5427716A.1080407@kernel.dk>
 <20140928103616.GA9991@sucs.org>
 <54281A0A.8050905@kernel.dk>
 <5428246F.7020506@kernel.dk>
 <20140928194419.GA24724@sucs.org>
 <54288805.2020008@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54288805.2020008@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: Akira Hayakawa <ruby.wktk@gmail.com>, Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

(Resending because list rejected HTML part)

On 28 September 2014 23:13, Jens Axboe <axboe@kernel.dk> wrote:

> On 09/28/2014 01:44 PM, Sitsofe Wheeler wrote:
> > The patch fixes
> > fio --bs=4k --rw=write:4k --filename=/dev/shm/1M --name=go --io_limit=2M
> > but not
> > fio --bs=512k --rw=write --filename=/dev/shm/1M --name=go --number_io=4
>
> number_ios=x is implemented as a cap, not a forced "must complete this
> amount of ios to be done".

Ah I see. Now I look again the HOWTO even says it doesn't extend the number
of I/Os - I should have read more carefully!

> > or
> > fio --bs=4k --rw=write --filename=/dev/shm/1M --name=go --zoneskip=4k
> --zonesize=4k --io_limit=2M
>
> That one is a bit more tricky. Oh, try the attached (keep the previous
> applied).

Latest patch fixes zone skipping for me too. Akira are things better for
you too?

-- 
Sitsofe | http://sucs.org/~sits/

