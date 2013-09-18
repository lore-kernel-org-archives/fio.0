Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.uni-ulm.de ([134.60.1.11]:56825 "EHLO mail.uni-ulm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab3IRO6n (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 18 Sep 2013 10:58:43 -0400
Received: from wattwurm.rz.uni-ulm.de (wattwurm.rz.uni-ulm.de [134.60.2.82])
	(authenticated bits=0)
	by mail.uni-ulm.de (8.14.6/8.14.2) with ESMTP id r8IEwZMH023870
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Wed, 18 Sep 2013 16:58:41 +0200 (CEST)
Date: Wed, 18 Sep 2013 16:58:30 +0200
From: Juergen Salk <juergen.salk@uni-ulm.de>
Subject: Amount of data read with mixed workload sequential/random with
 percentage_random set
Message-ID: <20130918145830.GA24714@wattwurm.rz.uni-ulm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

given the following job file ...

--- snip ---

[global]
ioengine=sync
direct=0
# Block sizes for I/O units: 25% 19k, 15% 177k, 60% 350k 
bssplit=19k/25:177k/15:350k/60
# Use mixed workload: 30% random IO, 70% sequential IO
percentage_random=30
size=${SIZE}
numjobs=${NUMJOBS}
runtime=${RUNTIME}
directory=${DIRECTORY}

[application]
# Define of I/O pattern: Random read. 
rw=randread

--- snip ---

This is run with the following command: 

$ RUNTIME=0 NUMJOBS=4 SIZE=4096m DIRECTORY=/work/testsoft fio jobfile.fio >fio.out 2>&1

I have noticed from the output file, that this results in different 
amounts of data read by the individual processes:

$ grep io= fio.out
read : io=5847.5MB, bw=149458KB/s, iops=627, runt= 40063msec
read : io=4096.2MB, bw=140358KB/s, iops=595, runt= 29884msec
read : io=4096.3MB, bw=140889KB/s, iops=596, runt= 29772msec
read : io=5246.4MB, bw=134821KB/s, iops=560, runt= 39847msec
 READ: io=19286MB, aggrb=492947KB/s, minb=134820KB/s, maxb=149458KB/s, mint=29772msec, maxt=40063msec 

I have expected that every individual process will read 
its 4096 MB and then stop further reading. Or am I missing 
something?

Thanks in advance.

Best regards,

Juergen


