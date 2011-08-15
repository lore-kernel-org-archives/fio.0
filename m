Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:54113 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab1HOI35 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 15 Aug 2011 04:29:57 -0400
Message-ID: <4E48D901.6030603@fusionio.com>
Date: Mon, 15 Aug 2011 10:29:53 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: fio memory allocation problems
References: <4E453BE0.5060708@cesnet.cz>
In-Reply-To: <4E453BE0.5060708@cesnet.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jiri Horky <jiri.horky@cesnet.cz>
Cc: fio@vger.kernel.org, 'Jan Furman' <Jan.Furman@cesnet.cz>, =?UTF-8?B?UGV0ZXIgVmVyxI1pbcOhaw==?= <peter.vercimak@cesnet.cz>

On 2011-08-12 16:42, Jiri Horky wrote:
> Hi,
> 
> I think I found a bug. If the device (file) used in fio has "wrong" size, and is used with "wrong" block size, the fio fails to allocate memory for randommap.
> Following conditions must be true, considering just one thread for simplicity:
> 
>  1) number of blocks on the device are too big to fill in the default's pool
>  2) number of blocks on the device must be "right", so the size of newly allocated pool by smalloc.c:add_pool is exactly as big as requested size (there are some roundings in place, so not every size triggers this error)
> 
> When this is true, function smalloc.c:__smalloc_pool fails to use the newly created (exactly big enough) pool, because of this line:
> 
>                 idx = find_next_zero(pool->bitmap[i], last_idx);
> 
> which always returns non-zero value (the minimum returned value is last_idx +1), and so in our case the idx is 1 even though, the block number 0 is free. As the direct consequence, the function doesn't find enough free space in the given pool and returns NULL pointer. This leads to another try to allocate enough memory in smalloc.c:smalloc_real function, and so on...
> 
> The behavior could be reprocuded using both stable 1.57 and git version of the tool. The values that triggers the error are:
> init_random_map - real_file_size: 21999995584512, o.rw_min_bs: 4096, blocks: 5371092672, num_maps: 83923323, alloc size: 671386584
> 
> whereas this block device is fine:
> init_random_map - real_file_size: 19999995985920, o.rw_min_bs: 4096, blocks: 4882811520, num_maps: 76293930, alloc size: 610351440
> 
> the configuration file used:
> 
> [global]
> description=CESNET_test
> [cesnet]
> filename=/dev/sdd
> rw=randread
> size=10000g
> ioengine=libaio
> iodepth=4
> bs=4k
> runtime=10m
> time_based
> numjobs=1
> #norandommap
> group_reporting
> 
> 
> I am not sure I fully understand all the logic in smalloc.c so I am afraid I would break something with a trivial patch.
> 
> Let me know, if you need more information

That does indeed look like a bug in smalloc, bummer. I'll try and take a
look at it, if you do have a test patch you are using, please send it
along.

-- 
Jens Axboe

