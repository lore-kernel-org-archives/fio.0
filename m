Return-Path: <bart.vanassche@gmail.com>
Return-Path: <bart.vanassche@gmail.com>
Message-ID: <1538060340.226558.1.camel@acm.org>
Subject: Re: [PATCH] zbd: Use bytes unit
From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 27 Sep 2018 07:59:00 -0700
In-Reply-To: <20180831044813.22556-1-damien.lemoal@wdc.com>
References: <20180831044813.22556-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset="UTF-7"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On Fri, 2018-08-31 at 13:48 +-0900, Damien Le Moal wrote:
+AD4 Simplify zbd.c code by using byte unit for the zone information values
+AD4 instead of 512B sector count. Doing so, many 9 bits shift operations
+AD4 are removed and code readability improved.

This patch is incomplete. The following documentation in zbd.h should also
updated to reflect the unit changes:

/+ACoAKg
 +ACo struct fio+AF8-zone+AF8-info - information about a single ZBD zone
 +ACo +AEA-start: zone start in 512 byte units
 +ACo +AEA-wp: zone write pointer location in 512 byte units
 +ACo +AEA-verify+AF8-block: number of blocks that have been verified for this zone
 +ACo +AEA-mutex: protects the modifiable members in this structure
 +ACo +AEA-type: zone type (BLK+AF8-ZONE+AF8-TYPE+AF8AKg)
 +ACo +AEA-cond: zone state (BLK+AF8-ZONE+AF8-COND+AF8AKg)
 +ACo +AEA-open: whether or not this zone is currently open. Only relevant if
 +ACo              max+AF8-open+AF8-zones +AD4 0.
 +ACo +AEA-reset+AF8-zone: whether or not this zone should be reset before writing to it
 +ACo-/
struct fio+AF8-zone+AF8-info +AHs

Thanks,

Bart.

