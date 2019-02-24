Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2 0/9] ZBD support fixes
References: <20190221041107.8576-1-damien.lemoal@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <683539f2-bad5-7baa-1110-cb595adb45a4@kernel.dk>
Date: Sat, 23 Feb 2019 21:19:26 -0700
MIME-Version: 1.0
In-Reply-To: <20190221041107.8576-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Matias Bjorling <matias.bjorling@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On 2/20/19 9:10 PM, Damien Le Moal wrote:
> This patch series fixes various problems with fio zbd support discovered
> with extensive testing on various test targets (null_blk, iscsi/tcmu
> device, SMR disk, partition devices, etc).
> 
> In more details:
> * Patch 1 fixes the discovery of a block device zone model to correctly
>   handle block devices that are partitions.
> * Patch 2 addresses a problem with the SG engine and devices not
>   supporting the READ CAPACITY(10) command.
> * Patch 3 cleans up the SG engine code with helper functions to handle
>   big-endian SCSI cdb fields.
> * Patch 4 to 6 fix the zbd support tests to avoid incorrect failures
>   reports.
> * Patch 7 and 8 fix zone locking handling to avoid write command
>   reordering with multi-jobs workloads with asynchronous I/O engines.
>   These changes do have a significant impact on the performance reported
>   for very small (test) devices with a high number of jobs. The worst
>   degradation observed result in libaio performance being equal to that
>   of the synchronous psync engine. There is however no noticeable
>   performance degradation with real disks as the large number of zones
>   with these drives do not cause excessive zone lock contention.
> * Patch 9 introduces a new zbd test case 46 to test asynchronous
>   muli-job writes.
> 
> All these fixes are necessary for correctly running blktests with
> different target devices, and to also implement further blktests
> zbd test group to improve test coverage.
> 
> As always, comments are very welcome.

Applied, thanks.

-- 
Jens Axboe


