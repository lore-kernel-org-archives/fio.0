Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:53300 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292Ab3CGLiE (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 7 Mar 2013 06:38:04 -0500
Date: Thu, 7 Mar 2013 12:37:43 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: fio-2.0.14 crashes with "Assertion failed: (data->fail_ok),
 function axmap_set_fn, file lib/axmap.c, line 233."
Message-ID: <20130307113743.GL1059@kernel.dk>
References: <1404460263.20130306190819@serebryakov.spb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404460263.20130306190819@serebryakov.spb.ru>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Lev Serebryakov <lev@serebryakov.spb.ru>
Cc: fio@vger.kernel.org

On Wed, Mar 06 2013, Lev Serebryakov wrote:
> Hello, Fio.
> 
>   FreeBSD 9.1-STABLE, dual-core machine with 6GiB of physical RAM, job
>  file with 8 jobs with filesize=1G-2G (attached).
> 
>    fio --latency-log --bandwidth-log torrent-like.fio
> 
>  crashes after file layout:
> 
> file-1: (g=0): rw=randrw, bs=64-64/128K-128K/128K-128K, ioengine=psync, iodepth=1
> file-2: (g=0): rw=randrw, bs=64-64/128K-128K/128K-128K, ioengine=psync, iodepth=1
> file-3: (g=0): rw=randrw, bs=64-64/128K-128K/128K-128K, ioengine=psync, iodepth=1
> file-4: (g=0): rw=randrw, bs=64-64/128K-128K/128K-128K, ioengine=psync, iodepth=1
> file-5: (g=0): rw=randrw, bs=64-64/128K-128K/128K-128K, ioengine=psync, iodepth=1
> file-6: (g=0): rw=randrw, bs=64-64/128K-128K/128K-128K, ioengine=psync, iodepth=1
> file-7: (g=0): rw=randrw, bs=64-64/128K-128K/128K-128K, ioengine=psync, iodepth=1
> file-8: (g=0): rw=randrw, bs=64-64/128K-128K/128K-128K, ioengine=psync, iodepth=1
> fio-2.0.14
> Starting 8 threads
> file-1: Laying out IO file(s) (1 file(s) / 1910MB)
> file-2: Laying out IO file(s) (1 file(s) / 1910MB)
> file-3: Laying out IO file(s) (1 file(s) / 1910MB)
> file-4: Laying out IO file(s) (1 file(s) / 1910MB)
> file-5: Laying out IO file(s) (1 file(s) / 1910MB)
> file-6: Laying out IO file(s) (1 file(s) / 1910MB)
> file-7: Laying out IO file(s) (1 file(s) / 1910MB)
> file-8: Laying out IO file(s) (1 file(s) / 1910MB)
> Assertion failed: (data->fail_ok), function axmap_set_fn, file lib/axmap.c, line 233.

I've noticed that you used bs= and gave a range, that wont work. Fio
should fail to parse that, but alas, it does not and you get this:

        file-8: (g=0): rw=randrw, bs=64-64/128K-128K/128K-128K, ioengine=psync, iodepth=1

which is 64b reads, 128K writes, 128K trims. I will look into why this
doesn't fail to parse, but in the mean time, you want to use
bsrange=64k-128k which will do what you intend it to.

-- 
Jens Axboe

