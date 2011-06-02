Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:41804 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203Ab1FBLvg (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 2 Jun 2011 07:51:36 -0400
Message-ID: <4DE77932.10809@fusionio.com>
Date: Thu, 2 Jun 2011 13:51:14 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Unaligned AIO/DIO
References: <4DE531D0.40600@arvin.dk> <4DE61875.4070501@fusionio.com> <4DE635E0.8060808@arvin.dk> <4DE63BE8.60105@fusionio.com> <4DE64DC5.3060703@arvin.dk>
In-Reply-To: <4DE64DC5.3060703@arvin.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Troels Arvin <troels@arvin.dk>
Cc: fio@vger.kernel.org

On 2011-06-01 16:33, Troels Arvin wrote:
> Hello,
> 
> Jens Axboe wrote:
>> The iometer like test
>> case you are using is meant to be used on a raw block device, not on a
>> file system.
> 
> OK, but how does one use fio with a raw device? Can you give an example of a job specification file for working with a raw block device?

To take your example:

[global]
bssplit=512/10:1k/5:2k/5:4k/60:8k/2:16k/4:32k/4:64k/10
rw=randrw
rwmixread=70
direct=1
size=10g
ioengine=libaio
iodepth=256
write_bw_log
write_lat_log
numjobs=6

[sda]
filename=/dev/sda

would run the workload in question directly on the raw sda device.

> And can that be done in a way which simulates parallel I/O (several
> processes/threads working simultaneously)?

For the above example, you have 6 processes doing random read/write
patterns with the 70/30 read/write mix and with the block sizes given.

-- 
Jens Axboe

