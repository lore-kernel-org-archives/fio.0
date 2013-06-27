Date: Thu, 27 Jun 2013 21:28:28 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Generating almost-sequential traffic
Message-ID: <20130627192828.GH25599@kernel.dk>
References: <A7A1D348E34E024BBC74480FB93A2EAB039C63@DAGN05A-E6.exg6.exghost.com>
 <20130627090123.GK25599@kernel.dk>
 <A7A1D348E34E024BBC74480FB93A2EAB039F2F@DAGN05A-E6.exg6.exghost.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A7A1D348E34E024BBC74480FB93A2EAB039F2F@DAGN05A-E6.exg6.exghost.com>
To: Carl Zwanzig <cpz@coraid.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Thu, Jun 27 2013, Carl Zwanzig wrote:
> > From: Jens Axboe [mailto:axboe@kernel.dk]
> > Sent: Thursday, June 27, 2013 2:01 AM
> 
> > See percentage_random in the man page (or --cmdhelp=percentage_random)
> 
> In the tests I'm running, the sequence has to continue essentially
> uninterrupted with the occasional drop/transposition, but it can't
> contain LBAs that are wildly off. So '1 2 3 (4) 5 6' or '1 2 3 (5 4)
> 6' are good, '1 2 3 9999 4 5 6' is not. They trigger different
> specific behaviors in some hard drives.
> 
> Is there a good place in the code to insert this sort or thing?

I would look at the profile support in fio. That allows you to hook into
io_u.c:get_next_offset(), which is where fio decides what the next
offset should be. If a profile defines ops->fill_io_u(), then that is
called instead. That gives you absolute control of the IO pattern,
without having to modify core fio code.

-- 
Jens Axboe


