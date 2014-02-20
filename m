Return-Path: <axboe@kernel.dk>
Date: Thu, 20 Feb 2014 09:05:49 -0800
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch 2/9] fio: allow general repeatability
Message-ID: <20140220170549.GB30251@kernel.dk>
References: <20140220132050.493701099@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220132050.493701099@linux.vnet.ibm.com>
To: ehrhardt@linux.vnet.ibm.com
Cc: fio@vger.kernel.org, oberpar@linux.vnet.ibm.com
List-ID: <fio@vger.kernel.org>

On Thu, Feb 20 2014, ehrhardt@linux.vnet.ibm.com wrote:
> *Resend with hopefully non mangled patches*
> References: <20140220131958.965092001@linux.vnet.ibm.com>
> Content-Disposition: inline; filename=repeatable-global-randomness.diff
> 
> From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
> 
> This patch adds a "allrandrepeat" option similar to the existing randrepeat.
> But other than the former option it does not only affect the random I/O pattern,
> but also all remaining users of randomness as well.
> 
> By that e.g. testcases using nrfiles, filesize ranges, blocksizesplit ranges
> and so on will stay repeatable across (euqally parametrized) runs as well.
> To maintain compatibility the default is off. 

Forgot the thread_options.h change here too. Also note that you need to
update cconv.c as well when adding options.

-- 
Jens Axboe


