Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B86FC433F5
	for <fio@archiver.kernel.org>; Tue, 15 Feb 2022 16:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239737AbiBOQhS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 15 Feb 2022 11:37:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233621AbiBOQhR (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 Feb 2022 11:37:17 -0500
Received: from angmar.tmp.com.br (angmar.tmp.com.br [188.40.49.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B2AA4181
        for <fio@vger.kernel.org>; Tue, 15 Feb 2022 08:37:03 -0800 (PST)
Received: from angmar.tmp.com.br (localhost.localdomain [127.0.0.1])
        by angmar.tmp.com.br (8.13.1/8.13.1) with ESMTP id 21FGeQdX032345;
        Tue, 15 Feb 2022 13:40:26 -0300
Received: (from spamtrap@localhost)
        by angmar.tmp.com.br (8.13.1/8.13.1/Submit) id 21FGeQmL032344;
        Tue, 15 Feb 2022 13:40:26 -0300
Date:   Tue, 15 Feb 2022 13:40:26 -0300
From:   Durval Menezes <jmmml@durval.com>
To:     fio <fio@vger.kernel.org>
Cc:     Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: Samsung PM863 SSD: surprisingly high Write IOPS measured using `fio`, over 4.6 times more than spec!?
Message-ID: <20220215164026.GK487@angmar.tmp.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
X-MailScanner-ID: 21FGeQdX032345
X-TMP-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-TMP-MailScanner-SpamCheck: 
X-TMP-MailScanner-From: spamtrap@angmar.tmp.com.br
X-TMP-MailScanner-To: fio@vger.kernel.org, sitsofe@gmail.com
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


Hi Sitsofe,

First of all, thanks for your detailed, thoughtful response. More, below:

On Mon, Feb 14, 2022 at 4:51 PM Sitsofe Wheeler <sitsofe@gmail.com> wrote:
> On Mon, 14 Feb 2022 at 18:44, Durval Menezes <jmmml@durval.com> wrote:
> >
> > Hello everyone,
> >
> > I've arrived at a very surprising number measuring IOPS write performance
> > on my SSDs' "bare metal" (ie, straight on the /dev/$DISK, no filesystem
> > involved):
> >
> >         export COMMON_OPTIONS='--ioengine=libaio --direct=1
> --runtime=120 --time_based --group_reporting'
> >
> >         ls -l /dev/disk/by-id | grep 'ata-.*sda'
> >                 lrwxrwxrwx 1 root root  9 Feb 13 17:19
> ata-SAMSUNG_MZ7LM1T9HCJM-00003_XXXXXXXXXXXXXX -> ../../sda
> >
> >
>  TANGO=/dev/disk/by-id/ata-SAMSUNG_MZ7LM1T9HCJM-00003_XXXXXXXXXXXXXX
> >         sudo fio --filename=${TANGO} --name=device_iops_write
> --rw=randwrite --bs=4k  --iodepth=256 --numjobs=4 ${COMMON_OPTIONS}
> >                 [...]
> >                 write: *IOPS=83.1k*, BW=325MiB/s
> (341MB/s)(38.1GiB/120007msec)
> >                 [...]
> >
> > (please find the complete output at the end of this message, in case I
> should
> > have looked at some other lines and/or you are curious)
> >
> > As per the official manufacturer specs (both in this whitepaper at their
> > website[1]), and also in this datasheet I found somewhere else[2]), it's
> > supposed to be only *18K IOPS*.
> >
> > All the other base performance numbers I've measured (read IOPS, read and
> > write MB/s, read and write latencies) are at or very near the
> manufacturer
> > specs.
> >
> > What's going on?
> >
> > At first I thought that, despite `--direct=1` being explicitly indicated,
> > my machine's 64GB RAM (via the Linux buffer cache) could be caching the
> > writes (even if the number, in that case, should have been much
> higher)...
> > so, I tested it again with `--runtime=120` to saturate the buffer cache
> in
> > case it was really the 'culprit'... lo and behold, the result was:
> >
> >         [...]
> >         write: IOPS=83.1k, BW=325MiB/s (341MB/s)(190GiB/600019msec)
> >         [...]
> >
> >
> > So, the surprising over-4.6x-times-the-spec Write IOPS is mantained, even
> > for 190GiB total data.
> >
> > And with 190GiB data written (about 10% the total device capacity), I do
> > not believe it's any kind of cache (RAM, MLC or whatever) inside the SSD
> > either.
> >
> You're running your workload for a comparatively short time

OK, I was able to find in the whitepaper (see below) the manufacturer
stating that the rand writes should be run for twice the capacity of the
disk. That will also imply a much longer test time...

> and additionally we don't know how "fresh" your SSD is.
 
Good point; here's its "freshness"-relevant data straight from `smartctl -a`:
	 
	   9 Power_On_Hours          0x0032   091   091   000    Old_age   Always
	     -       43694
	 177 Wear_Leveling_Count     0x0013   094   094   005    Pre-fail  Always
	     -       394
	 241 Total_LBAs_Written      0x0032   099   099   000    Old_age   Always
	     -       535797643689
	 242 Total_LBAs_Read         0x0032   099   099   000    Old_age   Always
	     -       1848967801660
	 
	 251 NAND_Writes             0x0032   100   100   000    Old_age   Always
	     -       1642499721864

So, I think it's a pretty 'mature' disk already (but hopefully with a lot
of 'life' still in it).

In other words, I don't think it's "fresh" enough to explain a 4x I/O increase.

Perhaps "freshness" in this case refers to it being recently
secure-erased (which I did prior to start testing)? 
 
> The 18K IOPS value
> might be when the drive has been fully written and there are no
> pre-erased blocks available (via so-called preconditioning)... I'll
> also note the whitepaper [1] mentions this:
>
> 	SSD Precondition: Sustained state (or steady state)
> 	[...]
> 	It's important to note that all performance items mentioned in this
> 	white paper have been measured at the sustained state, except the
> 	sequential read/write performance
>

Thanks for going through the whitepaper and picking this up. It passed
right by me...

I went through the whitepaper again, and found this:

	The sustained state in this document refers to the status that a
	128 KB sequential write has been completed equal to the drive capacity and
	then 4 KB random write has completed twice as much as the drive capacity
	
OK, so at least there's a "recipe" for this preconditioning. I will try it
and come back later to report.

> I notice that your SSD appears to be SATA (sda) so I'd be surprised
> that a total queue depth greater than 32 makes a difference (your
> total queue depth is 1024). Do you get a similar result with just the
> one job with an iodepth=32?

I tested with iodepth=32 (instead of 256) and got the same result, so I
guess you are not surprised ;-)

Just did it again, this time with   `--numjobs=1` (instead of 4) and here's
the result:

        write: IOPS=83.0k, BW=324MiB/s (340MB/s)(38.0GiB/120001msec)

So that's not it either.

> It's unlikely but if the jobs were submitting I/O to the same areas as
> other jobs at the same time then some of the I/O could be elided but
> given what you've posted this should not be the case.

Agreed.

Cheers,
-- 
   Durval.

> 
> 
> --
> Sitsofe
> >
> >
