Return-Path: <fio-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:52779 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752089AbcHVUsI (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 22 Aug 2016 16:48:08 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcsf-fio@m.gmane.org>)
        id 1bbw8b-0000HU-1T
        for fio@vger.kernel.org; Mon, 22 Aug 2016 22:48:05 +0200
From: Saeed <ionictea@gmail.com>
Subject: Re: multiple entries for each second for bw/iop/xlat log files
Date: Mon, 22 Aug 2016 15:47:58 -0500
Message-ID: <npfodt$uqa$1@blaine.gmane.org>
References: <npf9p3$6e3$1@blaine.gmane.org> <caf6faa7-9584-724c-2c5b-a6fb1a2af441@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
        format=flowed
Content-Transfer-Encoding: 7BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm still getting the same problem where there seems to be duplicate 
time interval entries and no data for the iops log using the latest git:

479999, 1, 0, 4096
479999, 1, 0, 4096
479999, 1, 0, 4096
479999, 1, 0, 4096
479999, 1, 0, 4096
479999, 1, 0, 4096
479999, 1, 0, 4096
480000, 1, 0, 4096

I do see the following errors during the configure process but not sure 
if its related:

/tmp/fio-conf--8430-.c:2:2: error: #error __ANDROID__ not defined
 #error __ANDROID__ not defined
/tmp/fio-conf--8430-.c:2:2: error: #error __i386__ not defined
 #error __i386__ not defined
/tmp/fio-conf--8430-.c:5:3: error: size of unnamed array is negative
collect2: error: ld returned 1 exit status
/tmp/fio-conf--8430-.c:2:24: fatal error: sys/asynch.h: No such file or 
directory
/tmp/fio-conf--8430-.c:2:29: fatal error: infiniband/arch.h: No such 
file or directory
/tmp/fio-conf--8430-.c:2:27: fatal error: rdma/rdma_cma.h: No such file 
or directory

/tmp/fio-conf--8430-.c:5:24: error: 'CLOCK_MONOTONIC_PRECISE' 
undeclared (first use in this function)
/tmp/fio-conf--8430-.c:5:22: error: storage size of 'me' isn't known
/tmp/fio-conf--8430-.c:6:19: error: 'EXT4_IOC_MOVE_EXT' undeclared 
(first use in this function)
/tmp/fio-conf--8430-.c:1:19: fatal error: guasi.h: No such file or directory
/tmp/fio-conf--8430-.c:1:32: fatal error: nvm/nvm_primitives.h: No such 
file or directory
/tmp/fio-conf--8430-.c:1:18: fatal error: numa.h: No such file or directory
collect2: error: ld returned 1 exit status
collect2: error: ld returned 1 exit status
/tmp/fio-conf--8430-.c:1:24: fatal error: rbd/librbd.h: No such file or 
directory
/tmp/fio-conf--8430-.c:1:24: fatal error: rbd/librbd.h: No such file or 
directory
/tmp/fio-conf--8430-.c:1:32: fatal error: glusterfs/api/glfs.h: No such 
file or directory
/tmp/fio-conf--8430-.c:7: Error: unknown pseudo-op: `.machine'
/tmp/fio-conf--8430-.c:8: Error: unknown pseudo-op: `.machine'
/tmp/fio-conf--8430-.c:9: Error: no such instruction: `stfle %rcx'
/tmp/fio-conf--8430-.c:10: Error: unknown pseudo-op: `.machine'
/tmp/fio-conf--8430-.c:6:17: error: storage size of 'st' isn't known
/tmp/fio-conf--8430-.c:7:26: error: 'MNT_NOWAIT' undeclared (first use 
in this function)
On 2016-08-22 17:33:13 +0000, Jens Axboe said:

> On 08/22/2016 10:37 AM, Saeed wrote:
>> Why are there multiple entries for each interval / second in the fio log
>> generated?
>> 
>> 1, 585142, 1, 4096
>> 1, 4096000, 1, 4096
>> 1, 4096000, 1, 4096
>> 1, 0, 1, 4096
>> 1, 0, 1, 4096
>> 1, 4096000, 1, 4096
>> 1, 0, 1, 4096
>> 1, 0, 1, 4096
>> 1, 4096000, 1, 4096
>> 1, 0, 1, 4096
>> 2, 4096000, 1, 4096
>> 2, 4096000, 1, 4096
>> 2, 4096000, 1, 4096
>> 2, 0, 1, 4096
>> 2, 4096000, 1, 4096
>> 2, 4096000, 1, 4096
>> 2, 4096000, 1, 4096
>> 2, 0, 1, 4096
>> 2, 0, 1, 4096
>> 2, 0, 1, 4096
> 
> Ditto for this one, try current -git.



