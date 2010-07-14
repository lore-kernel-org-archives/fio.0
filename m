Return-Path: <fio-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46744 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab0GNGdm (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 14 Jul 2010 02:33:42 -0400
Message-ID: <4C3D5A43.6020005@fusionio.com>
Date: Wed, 14 Jul 2010 08:33:39 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Patch to re-use already filled up pattern in io buffers
References: <AANLkTinGG7P6hY4ltETjYGkQVV51VfiiqBPRzM0SSzhu@mail.gmail.com>
In-Reply-To: <AANLkTinGG7P6hY4ltETjYGkQVV51VfiiqBPRzM0SSzhu@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: fio@vger.kernel.org

On 07/14/2010 02:13 AM, Radha Ramachandran wrote:
> Hi Jens,
> I made changes to fio so we wld re-use the already populated io_u
> buffer (when there is a non-random pattern) during writes. That way
> only the header will be re-calculated for every I/O. This way the
> buffer wld get populated in the beginning and as long as the
> subsequent ios using the same io_u structure are writes and have same
> or less block size, it wld get re-used. If any of the subsequent i/o
> is a read or has a block size greater than the pre-filled one, then
> the buffer is invalidated and will be re-filled at the next write.
> 
> Reason for this risky change: (Performance)
> I tested this change on a tmpfs(with no swap backing), with the
> following config file:
> [sscan_write]
> filename=/mytmpfs/datafile.tmp
> rw=write
> bs=64k
> size=3G
> ioengine=libaio
> iodepth=1024
> iodepth_low=512
> runtime=10800
> bwavgtime=5000
> thread=1
> do_verify=0
> verify=meta
> verify_pattern=0x55aaa55a
> verify_interval=4k
> continue_on_error=1
> 
> fio-1-41-6 gave 306MB/s and the new change had a performance of 1546MB/s
> 
> Side effects/Risks:
> There is a risk with this fix, that if the buffer gets corrupted then
> the subsequent writes will also be corrupt. I think for both
> sequential writes and random writes (with verify, where the I/O log is
> replayed) we shld be able to find the first I/O that started with the
> corruption and if the buffer is getting corrupted, there are other
> issues here.
> 
> Testing:
> I have tested this fix with sequential write(verify)/random read write
> mix combination(with verify).
> 
> I think I have taken care of most of the case, but please let me know
> if there is anything I have missed. I have attached the patch along
> with this email. I think the performance improvement outweighs the
> risk associated with the fix. But I will let you decide if you wld
> like to pick it up.

I will pick this up, the fill time is the reason for some of the
other hoops we jump through to try and avoid that when possible.
I don't think the risk of memory corruption is something we need
to consider. That could just as easily happen after the data
has been read anyway, both cases would result in a verify error.

-- 
Jens Axboe

