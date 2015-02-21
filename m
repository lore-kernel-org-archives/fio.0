Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:42911 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbbBUPSz convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 21 Feb 2015 10:18:55 -0500
Received: by labgf13 with SMTP id gf13so11287236lab.9
        for <fio@vger.kernel.org>; Sat, 21 Feb 2015 07:18:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <D10CFEF2.19AB0%andrey.o.kudryavtsev@intel.com>
References: <D10CFEF2.19AB0%andrey.o.kudryavtsev@intel.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Sat, 21 Feb 2015 18:18:33 +0300
Message-ID: <CANvN+eksS-aw8h3fwZ6k=jVwu3-VG5OQg2CettTpikusYReYzw@mail.gmail.com>
Subject: Re: REPORT: High CPU utilization since 2.2.5
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Kudryavtsev, Andrey O" <andrey.o.kudryavtsev@intel.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Sat, Feb 21, 2015 at 2:10 AM, Kudryavtsev, Andrey O
<andrey.o.kudryavtsev@intel.com> wrote:
> Hi Jens,
> I’m running NVMe SSD benchmarks which are using multi-job configurations in the most common scenarios.
> I have noticed that since 2.2.5 release FIO has 3-4 times higher CPU utilization on the same workload, same system, same kernel 3.18.

It would be definitely more informative if you have attached run
summary or, at least, the excerpt with fio CPU utilization report.

Regards,
Andrey

> In fact I’m not able to achieve 450k IOPS on latest Core-i7 CPU due to 100% utilization.
> I tracked down the changes back, 2.1.14 is the most stable for me. Release had 2.2.0 the reporting issues, which were fixed in 2.2.5 but introduced high CPU utilization instead.
> Did anyone notice that too?
>
> Configuration details are bellow:
>
> [global]
> name=4k random read 4 ios in the queue in 32 queues
> filename=/dev/nvme0n1
> ioengine=libaio
> direct=1
> bs=4k
> rw=randread
> iodepth=4
> numjobs=32
> buffered=0
> size=100%
> runtime=0
> randrepeat=0
> norandommap
> refill_buffers
> [job1]
>
>
> --
> Andrey Kudryavtsev,
> SSD Solution Architect
> Intel Corp.
> inet: 83564353
> work: +1-916-356-4353
> mobile: +1-916-221-2281
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
