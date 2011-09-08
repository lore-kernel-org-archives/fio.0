Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:33194
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367Ab1IHLc2 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 8 Sep 2011 07:32:28 -0400
Message-ID: <4E68A7C9.1020702@kernel.dk>
Date: Thu, 08 Sep 2011 13:32:25 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: problem while executing fio on multiple disks
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B02CF0A@MYMBX.MY.STEC-INC.AD>
In-Reply-To: <C4B5704C6FEB5244B2A1BCC8CF83B86B02CF0A@MYMBX.MY.STEC-INC.AD>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Shrirang Phansalkar <sphansalkar@stec-inc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Prasad Joshi <pjoshi@stec-inc.com>

On 2011-09-08 11:55, Shrirang Phansalkar wrote:
> Hi,
> 
> I was trying to execute fio with the following job file, but I have some issues with it.
> 
> [globals]
> rw=randrw
> size=10M
> ioengine=sync
> blocksize=4k
> numjobs=16
> direct=1
> iodepth=32
> thread
> 
> [thread1]
> filename=/dev/sdb
> stonewall
> 
> [thread2]
> filename=/dev/sdc
> stonewall
> 
> [thread3]
> filename=/dev/sdd
> stonewall
> 
> 
> After its completion in Disk stats I got util as :
> 
> sdb: util=99.64%
> sdc: util=51.72%
> sdd: util=34.76%
> 
> where as expected util for all 3 disks should be somewhat similar ( all 3 disks are of same size)
> 
> But if I run fio using separate jobfile for every disk, then I am getting almost similar disk util for each disk (around util=98% for each disk).
> 
> Pl let me know that if there is some problem with the fio or there is something wrong with my jobfile.

Hmm, I'm assuming the performance is about the same (whether run with
this file, or separately)?

Looks like the utilization is done prior to the job being started, hence
you get ~100%, ~50%, and ~33%. So looks like just an accounting bug,
I'll take a look at it.

-- 
Jens Axboe

