Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-am1on0079.outbound.protection.outlook.com ([157.56.112.79]:36408
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753061AbbL2I3Y convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 29 Dec 2015 03:29:24 -0500
From: Thierry BERTAUD <tbertaud@conforama.fr>
Subject: fio-2c2c93d and with a lot of numjobs causing fio Jobs to Time Out
Date: Tue, 29 Dec 2015 08:29:19 +0000
Message-ID: <VI1PR05MB13437814C9CD31D2CECE7398B1FC0@VI1PR05MB1343.eurprd05.prod.outlook.com>
Content-Language: fr-FR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Fio team,

During a important workload fio is hanging.
with iodepth=128 and numjobs=128 , i have the issue but not with both set at 64.
Environment is AIX 6.1 against SAN disk (hba card 8 Gbps)

Could you take a look at this?

Error message and script file are copy-pasted below.
# cat myfio.fio
[global]
ioengine=posixaio
invalidate=1
norandommap
refill_buffers
randrepeat=0
runtime=300
time_based
direct=1
group_reporting

[test]
stonewall
filename=/dev/${HDISK}
rw=${RWTYPE}
rwmixread=${RRATIO}
bs=${BS}
iodepth=${QD}
numjobs=${NJ}
write_bw_log=${BS}-${RWTYPE}-${RRATIO}R-${QD}q-${QD}-${hdisk}_bw.results
write_iops_log=${BS}-${RWTYPE}-${RRATIO}R-${QD}q-${QD}-${hdisk}_iops.results
write_lat_log=${BS}-${RWTYPE}-${RRATIO}R-${QD}q-${QD}-${hdisk}_lat.results
# 

Command:
# HDISK=hdisk3 RWTYPE=rw RRATIO=0 BS=65536 QD=128 NJ=128 /home/padmin/fio/fio-2c2c93d/fio myfio.fio

PS: Output:
# ps -ef | grep fio | wc -l
     130
# ps -ef | grep fio | grep -v grep | wc -l
     130
# nmon
# ps -ef | grep fio | grep -v grep | wc -l
     130
# ps -ef | grep fio | grep -v grep | wc -l
     130
# date;ps -ef | grep fio | grep -v grep | wc -l
Tue Dec 29 02:59:07 CET 2015
      17
# date;ps -ef | grep fio | grep -v grep | wc -l
Tue Dec 29 02:59:12 CET 2015
      17
# date;ps -ef | grep fio | grep -v grep | wc -l
Tue Dec 29 03:01:35 CET 2015
       1
# date;ps -ef | grep fio | grep -v grep | wc -l
Tue Dec 29 03:04:12 CET 2015
      10
# date;ps -ef | grep fio | grep -v grep | wc -l
Tue Dec 29 03:10:17 CET 2015
       1
# date;ps -ef | grep fio | grep -v grep | wc -l
Tue Dec 29 03:12:18 CET 2015
      18
# date;ps -ef | grep fio | grep -v grep | wc -l
Tue Dec 29 03:13:39 CET 2015
      18
# date;ps -ef | grep fio | grep -v grep | wc -l
Tue Dec 29 03:20:52 CET 2015
      34
# date;ps -ef | grep fio | grep -v grep | wc -l
Tue Dec 29 03:25:03 CET 2015
      66
# date;ps -ef | grep fio | grep -v grep | wc -l
Tue Dec 29 03:26:43 CET 2015
      66
# 
# date;ps -ef | grep fio | grep -v grep | wc -l
Tue Dec 29 09:15:05 CET 2015
       2
#

Command output:
# HDISK=hdisk3 RWTYPE=rw RRATIO=0 BS=65536 QD=128 NJ=128 /home/padmin/fio/fio-2c2c93d/fio myfio.fio
test: (g=0): rw=rw, bs=64K-64K/64K-64K/64K-64K, ioengine=posixaio, iodepth=128
...
fio-2.3
Starting 128 processes
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.0 iops] [eta 17m:00s]
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.12.9% done] [0KB/1991KB/0KB /s] [0/31/0 iops] [eta 41m:01s]
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
Jobs: 115 (f=115): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(14),_(1),W(8),_(1),W(3),_(1),W(1),_(1),W(2),_(1),W(4),_(1),W(1),_(1),W(1),_(1),W(43)] [7.3% done] [0KB/11662KBJobs: 115 (f=115): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(14),_(1),W(8),_(1),W(3),_(1),W(1),_(1),W(2),_(1),W(4),_(1),W(1),_(1),W(1),_(1),W(43)] [7.3% done] [0KB/17351KBJobs: 115 (f=115): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(14),_(1),W(8),_(1),W(3),_(1),W(1),_(1),W(2),_(1),W(4),_(1),W(1),_(1),W(1),_(1),W(43)] [7.3% done] [0KB/6328KB/Jobs: 115 (f=115): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(14),_(1),W(8),_(1),W(3),_(1),W(1),_(1),W(2),_(1),W(4),_(1),W(1),_(1),W(1),_(1),W(43)] [7.3% done] [0KB/7111KB/fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
Jobs: 113 (f=113): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(1),W(1),_(1),W(2),_(1),W(4),_(1),W(1),_(1),W(1),_(1),W(43)] [6.4%fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
Jobs: 111 (f=111): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(1),W(1),_(1),W(2),_(1),W(4),_(1),W(1),_(1),W(1),_(1),W(13),_(1),Wfio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
Jobs: 108 (f=108): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(1),W(1),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(1),_(3),W(13),_(1),WJobs: 108 (f=108): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(1),W(1),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(1),_(3),W(13),_(1),WJobs: 108 (f=108): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(1),W(1),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(1),_(3),W(13),_(1),Wfio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
Jobs: 106 (f=106): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(1),W(1),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(1),_(3),W(5),_(1),W(fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.:12m:03s]
Jobs: 105 (f=105): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(1),W(1),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(1),_(3),W(1),_(1),W(Jobs: 105 (f=105): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(1),W(1),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(1),_(3),W(1),_(1),W(fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job. 02h:18m:13s]
Jobs: 104 (f=104): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(1),W(1),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(1),_(3),W(1),_(1),W(Jobs: 104 (f=104): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(1),W(1),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(1),_(3),W(1),_(1),W(fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job./0 iops] [eta 02h:24m:22s]
Jobs: 103 (f=103): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(1),W(1),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(1),_(3),W(1),_(1),W(Jobs: 103 (f=103): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(1),W(1),_(1),W(2),_(1),W(2),_(1),W(1),_(1),W(1),_(3),W(1),_(1),W(fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.ops] [eta 02h:30m:34s]
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
Jobs: 100 (f=100): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(1),W(1),_(1),W(2),_(1),W(1),_(2),W(1),_(1),W(1),_(3),W(1),_(1),W(fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.10168KB/0KB /s] [0/158/0 iops] [eta 02h:49m:19s]
Jobs: 99 (f=99): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(1),W(1),_(1),W(2),_(1),W(1),_(2),W(1),_(1),W(1),_(3),W(1),_(1),W(2)fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.933KB/0KB /s] [0/233/0 iops] [eta 02h:55m:35s]
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
Jobs: 97 (f=97): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(1),W(1),_(1),W(2),_(1),W(1),_(2),W(1),_(1),W(1),_(3),W(1),_(1),W(2)fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job. [3.3% done] [0KB/9376KB/0KB /s] [0/146/0 iops] [eta 03h:08m:09s]
Jobs: 96 (f=96): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(1),W(1),_(1),W(2),_(1),W(1),_(2),W(1),_(1),W(1),_(3),W(1),_(1),W(2)fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job._(1),W(2)] [3.2% done] [0KB/1493KB/0KB /s] [0/23/0 iops] [eta 03h:14m:27s]
Jobs: 95 (f=95): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(1),W(1),_(1),W(2),_(1),W(1),_(2),W(1),_(1),W(1),_(3),W(1),_(1),W(2),_(2),W(3),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(3),_(1),W(1),_(1),W(3),_(1),W(3),_(1),W(5),_(2),W(1),_(1),W(2)] [3.1% done] [0KB/15573KB/0KB /s] [0/243/0 iops] [eta 03h:20m:4fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
Jobs: 94 (f=94): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(3),W(2),_(1),W(1),_(2),W(1),_(1),W(1),_(3),W(1),_(1),W(2),_(2),W(3),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(3),_(1),W(1),_(1),W(3),_(1),W(3),_(1),W(5),_(2),W(1),_(1),W(2)] [3.0% done] [0KB/11733KB/0KB /s] [0/183/0 iops] [eta 03h:27m:05s]       fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
Jobs: 93 (f=93): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(3),_(1),W(1)Jobs: 93 (f=93): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(3),_(1),W(1)fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job. [2.9% done] [0KB/8675KB/0KB /s] [0/135/0 iops] [eta 03h:33m:23s]
Jobs: 92 (f=92): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(1),_(1),W(1)fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job._(1),W(2)] [2.8% done] [0KB/1207KB/0KB /s] [0/18/0 iops] [eta 03h:39m:44s]
Jobs: 91 (f=91): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(1),_(1),W(1)Jobs: 91 (f=91): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(1),W(3),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(1),_(1),W(1)fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job._(1),W(2)] [2.8% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta 03h:46m:06s]
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
Jobs: 88 (f=88): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(2),W(2),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(1),_(1),W(1)fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job._(1),W(2)] [2.6% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta 04h:05m:21s]
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
Jobs: 86 (f=86): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(2),W(2),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(1),_(1),W(1)fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job. [2.4% done] [0KB/19697KB/0KB /s] [0/307/0 iops] [eta 04h:18m:12s]
Jobs: 85 (f=85): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(2),W(2),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(1),_(1),W(1)fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job._(1)] [2.4% done] [0KB/18062KB/0KB /s] [0/282/0 iops] [eta 04h:24m:37s]
Jobs: 84 (f=84): [W(5),_(1),W(10),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(2),W(2),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(1),_(1),W(1)fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.% done] [0KB/8736KB/0KB /s] [0/136/0 iops] [eta 04h:31m:03s]
Jobs: 83 (f=83): [W(5),_(1),W(5),_(1),W(4),_(1),W(11),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(2),W(2),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(1),fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.(1)] [2.3% done] [0KB/34379KB/0KB /s] [0/537/0 iops] [eta 04h:37m:31s]
Jobs: 82 (f=82): [W(5),_(1),W(5),_(1),W(4),_(1),W(2),_(1),W(8),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(2),W(2),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.1),W(1),_(1)] [2.2% done] [0KB/9447KB/0KB /s] [0/147/0 iops] [eta 04h:44m:00s]
Jobs: 81 (f=81): [W(5),_(1),W(1),_(1),W(3),_(1),W(4),_(1),W(2),_(1),W(8),_(1),W(6),_(1),W(6),_(1),W(4),_(1),W(5),_(1),W(3),_(1),W(8),_(2),W(2),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(3),_(3),W(3),_(1),W(2),_(4),W(2),_(3),W(1),_(1),W(1),_(1)] [2.2% done] [0KB/9173KB/0KB /s] [0/143/0 iops] [eta 04h:50mfio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
Jobs: 78 (f=78): [W(5),_(1),W(1),_(1),W(3),_(1),W(4),_(1),W(2),_(1),W(8),_(1),W(6),_(2),W(5),_(1),W(4),_(1),W(2),_(1),W(2),_(1),W(3),_(1),W(8),_(2),W(2),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(3),_(3),W(1),_(1),W(1),_(1),W(2),_(4),W(2),_(3),W(1),_(1),W(1),_(1)] [2.1% done] [0KB/4830KB/0KB /s] [0/75/0fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
Jobs: 77 (f=77): [W(4),_(2),W(1),_(1),W(3),_(1),W(4),_(1),W(2),_(1),W(8),_(1),W(6),_(2),W(5),_(1),W(4),_(1),W(2),_(1),W(2),_(1),W(3),_(1),W(8),_(2),W(2),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(3),_(3),W(1),_(1),W(1),_(1),W(2),_(4),W(2),_(3),W(1),_(1),W(1),_(1)] [2.0% done] [0KB/16763KB/0KB /s] [0/261Jobs: 77 (f=77): [W(4),_(2),W(1),_(1),W(3),_(1),W(4),_(1),W(2),_(1),W(8),_(1),W(6),_(2),W(5),_(1),W(4),_(1),W(2),_(1),W(2),_(1),W(3),_(1),W(8),_(2),W(2),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(3),_(3),W(1),_(1),W(1),_(1),W(2),_(4),W(2),_(3),W(1),_(1),W(1),_(1)] [2.0% done] [0KB/0KB/0KB /s] [0/0/0 iopJobs: 77 (f=77): [W(4),_(2),W(1),_(1),W(3),_(1),W(4),_(1),W(2),_(1),W(8),_(1),W(6),_(2),W(5),_(1),W(4),_(1),W(2),_(1),W(2),_(1),W(3),_(1),W(8),_(2),W(2),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(3),_(3),W(1),_(1),W(1),_(1),W(2),_(4),W(2),_(3),W(1),_(1),W(1),_(1)] [2.0% done] [0KB/11377KB/0KB /s] [0/177Jobs: 77 (f=77): [W(4),_(2),W(1),_(1),W(3),_(1),W(4),_(1),W(2),_(1),W(8),_(1),W(6),_(2),W(5),_(1),W(4),_(1),W(2),_(1),W(2),_(1),W(3),_(1),W(8),_(2),W(2),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(3),_(3),W(1),_(1),W(1),_(1),W(2),_(4),W(2),_(3),W(1),_(1),W(1),_(1)] [2.1% done] [0KB/12017KB/0KB /s] [0/187fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
Jobs: 76 (f=76): [W(4),_(2),W(1),_(1),W(3),_(1),W(4),_(1),W(2),_(1),W(5),_(1),W(2),_(1),W(6),_(2),W(5),_(1),W(4),_(1),W(2),_(1),W(2),_(1),W(3),_(1),W(8),_(2),W(2),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(3),_(3),W(1),_(1),W(1),_(1),W(2),_(4),W(2),_(3),W(1),_(1),W(1),_(1)] [2.0% done] [0KB/22162KB/0KB fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
Jobs: 75 (f=75): [W(2),_(1),W(1),_(2),W(1),_(1),W(3),_(1),W(4),_(1),W(2),_(1),W(5),_(1),W(2),_(1),W(6),_(2),W(5),_(1),W(4),_(1),W(2),_(1),W(2),_(1),W(3),_(1),W(8),_(2),W(2),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(3),_(3),W(1),_(1),W(1),_(1),W(2),_(4),W(2),_(3),W(1),_(1),W(1),_(1)] [2.0% done] [0KB/10fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
Jobs: 72 (f=72): [W(2),_(1),W(1),_(5),W(2),_(1),W(4),_(1),W(2),_(1),W(5),_(1),W(1),_(2),W(6),_(2),W(5),_(1),W(4),_(1),W(2),_(1),W(2),_(1),W(3),_(1),W(8),_(2),W(2),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(3),_(3),W(1),_(1),W(1),_(1),W(2),_(4),W(2),_(3),W(1),_(1),W(1),_(1)] [1.9% done] [0KB/6250KB/0KB /fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
Jobs: 70 (f=70): [W(2),_(1),W(1),_(5),W(1),_(2),W(1),_(1),W(2),_(1),W(2),_(1),W(5),_(1),W(1),_(2),W(6),_(2),W(5),_(1),W(4),_(1),W(2),_(1),W(2),_(1),W(3),_(1),W(8),_(2),W(2),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(3),_(3),W(1),_(1),W(1),_(1),W(2),_(4),W(2),_(3),W(1),_(1),W(1),_(1)] [1.8% done] [0KB/10fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
Jobs: 69 (f=69): [W(2),_(1),W(1),_(5),W(1),_(2),W(1),_(1),W(1),_(2),W(2),_(1),W(5),_(1),W(1),_(2),W(6),_(2),W(5),_(1),W(4),_(1),W(2),_(1),W(2),_(1),W(3),_(1),W(8),_(2),W(2),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(3),_(3),W(1),_(1),W(1),_(1),W(2),_(4),W(2),_(3),W(1),_(1),W(1),_(1)] [1.8% done] [0KB/78Jobs: 69 (f=69): [W(2),_(1),W(1),_(5),W(1),_(2),W(1),_(1),W(1),_(2),W(2),_(1),W(5),_(1),W(1),_(2),W(6),_(2),W(5),_(1),W(4),_(1),W(2),_(1),W(2),_(1),W(3),_(1),W(8),_(2),W(2),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(3),_(3),W(1),_(1),W(1),_(1),W(2),_(4),W(2),_(3),W(1),_(1),W(1),_(1)] [1.8% done] [0KB/12fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
Jobs: 68 (f=68): [W(2),_(1),W(1),_(5),W(1),_(2),W(1),_(1),W(1),_(2),W(2),_(1),W(5),_(1),W(1),_(2),W(6),_(2),W(5),_(1),W(4),_(1),W(2),_(1),W(2),_(1),W(3),_(1),W(8),_(2),W(2),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(3),_(5),W(1),_(1),W(2),_(4),W(2),_(3),W(1),_(1),W(1),_(1)] [1.8% done] [0KB/1280KB/0KB /Jobs: 68 (f=68): [W(2),_(1),W(1),_(5),W(1),_(2),W(1),_(1),W(1),_(2),W(2),_(1),W(5),_(1),W(1),_(2),W(6),_(2),W(5),_(1),W(4),_(1),W(2),_(1),W(2),_(1),W(3),_(1),W(8),_(2),W(2),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(1),W(2),_(2),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(2),f(1),_(5),W(1),_(1),W(2),_(4),W(2),_(3),W(1),_(1),W(1),_(1)] [1.8% done] [0KB/8097KB/fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
Jobs: 65 (f=65): [W(2),_(1),W(1),_(5),W(1),_(2),W(1),_(1),W(1),_(2),W(2),_(1),W(5),_(4),W(6),_(2),W(5),_(1),W(4),_(1),W(2),_(2),W(1),_(1),W(3),_(1),W(8),_(2),W(2),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(2),W(1),_(2),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(3),_(5),W(1),_(1),W(2),_(4),W(2),_(3),W(1),_(1),W(1),_(1)] [1.7% done] [0KB/11649KB/0KB /s] [0/182fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.
Jobs: 62 (f=62): [W(2),_(1),W(1),_(5),W(1),_(2),W(1),_(1),W(1),_(3),W(1),_(1),W(5),_(4),W(5),_(3),W(5),_(1),W(3),_(2),W(2),_(2),W(1),_(1),W(3),_(1),W(8),_(2),W(2),_(3),W(2),_(1),W(1),_(4),W(1),_(3),W(1),_(2),W(1),_(2),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(1),W(1),_(3),W(3),_(5),W(1),_(1),W(2),_(4),W(2),_(3),W(1),_(1),W(1),_(1)] [1.6% done] [0KB/6257KB/0KB /s] [0/97/0fio: job 'test' hasn't exited in 103 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 106 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 104 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 105 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 104 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 105 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 105 seconds, it appears to be stuck. Doing forceful exit of this job.
fio: job 'test' hasn't exited in 104 seconds, it appears to be stuck. Doing forceful exit of this job.
Jobs: 4 (f=4): [_(55),W(1),_(13),W(1),_(6),W(1),_(42),W(1),_(8)] [0.5% done] [0KB/105.8MB/0KB /s] [0/1681/0 iops] [eta 21h:01m:48s]                                                                                                                                                                                                                                             fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.iops] [eta 21h:01m:02s]
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job. 21h:08m:31s]
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.3s]
fio: job 'test' hasn't exited in 60 seconds, it appears to be stuck. Doing forceful exit of this job.

WHat the process do:
# truss -af -p 3015098
3015098:        psargs: fio myfio.fio
3015098:                                                        = 0
3015098:        117309669: statx("/tmp/fio-dump-status", 0x2FF20648, 128, 010) Err#2  ENOENT
3015098:        117309669: _nsleep(0x2FF20A60, 0x2FF20AD8)      = 0
3015098:        117309669: statx("/tmp/fio-dump-status", 0x2FF20648, 128, 010) Err#2  ENOENT
3015098:        117309669: _nsleep(0x2FF20A60, 0x2FF20AD8)      = 0
3015098:        117309669: statx("/tmp/fio-dump-status", 0x2FF20648, 128, 010) Err#2  ENOENT
3015098:        117309669: _nsleep(0x2FF20A60, 0x2FF20AD8)      = 0
3015098:        117309669: statx("/tmp/fio-dump-status", 0x2FF20648, 128, 010) Err#2  ENOENT
3015098:        117309669: _nsleep(0x2FF20A60, 0x2FF20AD8)      = 0
3015098:        117309669: statx("/tmp/fio-dump-status", 0x2FF20648, 128, 010) Err#2  ENOENT
3015098:        117309669: _nsleep(0x2FF20A60, 0x2FF20AD8)      = 0
3015098:        117309669: statx("/tmp/fio-dump-status", 0x2FF20648, 128, 010) Err#2  ENOENT
3015098:        117309669: _nsleep(0x2FF20A60, 0x2FF20AD8)      = 0
3015098:        117309669: statx("/tmp/fio-dump-status", 0x2FF20648, 128, 010) Err#2  ENOENT
3015098:        117309669: _nsleep(0x2FF20A60, 0x2FF20AD8)      = 0
3015098:        117309669: statx("/tmp/fio-dump-status", 0x2FF20648, 128, 010) Err#2  ENOENT
3015098:        117309669: _nsleep(0x2FF20A60, 0x2FF20AD8)      = 0
3015098:        117309669: statx("/tmp/fio-dump-status", 0x2FF20648, 128, 010) Err#2  ENOENT
3015098:        117309669: _nsleep(0x2FF20A60, 0x2FF20AD8)      = 0
3015098:        117309669: statx("/tmp/fio-dump-status", 0x2FF20648, 128, 010) Err#2  ENOENT
3015098:        117309669: _nsleep(0x2FF20A60, 0x2FF20AD8)      = 0
3015098:        117309669: statx("/tmp/fio-dump-status", 0x2FF20648, 128, 010) Err#2  ENOENT
3015098:        117309669: _nsleep(0x2FF20A60, 0x2FF20AD8)      = 0
Pstatus: process is not stopped
#

# truss -acf -p 3015098
psargs: fio myfio.fio
Pstatus: process is not stopped
syscall               seconds   calls  errors
_nsleep        10.44    1423
kioctl           .00      56     56
statx            .00    1367   1367
                         ----     ---    ---
sys totals:               .00    2846   1423
usr time:                 .00
elapsed:                  .00
#

The file not exist in /tmp but the program look for it!!!
# ls -l /tmp/fio-dump-status
ls: 0653-341 The file /tmp/fio-dump-status does not exist.
#



  
Regards,
Thierry  