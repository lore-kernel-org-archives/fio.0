Return-Path: <fio-owner@vger.kernel.org>
Received: from legacy.ddn.com ([64.47.133.206]:44311 "EHLO legacy.ddn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750985AbeEKSPz (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 11 May 2018 14:15:55 -0400
From: Jim Reuter <jreuter@ddn.com>
Subject: fio synchronization across client/server?
Date: Fri, 11 May 2018 18:10:31 +0000
Message-ID: <BBE28C8D35EDEC48B06294CB3C6597278D2CD8@LAX-EX-MB3.datadirect.datadirectnet.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

I am trying to figure out if something I want to do is possible with fio.  Large high performance storage systems often require load to be generated from multiple hosts over multiple interconnects to reach (and test) maximum performance.  But the fio documentation says nothing about how or if any synchronization is done between clients and servers (in the fio --client and --server meaning of these terms).

Let's begin with a trivial single node example:

[global]
bs=4k
iodepth=16
direct=1
ioengine=libaio
randrepeat=0
time_based
runtime=60

[rrsda]
rw=randread
filename=/dev/sda
[rrsdb]
rw=randread
filename=/dev/sdb

[rwsda]
stonewall
rw=randwrite
filename=/dev/sda
[rrsdb]
rw=randwrite
filename=/dev/sdb

The above will run concurrent random read workloads on /dev/sda and /dev/sdb, then switch to random write workloads on the same.  In my situation, with a multi-client external array storage, the two LUNs to test might be /dev/sda on host1 and /dev/sda on host2.  How do I achieve the above test but with the devices on different nodes using fio?  If I am reading the documentation correctly, using separate job files is an implicit stonewall, so I cannot just split the node specific parts from above into separate job files. 

I could split this into completely separate job files for the randread and randwrite parts and have one for each node, but then these just run independently, so I do not get the purpose of the client/server fio feature for this.  Or I could just launch separate fio jobs on each node and hope they start at roughly the same time, which is a hack and possibly highly variable, which can skew results.  What am I missing?  Can fio do this?  If not, what is the real purpose of the client/server feature?

