Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] backend: fix switch_ioscheduler()
References: <20210414111056.213360-1-damien.lemoal@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d7a15832-21a1-7d09-5592-236da1d398f9@kernel.dk>
Date: Wed, 14 Apr 2021 08:23:18 -0600
MIME-Version: 1.0
In-Reply-To: <20210414111056.213360-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 4/14/21 5:10 AM, Damien Le Moal wrote:
> If the first file specified for a job is not a block device file, the
> ioscheduler option cannot be used. Trying to use this option can cause a
> crash as that file du (struct disk_util) field is NULL. Prevent such
> crash and signal the error by testing the file type, allowing only files
> with the type FIO_TYPE_BLOCK to proceed with switching the IO scheduler.

I wonder if this shouldn't be a for_each_file() loop, and just skipping
file types that aren't FIO_TYPE_BLOCK, moving the actual switching into
a helper?

-- 
Jens Axboe


