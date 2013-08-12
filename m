Return-Path: <fio-owner@vger.kernel.org>
Received: from mx11.netapp.com ([216.240.18.76]:37696 "EHLO mx11.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757153Ab3HLQjl convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 12 Aug 2013 12:39:41 -0400
From: "Neto, Antonio Jose Rodrigues" 
	<Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Just to make sure about my config file is ok
Date: Mon, 12 Aug 2013 16:39:39 +0000
Message-ID: <CE2E880B.15066%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <008BEDF76A667F40A2D4BD62EFAA1081@hq.netapp.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi All,

This is neto from Brazil

How are you?

Could anyone please help me to double check if my config file below is
correct to match the following workload pattern.

Sequential Read 35%
Sequential Write 5%
Sequential Block size 64KB

Random Read 50%
Random Write 10%
Random Block size 4KB

Working set 2TB


[global]
bs=64k,4k
bs_is_seq_rand=1
ioengine=libaio
direct=1
runtime=14400
size=2000g
filename=/dev/mapper/360a980004175786a7a24444159626561:/dev/mapper/360a9800
0417578574c2b44415a364e77:/dev/mapper/360a98000417578574c2b44415a364f30:/de
v/mapper/360a98000417578574c2b44415a364e75:/dev/mapper/360a980004175786a7a2
4444159626567:/dev/mapper/360a980004175786a7a24444159626565:/dev/mapper/360
a980004175786a7a24444159626563:/dev/mapper/360a98000417578574c2b44415a364e7
9
rw=randrw
rwmixread=85
percentage_random=59,67
thread
unified_rw_reporting=1
group_reporting=1
norandommap=1

[random]
iodepth=2
numjobs=32

[sequential]
iodepth=8
numjobs=1

Thank you very much

All the best

neto

