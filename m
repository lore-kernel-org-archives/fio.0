Return-Path: <fio-owner@vger.kernel.org>
Received: from exprod5og107.obsmtp.com ([64.18.0.184]:46208 "EHLO
	exprod5og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab2JTDSP (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 19 Oct 2012 23:18:15 -0400
Received: by mail-vc0-f198.google.com with SMTP id d16so1786062vcd.1
        for <fio@vger.kernel.org>; Fri, 19 Oct 2012 20:18:14 -0700 (PDT)
From: Yufei Ren <yufei.ren@stonybrook.edu>
Subject: [PATCH 0/4] FIO libnuma integration and 3 patches
Date: Fri, 19 Oct 2012 23:11:48 -0400
Message-Id: <1350702712-5168-1-git-send-email-yufei.ren@stonybrook.edu>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org
Cc: Yufei Ren <renyufei83@gmail.com>

From: Yufei Ren <renyufei83@gmail.com>

Three patches and a numa integration is present as follows.

Yufei Ren (4):
  Current cpu ioengine always bruns out 100 percent cpu cycles     no
    matter what the cpuload value is. Since no data is transferred    
    with cpuio, bytes_done would be ZERO. Consequently, think_time    
    is omitted and loops keeps running.
  If `thread' option is enabled, resource usage should be thread    
    based instead of process based. For the following job,
  rdma ioengine improvement
  Two new options, numa_cpu_nodes and numa_mem_policy, are created    
    for a fine-grained job level numa control. Please refer HOWTO and  
      README for detailed description.     A example job,
    examples/numa, is added as well.

 HOWTO          |   18 +++++++
 README         |   14 ++++--
 backend.c      |   45 ++++++++++++++++++-
 engines/cpu.c  |    5 ++
 engines/rdma.c |   28 ++++++++---
 examples/cpuio |    8 +++
 examples/numa  |   21 +++++++++
 fio.1          |   22 +++++++++
 fio.h          |   18 +++++++
 options.c      |  138 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 os/os-linux.h  |    5 ++
 stat.c         |    4 ++
 12 files changed, 313 insertions(+), 13 deletions(-)
 create mode 100644 examples/cpuio
 create mode 100644 examples/numa

-- 
1.7.2.3

