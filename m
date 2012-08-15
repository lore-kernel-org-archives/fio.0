Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40257 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab2HODzT (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 14 Aug 2012 23:55:19 -0400
Received: by obbuo13 with SMTP id uo13so1560797obb.19
        for <fio@vger.kernel.org>; Tue, 14 Aug 2012 20:55:18 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 14 Aug 2012 20:55:18 -0700
Message-ID: <CAJBj3vfcQYnAEtJkh7FKYGAaePtpGbkgVKDOJeBwQcz8WsgNRQ@mail.gmail.com>
Subject: log_avg_msec does not work for BW or IOPS logs
From: John Williams <jwilliams4200@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm calling fio v2.0.8 from the command line in linux, and I wanted to
set the averaging time for the log data to 200msec. Here is the
command line I used:

fio --name=SeqWrite --readwrite=write --bs=128K --iodepth=1
--ioengine=libaio --direct=1 --invalidate=1 --output=/tmp/fio_output
--write_bw_log=bw_seq128K --write_lat_log=lat_seq128K
--write_iops_log=iops_seq128K --log_avg_msec=200 --randrepeat=0
--norandommap --offset=0 --size=128035676160 --filename=/dev/sdaa

But when I examined the logs that fio produced, the BW and the IOPS
logs had the default 500msec resolution. But the latency logs had my
requested 200msec resolution.

Is this an fio bug, or did I misunderstand something?

Beginning of BW log:
507, 347392, 1, 0
1009, 335201, 1, 0
1527, 332108, 1, 0
2037, 345349, 1, 0
2540, 333868, 1, 0
3045, 341333, 1, 0
3548, 334533, 1, 0
4053, 333206, 1, 0
4560, 339313, 1, 0

Beginning of IOPS log:
507, 84, 1, 0
1009, 81, 1, 0
1527, 81, 1, 0
2037, 84, 1, 0
2540, 81, 1, 0
3045, 83, 1, 0
3548, 81, 1, 0
4053, 81, 1, 0
4560, 82, 1, 0

Beginning of lat log:
201, 11875, 1, 0
402, 11789, 1, 0
605, 11972, 1, 0
811, 12060, 1, 0
1020, 12341, 1, 0
1223, 11900, 1, 0
1430, 12210, 1, 0
1636, 12131, 1, 0
1842, 12104, 1, 0
2048, 12114, 1, 0
2254, 12105, 1, 0
2462, 12247, 1, 0
2669, 12144, 1, 0
2887, 12843, 1, 0
3090, 11953, 1, 0
3295, 12022, 1, 0
3501, 12128, 1, 0
3707, 12111, 1, 0
3914, 12162, 1, 0
4125, 12429, 1, 0
4331, 12088, 1, 0
4537, 12124, 1, 0
