Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37634 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab3EVI54 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 22 May 2013 04:57:56 -0400
Date: Wed, 22 May 2013 10:57:36 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: output - aggregate read bandwitdh
Message-ID: <20130522085736.GE9714@kernel.dk>
References: <OFB8065112.FF17BF54-ON80257B6F.00062897-80257B6F.000821C0@uk.ibm.com>
 <20130518065341.GJ19781@kernel.dk>
 <20130518070110.GK19781@kernel.dk>
 <OFCAFB895A.56FC581E-ON80257B6F.003AA486-80257B6F.003BB600@uk.ibm.com>
 <OFEF259463.FACECBD6-ON80257B6F.003C54FB-80257B6F.003CA237@LocalDomain>
 <OF1E75BC9A.821D96E0-ON80257B6F.003CB4BE-80257B6F.003E2AAA@uk.ibm.com>
 <20130518122211.GM19781@kernel.dk>
 <OF4E37C571.40B0273E-ON80257B6F.005B05C5-80257B6F.005DC361@uk.ibm.com>
 <OFD80C407E.DC45623D-ON80257B6F.007F5485-80257B6F.007FC70E@uk.ibm.com>
 <OFE288D6C7.BEB7BBEB-ON80257B73.002E3467-80257B73.002E896D@uk.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFE288D6C7.BEB7BBEB-ON80257B73.002E3467-80257B73.002E896D@uk.ibm.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Edoardo Comar <ECOMAR@uk.ibm.com>
Cc: fio@vger.kernel.org

On Wed, May 22 2013, Edoardo Comar wrote:
> > 
> > I just tried the code from git on my personal macbook.
> > I replaced libaio with posixaio in the config file and 
> > the ultra-high aggrb read is there too (files being created).
> > 
> > is caused by the contribution to the aggregate stats 
> > of the second of the two query threads [queryB]
> > 
> > 
> > Run status group 0 (all jobs):
> >    READ: io=16350MB, aggrb=277927KB/s, minb=10KB/s, maxb=278418KB/s, 
> > mint=60001msec, maxt=60240msec
> >   WRITE: io=10164KB, aggrb=168KB/s, minb=8KB/s, maxb=160KB/s, 
> > mint=60088msec, maxt=60240msec
> 
> Hi, are there any insight on the READ aggrb issue?
> I'm fairly confident it's a bug now that I see it happening even on 
> different platforms (mac and linux) 

It would help a lot if you could do a git bisect and reliably find out
which commit caused the problem. The procedure is something like this,
assuming you are in the fio git repository:

$ git bisect start
$ git bisect good fio-2.0.13
$ git bisect bad master

Then make clean and make fio, run the job file:

$ make clean; make
$ ./fio <jobfile>

Run the job file as many times as is required to reliably tell whether
this is a good or a bad build. Lets assume the first one is good, you
would then do:

$ git bisect good

and repeat the make clean && make && run of job file. If the result was
bad, you'd do git bisect bad.

You continue this process until it tells you which one is the offending
commit. Then you mail that here :-)

-- 
Jens Axboe

