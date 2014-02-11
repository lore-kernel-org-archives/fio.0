Return-Path: <axboe@kernel.dk>
Date: Tue, 11 Feb 2014 09:39:36 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Fix documentation of SI vs. binary prefixes
Message-ID: <20140211163936.GI19057@kernel.dk>
References: <94D0CD8314A33A4D9D801C0FE68B4029548A6481@G9W0745.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029548A6481@G9W0745.americas.hpqcorp.net>
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Tue, Feb 11 2014, Elliott, Robert (Server Storage) wrote:
> fio specifies SI and binary units backwards, presumably for
> compatibility with old scripts.  The description in HOWTO and the man
> page should acknowledge this.  I suggest fixing it something like
> this.

It's weird how that happened, I don't even remember, to be honest. I
would agree with John here that we just need to make the painful switch,
and potentially add a switch for backwards compatability.

-- 
Jens Axboe


