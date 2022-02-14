Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A90E4C433EF
	for <fio@archiver.kernel.org>; Mon, 14 Feb 2022 16:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbiBNQ1t (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 14 Feb 2022 11:27:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236773AbiBNQ1t (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 14 Feb 2022 11:27:49 -0500
X-Greylist: delayed 7267 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Feb 2022 08:27:36 PST
Received: from angmar.tmp.com.br (angmar.tmp.com.br [188.40.49.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B275FF0B
        for <fio@vger.kernel.org>; Mon, 14 Feb 2022 08:27:36 -0800 (PST)
Received: from angmar.tmp.com.br (localhost.localdomain [127.0.0.1])
        by angmar.tmp.com.br (8.13.1/8.13.1) with ESMTP id 21EETnGE008887;
        Mon, 14 Feb 2022 11:29:49 -0300
Received: (from spamtrap@localhost)
        by angmar.tmp.com.br (8.13.1/8.13.1/Submit) id 21EETnCm008886;
        Mon, 14 Feb 2022 11:29:49 -0300
Date:   Mon, 14 Feb 2022 11:29:48 -0300
From:   Durval Menezes <jmmml@durval.com>
To:     fio@vger.kernel.org
Cc:     jmmml@durval.com
Subject: Samsung PM863 SSD: surprisingly high Write IOPS measured using `fio`, over 4.6 times more than spec!?
Message-ID: <20220214142948.GJ487@angmar.tmp.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
X-MailScanner-ID: 21EETnGE008887
X-TMP-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-TMP-MailScanner-SpamCheck: 
X-TMP-MailScanner-From: spamtrap@angmar.tmp.com.br
X-TMP-MailScanner-To: fio@vger.kernel.org, jmmml@durval.com
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hello everyone,

I've arrived at a very surprising number measuring IOPS write performance
on my SSDs' "bare metal" (ie, straight on the /dev/$DISK, no filesystem
involved):

	export COMMON_OPTIONS='--ioengine=libaio --direct=1 --runtime=120 --time_based --group_reporting'

	ls -l /dev/disk/by-id | grep 'ata-.*sda'
		lrwxrwxrwx 1 root root  9 Feb 13 17:19 ata-SAMSUNG_MZ7LM1T9HCJM-00003_XXXXXXXXXXXXXX -> ../../sda

	TANGO=/dev/disk/by-id/ata-SAMSUNG_MZ7LM1T9HCJM-00003_XXXXXXXXXXXXXX
	sudo fio --filename=${TANGO} --name=device_iops_write --rw=randwrite --bs=4k  --iodepth=256 --numjobs=4 ${COMMON_OPTIONS}
		[...]
		write: *IOPS=83.1k*, BW=325MiB/s (341MB/s)(38.1GiB/120007msec)
		[...]

(please find the complete output at the end of this message, in case I should
have looked at some other lines and/or you are curious)

As per the official manufacturer specs (both in this whitepaper at their
website[1]), and also in this datasheet I found somewhere else[2]), it's
supposed to be only *18K IOPS*.

All the other base performance numbers I've measured (read IOPS, read and
write MB/s, read and write latencies) are at or very near the manufacturer
specs.

What's going on?

At first I thought that, despite `--direct=1` being explicitly indicated,
my machine's 64GB RAM (via the Linux buffer cache) could be caching the
writes (even if the number, in that case, should have been much higher)...
so, I tested it again with `--runtime=120` to saturate the buffer cache in
case it was really the 'culprit'... lo and behold, the result was:

	[...]
	write: IOPS=83.1k, BW=325MiB/s (341MB/s)(190GiB/600019msec)
	[...]


So, the surprising over-4.6x-times-the-spec Write IOPS is mantained, even
for 190GiB total data.

And with 190GiB data written (about 10% the total device capacity), I do
not believe it's any kind of cache (RAM, MLC or whatever) inside the SSD
either.

I even considered that I could have got some kind of 'unicorn' device, so I
repeated all tests on my other SSD (same model and firmware, but a little
older -- date of manufacture on the paper label about 3 months earlier),
and got almost the exact same results (less than 1% variation). I do not
believe I got *two* over-4.6x-times-faster-than-spec 'unicorns' out of a
used eBay SSD sale...

So, what gives? With me being no `fio` expert, the obvious answer is that I
made some kind of mistake in its command-line above, but if so, for the
life of me I can't see it.

Thanks in advance for all tips and hints and cluebats from all you `fio` connoiseurs...
and please have no mercy, in case I messed up both the face and the palm here are ready to meet each other... ;-)

PS: in case it matters, this was running Ubuntu 18.04.6 with kernel 4.15.0-167-generic and fio-3.1 installed via
`apt-get install` from the official distro repo.

[1] https://www.samsung.com/semiconductor/global.semi.static/PM863_White_Paper-0.pdf,
p.4: "4 KB Random R/*W* (IOPs) Up to 99,000 / *18,000 IOPS*";

[2] https://www.compuram.de/documents/datasheet/PM863_SAMSUNG.pdf,
p.6: "Random Write IOPS (4 KB) [then, in the column for the 1,920GB model] 18K IOPS"

Cheers,
-- 
   Durval.

$ export COMMON_OPTIONS='--ioengine=libaio --direct=1 --runtime=120 --time_based --group_reporting'
$ ls -l /dev/disk/by-id | grep 'ata-.*sda'
lrwxrwxrwx 1 root root  9 Feb 13 17:19 ata-SAMSUNG_MZ7LM1T9HCJM-00003_XXXXXXXXXXXXXX -> ../../sda
$ TANGO=/dev/disk/by-id/ata-SAMSUNG_MZ7LM1T9HCJM-00003_XXXXXXXXXXXXXX
$ sudo fio --filename=${TANGO} --name=device_iops_write --rw=randwrite            --bs=4k  --iodepth=256 --numjobs=4 ${COMMON_OPTIONS}
device_iops_write: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=libaio, iodepth=256
...
fio-3.1
Starting 4 processes
Jobs: 4 (f=4): [w(4)][100.0%][r=0KiB/s,w=326MiB/s][r=0,w=83.4k IOPS][eta 00m:00s]
device_iops_write: (groupid=0, jobs=4): err= 0: pid=27042: Sun Feb 13 16:19:10 2022
  write: IOPS=83.1k, BW=325MiB/s (341MB/s)(38.1GiB/120007msec)
    slat (nsec): min=1504, max=13545k, avg=46653.86, stdev=230086.16
    clat (usec): min=769, max=39675, avg=12267.87, stdev=3172.09
     lat (usec): min=772, max=39681, avg=12314.59, stdev=3187.43
    clat percentiles (usec):
     |  1.00th=[ 6521],  5.00th=[ 7963], 10.00th=[ 8717], 20.00th=[ 9765],
     | 30.00th=[10421], 40.00th=[11207], 50.00th=[11863], 60.00th=[12518],
     | 70.00th=[13435], 80.00th=[14484], 90.00th=[16319], 95.00th=[17957],
     | 99.00th=[22414], 99.50th=[23987], 99.90th=[26870], 99.95th=[28181],
     | 99.99th=[30802]
   bw (  KiB/s): min=58880, max=101216, per=25.00%, avg=83130.06, stdev=8366.08, samples=959
   iops        : min=14720, max=25304, avg=20782.51, stdev=2091.52, samples=959
  lat (usec)   : 1000=0.01%
  lat (msec)   : 2=0.01%, 4=0.02%, 10=23.35%, 20=74.16%, 50=2.47%
  cpu          : usr=3.21%, sys=9.27%, ctx=425656, majf=0, minf=28
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=0.1%, >=64=100.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.1%
     issued rwt: total=0,9977029,0, short=0,0,0, dropped=0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=256

Run status group 0 (all jobs):
  WRITE: bw=325MiB/s (341MB/s), 325MiB/s-325MiB/s (341MB/s-341MB/s), io=38.1GiB (40.9GB), run=120007-120007msec
$ 
