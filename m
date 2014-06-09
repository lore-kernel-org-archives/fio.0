Return-Path: <pw@honk.padd.com>
Date: Mon, 9 Jun 2014 13:04:32 -0700
From: Pete Wyckoff <pw@padd.com>
Subject: Re: two jobs sometimes ignore time_based=1
Message-ID: <20140609200432.GA6446@padd.com>
References: <20140603210141.GA29246@padd.com>
 <5395D939.5010506@kernel.dk>
 <20140609190445.GA6052@padd.com>
 <53960A68.8000001@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53960A68.8000001@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

axboe@kernel.dk wrote on Mon, 09 Jun 2014 13:26 -0600:
> Can you check if current -git works? I checked in a fix for this. Thanks
> a lot for doing the bisection!
> 
> http://git.kernel.dk/?p=fio.git;a=commit;h=cbb1303c21eb43f59c4d2a4bf97a856eb8863773

That fixed it, too.  Thanks!

		-- Pete

