Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:47043 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab3H1Ssb (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 28 Aug 2013 14:48:31 -0400
Received: by mail-lb0-f170.google.com with SMTP id r12so4269124lbi.29
        for <fio@vger.kernel.org>; Wed, 28 Aug 2013 11:48:30 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 28 Aug 2013 14:48:30 -0400
Message-ID: <CABFR9T2djdvEh9t7Jk_ouE9vN7+=z56kp5Z-NkKSytBybC6nkA@mail.gmail.com>
Subject: question on log file command behavior change
From: Roger Sibert <roger_sibert@xyratex.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: FIO <fio@vger.kernel.org>

Hello Everyone,

It's been a stretch since I last did something that required logging
logging, that would be going from 2.0 to the latest git clone from
today.

When I tried to use my older fio configuration files with the new fio
it barked about not specifying the write_bw_log name.  The 2.0.x
version used the name from the job so you could have the options
turned on in [global].

Is the change in behavior where you now have to specify the name of
the log (thus requiring it to be in each job) intentional?

fio 2.0.x config
[global]
direct=1
ioengine=libaio
zonesize=256m
zoneskip=768m
randrepeat=1
write_bw_log
write_lat_log
;
[sda-iodepth1-write-bs1k-1]
stonewall
filename=/dev/sda
iodepth=1
rw=write
bs=1k
runtime=45s
time_based
ramp_time=15s

fio 2.1.x git from today
[global]
direct=1
ioengine=libaio
zonesize=256m
zoneskip=768m
randrepeat=1
;
[sdc-iodepth8-write-bs128k-1]
stonewall
filename=/dev/sdc
iodepth=8
rw=write
bs=128k
runtime=45s
time_based
ramp_time=15s
write_bw_log=sdc-iodepth8-write-bs128k-1
write_lat_log=sdc-iodepth8-write-bs128k-1
write_iops_log=sdc-iodepth8-write-bs128k-1


Thanks,
Roger
