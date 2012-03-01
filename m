Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56976 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758233Ab2CANCp (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 1 Mar 2012 08:02:45 -0500
Message-ID: <4F4F736C.1030508@kernel.dk>
Date: Thu, 01 Mar 2012 14:02:36 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: verify seems not to take place on iSCSI-Target writing
References: <DIIE.00000F160002E4D3@192.168.0.5>
In-Reply-To: <DIIE.00000F160002E4D3@192.168.0.5>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?UTF-8?B?U3RlZmFuIEjDvGJuZXI=?= <shu@wwwgroup.de>
Cc: fio@vger.kernel.org

On 03/01/2012 11:09 AM, Stefan Hübner wrote:
> Hi List,
> 
> I'm using this FIO-job to stress-test iSCSI-Targets:
> 
> [global]
> disable_lat=1
> disable_clat=1
> disable_slat=1
> clat_percentiles=0
> time_based
> runtime=${SECONDS}
> nice=10
> prio=5
> ioengine=libaio
> iodepth=16
> direct=1
> iomem_align=4M
> verify=crc32c-intel
> verify_async=2
> do_verify=1
> verify_dump=1
> [iSCSI]
> rw=randwrite
> bsrange=4k-4M
> filename=${ISCSI_DEVICE}
> 
> ISCSI_DEVICE=/dev/sdX
> SECONDS=some value how long it should take
> 
> When running this job I cannot see the verification taking place.  I.e. network thruput to the target (writing) is happening at around 115MB/s, but thruput from the target (reading/verifying) doesn't exceed 2,7MB/s.
> 
> Am I doing something wrong, here?

Does the fio job transition to the verify phase? You can see that in the
[] listing, a V would be the verify. When the job exits, it also shows
you both how many bytes were read and written. The read could should be
the verified part.

So please post the output of the job so we can take a closer look.

-- 
Jens Axboe

