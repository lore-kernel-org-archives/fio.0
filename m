Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:52676 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbaAVVLe convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 22 Jan 2014 16:11:34 -0500
Received: by mail-la0-f44.google.com with SMTP id hm7so785724lab.17
        for <fio@vger.kernel.org>; Wed, 22 Jan 2014 13:11:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: Strange aggregate BW
From: grant <626542@gmail.com>
In-Reply-To: <CAJBj3vfjD=vz7XNmL-X1XNpJiUjp63kSFcQPM+kvjuKEWHsMnQ@mail.gmail.com>
Date: Thu, 23 Jan 2014 01:11:28 +0400
Content-Transfer-Encoding: 8bit
Message-Id: <7C8FB099-590C-470C-B878-A69907AF8436@gmail.com>
References: <748581DD-9A26-41D7-A537-58F6D6741B33@gmail.com> <CAJBj3vfjD=vz7XNmL-X1XNpJiUjp63kSFcQPM+kvjuKEWHsMnQ@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: John Williams <jwilliams4200@gmail.com>
Cc: fio@vger.kernel.org

HW RAID has got large cache, 12 GB per controller.
60 total drives in array, but in logical volume (controller A) used only 10.
I’ll tryed increase runtime of benchmark to bypass cache effect, and run batch of tests with cfgs:

# cat searead.fio
[read]
blocksize=${BSIZE}
filename=/dev/sda
rw=read
direct=1
bufferred=0
ioengine=libaio
iodepth=48
runtime=1h
numjobs=16
group_reporting
thread
disable_lat=1
disable_slat=1
disable_bw_measurement=1
flat_percentiles=0

and

# cat seqwrite.fio
[write]
…
rw=write
…

BSIZE = 4K, 8K, 32K, 64K, 256K, 512K, 1M, 8M, 10M, 64M

I’ve got results:

bs=4K, bw_read=1764, iops_read=451670, bw_write=1055, iops=write=270084
bs=8K, bw_read=1909, iops_read=244354, bw_write=1516, iops=write=194136
bs=32K, bw_read=2003, iops_read=64120, bw_write=1093, iops=write=34983
bs=64K, bw_read=383, iops_read=6131, bw_write=2102, iops=write=33639
bs=256K, bw_read=281, iops_read=1125, bw_write=1134, iops=write=4539
bs=512K, bw_read=295, iops_read=590, bw_write=1721, iops=write=3443
bs=1M, bw_read=287, iops_read=287, bw_write=1825, iops=write=1825
bs=8M, bw_read=330, iops_read=41, bw_write=1954, iops=write=244
bs=10M, bw_read=337, iops_read=33, bw_write=1614, iops=write=161
bs=64M, bw_read=317, iops_read=4, bw_write=1657, iops=write=25

bw’s in MB/s

bw_read in bs range 4K-32K under cache effect?
bw_write in all bss cache effect?

Pls help me to describe results.

On 21 янв. 2014 г., at 1:47, John Williams <jwilliams4200@gmail.com> wrote:

> On Mon, Jan 20, 2014 at 1:23 PM, grant <626542@gmail.com> wrote:
> 
>> I’ve got a HWRAID with 10 NL-SAS HDDs.
> 
> If it is HW RAID6 with 10 total drives, then the aggregrate write
> throughput to the HDDs is about 25% ( 10 / 8 - 1 ) higher than the
> write throughput that fio measures as going into the HW RAID device.
> 
> So you'd be looking at about 266MB/s per drive. Which seems unlikely.
> I wonder if your HW RAID has a large cache. Did you let the fio job
> run for the full 10 minutes? Because I would expect the cache to fill
> well before 10 minutes, unless the cache is huge.
