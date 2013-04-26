Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:39659 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab3DZO54 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 26 Apr 2013 10:57:56 -0400
Date: Fri, 26 Apr 2013 08:57:54 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Random IO pattern ratios
Message-ID: <20130426145754.GR9563@kernel.dk>
References: <CAEzQZ4AEx5ioBUMR2HieVe9eoi2iwu-mFdEPdTkuPci55jBqHQ@mail.gmail.com>
 <20130426034452.GN9563@kernel.dk>
 <CAJBj3vcw+AcrR-ka-tp6+CrR=TVaav9OvRSjbm-rwFeaGHDFng@mail.gmail.com>
 <20130426134216.GO9563@kernel.dk>
 <20130426144736.GQ9563@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130426144736.GQ9563@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: John Williams <jwilliams4200@gmail.com>
Cc: Brian Carey <brian@careydrive.com>, fio@vger.kernel.org

On Fri, Apr 26 2013, Jens Axboe wrote:
> On Fri, Apr 26 2013, Jens Axboe wrote:
> > On Thu, Apr 25 2013, John Williams wrote:
> > > Are there any plans to add %random / %sequential capability to fio?
> > > 
> > > That is the only feature IOMeter has that I miss in fio.
> > 
> > Sure, that'd be pretty easy to add. Let me take a look this morning.
> 
> Done. Did a few test runs to check it.
> 
> percentage_random=50
> Random: 16313 (50.036808), Seq: 16289 (49.963192)
> 
> percentage_random=10
> Random: 3239 (9.942292), Seq: 29339 (90.057708)
> 
> percentage_random=72
> Random: 23467 (71.993496), Seq: 9129 (28.006504)
> 
> percentage_random=100
> Random: 32596 (99.990797), Seq: 3 (0.009203)
> 
> percentage_random=0
> Random: 1 (0.003066), Seq: 32613 (99.996934)
> 
> Note that the first IO is always counted as random, which is why the =0
> test says only 99.996% sequential. In fact it is fully sequential.

Committed with documentation:

http://git.kernel.dk/?p=fio.git;a=commit;h=211c9b8948b43ed47aedf1227e0444a58db015e4

So you can just grab the latest generated snapshot, or git update.

-- 
Jens Axboe

