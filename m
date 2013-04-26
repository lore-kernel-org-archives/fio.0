Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:59075
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759119Ab3DZDo7 (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 25 Apr 2013 23:44:59 -0400
Date: Thu, 25 Apr 2013 21:44:52 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Random IO pattern ratios
Message-ID: <20130426034452.GN9563@kernel.dk>
References: <CAEzQZ4AEx5ioBUMR2HieVe9eoi2iwu-mFdEPdTkuPci55jBqHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEzQZ4AEx5ioBUMR2HieVe9eoi2iwu-mFdEPdTkuPci55jBqHQ@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Brian Carey <brian@careydrive.com>
Cc: fio@vger.kernel.org

On Thu, Apr 25 2013, Brian Carey wrote:
> Hello all,
> 
> I'm fairly new to fio and am trying to vary the ratio of sequential to
> random IO per job.  I'm not sure if I'm reading the section of the
> HowTo on mixed IO types right or not .  I'm trying to have the first
> job do 100% sequential access, the 2nd do 50% sequential/50% random,
> and the 3rd do 100% random.  Below is the section of the How To that
> I'm referring to as well as a snip of my config.
> 
> For the mixed io types, the default is to split them 50/50.
> For certain types of io the result may still be skewed a bit,
> since the speed may be different. It is possible to specify
> a number of IO's to do before getting a new offset, this is
> one by appending a ':<nr>' to the end of the string given.
> For a random read, it would look like 'rw=randread:8' for
> passing in an offset modifier with a value of 8. If the
> suffix is used with a sequential IO pattern, then the value
> specified will be added to the generated offset for each IO.
> For instance, using rw=write:4k will skip 4k for every
> write. It turns sequential IO into sequential IO with holes.
> See the 'rw_sequencer' option.
> 
> [4k 70/30% R/W - 100% seq]
> bs=4k
> rw=rw
> rwmixread=70
> rwmixwrite=30
> stonewall
> 
> [4k 70/30% R/W - 50% seq]
> bs=4k
> rw=randrw:2
> rwmixread=70
> rwmixwrite=30
> stonewall
> 
> [4k 70/30% R/W - 0% seq]
> bs=4k
> rw=randrw
> rwmixread=70
> rwmixwrite=30
> stonewall

It looks correct. For the middle one, the way fio will behave is that it
will generate a random offset, read 4k from that, then read 4k again,
then generate a new random offset. So it's 50/50 random/seq in the sense
that for each seek, you will have two sequential IOs. Which means that
every IO will be either sequential to the former, or completely random.
That, in essense, is 50% random and 50% sequential. Outside of that,
there's currently no way to tell fio to do X ios randomly, then Y ios
sequentially. If 1/1 is good enough, then the job as listed will get
that done.

Job 1/3 are straight forward and do what you are looking for without
doubt.

-- 
Jens Axboe

