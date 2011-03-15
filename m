Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:52065 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758566Ab1COU45 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 15 Mar 2011 16:56:57 -0400
Message-ID: <4D7FD295.6020006@fusionio.com>
Date: Tue, 15 Mar 2011 21:56:53 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: memory caching
References: <C9A519EC.108B4%hussein@cscs.ch>,<4D7FCBDE.2080206@fusionio.com> <8512BC127909424EB483ED236E6AC3C003D6F4@MBX20.d.ethz.ch>
In-Reply-To: <8512BC127909424EB483ED236E6AC3C003D6F4@MBX20.d.ethz.ch>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "N. Harake" <hussein@cscs.ch>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-03-15 21:54, N. Harake wrote:
> 
> Things improved but maybe too much :), I was expecting a 100K IOPS not more
> 
> server1:~ # fio --name=job --directory=/lvm --size=1G --filesize=1G --iodepth=128 --iodepth_batch_complete=8 --iodepth_batch_submit=8 --ioengine=libaio --direct=1 --numjobs=64 --bs= 4096 --rw=randwrite --group_reporting
> Jobs: 50 (f=50): [wwwwww_wwwwwww_wwwwwwwwww_wwwwwwwwwww_www_www_ww_www___ww_w__w_w] [98.3% done] [0K/570.8M /s] [0 /143K iops] [eta 00m:02s]
> 
>   write: io=65536MB, bw=584771KB/s, iops=146192 , runt=114761msec

If you use numjobs=64, you probably don't want 128 for io depth. Not
very realistic, and you'll likely end up running slower than you could.

-- 
Jens Axboe

