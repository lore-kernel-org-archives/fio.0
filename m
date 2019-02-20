Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
Message-ID: <1550678420.93548.19.camel@acm.org>
Subject: Re: [PATCH 1/8] zbd: Fix partition block device handling
From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 20 Feb 2019 08:00:20 -0800
In-Reply-To: <20190220071725.8487-2-damien.lemoal@wdc.com>
References: <20190220071725.8487-1-damien.lemoal@wdc.com>
	 <20190220071725.8487-2-damien.lemoal@wdc.com>
Content-Type: text/plain; charset="UTF-7"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Matias Bjorling <matias.bjorling@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On Wed, 2019-02-20 at 16:17 +-0900, Damien Le Moal wrote:
+AD4 From: Shin'ichiro Kawasaki +ADw-shinichiro.kawasaki+AEA-wdc.com+AD4
+AD4 
+AD4 For fio to correctly handle the zonemode+AD0-zbd mode with partitions of
+AD4 zoned block devices, the partition block device file must be identified
+AD4 as a zoned disk. However, partition block device files do not have
+AD4 a zoned sysfs file. This patch allows a correct identification of the
+AD4 device file zone model by accessing the sysfs +ACI-zoned+ACI file of the
+AD4 holder disk for partition devices.
+AD4 
+AD4 Change get+AF8-zbd+AF8-model() function to resolve the symbolic link to the
+AD4 sysfs path to obtain the canonical sysfs path. The canonical sysfs
+AD4 path of a partition device includes both of the holder device name and
+AD4 the partition device name. If the given device is a partition device,
+AD4 cut the partition device name in the canonical sysfs path to access
+AD4 the +ACI-zoned+ACI file in the holder device sysfs path.

Please explain what makes you think that it makes sense to create
partitions on a zoned block device. An application that wants to write
to a partition of a zoned block device needs access to the whole disk
anyway to get permission to submit the BLKREPORTZONE and BLKRESETZONE
ioctls. So why would anyone create partitions on a zoned block device?

Thanks,

Bart.

