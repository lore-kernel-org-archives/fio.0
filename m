Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oln040092000084.outbound.protection.outlook.com ([40.92.0.84]:35520
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730328AbfEWL5b (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 23 May 2019 07:57:31 -0400
From: Etienne-Hugues Fortin <efortin@cyberspicace.com>
Subject: Either I don't understand how it work or I get unexpected result -
 mixed workload
Date: Thu, 23 May 2019 11:57:27 +0000
Message-ID: <CY4PR0801MB3793680FDFFBB3AE6BD85514D9010@CY4PR0801MB3793.namprd08.prod.outlook.com>
References: <CY4PR0801MB3793BFC227015B3DEC29C824D9010@CY4PR0801MB3793.namprd08.prod.outlook.com>
In-Reply-To: <CY4PR0801MB3793BFC227015B3DEC29C824D9010@CY4PR0801MB3793.namprd08.prod.outlook.com>
Content-Language: fr-FR
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

I'm trying to create a workload where 70% would be read, 30% write with a ratio of 50% random for the whole workload. Currently, the job look like this:

[global]
directory=\\server\path
rw=randrw
rwmixread=70
percentage_random=50
numjobs=16
size=20g
bs=32k
zero_buffers
direct=0
sync=0
refill_buffers
ioengine=sync
iodepth=1
runtime=900
time_based
[32k_IOPS]

My understanding is that randrw will do random read/write, rwmixread will set the read percentage to 70% and percentage_random will make 50% of the IO to be random. However, when I look at the storage unit, I'm seeing between 85-87% of read and 15-13% of write. Is that expected based on that config file? If so, what is the reason behind it?

Is there a way to see the distribution of the IO that are sent/received by fio in order to validate read/write and random/sequential ratio?

Thank you.

Etienne

