Return-Path: <grundler@google.com>
MIME-Version: 1.0
In-Reply-To: <CAPet_23bQMEwb32ZEXdG6jGYYMxY_9tOPZG2-JQX=-AAm+O+AA@mail.gmail.com>
References: <CANEJEGsMAS3uYtQx04bq8mPcdnhtXaVwg=vS=TgcY97d2kQeqw@mail.gmail.com>
	<51F98044.1080105@kernel.dk>
	<CANEJEGvQZXa4NhsjZcawQ+Z6MTOgzfJEX+t1WY2yX_+R-qC3Og@mail.gmail.com>
	<20130801022535.GF24569@kernel.dk>
	<CAPet_23bQMEwb32ZEXdG6jGYYMxY_9tOPZG2-JQX=-AAm+O+AA@mail.gmail.com>
Date: Fri, 2 Aug 2013 14:39:09 -0700
Message-ID: <CANEJEGtmipSvqai7ux0K9ibMbGBNN3VNxGicided3q3pQE6EPQ@mail.gmail.com>
Subject: Re: FIO and Storage Data Integrity testing
From: Grant Grundler <grundler@google.com>
Content-Type: text/plain; charset=UTF-8
To: Juan Casse <jcasse@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, Aug 2, 2013 at 2:21 PM, Juan Casse <jcasse@google.com> wrote:
...
> Grant, if fio currently has lfsr and the breadcrumbs and can do writes
> with do_verify=0 and reads with do_verify=1, it seems to me that fio
> already satisfies our requirements for data integrity testing,

That's almost true. :)

> contingent on Jens' answers to my questions above. Also, wouldn't
> these features be sufficient for data retention testing as well?

Yes, they will be once you implement them. E.g. numberio is not a
generation number. Given the LFSR seed, one could determine the
generation number. So perhaps add the LSFR seed value to the data
structure so that gets written with each test run many many times too.
Later, when we validate the drive, we can determine generation number
and confirm the value is correct that was read from media. All of this
needs to be implemented.

Carefully re-read Jen's replies. Some of his answers are "speculative"
(e.g. "could do this" vs "does this").

> If you write do_verify=0 and then 3 months later read do_verify=1,
> wouldn't that be enough?

Correct - That's the goal. It's not reality yet. :)

cheers,
grant

