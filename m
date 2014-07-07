Return-Path: <fio-owner@vger.kernel.org>
Received: from na3sys010aog108.obsmtp.com ([74.125.245.84]:58722 "EHLO
	na3sys010aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751227AbaGGHgK convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>); Mon, 7 Jul 2014 03:36:10 -0400
From: Ritchie Babaylan <Ritchie.Babaylan@bitmicro.com>
Subject: Mix Sequential & Random Access
Date: Mon, 7 Jul 2014 07:30:40 +0000
Message-ID: <9E26C6259ACF1842A4815F929194EDD394B57968@phex01.corp.bitmicro.com>
References: <CAFTxqD8+B7BbUCAE5Md2Ro8y4c1FNYV_AZnOT1OvpJd4H2vQ_Q@mail.gmail.com>
 <CAFTxqD-R2AzHnq8B-QEGhkLSb_ftzjQ6evAgOiQn9DR0koHKXw@mail.gmail.com>
In-Reply-To: <CAFTxqD-R2AzHnq8B-QEGhkLSb_ftzjQ6evAgOiQn9DR0koHKXw@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I am confuse currently of string to put on rw= for the access profile below.

	30% seq 60% read; 8KB
	60% seq 30% read; 8KB


My config file was written in this matter.

[global]
ioengine=libaio
direct=1
ba=4kb
iodepth=4
numjobs=4
runtime=300
ramp_time=180
time_based
group_reporting
filename=/dev/sdb1

[job-1]
description=30% seq 60% read - 8kb
stonewall
bs=8kb
percentage_random=60
rwmixread=60
rwmixwrite=40
rw=??

[job-2]
description=60% seq 30% read - 8kb
stonewall
bs=8kb
percentage_random=40
rwmixread=30
rwmixwrite=70
rw=??


Appreciate any help on this matter.


Thanks,
Ritchie Babaylan

