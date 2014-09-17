Return-Path: <axboe@kernel.dk>
Message-ID: <5418EDC2.6080203@kernel.dk>
Date: Tue, 16 Sep 2014 20:11:14 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] fio: print io_u errors on one line
References: <20140916220631.32299.39978.stgit@beardog.cce.hp.com>
In-Reply-To: <20140916220631.32299.39978.stgit@beardog.cce.hp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Robert Elliott <relliott@beardog.cce.hp.com>, elliott@hp.com, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-09-16 16:09, Robert Elliott wrote:
> From: Robert Elliott <elliott@hp.com>
>
> Print io_u errors on one line and with one log_err command
> to keep them from being interrupted by other prints
>
> Old:
> fio: io_u error on file /dev/sdt: Input/output error5.1MB/0KB/0KB /s]
> [227K/0/0 iops] [eta 02d:10h:53m:36s]
>       read offset=145442430976, buflen=4096
> fio: io_u error on file /dev/sdt: Input/output error
>       read offset=397760724992, buflen=4096
>
> New:
> fio: io_u error on file /dev/sdr: Input/output error: write offset=1532626153472, buflen=4096
> fio: io_u error on file /dev/sdt: Input/output error: write offset=102684229632, buflen=4096

Thanks, applied.

-- 
Jens Axboe


