Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:45466
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206Ab1INRjI (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 14 Sep 2011 13:39:08 -0400
Message-ID: <4E70E6BB.6060708@kernel.dk>
Date: Wed, 14 Sep 2011 19:39:07 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: memory leak bug? when do write with verify
References: <CADson1wk9astwdroeAtPXb4A3+yrAcDcCXaEPvEGJPhM4TBfqQ@mail.gmail.com> <CADson1wi5=W-WDbDGy1j2T4FZD_2yoGGzOG8Af7GKKppiY7Lrg@mail.gmail.com>
In-Reply-To: <CADson1wi5=W-WDbDGy1j2T4FZD_2yoGGzOG8Af7GKKppiY7Lrg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Zhang Taile <zhangtl@gmail.com>
Cc: fio@vger.kernel.org

On 2011-09-14 11:53, Zhang Taile wrote:
> HI
> When I do RandWrite with verify, fio will use a lot of memory. The fio
> will increase memory about 10MB in every second. And, the system will
> become very slow, after fio start to use swap partition.
> 
> For example,  if use fio with following configuration,
> [rand-write]
> rw=randwrite
> numjobs=32
> loops=10
> thread=1
> filename=/dev/sdb
> verify=md5
> verify_interval=4k
> 
> after  minutes, top will Like this :
>  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>  3749 root      15   0 2672m 1.5g 304m S 169.4 40.4   4:10.04 fio
> 
> 
> If remove the verify from the configuration, there will be no the
> memory problem.
> 
> I guess it is a memory leak problem?

It's probably not a leak, fio will use a lot of memory for your job
file. Each job will maintain a full backlog of meta data for blocks
written, so it can safely verify it. And you have 32 jobs, so it'll be a
lot of memory.

-- 
Jens Axboe

