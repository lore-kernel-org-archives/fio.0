Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:30915 "EHLO
	mx0a-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752200AbbAIQEW (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 9 Jan 2015 11:04:22 -0500
Received: from pps.filterd (m0075554.ppops.net [127.0.0.1])
	by mx0a-00003501.pphosted.com (8.14.5/8.14.5) with SMTP id t09G1Kc0025980
	for <fio@vger.kernel.org>; Fri, 9 Jan 2015 11:04:22 -0500
Received: from mail-qc0-f173.google.com (mail-qc0-f173.google.com [209.85.216.173])
	by mx0a-00003501.pphosted.com with ESMTP id 1rthnnr937-2
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Fri, 09 Jan 2015 11:04:21 -0500
Received: by mail-qc0-f173.google.com with SMTP id i17so9680012qcy.4
        for <fio@vger.kernel.org>; Fri, 09 Jan 2015 08:04:21 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 9 Jan 2015 09:04:21 -0700
Message-ID: <CAFCBNRFzOw4rVnWpHWN=FfdhDYePKwP9xo7vWdKTPR+LSpyZwQ@mail.gmail.com>
Subject: Log Bug with fio-2.1.14 and Higher Causing fio Jobs to Time Out
From: George T Seese <george.t.seese@seagate.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

fio team,

I've found a bug that results in fio hanging at the end of a workload
involving log generation, in this case specific to latency log
generation. The bug appears in version 2.1.14, 2.2.4, and possibly
others. I have tested these scripts with 2.0.9 and they work. Slightly
different scripts work on 2.0.14 as well.

Error message and script file are copy-pasted below. The job that
times out is not always the same job but, usually at least one does
time out, it's worse with more targets.

fio: pid=37182, got signal=11
fio: job '/dev/sdc' hasn't exited in 60 seconds, it appears to be
stuck. Doing forceful exit of this job.

[global]
bs=4k
runtime=1800
rw=randread
;thread=1
direct=1
ioengine=libaio
;offset=0
;randommap=1
;time_based=1
bwavgtime=5000
;write_lat_log
;stonewall=1
iodepth=1

;TargetDriveMarker
[/dev/sdc]
filename=/dev/sdc
write_lat_log=sdc

[/dev/sdd]
filename=/dev/sdd
write_lat_log=sdd

Thanks,
George
