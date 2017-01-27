Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:35765 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751948AbdA0WHh (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 Jan 2017 17:07:37 -0500
Received: by mail-qt0-f176.google.com with SMTP id x49so158120051qtc.2
        for <fio@vger.kernel.org>; Fri, 27 Jan 2017 14:07:32 -0800 (PST)
MIME-Version: 1.0
From: Prabhakaran <prabhugce@gmail.com>
Date: Fri, 27 Jan 2017 14:58:59 -0700
Message-ID: <CAPqbHXh4m_UgDRtj1Htb8DByZu2JJxQFB-w8wNZthOJkX64tHA@mail.gmail.com>
Subject: Offset in percentage rather than in LBA
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

Can offset be specified in percentage rather than in capacity value
like gb or mb?
I have a config file which fills a drive once randomly. I got 4 jobs
running in parallel (4*64qd=256qd) with lba space divided among them.
I want to specify in percentage, so that all the jobs are equally
used, rather than hard-coding the capacity.

The following example configuration is designed for 450GB NVMe drive.


#################################################
[global]
ioengine=libaio
thread
cpus_allowed=0-7
cpus_allowed_policy=split
direct=1
size=100g
loops=6

[4k-4k_randwrite_0_rd_qd256_numjob1]
bs=4k
ba=4k
iodepth=64
offset=0
rw=randwrite
randrepeat=0
norandommap
refill_buffers
log_avg_msec=1000
unified_rw_reporting=1
write_bw_log=4k-4k_randwrite_0_rd_qd256_numjob1
write_iops_log=4k-4k_randwrite_0_rd_qd256_numjob1

[4k-4k_randwrite_0_rd_qd256_numjob2]
bs=4k
ba=4k
iodepth=64
offset=100g
rw=randwrite
randrepeat=0
norandommap
refill_buffers
log_avg_msec=1000
unified_rw_reporting=1
write_bw_log=4k-4k_randwrite_0_rd_qd256_numjob2
write_iops_log=4k-4k_randwrite_0_rd_qd256_numjob2

[4k-4k_randwrite_0_rd_qd256_numjob3]
bs=4k
ba=4k
iodepth=64
offset=200g
rw=randwrite
randrepeat=0
norandommap
refill_buffers
log_avg_msec=1000
unified_rw_reporting=1
write_bw_log=4k-4k_randwrite_0_rd_qd256_numjob3
write_iops_log=4k-4k_randwrite_0_rd_qd256_numjob3

[4k-4k_randwrite_0_rd_qd256_numjob4]
bs=4k
ba=4k
iodepth=64
offset=300g
rw=randwrite
randrepeat=0
norandommap
refill_buffers
log_avg_msec=1000
unified_rw_reporting=1
write_bw_log=4k-4k_randwrite_0_rd_qd256_numjob4
write_iops_log=4k-4k_randwrite_0_rd_qd256_numjob4
#################################################


Thanks,
Prabhu
