Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
Message-ID: <1550678583.93548.21.camel@acm.org>
Subject: Re: [PATCH 2/8] sg: Avoid READ CAPACITY failures
From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 20 Feb 2019 08:03:03 -0800
In-Reply-To: <20190220071725.8487-3-damien.lemoal@wdc.com>
References: <20190220071725.8487-1-damien.lemoal@wdc.com>
	 <20190220071725.8487-3-damien.lemoal@wdc.com>
Content-Type: text/plain; charset="UTF-7"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Matias Bjorling <matias.bjorling@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On Wed, 2019-02-20 at 16:17 +-0900, Damien Le Moal wrote:
+AD4 From: Dmitry Fomichev +ADw-dmitry.fomichev+AEA-wdc.com+AD4
+AD4 
+AD4 Some SCSI devices (very large disks or SMR zoned disks in particular)
+AD4 do not support the READ CAPACITY(10) command and only reply
+AD4 successfully to the READ CAPACITY(16) command. This patch forces the
+AD4 execution READ CAPACITY(16) if READ CAPACITY(10) fails with
+AD4 CHECK CONDITION.
+AD4 
+AD4 Signed-off-by: Dmitry Fomichev +ADw-dmitry.fomichev+AEA-wdc.com+AD4
+AD4 ---
+AD4  engines/sg.c +AHw 45 +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+----------------
+AD4  1 file changed, 30 insertions(+-), 15 deletions(-)
+AD4 
+AD4 diff --git a/engines/sg.c b/engines/sg.c
+AD4 index 3cc068f3..9105c24c 100644
+AD4 --- a/engines/sg.c
+AD4 +-+-+- b/engines/sg.c
+AD4 +AEAAQA -723,6 +-723,8 +AEAAQA static int fio+AF8-sgio+AF8-read+AF8-capacity(struct thread+AF8-data +ACo-td, unsigned int +ACo-bs,
+AD4  	 +ACo io+AF8-u structures, which are not initialized until later.
+AD4  	 +ACo-/
+AD4  	struct sg+AF8-io+AF8-hdr hdr+ADs
+AD4 +-	unsigned long long hlba+ADs
+AD4 +-	unsigned int blksz +AD0 0+ADs
+AD4  	unsigned char cmd+AFs-16+AF0AOw
+AD4  	unsigned char sb+AFs-64+AF0AOw
+AD4  	unsigned char buf+AFs-32+AF0AOw  // read capacity return
+AD4 +AEAAQA -759,16 +-761,21 +AEAAQA static int fio+AF8-sgio+AF8-read+AF8-capacity(struct thread+AF8-data +ACo-td, unsigned int +ACo-bs,
+AD4  		return ret+ADs
+AD4  	+AH0
+AD4  
+AD4 -	+ACo-bs	 +AD0 ((unsigned long) buf+AFs-4+AF0 +ADwAPA 24) +AHw ((unsigned long) buf+AFs-5+AF0 +ADwAPA 16) +AHw
+AD4 -		   ((unsigned long) buf+AFs-6+AF0 +ADwAPA 8) +AHw (unsigned long) buf+AFs-7+AF0AOw
+AD4 -	+ACo-max+AF8-lba +AD0 ((unsigned long) buf+AFs-0+AF0 +ADwAPA 24) +AHw ((unsigned long) buf+AFs-1+AF0 +ADwAPA 16) +AHw
+AD4 -		   ((unsigned long) buf+AFs-2+AF0 +ADwAPA 8) +AHw (unsigned long) buf+AFs-3+AF0AOw
+AD4 +-	if (hdr.info +ACY SG+AF8-INFO+AF8-CHECK) +AHs
+AD4 +-		/+ACo RCAP(10) might be unsupported by device. Force RCAP(16) +ACo-/
+AD4 +-		hlba +AD0 MAX+AF8-10B+AF8-LBA+ADs
+AD4 +-	+AH0 else +AHs
+AD4 +-		blksz	 +AD0 ((unsigned long) buf+AFs-4+AF0 +ADwAPA 24) +AHw ((unsigned long) buf+AFs-5+AF0 +ADwAPA 16) +AHw
+AD4 +-			   ((unsigned long) buf+AFs-6+AF0 +ADwAPA 8) +AHw (unsigned long) buf+AFs-7+AF0AOw
+AD4 +-		hlba	 +AD0 ((unsigned long) buf+AFs-0+AF0 +ADwAPA 24) +AHw ((unsigned long) buf+AFs-1+AF0 +ADwAPA 16) +AHw
+AD4 +-			   ((unsigned long) buf+AFs-2+AF0 +ADwAPA 8) +AHw (unsigned long) buf+AFs-3+AF0AOw
+AD4 +-	+AH0

Please introduce get+AF8-unaligned+AF8-be32() and get+AF8-unaligned+AF8-be64() functions in fio
such that this code becomes easier to read and to maintain.

Thanks,

Bart.

