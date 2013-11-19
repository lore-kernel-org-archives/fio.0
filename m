Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:49676 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab3KSV25 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 19 Nov 2013 16:28:57 -0500
Message-ID: <528BD7FD.4060706@kernel.dk>
Date: Tue, 19 Nov 2013 14:28:29 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Blktrace replay in FIO failed with lseek err=22
References: <CAEyTGCcDDgN=5Oa0J_40Q2F=uoGSZkAtrbR0npzjZLzfmSZ=EQ@mail.gmail.com>
In-Reply-To: <CAEyTGCcDDgN=5Oa0J_40Q2F=uoGSZkAtrbR0npzjZLzfmSZ=EQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Lakshmi Devi <sendtold@gmail.com>, fio@vger.kernel.org

On 11/19/2013 10:12 AM, Lakshmi Devi wrote:
> Hi,
> 
> I am using FIO version 2.1.1 and blktrace 2.0.0
> 
> I ran a read, 4K workload through FIO and collected blktrace for it.
> I got like 16 trace files one for each CPU core with varying sizes.
> 
> I parsed one of the files as below
> blkparse -i ./*.blktrace.0 -d ./bp.bin -o bp.txt -w 0:600
> 
> used this bp.bin to perform a read_iolog in FIO.
> 
> When I replay in FIO using read_iolog=/root/bp.bin , I get the below error.
> 
> Replay: (groupid=0, jobs=1): err=22 file engine sync.c: 45, func=lseek,
> error=invalid argument.
> 
> Please help me understand the reason for this error

Would it be possible for you to send me the bp.bin output file?

-- 
Jens Axboe

