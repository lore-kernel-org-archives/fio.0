Return-Path: <fio-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:53461 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbbA2Bgg (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 28 Jan 2015 20:36:36 -0500
Message-ID: <54C98E9A.5010500@huawei.com>
Date: Thu, 29 Jan 2015 09:36:26 +0800
From: "majun (F)" <majun258@huawei.com>
MIME-Version: 1.0
Subject: Help: FIO testing problem on arm64
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All:
	I met a problem while testing the ramdisk peformance using fio.
	The platform is arm64 , fio version is 2.1.10.
	
	The ramdisk is enabled on my platform , so there are dev/ram0 ...to dev/ram15 totall 16 ramdisk devices.
	I tried to test these ramdisks performance uisng the script file list as below.

#!/bin/bash

#disk_list=`lsscsi | awk '{print $NF}' | cut -d/ -f3`
disk_list="ram1 ram2 ram3 ram4 ram5 ram6 ram7 ram8 ram9 ram10 ram11 ram12 ram13 ram14 ram15"
numjobs=1
runtime=180
	
run_18disk_test()
{
logdir=/root/18disk_performance_test
rm -rf $logdir
mkdir $logdir
for rw in read write randread randwrite
	do
		for bs in 4K 1M
		do
			for iodepth in 1 2 4 8 16 32
			do
				for disk in `echo $disk_list`
				do
					iodepth_2=`printf "%02d" $iodepth`
					fio --time_based --filename=/dev/$disk --rw=$rw --bs=$bs --ioengine=libaio --direct=1 --numjobs=$numjobs --iodepth=$iodepth --name=test --group_reporting --runtime=$runtime &> $logdir/${disk}_${bs}_${rw}_numjobs${numjobs}_iodepth${iodepth_2}.log &
				done
				sleep $runtime
			done
		done
done
}

	

	But the test result is not ok.
	The error log is:

test: (g=0): rw=write, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1
fio-2.1.14
Starting 1 process
fio: cache invalidation of /dev/ram2 failed: Device or resource busy
fio: cache invalidation of /dev/ram2 failed: Device or resource busy
fio: cache invalidation of /dev/ram2 failed: Device or resource busy
fio: cache invalidation of /dev/ram2 failed: Device or resource busy
fio: cache invalidation of /dev/ram2 failed: Device or resource busy
fio: cache invalidation of /dev/ram2 failed: Device or resource busy
fio: cache invalidation of /dev/ram2 failed: Device or resource busy
fio: cache invalidation of /dev/ram2 failed: Device or resource busy

	


