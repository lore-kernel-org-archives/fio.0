Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] stat: Modify info for bw and iops stats in normal
 output
References: <20170609154716.GA11503@suselix.suse.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <241cff25-7cba-ac5a-a17b-9aa4f3bb84a9@kernel.dk>
Date: Fri, 9 Jun 2017 09:57:01 -0600
MIME-Version: 1.0
In-Reply-To: <20170609154716.GA11503@suselix.suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Andreas Herrmann <aherrmann@suse.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 06/09/2017 09:49 AM, Andreas Herrmann wrote:
> Hi,
> 
> I'd like to add basic IOPS statistics to fio's output. Sampling is
> done already but the final calculation and printing is missing.
> 
> Also I think it's usefull to know how many samples were collected and
> used to do the calculations. At least it helped me to understand that
> log_avg_msec parameter only has impact to metrics for which a log is
> written (e.g. using write_bw_log, write_lat_log etc.). For the rest
> the default sampling time is 500 msec, I think.
> 
> To make this information available in general, other output formats
> (at least the terse format) should also be adapted. But before doing
> that I'd like to know whether adding such info is accepted or
> rejected.

I like it, and my only comment would have been that this should be added
to the json format as well. So please go ahead and do that, then I'm
fine with it.

Terse is, as usual, more difficult since we can't really break existing
parsing scripts. And honestly, I keep pushing people to use json if they
want something that is both readable and parseable, so I don't think we
need to worry too much about the terse/csv output.

-- 
Jens Axboe


