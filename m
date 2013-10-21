Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37485 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3JURA7 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 21 Oct 2013 13:00:59 -0400
Date: Mon, 21 Oct 2013 11:00:57 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: running FIO w/ 2 parallel processes on the same disk
Message-ID: <20131021170057.GB32366@kernel.dk>
References: <CAAAK+WU-XC-aqAU4iCPLnKLLgAwtKmXMe2NKzGjFRvL34PcsjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAK+WU-XC-aqAU4iCPLnKLLgAwtKmXMe2NKzGjFRvL34PcsjQ@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Brian L." <brianclam@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Thu, Oct 17 2013, Brian L. wrote:
> Hello there,
> 
> I would like to simulate the following workload - 2 process total that
> is contenting for read / write IO on the same disk:
> 
> 1 process is doing a sequential writes
> 1 process is down random reads
> 
> This is my FIO job file:
> 
> ## job file start ##
> 
> [global]
> filename=${mydisk}
> size=5G
> iodepth=${myiodepth}
> bs=${myblocksize}
> ioengine=libaio
> ramp_time=10s
> norandommap=1
> randrepeat=0
> refill_buffers
> group_reporting=1
> direct=1
> end_fsync=0
> invalidate=1
> nice=0
> prio=0
> prioclass=1
> 
> [process_1_seq_write]
> rw=write
> write_bw_log=process_1_seq_write.${mydisksub}
> 
> [process_2_rand_read]
> rw=randread
> write_bw_log=process_2_rand_read.${mydiskzub}
> 
> ## job file end ##
> 
> I have ran it and it looks right but just want to check with someone
> else to valid that it is correct.

Job file does what you describe, so you should be good.

-- 
Jens Axboe

