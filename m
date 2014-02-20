Return-Path: <axboe@kernel.dk>
Date: Thu, 20 Feb 2014 09:20:33 -0800
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch 0/9] Collection of various fio fixes and extensions V2
Message-ID: <20140220172033.GD30251@kernel.dk>
References: <20140220131958.965092001@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220131958.965092001@linux.vnet.ibm.com>
To: ehrhardt@linux.vnet.ibm.com
Cc: fio@vger.kernel.org, oberpar@linux.vnet.ibm.com
List-ID: <fio@vger.kernel.org>

On Thu, Feb 20 2014, ehrhardt@linux.vnet.ibm.com wrote:
> *Resend with hopefully non mangled patches*
> 
> Hi,
> we adopted fio as a very good tool back at version 1.57.
> It suited our needs in replacing iozone with a more modern and more capable
> benchmarking tool.

Glad to hear it!

> As it is usually we needed a few little extensions to support the old use
> cases we wanted to migrate to the new benchmark. Also we found a few issues
> in the fio code that we had to fix.
> 
> All that happened a long time back and we always wanted to cotribute our
> changes to the project which after a loooong legal process now is finally
> possible. To make things worse the code was affected by some bit rot due
> to that legal waiting time which in turn stalled me making it ready for
> submission again.
> 
> I'm happy that I finally found some time to update the patches to match to
> the current fio git. It passed my 18 test cases which are based on the
> examples delivered with fio new for the new functionality added.

I have applied all of the patches directly, except for 8/9. I fixed up
the options issues I noted, and also fixed up rbd not being updated for
the multidirectory support.

Thanks!

-- 
Jens Axboe


