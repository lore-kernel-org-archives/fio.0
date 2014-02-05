Return-Path: <axboe@kernel.dk>
Date: Wed, 5 Feb 2014 15:30:52 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Rip out verify_backlog support?
Message-ID: <20140205223052.GF20626@kernel.dk>
References: <CANEJEGuqYiSQnyw2bVNFa3CKqmZK6+-3y5dDT4h3iccU-n0cAA@mail.gmail.com>
 <20140205193214.GI27534@kernel.dk>
 <CANEJEGs-KdsMC3fE3SvOUkkbJESXXvUHwRVq5OjWTfKyf-ooEA@mail.gmail.com>
 <20140205195317.GK27534@kernel.dk>
 <CANEJEGsqwKQssFqZPEycWR-ccqcVjWGQA=EtLtDsdxg5D1-c_g@mail.gmail.com>
 <20140205212812.GC20626@kernel.dk>
 <CANEJEGt5neHeCc-wnDDyFWY7S_AyxzKjaOj09DXR08oRjF+Dow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEJEGt5neHeCc-wnDDyFWY7S_AyxzKjaOj09DXR08oRjF+Dow@mail.gmail.com>
To: Grant Grundler <grundler@chromium.org>
Cc: FIO_list <fio@vger.kernel.org>, Puthikorn Voravootivat <puthik@chromium.org>
List-ID: <fio@vger.kernel.org>

On Wed, Feb 05 2014, Grant Grundler wrote:
> > It does - that's the log_io_piece() mechanism. The writer will generate
> > on, and verify will read those and verify. We just have to ensure that
> > it is correct in the way that it is logged. The alternative would be to
> > rely purely on the generator rollback, and for that you would then need
> > some specific notification on how far the reader could proceed, if async
> > verify_backlog is used.
> 
> Yes - I was referring to the "rely purely on generator rollback".
> 
> Once log_io_piece() is called, the verify code assumes the IO is
> complete...which isn't true if log_io_piece() is used to record "order
> issued".

Right, we'd need to ensure the state is accurately known to the
verifier.

-- 
Jens Axboe


