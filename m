Return-Path: <fio-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49074 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab0CYUJN convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 25 Mar 2010 16:09:13 -0400
From: "Veal, Bryan E" <bryan.e.veal@intel.com>
Date: Thu, 25 Mar 2010 13:09:05 -0700
Subject: refill_buffers has high CPU utilization
Message-ID: <43F901BD926A4E43B106BF17856F0755A37180B3@orsmsx508.amr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi all,

I'm experiencing really high CPU utilization with the refill_buffers option, presumably due to using rand() to generate all the data:

Output with zero_buffers:
zero_buffers: (g=0): rw=randwrite, bs=64K-64K/64K-64K, ioengine=psync, iodepth=1
...
zero_buffers: (g=0): rw=randwrite, bs=64K-64K/64K-64K, ioengine=psync, iodepth=1
zero_buffers: (groupid=0, jobs=32): err= 0: pid=21556
  write: io=4600MB, bw=156966KB/s, iops=2452, runt= 30009msec
    clat (usec): min=378, max=139675, avg=13045.49, stdev=1468.67
    bw (KB/s) : min= 2609, max= 6677, per=3.11%, avg=4886.17, stdev=120.46
  cpu          : usr=0.30%, sys=1.87%, ctx=2452182, majf=0, minf=11463

Output with refill_buffers:
refill_buffers: (g=0): rw=randwrite, bs=64K-64K/64K-64K, ioengine=psync, iodepth=1
...
refill_buffers: (g=0): rw=randwrite, bs=64K-64K/64K-64K, ioengine=psync, iodepth=1
refill_buffers: (groupid=0, jobs=32): err= 0: pid=21503
  write: io=4246MB, bw=144867KB/s, iops=2263, runt= 30010msec
    clat (usec): min=293, max=140908, avg=13969.29, stdev=1837.85
    bw (KB/s) : min= 1187, max= 6843, per=3.13%, avg=4535.65, stdev=204.58
  cpu          : usr=37.76%, sys=1.63%, ctx=2286876, majf=0, minf=29750

While it is useful to write random data, the overhead is prohibitively expensive in high-throughput tests.  Would it be a better option to allocate a large memory buffer, initialize it with random data, and use random offsets within the buffer for data to write to the disk?

--
Bryan Veal <bryan.e.veal@intel.com>
NOT SPEAKING FOR INTEL
