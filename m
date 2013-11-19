Return-Path: <fio-owner@vger.kernel.org>
Received: from nm25-vm6.bullet.mail.ne1.yahoo.com ([98.138.91.118]:39136 "EHLO
	nm25-vm6.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752280Ab3KSX0L convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 19 Nov 2013 18:26:11 -0500
References: <1384903429.33093.YahooMailNeo@web120804.mail.ne1.yahoo.com>
Message-ID: <1384903569.45715.YahooMailNeo@web120806.mail.ne1.yahoo.com>
Date: Tue, 19 Nov 2013 15:26:09 -0800 (PST)
From: "K.R Kishore" <krkishore@yahoo.com>
Reply-To: "K.R Kishore" <krkishore@yahoo.com>
Subject: fio results show sequential reads and writes better for network block device than local block device?
In-Reply-To: <1384903429.33093.YahooMailNeo@web120804.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: "krkishore@yahoo.com" <krkishore@yahoo.com>

Hi=EF=BF=BD
I am trying to compare the performance of locally attached block device (SS=
D) with a network attached block device SSD)and I am seeing results for seq=
uential reads and writes using that I cannot explain. The other results (ra=
ndom reads, writes etc) are as expected, i.e. local is better than remote.

Here is my setup
- Two machines connected back-to-back by a 10G link
- Running RHEL 6.4 (Santiago), 2.6.32-358.6.1.el6.x86_64
- Running nbd v2.9.20 (http://nbd.sourceforge.net/)
- Running fio v2.1.2
- Using identical SSD on both machines - Samsung 840 PRO, 128G
- all 128G exported as rw volume

I have my fio commands and output (only relevant portions) below. I cannot =
understand how the network device can have high throughput than local devic=
e. I see that when I use smaller block sizes to measure iops, the numbers a=
re as expected (local > remote).=EF=BF=BD
Has anyone tried fio on nbd? does fio measure a transaction done when it se=
es the block-io request handed off to the virtual device and assume TCP wil=
l take care of completing the transaction? I can see that it might do so fo=
r posted operations such as writes, but reads?

Any clues?
thx,
Kishore


---------------------------------------------------------------------------=
----------------------------------

# Sequential Write Bandwidth test: Locally attached SSD
fio --name=3Dwritebw --filename=3D/dev/sdb --direct=3D1 --rw=3Dwrite --bs=
=3D1m --numjobs=3D4 --iodepth=3D32 --direct=3D1 --iodepth_batch=3D16 --iode=
pth_batch_complete=3D16 --runtime=3D300 --ramp_time=3D5 --norandommap --tim=
e_based --ioengine=3Dlibaio --group_reporting > sdb_seqwrite_bw.out

---- output----
writebw: (g=3D0): rw=3Dwrite, bs=3D1M-1M/1M-1M/1M-1M, ioengine=3Dlibaio, io=
depth=3D32
...
writebw: (groupid=3D0, jobs=3D4): err=3D 0: pid=3D18689: Tue Nov 19 10:27:0=
8 2013
=EF=BF=BD write: io=3D73932MB, bw=3D252024KB/s, iops=3D245, runt=3D300393ms=
ec
=EF=BF=BD =EF=BF=BD slat (msec): min=3D1, max=3D262, avg=3D96.57, stdev=3D6=
2.94
=EF=BF=BD =EF=BF=BD clat (msec): min=3D74, max=3D808, avg=3D423.21, stdev=
=3D90.93
=EF=BF=BD =EF=BF=BD =EF=BF=BDlat (msec): min=3D194, max=3D912, avg=3D519.78=
, stdev=3D68.03
...
#### Sequential Write Bandwidth test: Network attached SSD (nbd0 is exposed=
 as a NetworkBlockDevice)
fio --name=3Dwritebw --filename=3D/dev/nbd0 --direct=3D1 --rw=3Dwrite --bs=
=3D1m --numjobs=3D4 --iodepth=3D32 --direct=3D1 --iodepth_batch=3D16 --iode=
pth_batch_complete=3D16 --runtime=3D300 --ramp_time=3D5 --norandommap --tim=
e_based --ioengine=3Dlibaio --group_reporting > ndb0_seqwrite_bw.out

---- output----
writebw: (g=3D0): rw=3Dwrite, bs=3D1M-1M/1M-1M/1M-1M, ioengine=3Dlibaio, io=
depth=3D32
...
writebw: (groupid=3D0, jobs=3D4): err=3D 0: pid=3D8570: Mon Nov 18 18:18:34=
 2013
=EF=BF=BD write: io=3D142764MB, bw=3D487036KB/s, iops=3D475, runt=3D300163m=
sec
=EF=BF=BD =EF=BF=BD slat (msec): min=3D1, max=3D865, avg=3D134.08, stdev=3D=
70.20
=EF=BF=BD =EF=BF=BD clat (msec): min=3D35, max=3D865, avg=3D134.61, stdev=
=3D70.20
=EF=BF=BD =EF=BF=BD =EF=BF=BDlat (msec): min=3D148, max=3D1029, avg=3D268.6=
5, stdev=3D103.63
...
#--------------------------------------------------------------------------=
---
#### Sequential Read Bandwidth test: Locally attached SSD

fio --name=3Dreadbw --filename=3D/dev/sdb --direct=3D1 --rw=3Dread --bs=3D1=
m --numjobs=3D4 --iodepth=3D32 --direct=3D1 --iodepth_batch=3D16 --iodepth_=
batch_complete=3D16 --runtime=3D300 --ramp_time=3D5 --norandommap --time_ba=
sed --ioengine=3Dlibaio --group_reporting > sdb_seqread_bw.out

---- output----
readbw: (g=3D0): rw=3Dread, bs=3D1M-1M/1M-1M/1M-1M, ioengine=3Dlibaio, iode=
pth=3D32
...
readbw: (groupid=3D0, jobs=3D4): err=3D 0: pid=3D18943: Tue Nov 19 10:47:32=
 2013
=EF=BF=BD read : io=3D81596MB, bw=3D278285KB/s, iops=3D271, runt=3D300247ms=
ec
=EF=BF=BD =EF=BF=BD slat (msec): min=3D2, max=3D181, avg=3D96.16, stdev=3D4=
8.97
=EF=BF=BD =EF=BF=BD clat (msec): min=3D58, max=3D1161, avg=3D375.17, stdev=
=3D192.42
=EF=BF=BD =EF=BF=BD =EF=BF=BDlat (msec): min=3D223, max=3D1335, avg=3D471.3=
7, stdev=3D197.63
...
#### Sequential Read Bandwidth test: Network attached SSD (nbd0 is exposed =
as a NetworkBlockDevice)

fio --name=3Dreadbw --filename=3D/dev/ndb0 --direct=3D1 --rw=3Dread --bs=3D=
1m --numjobs=3D4 --iodepth=3D32 --direct=3D1 --iodepth_batch=3D16 --iodepth=
_batch_complete=3D16 --runtime=3D300 --ramp_time=3D5 --norandommap --time_b=
ased --ioengine=3Dlibaio --group_reporting > ndb0_seqread_bw.out

---- output----
readbw: (g=3D0): rw=3Dread, bs=3D1M-1M/1M-1M/1M-1M, ioengine=3Dlibaio, iode=
pth=3D32
...
readbw: (groupid=3D0, jobs=3D4): err=3D 0: pid=3D8781: Mon Nov 18 18:38:56 =
2013
=EF=BF=BD read : io=3D115692MB, bw=3D394691KB/s, iops=3D385, runt=3D300155m=
sec
=EF=BF=BD =EF=BF=BD slat (msec): min=3D77, max=3D405, avg=3D165.67, stdev=
=3D25.84
=EF=BF=BD =EF=BF=BD clat (msec): min=3D39, max=3D405, avg=3D166.11, stdev=
=3D25.58
=EF=BF=BD =EF=BF=BD =EF=BF=BDlat (msec): min=3D168, max=3D621, avg=3D332.26=
, stdev=3D28.49
...
#--------------------------------------------------------------------------=
---
