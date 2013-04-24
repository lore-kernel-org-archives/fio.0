Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:33364 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758403Ab3DXWbl (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 24 Apr 2013 18:31:41 -0400
Date: Wed, 24 Apr 2013 16:31:39 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] fix memory allocation in the cases we may need to align
Message-ID: <20130424223139.GT2354@kernel.dk>
References: <1366840545-11768-1-git-send-email-dpf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366840545-11768-1-git-send-email-dpf@google.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: peter chang <dpf@google.com>
Cc: gwendal@google.com, fio@vger.kernel.org

On Wed, Apr 24 2013, peter chang wrote:
> when using the sg backend we crash w/ a SEGV in fio_sgio_getevents()
> because of memory corruption from the IO. when we allocate the td's
> backing store there's a possible post-allocation adjustment to page
> align the buffers. however, the extra memory that this alignment may
> need is not taken into account when allocating the buffer.
> 
> Tested:
>   - the problematic fio file looks like
>   fdha347:~# cat foo.fio
>   [global]
>   bs=64k
>   thread
>   rw=read
>   size=100g
>   time_based=1
>   runtime=60
>   iodepth=1
> 
>   [sdc]
>   ioengine=sg
>   filename=/dev/sg2
>   numjobs=1

Thanks, good description and the potential extra alignment bytes isn't
an issue. Applied!

-- 
Jens Axboe

