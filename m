Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:38782 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756509Ab0CPIFa (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 16 Mar 2010 04:05:30 -0400
Date: Tue, 16 Mar 2010 09:05:28 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Does fio write only 0x00s?
Message-ID: <20100316080528.GX5768@kernel.dk>
References: <4B9E9D92.80701@arvin.dk> <20100315212219.GQ5768@kernel.dk> <4B9EC06E.2000101@arvin.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9EC06E.2000101@arvin.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Troels Arvin <troels@arvin.dk>
Cc: fio@vger.kernel.org

On Tue, Mar 16 2010, Troels Arvin wrote:
> Hello,
>
> On Mar 15, Jens Axboe wrote:
>> By default, fio will at init time randomly fill the buffer of the
>> allocated IO units. If you are using the sync io engine, then only one
>> buffer will be allocated and that will be repeatedly written. So yes,
>> that'll compress very nicely.
>
> I'm using libaio. So the data from that shouldn't compress all that much?

Each buffer used will have different contents, so it'll depend on how
large the file is. If you end up writing the same 256 buffers (in your
case) thousands of time, the output will still be compressible.

>> You can enable refill_buffers=1 and
>> that'll cause fio to randomly fill it everytime it's submitted instead.
>> That should effectively disable compression at the storage end.
>
> Turning refill_buffers on or off doesn't seem to make much of a  
> difference when compressing fil's work-file with "gzip -2" (201MB vs  
> 198MB). But perhaps, "gzip -2" still compreses more than one can expect  
> from a storage system?

Hard to say really, if it's inline compression then perhaps not as
strong, background data-dedup could be a lot stronger.

> I'm probably missing something. Here's the job description file I'm  
> using (in this case only testing a small amount of I/O; when I was  
> testing the storage systems, I used size=10g and six numjobs=6):
> ===========================================================
> [global]
> description=Emulation of Intel IOmeter File Server Access Pattern
>
> [iometer]
> bssplit=512/10:1k/5:2k/5:4k/60:8k/2:16k/4:32k/4:64k/10
> rw=randrw
> rwmixread=70
> direct=1
> size=1g
> ioengine=libaio
> iodepth=256
> refill_buffers=0
> ===========================================================

I think what you are missing is that the random writes will create a
large sparse file. The Output is 10G, and you are doing a lot of reads.
So you could end up writing only 30% of the 10G, the rest would be
sparse holes in the file.

-- 
Jens Axboe

