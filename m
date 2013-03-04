Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58752
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756797Ab3CDO1i (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 4 Mar 2013 09:27:38 -0500
Date: Mon, 4 Mar 2013 15:27:25 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Seq Write with holes
Message-ID: <20130304142725.GP7485@kernel.dk>
References: <CANUChTxj5=ZXXkJkkRs-mFoWH7mX+DXjE+5KwYtuUFY3hvXqhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANUChTxj5=ZXXkJkkRs-mFoWH7mX+DXjE+5KwYtuUFY3hvXqhw@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Gavin Martin <gavin_martin@xyratex.com>
Cc: fio@vger.kernel.org

On Mon, Mar 04 2013, Gavin Martin wrote:
> Hi,
> 
> I'm trying to setup a job file that tests interleaved data, so in
> theory writing 256K blocks with a gap of 256K in between, the end
> results is that I would like to write extra data into the gaps and
> make sure it is not corrupting neighbouring areas.
> 
> But I'm having a problem with the first part.
> 
> Here is the jobfile:-
> 
> [global]
> ioengine=libaio
> direct=1
> filename=/dev/sdb
> verify=meta
> verify_backlog=1
> verify_dump=1
> verify_fatal=1
> stonewall
> 
> [Job 2]
> name=SeqWrite256K
> description=Sequential Write with 1M Bands (256K)
> rw=write:1M
> bs=256K
> do_verify=0
> verify_pattern=0x33333333
> size=1G
> 
> [Job 4]
> name=SeqVerify256K
> description=Sequential Read/Verify from Sequential Write (256K)
> rw=read:1M
> bs=256K
> do_verify=1
> verify_pattern=0x33333333
> size=1G
> 
> There seems to be a bug (or maybe by design) when using the 'size='
> variable.  It seems to count the gaps (1M) within the size of 1G, but
> only on the write, the reads seems to report the IO transferred as 1G
> 
> Here is the status of the runs:-
> 
> Run status group 0 (all jobs):
>   WRITE: io=209920KB, aggrb=34039KB/s, minb=34039KB/s, maxb=34039KB/s,
> mint=6167msec, maxt=6167msec
> 
> Run status group 1 (all jobs):
>    READ: io=1025.0MB, aggrb=36759KB/s, minb=36759KB/s, maxb=36759KB/s,
> mint=28553msec, maxt=28553msec
> 
> And you can see the Write IO is a lot lower than the Read IO, even
> though I have asked it to cover the same disk space.
> 
> It could be that this is by design and it is my jobfile that is not
> setup correctly, has anybody tried something like this before?

They should behave identically - if they don't, then that is a bug. I
will take a look at this tomorrow.

-- 
Jens Axboe

