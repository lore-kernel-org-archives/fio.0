Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:64181 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829AbaHEQFk (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 5 Aug 2014 12:05:40 -0400
Received: by mail-ie0-f175.google.com with SMTP id x19so1262825ier.6
        for <fio@vger.kernel.org>; Tue, 05 Aug 2014 09:05:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9E8FC62FFD81D74BA20610CD2B890B843DF4F8@SHSMSX101.ccr.corp.intel.com>
References: <9E8FC62FFD81D74BA20610CD2B890B843DF4F8@SHSMSX101.ccr.corp.intel.com>
Date: Tue, 5 Aug 2014 12:05:39 -0400
Message-ID: <CAFTzLMOm7N_psDX5YW1HKQv3Xby-OM7EvVeHyvoYVUFV0_cYYA@mail.gmail.com>
Subject: Re: bug report
From: Vasily Tarasov <tarasov@vasily.name>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Zhu, Zhengyun" <zhengyun.zhu@intel.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Zhu,

If the total run time of the job is only 30 seconds, there is no way
to have a warm-up time more than 30 seconds. In fact, during the
warm-up time fio executes exactly same workload as during the "main"
run. That is a definition of warm-up time. So, if the whole workload
can run for only 30 seconds, there is no way to warm the system up for
more than 30 seconds with this workload.

I think you need to make your experiment longer. For example, you can
use "loops=" parameter to execute a job multiple times.

HTH,
Vasily

On Tue, Aug 5, 2014 at 1:08 AM, Zhu, Zhengyun <zhengyun.zhu@intel.com> wrote:
>
> Hi,
>
> When I am using fio to do some tests, I find a problem.
>
> I am using a client with a 10Gb NIC to do the test case of sequential read, and the configuration file is below:
>
> //version 2.0.8
> global]
> iodepth=256
> runtime=600
> ioengine=libaio
> direct=1
> size=30g
> filename=/dev/vdb
> ramp_time=10
>
> [seq-read-64k]
> rw=read
> bs=64k
> iodepth_batch_submit=8
> iodepth_batch_complete=8
>
>
> we know the bandwidth can reach nearly 1100MB/s without the parameter of rate. It will finish fio in about 30 seconds, because the size is 30g.
>
> first, when I set ramp_time to 10, the fio result is below:
>
> seq-read-64k: (groupid=0, jobs=1): err= 0: pid=26840
>   read : io=20016MB, bw=1105.8MB/s, iops=17677 , runt= 18102msec
>
> second, when I set ramp_time to 35, the fio result is below:
>
> seq-read-64k: (groupid=0, jobs=1): err= 0: pid=26861
>   read : io=30720MB, bw=1102.3MB/s, iops=17636 , runt= 27870msec
>
> According to these, we can summary:
>
> 1. When we set ramp_time less than the time of fio finish read(we call it fftime for short), then
>      Runt = fftime - ramptime
> 2. When we set ramp_time greater than the time of fio finish read(we call it fftime for short), then
>   Runt = fftime
> My requirement is:
>   I want to use ramp time to warm up 50 seconds, and then collect iostat data, but fio has finished after 30 seconds, so I will collect all empty data.
>
> Could we not calculate time and io size during ramp time in runt time, or do I have some mistakes to understand it?
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
