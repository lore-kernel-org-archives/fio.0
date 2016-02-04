Return-Path: <fio-owner@vger.kernel.org>
Received: from mx143.netapp.com ([216.240.21.24]:61057 "EHLO mx143.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756053AbcBDWcq convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 4 Feb 2016 17:32:46 -0500
From: neto from Brazil <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: FIO and replay_redirect
Date: Thu, 4 Feb 2016 22:32:24 +0000
Message-ID: <D2D93BA8.1CCD9%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A667A42EDB13154FAC8BAC83DEB5FCCA@hq.netapp.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,

This is neto from Brazil

How are you?

I have captured a blktrace from an Oracle workload. 18 dm devices.

Steps to capture:

blktrace <device 0> <device 1> ... -w 40
blkparse -i <device 0> -i <device 1> ... -o /dev/null -d oracle_trace.out

Trying to replay with FIO (here I have 2 devices - /dev/sdh and /dev/sdi)

Testing with one device:

[workload]
ioengine=libaio
iodepth=1
size=100g
numjobs=1
direct=1
thread
read_iolog=/root/traces/oracle-s144/oracle_trace.out
replay_no_stall=1
replay_redirect=/dev/sdh

[root@oraperf1 fio]# ./fio oracle-replay.cfg
workload: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=1
fio-2.2.9-26-g669e
Starting 1 thread
fio: ioengines.c:422: td_io_open_file: Assertion `!fio_file_open(f)'
failed.
Aborted (core dumped)





Questions:

1) The workload that I capture, all DM devices have 200GB size. My devices
where I want to replay have 100GB. I believe I will need to match the size
of all disks (where I captured the workload) with the destination where I
am going to replay. For example: If I capture a workload with 18 LUNs
200GB, to replay I need to have 18 LUNs with 200GB minimum.

2) I need to replay to more than one device. How can I do that with fio?
Seems to me replay_redirect is for a single specified device.

3) Any help why I am getting that error? fio: ioengines.c:422:
td_io_open_file: Assertion `!fio_file_open(f)' failed.

Thank you very much for all help.

All the best

neto

