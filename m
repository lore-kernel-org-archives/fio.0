Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:47378 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758591Ab2JYIU7 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 25 Oct 2012 04:20:59 -0400
Message-ID: <5088F648.4010606@kernel.dk>
Date: Thu, 25 Oct 2012 10:20:24 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Anyone doing async I/O on FreeBSD?
References: <CAEQv8RE=W_7RShF-ce1kV1V9VaFSBC4hq=QbxEy9GNHYXDo+uw@mail.gmail.com>
In-Reply-To: <CAEQv8RE=W_7RShF-ce1kV1V9VaFSBC4hq=QbxEy9GNHYXDo+uw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tom Blamer <blamer@gmail.com>
Cc: fio@vger.kernel.org

On 2012-10-24 23:45, Tom Blamer wrote:
> On a clean install of 9.0-RELEASE, fio-2.0.10 built from source, any
> job with posixaio fails with a "Function not implemented" error (see
> below).
> 
> It looks like the ports collection contains some kind of emulation
> tool for libaio (linux-libaio), should I be looking into that?
> 
> bsdserv1# cat doit.job
> [doit]
> thread
> ioengine=posixaio
> iodepth=2
> size=16M
> nrfiles=1
> rw=rw
> rwmixread=90
> 
> bsdserv1# fio doit.job
> doit: (g=0): rw=rw, bs=4K-4K/4K-4K/4K-4K, ioengine=posixaio, iodepth=2
> fio-2.0.10
> Starting 1 thread
> fio: pid=100082, err=78/file:engines/posixaio.c:198, func=xfer,
> error=Function not implemented

That's aio_read or aio_write returning -1/ENOSYS, which means that it's
not implemented. From a quick google, on FreeBSD, it seems you need to
have a kernel compiled with VFS_AIO enabled. Not sure why that isn't the
default...

-- 
Jens Axboe

