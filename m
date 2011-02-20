Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:40502 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892Ab1BTTL4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 20 Feb 2011 14:11:56 -0500
Message-ID: <4D616775.8050908@fusionio.com>
Date: Sun, 20 Feb 2011 20:11:49 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: uneven IOPS among HD
References: <932143.86482.qm@web161913.mail.bf1.yahoo.com>
In-Reply-To: <932143.86482.qm@web161913.mail.bf1.yahoo.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: john smith <whalajam@yahoo.com>
Cc: fio@vger.kernel.org

On 2011-02-17 03:14, john smith wrote:
> I have a couple of questions:
> 
> 1) if it is normal (and if so, why) that while running a number of identical jobs (e.g 4), each bound to a different CPU (cpu_allowed=i) and each performing sequential (bs=512) reads on (e.g. 4) different HD, fio reports IOPS numbers that are highly unbalanced among HD with one HD reporting more than 7x of the IOPS of the minimum IOPS HD.
> Different runs may show most of the IOPS on a different HD, so it's not that one HD is faster.
> 
> Here are some possibly interesting parameters:
> 
> ioengine=libaio
> iodepth=32
> direct=1

There should be very little variance between runs, and between jobs.
Each are separate threads/processes, so most of the variance you will
see will be due to system "artifacts". So I'd suggest you look there. If
you don't pin to specific CPUs, do you see smaller or larger
differences?

Are you doing random or sequential IO? Could also be timing differences
in submission and dispatch from the IO scheduler.

> 2) why increasing "iodepth' (eg to 512) decreses the IOPS results significantly (by 10x)?

You probably don't want a larger depth in fio than the system supports.

-- 
Jens Axboe

