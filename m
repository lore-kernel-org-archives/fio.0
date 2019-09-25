Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] Extend file size for 'null' and 'filecreate'
 ioengines
References: <20190925082924.9771-1-shinichiro.kawasaki@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <0767e4be-705e-5d8e-5281-81a0a3f62b96@kernel.dk>
Date: Wed, 25 Sep 2019 11:12:18 +0200
MIME-Version: 1.0
In-Reply-To: <20190925082924.9771-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org
Cc: Vincent Fu <Vincent.Fu@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Masato Suzuki <masato.suzuki@wdc.com>
List-ID: <fio@vger.kernel.org>

On 9/25/19 10:29 AM, Shin'ichiro Kawasaki wrote:
> The commit ad46c5715ffc "filesetup: honor the offset option" intended to fix
> a failure observed with null ioengine, but it affected all other ioengines. It
> changed io_size and caused t/zbd/test-zbd-support test script failures for
> zoned block devices.
> 
> This patch series suggests to replace the commit with the better fix which
> affects only null ioengine and filecreate ioengine. The cause of the failure was
> that fio does not extend file size even when it is smaller than io_size + offset
> if null ioengine is set. This failure is observed also for filecreate ioengine.
> The first patch reverts the fix affecting all ioengines. The second patch
> extends file size for null ioengine and filecreate ioengine when file size is
> smaller than io_size + offset.

Applied, thanks.

-- 
Jens Axboe


