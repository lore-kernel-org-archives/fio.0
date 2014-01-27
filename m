Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:36503 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaA0TWQ (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 27 Jan 2014 14:22:16 -0500
Date: Mon, 27 Jan 2014 12:22:15 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: A bug in combining fsrange and verify
Message-ID: <20140127192215.GF2782@kernel.dk>
References: <CAOpYm_W685AkEuFnNZX-m0Jfq+B+crzQv5oEF_Hbvq3XbABhaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOpYm_W685AkEuFnNZX-m0Jfq+B+crzQv5oEF_Hbvq3XbABhaQ@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Wallence Lu <wallencelu@gmail.com>
Cc: fio@vger.kernel.org

On Fri, Jan 24 2014, Wallence Lu wrote:
> Hi,
> 
> I've hit a bug in using the combination of bsrange and verify.
> Basically I want to do a random write test with a variable block size,
> and then verify the content after the write. But for some reason, the
> verify phase fails consistently.
> 
> Linux distribution:
> Ubuntu 12.04.2 LTS, Linux version 3.5.0-23-generic
> $ fio --version
> fio 1.59
> 
> Conf file:
> [global]
> thread=1
> ioengine=libaio
> buffered=0
> direct=1
> runtime=5400
> write_iolog=./w_iolog2
> 
> [rand-write]
> bsrange=512-32K
> filename=disk.raw
> iodepth=1280
> size=256M
> verify=meta
> verify_pattern=0x33
> rw=randwrite
> 
> The output complains as the following:
> Jobs: 1 (f=1): [V] [50.5% done] [0K/0K/0K /s] [0 /0 /0  iops] [eta
> 01m:40s]     verify: bad magic header 0, wanted acca at file
> /home/maohua/test-clone/softwareCache/qemu/iscsi_sdd2/disk.raw offset
> 1179648, length 0
> fio: pid=6118, err=84/file:io_u.c:1477, func=io_u_queued_complete,
> error=Invalid or incomplete multibyte or wide character
> 
> rand-write: (groupid=0, jobs=1): err=84 (file:io_u.c:1477,
> func=io_u_queued_complete, error=Invalid or incomplete multibyte or
> wide character): pid=6118: Fri Jan 24 17:40:16 201

Fio 1.59 is ancient. Please try and reproduce on a recent version and
report back what happens.

-- 
Jens Axboe

