Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:51495 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3F0JCa (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 27 Jun 2013 05:02:30 -0400
Date: Thu, 27 Jun 2013 11:02:27 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Simulating bursts at different rates at irregular intervals?
Message-ID: <20130627090227.GL25599@kernel.dk>
References: <255129448.30162533.1372322165642.JavaMail.root@framestore.com>
 <803980722.30163228.1372322272381.JavaMail.root@framestore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <803980722.30163228.1372322272381.JavaMail.root@framestore.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: James Vanns <james.vanns@framestore.com>
Cc: fio@vger.kernel.org

On Thu, Jun 27 2013, James Vanns wrote:
> Hi. I'm new to fio and though I've read the HOWTO from the git repo several times now, I'm unsure if it is possible to achieve what I want;
> 
> I can simulate a mix of sequential and random writes for a duration at
> an average rate or throughput of say, 5.4MB/s.  I presume that fio
> will attempt to sustain that rate? My real question is this - is it
> possible in either the same job or a different job in the same file to
> simulate bursts of higher rates? I.e. on average attempt to write at
> nMB/s but at random or irregular intervals during this period attempt
> a 'burst' of 138MB/s for 5 minutes and then return to the 'normal'
> rate. Then again at some other point a burst of 57MB/s for 30minutes
> etc.
> 
> Is this possible? Presently I've found that I cannot do this. Or
> rather, thinking about it, I'd have to specify n jobs for each
> different rate and then perhaps use 'ratecycle' and 'thinktime'? I
> can't see how to skew 'thinktime' randomly though?

That's currently not possible, fio only supports a fixed rate. But if
you have a good idea on how to express your criteria as an option (or
options), then it can surely be added :-)

-- 
Jens Axboe

