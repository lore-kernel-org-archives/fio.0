Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:59229 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871Ab1B1NGy (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 28 Feb 2011 08:06:54 -0500
Message-ID: <4D6B9DEC.2080805@fusionio.com>
Date: Mon, 28 Feb 2011 08:06:52 -0500
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: using blktrace, blkparse, and fio
References: <E9E9B636B25C054B8E6B9131614B925A039043FE@EXCHG-BE.marklogic.com> <4D676108.1060700@fusionio.com> <E9E9B636B25C054B8E6B9131614B925A039046CC@EXCHG-BE.marklogic.com>
In-Reply-To: <E9E9B636B25C054B8E6B9131614B925A039046CC@EXCHG-BE.marklogic.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Hsiao Su <Hsiao.Su@marklogic.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-02-25 13:24, Hsiao Su wrote:
> 
> Thanks,
> 
> A follow up question.  Suppose that I use fio directly, without
> blktrace and blkparse.  In this case, I would have to guess the real
> IO workload that my app is doing, and specify that in the job file.
> Would I still have to worry about file system corruption?
> 
> My guess is no for this one, that fio would create its own file for
> replaying the workload.

Depends on what the job looks like. If you stick to writing to files in
a mounted fs, it'll work fine. If you tell fio to use
--filename=/dev/sda or whatever the device is, you'll corrupt the file
system(s) if that job file is doing writes.

-- 
Jens Axboe

