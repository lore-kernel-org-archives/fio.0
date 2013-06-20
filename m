Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60224 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3FTHdS (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 20 Jun 2013 03:33:18 -0400
Date: Thu, 20 Jun 2013 09:33:14 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: meaning of err=84
Message-ID: <20130620073314.GY21663@kernel.dk>
References: <EEF9E3C12F20174DA289A981D6CCA6C8324642B5C2@MX44A.corp.emc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EEF9E3C12F20174DA289A981D6CCA6C8324642B5C2@MX44A.corp.emc.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Ruvinsky, Konstantin" <Konstantin.Ruvinsky@emc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Fri, Jun 14 2013, Ruvinsky, Konstantin wrote:
> Hi,
> 
> Running the following fio command in Red Hat 6.1
> 
> fio --name=myjob --ioengine=libaio --rw=randrw --bs=8k --numjobs=64 --thread  --direct=1 --size=400m --directory=/mnt --rwmixread=50 --rwmixwrite=50 --do_verify=1 --verify=md5 --verify_fatal=1
> 
> I got the error message:
> 
> myjob: (groupid=0, jobs=1): err=84 (file:io_u.c:1477, func=io_u_queued_complete, error=Invalid or incomplete multibyte or wide                                   character): pid=29170: Thu Jun 13 11:56:04 2013
> 
> fio returns 1280 (0x500)
> 
> What is the meaning of this error message?

It means you got a verification failure, comparing the data read back to
the expected results.

-- 
Jens Axboe

