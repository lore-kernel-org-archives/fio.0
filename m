Return-Path: <fio-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:46042 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1755320AbcHVQ1y (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 22 Aug 2016 12:27:54 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcsf-fio@m.gmane.org>)
        id 1bbs4l-0001Ei-4g
        for fio@vger.kernel.org; Mon, 22 Aug 2016 18:27:51 +0200
From: Saeed <ionictea@gmail.com>
Subject: write_iops_log doesn't show any iops
Date: Mon, 22 Aug 2016 11:27:45 -0500
Message-ID: <npf960$31m$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
        format=flowed
Content-Transfer-Encoding: 7BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

1, 1, 1, 4096
1, 1, 1, 4096
1, 1, 1, 4096
1, 1, 1, 4096
1, 1, 1, 4096
1, 1, 1, 4096
1, 1, 1, 4096
1, 1, 1, 4096
1, 1, 1, 4096
2, 1, 1, 4096
2, 1, 1, 4096
2, 1, 1, 4096
2, 1, 1, 4096
2, 1, 1, 4096
2, 1, 1, 4096
2, 1, 1, 4096

Strange but my write_iops_log log file doesn't contain any IOP data.  
What column should the iops data be in and what could be the reason why 
I'm getting any iop stats?

1, 1, 1, 4096
1, 1, 1, 4096
1, 1, 1, 4096
1, 1, 1, 4096
1, 1, 1, 4096
1, 1, 1, 4096
1, 1, 1, 4096
1, 1, 1, 4096
1, 1, 1, 4096
1, 1, 1, 4096
2, 1, 1, 4096
2, 1, 1, 4096
2, 1, 1, 4096
2, 1, 1, 4096
2, 1, 1, 4096
2, 1, 1, 4096
2, 1, 1, 4096
2, 1, 1, 4096

FIO 2.12 job:
[global]
ioengine=libaio
direct=1
filename=/dev/sdc
group_reporting
numjobs=1
time_based=1
per_job_logs=0
write_bw_log=results
write_iops_log=results
write_lat_log=results

[fill]
rw=randwrite
bs=8K
runtime=120
iodepth=1
stonewall

[read]
rw=randread
bs=8k
iodepth=16
runtime=480
stonewall


