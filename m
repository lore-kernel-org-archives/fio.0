Return-Path: <m.eaton82@gmail.com>
MIME-Version: 1.0
In-Reply-To: <532375B6.1060208@kernel.dk>
References: <CAF+0mvm1bjy99fbM_jkr9Sp7bbgnQSpr3WkeZ7Zgju9hFdNaSA@mail.gmail.com>
	<532349BF.4010307@kernel.dk>
	<CAF+0mv=crXGQfof7jrRSnKnmGJ3k4AW7CdaLtgJEdpFzsXENng@mail.gmail.com>
	<532361FE.10901@kernel.dk>
	<53236538.2040903@kernel.dk>
	<CAF+0mv=q-nEGkeQdJgwH78_3n6novRHAWfRwp=QHa8dFinYd3Q@mail.gmail.com>
	<53236D0B.5040507@kernel.dk>
	<CAF+0mvmV4DYyGvG_ccENE5NqhB-wuQsqUVQD8LY0mvM-hTeXoA@mail.gmail.com>
	<532375B6.1060208@kernel.dk>
Date: Fri, 14 Mar 2014 15:26:06 -0700
Message-ID: <CAF+0mvmL6hmFkm2Tf__EYz=PUceEX=H4NURb9bm1_hY_XTmXVQ@mail.gmail.com>
Subject: Re: Possible bug when setting compression
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

> scramble_buffers tells fio to randomly insert some data in the buffer. It's
> not a full overwrite or anything like that, just some basic garbage for each
> 512b to prevent naive compression/dedupe.
>
> --
> Jens Axboe
>
>

Thanks, that makes sense.  I guess my only concern is one might expect
that setting zero_buffers alone would provide fully compressible data,
not realizing that scramble_buffers is still adding some random data
unless explicitly turned off.

Maybe something that could be added to the man page / how to under
zero_buffers?  Something like...

"If you want a fully compressible workload, also set scramble_buffers=0."

