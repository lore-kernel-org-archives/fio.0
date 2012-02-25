Return-Path: <fio-owner@vger.kernel.org>
Received: from server505f.appriver.com ([98.129.35.10]:1853 "EHLO
	server505.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754389Ab2BYAcw convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 24 Feb 2012 19:32:52 -0500
Received: from [98.129.35.1] (HELO smtp.exg5.exghost.com)
  by server505.appriver.com (CommuniGate Pro SMTP 5.4.3k)
  with ESMTPS id 258015724 for fio@vger.kernel.org; Fri, 24 Feb 2012 18:27:51 -0600
From: Ross Becker <ross@gridironsystems.com>
Date: Fri, 24 Feb 2012 18:27:46 -0600
Subject: Bug with small partitions?
Message-ID: <CB6D6B02.7ADB1%ross@gridironsystems.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

I've found something very very odd, and I've tested it out and verified it
occurs with fio 1.54, 2.0.1 and 2.0.4.

Host OS is Redhat 5.7, kernel version 2.6.18-274.17.1.el5

I have 12 LUNs coming across fiber channel, each with multiple paths, and
dm-multipath rolling them up into devices.  I partitioned them down to 100
megabytes each.  I then told fio to go do random 4k reads across the 12
partitions; (/dev/mapper/somenamep1).  I had a 10 minute test specified,
and what occurred was that the time for the test to run started jumping
down dramatically each tick; it jumped from 10 minutes remaining to 3
minutes remaining to a minute and change, down to less than a minute.  I
cannot seem to get it to run for more than about 20 seconds, no matter
what I specify for the test run time.  I've been testing like this using
the full size of the LUNs without any trouble.  I rebooted the system,
same behavior.  I created LVM volume groups and logical volumes (one
logical volume per volume group per LUN partition), and the same behavior
occurred against those.  It's acting as if below a certain size, fio gets
confused in it's timekeeping.  I used 1 gig partitions, and everything
worked normally.  Here's my fio config file that I'm getting these results
with:

[global]
bs=4k
ioengine=libaio
iodepth=16
openfiles=1024
runtime=600
ramp_time=5
filename=/dev/mapper/dh0_extra_10p1:/dev/mapper/dh0_extra_11p1:/dev/mapper/
dh0_extra_12p1:/dev/mapper/dh0_extra_20p1:/dev/mapper/dh0_extra_21p1:/dev/m
apper/dh0_extra_22p1:/dev/mapper/dh1_extra_30p1:/dev/mapper/dh1_extra_31p1:
/dev/mapper/dh1_extra_32p1:/dev/mapper/dh1_extra_40p1:/dev/mapper/dh1_extra
_41p1:/dev/mapper/dh1_extra_42p1



[rand-read]
rw=randread
numjobs=12
file_service_type=random
direct=1
disk_util=0
gtod_cpu=1
norandommap=1
thread
group_reporting



