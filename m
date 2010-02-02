Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:50156 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab0BBJIP (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 2 Feb 2010 04:08:15 -0500
Date: Tue, 2 Feb 2010 10:08:13 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Writing to /dev/null with fio
Message-ID: <20100202090813.GC13771@kernel.dk>
References: <e2e108261002012338j62fd1983x7f4a0122d3fd97a4@mail.gmail.com> <20100202074135.GX13771@kernel.dk> <e2e108261002020001sbbf4123p8c0f505858c505b5@mail.gmail.com> <20100202081941.GY13771@kernel.dk> <e2e108261002020024s7502f97eib68fd7489a50d061@mail.gmail.com> <20100202083108.GZ13771@kernel.dk> <20100202085305.GA13771@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202085305.GA13771@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: fio@vger.kernel.org

On Tue, Feb 02 2010, Jens Axboe wrote:
> So the same for 512b buffers, fio is much quicker for 64k (must be due
> to proper aligning). I'll boot the big box and see what that says.

Same set of tests, only this time using a box with a lot more CPUs and
memory bandwidth. 'fio+' is fio with the fix for eliminating lseek(),
'fio' is without that fix.

App             bs              bandwidth
-----------------------------------------
dd              512              1.7GB/sec
fio             512              1.2GB/sec
fio+            512              1.5GB/sec
dd               4k              6.6GB/sec
fio              4k             10.3GB/sec
fio+             4k             12.4GB/sec

So dd is still faster for small blocks sizes, as expected. I don't think
there's any low hanging fruit left for fixing that. At 4k and higher the
impact should be neglible, so I don't think it's a huge problem. Most
real world testing is 4k or above.

-- 
Jens Axboe

