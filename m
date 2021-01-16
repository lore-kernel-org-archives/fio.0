Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Fix a rate limit issue.
References: <CAKvRR0Sch-xwyoG+MuyPANHD5Y+Gzd+o7m0gK27sCveKyXe_ig@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <ffcf64ff-e6b9-ccc9-2607-55df278c7ade@kernel.dk>
Date: Sat, 16 Jan 2021 11:58:49 -0700
MIME-Version: 1.0
In-Reply-To: <CAKvRR0Sch-xwyoG+MuyPANHD5Y+Gzd+o7m0gK27sCveKyXe_ig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Hongwei Qin <glqinhongwei@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 1/16/21 11:45 AM, Hongwei Qin wrote:
> In the current implementation, should_check_rate() returns false
> if ddir_rw_sum(td->bytes_done)==0. Therefore, a thread may violate
> the rate if iodepth*bs > rate.
> 
> This patch addresses the issue by not checking td->bytes_done in
> should_check_rate.
> 
> An example of the issue:
> 
> [root@localhost test]# cat fio_randwrite
> [global]
> thread
> kb_base=1000
> direct=1
> size=28GiB
> group_reporting
> io_size=16384
> ioengine=libaio
> iodepth=2
> bs=4096
> iodepth_batch_submit=1
> iodepth_batch_complete=1
> filename=/dev/qblkdev
> 
> [fio_randwrite]
> rw=randwrite
> rate_iops=,1
> iodepth_batch_submit=1
> thinktime_blocks=1
> rate_cycle=1000
> thinktime=3s
> rate_ignore_thinktime=1
> 
> [root@localhost test]# fio fio_randwrite
> 
> blktrace output:
> 259,1   11        1     0.100550729  6135  Q  WS 3541608 + 8 [fio]
> 259,1   11        2     0.100552183  6135  G  WS 3541608 + 8 [fio]
> 259,1   11        3     0.100560373  6135  D  WS 3541608 + 8 [fio]
> 259,1   11        4     0.100570436  6135  C  WS 3541608 + 8 [0]
> 259,1   11        5     0.100599816  6135  Q  WS 43470024 + 8 [fio]
> 259,1   11        6     0.100600513  6135  G  WS 43470024 + 8 [fio]
> 259,1   11        7     0.100601579  6135  D  WS 43470024 + 8 [fio]
> 259,1   11        8     0.100612750  6135  C  WS 43470024 + 8 [0]
> 259,1   11        9     3.101034407  6135  Q  WS 49511928 + 8 [fio]
> 259,1   11       10     3.101036067  6135  G  WS 49511928 + 8 [fio]
> 259,1   11       11     3.101054487  6135  D  WS 49511928 + 8 [fio]
> 259,1   11       12     3.101068699  6135  C  WS 49511928 + 8 [0]
> 259,1   11       13     6.101267480  6135  Q  WS 27599368 + 8 [fio]
> 259,1   11       14     6.101269216  6135  G  WS 27599368 + 8 [fio]
> 259,1   11       15     6.101277050  6135  D  WS 27599368 + 8 [fio]
> 259,1   11       16     6.101287956  6135  C  WS 27599368 + 8 [0]

Your mailer has manged the patch. But I think it needs changes anyway,
so that's ok.

With your change, __should_check_rate() and should_check_rate() as the
same thing. You should rename __should_check_rate() to
should_check_rate(), get rid of the existing should_check_rate(), and
update callers that are currently using the __ version to using
should_check_rate(). Then your fix becomes and actual cleanup too, which
is nice.

-- 
Jens Axboe


