Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35270
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754822Ab3ERMWX (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 18 May 2013 08:22:23 -0400
Date: Sat, 18 May 2013 14:22:11 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: output - aggregate read bandwitdh
Message-ID: <20130518122211.GM19781@kernel.dk>
References: <OFB8065112.FF17BF54-ON80257B6F.00062897-80257B6F.000821C0@uk.ibm.com>
 <20130518065341.GJ19781@kernel.dk>
 <20130518070110.GK19781@kernel.dk>
 <OFCAFB895A.56FC581E-ON80257B6F.003AA486-80257B6F.003BB600@uk.ibm.com>
 <OFEF259463.FACECBD6-ON80257B6F.003C54FB-80257B6F.003CA237@LocalDomain>
 <OF1E75BC9A.821D96E0-ON80257B6F.003CB4BE-80257B6F.003E2AAA@uk.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF1E75BC9A.821D96E0-ON80257B6F.003CB4BE-80257B6F.003E2AAA@uk.ibm.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Edoardo Comar <ECOMAR@uk.ibm.com>
Cc: fio@vger.kernel.org

On Sat, May 18 2013, Edoardo Comar wrote:
> In any case, even excluding the alleged bug, the difference in aggrb 
> between the runs is very significant.
> 
> fio-2.1-8-gb2c77 - run laying out the files (where I think we have a bug)
> Run status group 0 (all jobs):
>    READ: io=31740MB, aggrb=541365KB/s, minb=18KB/s, maxb=298351KB/s, 
> mint=60001msec, maxt=60036msec
>   WRITE: io=42116KB, aggrb=701KB/s, minb=15KB/s, maxb=685KB/s, 
> mint=60036msec, maxt=60054msec
> 
> fio-2.0.13 - run reusing the files
> Run status group 0 (all jobs):
>    READ: io=12856KB, aggrb=213KB/s, minb=37KB/s, maxb=135KB/s, 
> mint=60242msec, maxt=60304msec
>   WRITE: io=30048KB, aggrb=498KB/s, minb=134KB/s, maxb=363KB/s, 
> mint=60262msec, maxt=60304msec
> 
> ===========
> 
> fio-2.0.13 - run laying out the files
> Run status group 0 (all jobs):
>    READ: io=11080KB, aggrb=183KB/s, minb=31KB/s, maxb=113KB/s, 
> mint=60129msec, maxt=60326msec
>   WRITE: io=23756KB, aggrb=393KB/s, minb=115KB/s, maxb=278KB/s, 
> mint=60294msec, maxt=60326msec
> 
> fio-2.1-8-gb2c77 - run reusing the files
> Run status group 0 (all jobs):
>    READ: io=8564KB, aggrb=141KB/s, minb=10KB/s, maxb=65KB/s, 
> mint=60249msec, maxt=60359msec
>   WRITE: io=28632KB, aggrb=474KB/s, minb=9KB/s, maxb=464KB/s, 
> mint=60249msec, maxt=60378msec
> 
> ===========
> 
> if I run again reusing the existing files I get quite consistent results 
> (within 5% which is ok over just a minute, IMHO) 
> with the previous run of the same fio version that also reused the files.
> but the two versions report figures that are significantly different, the 
> new fio is consistently slower.
> 
> fio-2.0.13 - run reusing the files again
> Run status group 0 (all jobs):
>    READ: io=12844KB, aggrb=212KB/s, minb=31KB/s, maxb=143KB/s, 
> mint=60148msec, maxt=60316msec
>   WRITE: io=30380KB, aggrb=503KB/s, minb=138KB/s, maxb=365KB/s, 
> mint=60163msec, maxt=60316msec
> 
> fio-2.1-8-gb2c77 - run reusing the files again
> Run status group 0 (all jobs):
>    READ: io=8308KB, aggrb=137KB/s, minb=10KB/s, maxb=63KB/s, 
> mint=60010msec, maxt=60207msec
>   WRITE: io=27672KB, aggrb=459KB/s, minb=8KB/s, maxb=450KB/s, 
> mint=60162msec, maxt=60268msec
> 
> 
> fio-2.0.13 - run reusing the files again
> Run status group 0 (all jobs):
>    READ: io=11976KB, aggrb=198KB/s, minb=31KB/s, maxb=129KB/s, 
> mint=60332msec, maxt=60442msec
>   WRITE: io=29012KB, aggrb=479KB/s, minb=127KB/s, maxb=351KB/s, 
> mint=60442msec, maxt=60484msec
> 
> fio-2.1-8-gb2c77 - run reusing the files again
> Run status group 0 (all jobs):
>    READ: io=8496KB, aggrb=141KB/s, minb=10KB/s, maxb=66KB/s, 
> mint=60005msec, maxt=60029msec
>   WRITE: io=27320KB, aggrb=454KB/s, minb=8KB/s, maxb=445KB/s, 
> mint=60005msec, maxt=60112msec
> 
> ... which should I trust ?

Very odd, it seems consistent for me with fio off git, both for initial
run and repeat runs (with existing files). I wonder if it's the clock.
Please send me the output of --cpuclock-test and also repeat your run
(both fresh and reuse) with clocksource=clock_gettime added to your
config file.

-- 
Jens Axboe

