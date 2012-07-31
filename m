Return-Path: <fio-owner@vger.kernel.org>
Received: from mail4.conversis.de ([213.203.219.181]:55667 "EHLO
	mail4.conversis.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab2GaUAa (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 31 Jul 2012 16:00:30 -0400
Received: from nexus.conversis.de (p5DCF7C28.dip.t-dialin.net [93.207.124.40])
	by mail4.conversis.de (Postfix) with ESMTP id D9CE7242004C
	for <fio@vger.kernel.org>; Tue, 31 Jul 2012 21:37:24 +0200 (CEST)
Message-ID: <501833F3.8030204@conversis.de>
Date: Tue, 31 Jul 2012 21:37:23 +0200
From: Dennis Jacobfeuerborn <dennisml@conversis.de>
MIME-Version: 1.0
Subject: Puzzling SSD performance
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,
I've been trying to benchmark a new System and currently have trouble
understanding the numbers I'm seeing.

The System is equipped with an LSI 9266-8i dual-core controller with 1G
cache. This controller is configured with two logical drives: one 4 sas
disk raid5 and one 3 Intel 320 SSD disk raid5.

Initial fio benchmarking with the folling config:

[randwrite]
rw=randwrite
direct=1
filename=/dev/vg_test/lv_benchmark
numjobs=1
group_reporting
bs=4k
runtime=300

led to these results for the two volumes:

sas: write: io=141368KB, bw=482529 B/s, iops=117 , runt=300004msec
ssd: write: io=2799.5MB, bw=9555.5KB/s, iops=2388 , runt=300001msec
(notice that I set the caching policy to writethrough for both logical drives)

Next I create a KVM virtual machine with MongoDB on the system and created
a small system drive and one sas and one ssd drive for the data and used
them for the virtual machine.

When I now run an looped inserts on the database I can get 23.000 inserts
with the sas disks but only 3000 inserts with the ssd disks?
What is really puzzling is that the IOPS numbers monitored look really strange.
In the sas case I see around 100 iops which seems a little low but the
inserted record is about 250 bytes in size so this might be explained by
MongoDB submitting multiple records with one IOP?

But when I use the SSD raid5 instead I see 3000 iops on the hosts (and in
the guest). I have no explanation for this.

Why would the number of iops be so different especially in the guest that
cannot even see the difference because the disk is only presented as an
abstrakt virtio disk to it?

Does anyone have an idea why the SSD disks perform so dramatically worse
than the SAS disks?

Regards,
  Dennis
