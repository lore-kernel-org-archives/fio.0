Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:39932 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab2DSStz (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 19 Apr 2012 14:49:55 -0400
Message-ID: <4F905E50.9070303@kernel.dk>
Date: Thu, 19 Apr 2012 20:49:52 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio: first direct io errored
References: <CAOipSa2xmUmcNTFT5SSBJ0CnDHEpZVmkekWuSf5BnC47u_s3zA@mail.gmail.com>
In-Reply-To: <CAOipSa2xmUmcNTFT5SSBJ0CnDHEpZVmkekWuSf5BnC47u_s3zA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: bin lin <lbin186@gmail.com>
Cc: fio <fio@vger.kernel.org>

On 2012-04-19 15:56, bin lin wrote:
> Hi, i am a newer with fio. i have written a read_iolog and use fio to
> run the trace in a
> 
> device /dev/sdb1, but it had errors when add --direct=1. the errors is
> as follows:
> 
> replay: (g=0): rw=read, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
> fio 2.0.6
> Starting 1 process
> fio: first direct IO errored. File system may not support direct IO,
> or iomem_align= is bad.
> fio: pid=6363, err=22/file:engines/sync.c:62, func=xfer, error=Invalid argument
> 
> the trace file is as follows:
> fio version 2 iolog
> /dev/sdb1 add
> /dev/sdb1 open
> /dev/sdb1 read 27267456 8
> /dev/sdb1 read 27267560 8
> /dev/sdb1 read 34933120 8
> /dev/sdb1 read 34933128 8
> /dev/sdb1 read 34933136 8
> /dev/sdb1 read 34933144 8
> /dev/sdb1 read 34604888 8
> /dev/sdb1 close
> 
> The filesystem on /dev/sdb1 is ext3 which supports the O_DIRECT, and
> the trace file use
> 
> block size as 512 byte. I do not know where the error is and how to
> solve it ? thanks

What job generated that iolog? The reason is fails is that the transfer
size is 8 _bytes_, it's not sectors. So the above wont work on any
device.

-- 
Jens Axboe

