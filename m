Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59561 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab3HBVVi (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 2 Aug 2013 17:21:38 -0400
Message-ID: <51FC22BC.4080602@kernel.dk>
Date: Fri, 02 Aug 2013 15:21:00 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO and Storage Data Integrity testing
References: <CANEJEGsMAS3uYtQx04bq8mPcdnhtXaVwg=vS=TgcY97d2kQeqw@mail.gmail.com> <51F98044.1080105@kernel.dk> <CANEJEGvQZXa4NhsjZcawQ+Z6MTOgzfJEX+t1WY2yX_+R-qC3Og@mail.gmail.com> <20130801022535.GF24569@kernel.dk> <51FACCF8.2050304@kernel.dk> <CAPet_214qJj_Ri90kzpgkAq399Fe2kejfdxSGfDxfZv=7CP7Gg@mail.gmail.com>
In-Reply-To: <CAPet_214qJj_Ri90kzpgkAq399Fe2kejfdxSGfDxfZv=7CP7Gg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Juan Casse <jcasse@google.com>
Cc: Grant Grundler <grundler@google.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 08/02/2013 03:10 PM, Juan Casse wrote:
> Jens, Grant,
> 
> Bellow is a summary of the thread as I understood it.
> (To keep it simple, I'm using the TODO keyword for both action items and
> questions.)
> 
> Requirements for data integrity and retention test
> 
> 1) gpl implementaion:
> 
> fio satisfies this
> 
> 2) Verify data written to storage is available and correct:
> 
> 
> fio has axmap to log writes, but
> prefer linear feedback shift registers (lfsr) to reproduce data for
> verification; fio currently supports this with random_generator=lfsr
> 
> TODO: Jens says lfsr does not currently work with multiple block sizes?
> I'm missing something here; I thought a single run would have a single
> block size. Please explain.

A single run CAN use a single block size, but it could also be a
multiple of block sizes. It all depends on how you configure the job. If
all you care about is single block size runs, then yes, then fio already
works with lfsr and that.

> 3) Breadcrumbs for debugging data that is not correct:
> 
> a) lba - fio has uint64 offset. OK.
> b) generation # - fio has unsigned short numberio
> 
> 
> TODO: Jens says must be used differently? How does it currently work? Is
> it also incremented and written to storage upon a read?

Depends on how you want to use the generation number. Right now it's
just a truncated variant of the number of writes issued.

> c) timestamp - fio has unsigned long time_sec and time_usec. OK.
> d) magic # - fio has a generic magic number
> 
> 
> TODO: what does generic mean? is it always the same number dor every run
> of fio?

Yes, it's a fixed constant that fio uses (oxacca). Could easily be made
configurable.

> TODO: make this data structure (vhdr_meta) agnostic to 32- vs. 64-bit

And bonus points for making it little/big endian safe too, we should do
that if we change it anyway. Should be little endian disk format. Fio
has the appropriate cpu_to_leXX etc helpers included, the client/server
protocol is 32/64 little/big endian agnostic.

> 4) Data retention:
> 
> fio currently can do:
> 
> a) write workload with do_verify=0
> b) read workload with do_verify=1
> 
> fio currently checksums:
> 
> a) header information
> b) actual data
> 
> 5) Test trim/discard:
> 
> TODO: use sepparate lfsr to generate read/wrte/trim part
> 
> Grant, if fio currently has lfsr and the breadcrumbs and can do writes
> with do_verify=0 and reads with do_verify=1, it seems to me that fio
> already satisfies our requirements for data integrity testing,
> contingent on Jens' answers to my questions above. Also, wouldn't these
> features be sufficient for data retention testing as well? If you write
> do_verify=0 and then 3 months later read do_verify=1, wouldn't that be
> enough?
> 
> Juan

-- 
Jens Axboe

