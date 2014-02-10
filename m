Return-Path: <sits@sucs.org>
Date: Mon, 10 Feb 2014 20:22:45 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: Mutex destruction, invalid memory accesses, leaks
Message-ID: <20140210202245.GA6747@sucs.org>
References: <20140206192135.GB3950@kernel.dk>
 <20140207034439.GA17588@sucs.org>
 <52F505A8.30004@kernel.dk>
 <20140209195042.GA17058@sucs.org>
 <52F927AC.6020007@cran.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F927AC.6020007@cran.org.uk>
To: Bruce Cran <bruce@cran.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Mon, Feb 10, 2014 at 12:25:32PM -0700, Bruce Cran wrote:
> On 2/9/2014 12:50 PM, Sitsofe Wheeler wrote:
> >
> >Yes it's still happening with -git from a moment ago. What is stopping a
> >sleeping thread from holding a mutex that is destroyed and then waking
> >up on it after the memory has been unmapped?
> 
> In case it *is* a bug in winpthreads-1.dll, are you using version
> 3.1.0-1? It was released on the 15th January and there appeared to
> be some mutex-related fixes when I looked at the svn log a few weeks
> ago.

Yes I am using version 3.1.0-1 on Windows 7 installed about a week
ago...

-- 
Sitsofe | http://sucs.org/~sits/

