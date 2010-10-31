Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:37839 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420Ab0JaM2f (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 31 Oct 2010 08:28:35 -0400
Message-ID: <4CCD60F0.4020608@fusionio.com>
Date: Sun, 31 Oct 2010 08:28:32 -0400
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: fio: first direct IO errored
References: <4CCC1540.6090405@xmerlin.org> <4CCCCC11.7010203@fusionio.com> <4CCD5D6A.4000103@xmerlin.org>
In-Reply-To: <4CCD5D6A.4000103@xmerlin.org>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Christian Zoffoli <czoffoli@xmerlin.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2010-10-31 08:13, Christian Zoffoli wrote:
> Il 31/10/2010 02:53, Jens Axboe ha scritto:
> [cut]
>>
>> So you get -1/EINVAL on the issued IO. For O_DIRECT, this will typically
>> happen for one (or more) of these reasons:
>>
>> - The file system doesn't support O_DIRECT, as fio suggests. Since it
>>   works for your other test, we can safely discount that reason.
>>
>> - The block size is not a multiple of the block size of the device. I'm
>>   guessing this is your problem. You are using 1K block sizes, if your
>>   dm device has a larger block size, then this will not work.
>>
>> It's not likely to be iomem_align, it's more likely to be due to bs=1k
>> just being too small for your setup. To be sure, please provide a:
>>
>> $ grep . /sys/block/dm-0/queue/*
>>
>> for dm-0.
>>
> 
> Hi Jens
> 
> here is the output
> 
> /sys/block/dm-0/queue/discard_granularity:0
> /sys/block/dm-0/queue/discard_max_bytes:0
> /sys/block/dm-0/queue/discard_zeroes_data:0
> /sys/block/dm-0/queue/hw_sector_size:4096
> /sys/block/dm-0/queue/iostats:1
> /sys/block/dm-0/queue/logical_block_size:4096
> /sys/block/dm-0/queue/max_hw_sectors_kb:32767
> /sys/block/dm-0/queue/max_sectors_kb:512
> /sys/block/dm-0/queue/max_segment_size:65536
> /sys/block/dm-0/queue/max_segments:128
> /sys/block/dm-0/queue/minimum_io_size:4096
> /sys/block/dm-0/queue/nomerges:0
> /sys/block/dm-0/queue/nr_requests:128
> /sys/block/dm-0/queue/optimal_io_size:0
> /sys/block/dm-0/queue/physical_block_size:4096
> /sys/block/dm-0/queue/read_ahead_kb:128
> /sys/block/dm-0/queue/rotational:1
> /sys/block/dm-0/queue/rq_affinity:1
> /sys/block/dm-0/queue/scheduler:noop deadline [cfq]

The exposed hw block size is 4096 bytes, so that is also the mimimum
size at which you can issue unbuffered IO. Your test will work if you
change the bs=1k to bs=4k.

-- 
Jens Axboe

