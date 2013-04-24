Return-Path: <fio-owner@vger.kernel.org>
Received: from ravage.gg-net.de ([212.12.60.58]:44534 "EHLO ravage.gg-net.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932535Ab3DXMKU convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 24 Apr 2013 08:10:20 -0400
Received: from [217.92.252.169] (helo=blurr.ahrensburg.gg-net.de)
	by ravage.gg-net.de with esmtpa (Exim 4.72)
	(envelope-from <tim.rohwedder@gg-net.de>)
	id 1UUyJ7-0006BM-Fp
	for fio@vger.kernel.org; Wed, 24 Apr 2013 13:56:17 +0200
Received: from localhost ([127.0.0.1] helo=blurr.ahrensburg.gg-net.de)
	by blurr.ahrensburg.gg-net.de with esmtp (Exim 4.72)
	(envelope-from <tim.rohwedder@gg-net.de>)
	id 1UUyJ4-0008HE-Fc
	for fio@vger.kernel.org; Wed, 24 Apr 2013 13:56:14 +0200
Subject: issue with fio on drbd
From: =?windows-1252?Q?Tim_Rohwedder?= <tim.rohwedder@gg-net.de>
Date: Wed, 24 Apr 2013 13:56:14 +0200
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Message-Id: <zarafa.5177c85e.7c48.0e2449823a651c6d@blurr.ahrensburg.gg-net.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?windows-1252?Q?fio=40vger=2Ekernel=2Eorg?= <fio@vger.kernel.org>

Hello,

i'm getting  unexpected results benchmarking our new storages bandwidth running XFS in a DRBD RAID 1 over Ethernet.

The two peers are connected via DRBD 8.3 on Debian Wheezy x64.
I'm running Fio 2.0.8
The hardware is a hybrid RAID10 on an adaptec 71605Q. Build of 2x 3TB Seagate Conestellation CS SED and 2x Samsung 840 500GB.

My jobfile:
 [global]
disable_lat=1
disable_clat=1
disable_slat=1
clat_percentiles=0
direct=1
buffered=0
create_on_open=1

[randrw]
filename=rand.fio
rw=randrw
size=1g
runtime=180
stonewall

[randwrite]
filename=rand.fio
rw=randwrite
size=1g
runtime=180
stonewall

[seqwrite]
filename=seq.fio
rw=write
size=2g
runtime=180
stonewall

[dualseqwrite]
filename=seq.fio
rw=write
size=2g
numjobs=2
runtime=180
stonewall

[seqread]
filename=seq.fio
rw=read
size=2g
runtime=180
stonewall

I'm only measuring the bandwidth.

The results on the device without drbd are like this:
Randrw: 5564kb/s
Randrwr: 5575kb/s
Randw: 4520kb/s
Write: 74266kb/s
Dualwrite thread1: 44761kb/s
Dualwrite thread2: 44497kb/s
Read: 74619kb/s

The moment I start DRBD and set the node to primary the highest result is 500-700kb/s on every test. I tried various performance improving tweaks and even asynchronous sync for drbd.

Is there any way that these results emerge through the combination of fio and drbd?


kind regards

Tim Rohwedder


