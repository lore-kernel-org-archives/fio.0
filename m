Return-Path: <axboe@kernel.dk>
Message-ID: <54930AD8.5060800@kernel.dk>
Date: Thu, 18 Dec 2014 10:11:52 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Fwd: Huge eta with R/W mix job and job hangs
References: <CAEyTGCfpBS1jE09EkGVFyMU5mn4Rtpt6aozdyyid2bxke+QvVQ@mail.gmail.com>	<CAEyTGCc1W7J60WXQ3uLFHxpsV-pM3tbqWPxTzjWWUcLgHyd8wg@mail.gmail.com>	<549233BF.1020408@kernel.dk> <CAEyTGCdHacdp02U8iNe5TEkvkD25Qs-=BNTgw4q4N4DzFdWyhw@mail.gmail.com>
In-Reply-To: <CAEyTGCdHacdp02U8iNe5TEkvkD25Qs-=BNTgw4q4N4DzFdWyhw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Lakshmi <sendtold@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/18/2014 10:08 AM, Lakshmi wrote:
> Hi Jens,
>     Updated to 2.2.0 and I am still seeing the same issue.
> ==========================================
>
> # fio FIO_Test.job
> test: (g=0): rw=randrw, bs=71K-71K/20K-20K/20K-20K, ioengine=posixaio,
> iodepth=32
> ...
> fio-2.2.0
> Starting 64 processes
> Jobs: 10 (f=10):
> [_(18),m(1),_(1),m(1),_(8),m(1),_(1),m(1),_(4),m(1),_(2),m(1),_(1),m(1),_(3),m(2),_(12),m(1),_(4)]
> [1.9% done] [301.4MB/0KB/0KB /s] [4425/0/]
> Jobs: 10 (f=10):
> [_(18),m(1),_(1),m(1),_(8),m(1),_(1),m(1),_(4),m(1),_(2),m(1),_(1),m(1),_(3),m(2),_(12),m(1),_(4)]
> [1.9% done] [0KB/0KB/0KB /s] [0/0/0 iops]
> Jobs: 10 (f=10):
> [_(18),m(1),_(1),m(1),_(8),m(1),_(1),m(1),_(4),m(1),_(2),m(1),_(1),m(1),_(3),m(2),_(12),m(1),_(4)]
> [2.0% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta 26m:57s]
> ..................................
>
> Jobs: 10 (f=10):
> [_(18),m(1),_(1),m(1),_(8),m(1),_(1),m(1),_(4),m(1),_(2),m(1),_(1),m(1),_(3),m(2),_(12),m(1),_(4)]
> [0.0% done] [0KB/0KB/0KB /s] [0/0/0 iops]Jobs: 10 (f=10):
> [_(18),m(1),_(1),m(1),_(8),m(1),_(1),m(1),_(4),m(1),_(2),m(1),_(1),m(1),_(3),m(2),_(12),m(1),_(4)]
> [0.0% done] [0KB/0KB/0KB /s] [0/0/0 iops]Killed1158050441d:06h:30m:16s]

Can you send fio a SIGILL and have it dump core, and then bzip2 that 
core up and store it somewhere where I can reach it?

-- 
Jens Axboe


