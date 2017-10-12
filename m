Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <79c9569e-707c-6cd8-2bc0-2e774e09448f@kernel.dk>
References: <20171010212710.12526-1-andrzej.jakowski@intel.com>
 <CALjAwxhFr84M6p3SUmJuu8novyP+Wq7fiyPrTd=qGn4ubHwC1w@mail.gmail.com>
 <cf6c368d-110e-7776-bcc8-76e9d024914a@kernel.dk> <28cd47ad-913c-0eaa-ec2d-84ab47763029@gmail.com>
 <CAOmo8DbWZTT=yZE1rDrGBabji83-SwH+p0M5TpFk9awNdvMdGw@mail.gmail.com>
 <CALjAwxi7cd4RFG7WSz+XWHkouKwvX7iFnU3tNri-MgR1RTstZw@mail.gmail.com>
 <CALjAwxg=GCVbpNhOu1b7zpR-7Rexc1ttzWoUHqmNMfnDk2sZhw@mail.gmail.com> <79c9569e-707c-6cd8-2bc0-2e774e09448f@kernel.dk>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 12 Oct 2017 21:51:03 +0100
Message-ID: <CALjAwxjbDkQxP2eH=287GmfJvnoADre+5DHsXjsJhZf_7GhCGQ@mail.gmail.com>
Subject: Re: [PATCH] Fix overflow in percentile calculation for Windows
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrzej Jakowski <andrzej.jakowski@gmail.com>, Vincent Fu <vincentfu@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Andrzej Jakowski <andrzej.jakowski@intel.com>
List-ID: <fio@vger.kernel.org>

On 12 October 2017 at 15:36, Jens Axboe <axboe@kernel.dk> wrote:
>
> Just go through them one-by-one. I think some of these were likely
> introduced with the nsec conversion, which I guess isn't too
> surprising...

With all the latest patches applied these are the only warnings which
look faintly legitimate:

io_u.c:1272:28: runtime error: unsigned integer overflow: 0 - 1 cannot
be represented in type 'unsigned int'

Might be harmless because we goto out just after td->file_service_left
has wrapped around.

ioengines.c:270:22: runtime error: unsigned integer overflow: 59 - 63
cannot be represented in type 'unsigned int'

It does look like td->io_u_in_flight is over decremented but it's not
clear how I/Os that weren't already in flight somehow completed...

stat.c:1529:20: runtime error: unsigned integer overflow: 3370715872 +
1125639672 cannot be represented in type 'unsigned int'
stat.c:1531:23: runtime error: unsigned integer overflow: 3370715859 +
1125639668 cannot be represented in type 'unsigned int'
stat.c:1533:25: runtime error: unsigned integer overflow: 3370715862 +
1125639669 cannot be represented in type 'unsigned int'

The last three are all down to io_u_* structure members being 32 bit.
Would we want to make them 64 bit and bump the protocol version?

-- 
Sitsofe | http://sucs.org/~sits/

