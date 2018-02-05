Return-Path: <fio-owner@vger.kernel.org>
Received: from courriel.cmaisonneuve.qc.ca ([206.167.118.84]:33593 "EHLO
        courriel.cmaisonneuve.qc.ca" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752488AbeBEEsb (ORCPT
        <rfc822;fio@vger.kernel.org>); Sun, 4 Feb 2018 23:48:31 -0500
From: =?UTF-8?B?SsOpcsO0bWUgQ2hhcmFvdWk=?= <jcharaoui@cmaisonneuve.qc.ca>
Subject: Curious randwrite results on raid10 md device
Message-ID: <a4f3cafa-dd28-28aa-551e-85cb27cf234d@cmaisonneuve.qc.ca>
Date: Sun, 4 Feb 2018 23:33:26 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: fr
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

I've been running some tests on a bunch of disks lately and came across
a strange result that I'm struggling to explain.

I built a 20-device raid10 md array with SSDs and ran several fio tests
on it. The randwrite test really stands out because the IOPS starts out
fairly low, around 800 IOPS, but within a few seconds climbs up to about
70K IOPS, which is nearly three times higher than the IOPS I'm getting
with the randread test (25K).

I tried disabling the drive caches using hdparm -W 0, and also disabling
the internal write-intent bitmap on the md array, but the results are
the same.

Here are the test parameters:

ioengine=libaio
invalidate=1
ramp_time=10
iodepth=4
runtime=60
time_based
direct=1
randrepeat=0
filename=/dev/md1
bs=4k
rw=randwrite

I generated some gnuplot graphs from the logs:

randread test: https://imgur.com/dj25FFH
randwrite test: https://imgur.com/BuZVNmh


Thanks,

-- Jerome
