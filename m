Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58EFEC433F5
	for <fio@archiver.kernel.org>; Tue, 15 Feb 2022 16:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbiBOQpi (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 15 Feb 2022 11:45:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiBOQph (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 Feb 2022 11:45:37 -0500
Received: from angmar.tmp.com.br (angmar.tmp.com.br [188.40.49.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083BD1019FC
        for <fio@vger.kernel.org>; Tue, 15 Feb 2022 08:45:26 -0800 (PST)
Received: from angmar.tmp.com.br (localhost.localdomain [127.0.0.1])
        by angmar.tmp.com.br (8.13.1/8.13.1) with ESMTP id 21FGmjUL032445;
        Tue, 15 Feb 2022 13:48:47 -0300
Received: (from spamtrap@localhost)
        by angmar.tmp.com.br (8.13.1/8.13.1/Submit) id 21FGmHND032443;
        Tue, 15 Feb 2022 13:48:17 -0300
Date:   Tue, 15 Feb 2022 13:48:17 -0300
From:   Durval Menezes <jmmml@durval.com>
To:     fio <fio@vger.kernel.org>
Cc:     Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: Samsung PM863 SSD: surprisingly high Write IOPS measured using `fio`, over 4.6 times more than spec!?
Message-ID: <20220215164817.GL487@angmar.tmp.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
X-MailScanner-ID: 21FGmjUL032445
X-TMP-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-TMP-MailScanner-SpamCheck: 
X-TMP-MailScanner-From: spamtrap@angmar.tmp.com.br
X-TMP-MailScanner-To: fio@vger.kernel.org, sitsofe@gmail.com
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


Hi Sitsofe,

On Tue, Feb 15, 2022 at 12:32 PM Durval Menezes (MML) <jmmml@durval.com> wrote:
> On Mon, Feb 14, 2022 at 4:51 PM Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> > [...]
> > The 18K IOPS value
> > might be when the drive has been fully written and there are no
> > pre-erased blocks available (via so-called preconditioning)... I'll
> > also note the whitepaper [1] mentions this:
> >
> > 	SSD Precondition: Sustained state (or steady state)
> > 	[...]
> > 	It's important to note that all performance items mentioned in this
> > 	white paper have been measured at the sustained state, except the
> > 	sequential read/write performance
>
> Thanks for going through the whitepaper and picking this up. It passed
> right by me...
>
> Anyway.... hummmrmrmrmr... I did a full "Secure erase" on the drive before
> starting these tests... perhaps that was it?
>
> Anyway, I went through the whitepaper again, and found this:
>
> 	The sustained state in this document refers to the status that a
> 	128 KB sequential write has been completed equal to the drive capacity and
> 	then 4 KB random write has completed twice as much as the drive capacity
>
> OK, so at least there's a "recipe" for this preconditioning. I will try it
> and come back later to report.

That nailed it! Here's what I did to implement the "recipe":

a) Wrote random data in 128KB-sized blocks sequentially to the drive, until reaching the end of the device:

	date; openssl enc -rc4-40 -pass "pass:`dd bs=128 count=1 </dev/urandom 2>/dev/null`" </dev/zero | dd bs=128K of=/dev/sda oflag=direct iflag=fullblock; date
		Mon Feb 14 17:42:03 -03 2022
		dd: error writing '/dev/sda': No space left on device
		14651363+0 records in
		14651362+0 records out
		error writing output file
		1920383410176 bytes (1.9 TB, 1.7 TiB) copied, 6460.56 s, 297 MB/s
		Mon Feb 14 19:29:44 -03 2022

b) And then run a randomwrite FIO test with 4KB blocks and size equal to twice the SSD capacity:

	fdisk -l /dev/sda | grep ^Disk
		Disk /dev/sda: 1.8 TiB, 1920383410176 bytes, 3750748848 sectors
	export SIZE=1920383410176
	date; fio --filename=/dev/sda --name=device_iops_write --rw=randwrite --bs=4k --iodepth=32 --numjobs=1 --size=${SIZE} --io_size=`expr ${SIZE} \* 2` --ioengine=libaio --direct=1 --group_reporting
		Mon Feb 14 19:29:44 -03 2022
		device_iops_write: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=32
		fio-3.1
		Starting 1 process
		[...]
		Jobs: 1 (f=1): [w(1)][11.1%][r=0KiB/s,w=71.6MiB/s][r=0,w=18.3k IOPS][eta
		07h:51m:36s]
		[...]
		^C
		fio: terminating on signal 2

So, it didn't even take writing 2x the SSD capacity with random data to
bring write IOPS down to specs: just 11.1% of it was enough (and led me to
interrupt the test, no use eating up more write cycles out of its NAND
since the 'issue' is now explained).

Therefore, end of the case. Thank you very much for helping me nail this
down, I really like it when things make sense.

Cheers,
-- 
   Durval.
