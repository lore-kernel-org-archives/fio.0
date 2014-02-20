Return-Path: <axboe@kernel.dk>
Date: Thu, 20 Feb 2014 09:03:10 -0800
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch 4/9] fio: provide an option for a startdelay range
Message-ID: <20140220170310.GA30251@kernel.dk>
References: <20140220132050.860880543@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220132050.860880543@linux.vnet.ibm.com>
To: ehrhardt@linux.vnet.ibm.com
Cc: fio@vger.kernel.org, oberpar@linux.vnet.ibm.com
List-ID: <fio@vger.kernel.org>

On Thu, Feb 20 2014, ehrhardt@linux.vnet.ibm.com wrote:
> *Resend with hopefully non mangled patches*
> References: <20140220131958.965092001@linux.vnet.ibm.com>
> Content-Disposition: inline; filename=startdelay-range.diff
> 
> From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
> 
> This patch allows the specification of start delay as range.
> With a range each thread will chose an individual startdelay out of the range.
> 
> That solves an issue of startdelay being the same for each numjob clone and
> that way spreads all kind of activities e.g. that all clones with mixed r/w
> jobs switch r/w at the same time.
> Also all kind of other "thundering herd" issues can be softened by some
> time spread due to this option.
> 
> Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

You forgot the options part for thread_options.h.

-- 
Jens Axboe


