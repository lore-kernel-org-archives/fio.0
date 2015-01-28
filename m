Return-Path: <axboe@kernel.dk>
Message-ID: <54C90A47.8050901@kernel.dk>
Date: Wed, 28 Jan 2015 09:11:51 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] dedupe_percentage should work even if compress_percentage
 is not set
References: <20150127192448.GA16313@vass-desktop>
In-Reply-To: <20150127192448.GA16313@vass-desktop>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Vasily Tarasov <tarasov@vasily.name>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 01/27/2015 12:24 PM, Vasily Tarasov wrote:
> [PATCH] dedupe_percentage should work even if compress_percentage is not set
>
> Currently dedupe_percentage option does not work properly if compress_percentage
> is not set. This can be easily demonstrated using the following job file:
>
> [job-/dev/dm-0]
> filename=/dev/dm-0
> rw=randwrite
> blocksize=4096
> direct=1
> ioengine=libaio
> iodepth=32
> dedupe_percentage=50
> time_based=1
> runtime=5
> numjobs=1
>
> All writes will contain zeroes for the above job file.
>
> The problem is in fill_io_buffer() function that switches dedupe random state
> only if o->compress_percentage is set.
>
> This patch updates the condition appropriately in fill_io_buffer()
> appropriately.

Thanks, looks good, applied.

-- 
Jens Axboe


