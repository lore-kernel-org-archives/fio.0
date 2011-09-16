Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:33406 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490Ab1IPGTT (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 16 Sep 2011 02:19:19 -0400
Message-ID: <4E72EA62.5080709@fusionio.com>
Date: Fri, 16 Sep 2011 08:19:14 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: [PATCH RESEND] Fix sum_stat() bug in group_reporting.
References: <1316145305-10492-1-git-send-email-gnehzuil@gmail.com>
In-Reply-To: <1316145305-10492-1-git-send-email-gnehzuil@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Zheng Liu <gnehzuil@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Zheng Liu <wenqing.lz@taobao.com>, Yu-ju Hong <yjhong@google.com>

On 2011-09-16 05:55, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Write samples in io_stat does not be counted with rw=randread, vice versa.
> Then, in sum_stat() function, it will cause 0/0 in calculating mean and S,
> and 'nan' is printed. So it should return immediately when src->samples is
> equal to 0.
> 
> the error result is as follows:
>   write: io=8328.0KB, bw=1582.7KB/s, iops=395 , runt=  5262msec
>     clat (usec): min=58 , max=293353 , avg= -nan, stdev= -nan
>      lat (usec): min=59 , max=293353 , avg= -nan, stdev= -nan
>     bw (KB/s) : min=   92, max=  804, per=-nan%, avg= -nan, stdev= -nan
> 
> the configuration file used:
> 
> [global]
> direct=1
> ioengine=psync
> bs=4k
> filename=/dev/sdb1
> runtime=5
> group_reporting
> loops=50
> 
> [read]
> rw=randread
> numjobs=8
> 
> [write]
> rw=randwrite
> numjobs=8
> 
> CC: Jens Axboe <jaxboe@fusionio.com>
> CC: Yu-ju Hong <yjhong@google.com>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  stat.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/stat.c b/stat.c
> index d2cc775..3662fd9 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -618,6 +618,9 @@ static void sum_stat(struct io_stat *dst, struct io_stat *src, int nr)
>  {
>  	double mean, S;
>  
> +	if (src->samples == 0)
> +		return;
> +
>  	dst->min_val = min(dst->min_val, src->min_val);
>  	dst->max_val = max(dst->max_val, src->max_val);

Looks good, applied. Thanks!

-- 
Jens Axboe

