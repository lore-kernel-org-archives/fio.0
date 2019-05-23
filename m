Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0a-002e3701.pphosted.com ([148.163.147.86]:34612 "EHLO
        mx0a-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731217AbfEWRmd (ORCPT
        <rfc822;fio@vger.kernel.org>); Thu, 23 May 2019 13:42:33 -0400
From: "Elliott, Robert (Servers)" <elliott@hpe.com>
Subject: RE: Either I don't understand how it work or I get unexpected result
 - mixed workload
Date: Thu, 23 May 2019 17:42:28 +0000
Message-ID: <AT5PR8401MB1169C4380AA584992B610CBDAB010@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <CY4PR0801MB3793BFC227015B3DEC29C824D9010@CY4PR0801MB3793.namprd08.prod.outlook.com>
 <CY4PR0801MB3793680FDFFBB3AE6BD85514D9010@CY4PR0801MB3793.namprd08.prod.outlook.com>
In-Reply-To: <CY4PR0801MB3793680FDFFBB3AE6BD85514D9010@CY4PR0801MB3793.namprd08.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Etienne-Hugues Fortin <efortin@cyberspicace.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>



> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of Etienne-Hugues Fortin
> Sent: Thursday, May 23, 2019 6:57 AM
> To: fio@vger.kernel.org
> Subject: Either I don't understand how it work or I get unexpected result - mixed workload
> 
> Hi,
> 
> I'm trying to create a workload where 70% would be read, 30% write with a ratio of 50% random for the
> whole workload. Currently, the job look like this:
> 
> [global]
> directory=\\server\path
> rw=randrw
> rwmixread=70
> percentage_random=50
> numjobs=16
> size=20g
> bs=32k
> zero_buffers
> direct=0
> sync=0
> refill_buffers
> ioengine=sync
> iodepth=1
> runtime=900
> time_based
> [32k_IOPS]
> 
> My understanding is that randrw will do random read/write, rwmixread will set the read percentage to
> 70% and percentage_random will make 50% of the IO to be random. However, when I look at the storage
> unit, I'm seeing between 85-87% of read and 15-13% of write. Is that expected based on that config
> file? If so, what is the reason behind it?

With direct=0 you're going through the Windows Volume Cache (similar to the linux page cache), which
distorts everything - reads hit in a big cache in DRAM, and writes are collected there and burst out
later.

> Is there a way to see the distribution of the IO that are sent/received by fio in order to validate
> read/write and random/sequential ratio?

debug=io logs every I/O; some processing of that would confirm fio is generating what you expect.  

In linux, strace is an easy way to observe the system calls of a program.

In linux, you can use trace points to see what various layers of the kernel driver stack are doing.
Jens wrote tools to make the block layer trace points easily accessible
(see https://linux.die.net/man/8/blktrace).


> 
> Thank you.
> 
> Etienne

