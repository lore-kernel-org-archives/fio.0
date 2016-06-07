Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:33694 "EHLO
	mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbcFGGCF (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 7 Jun 2016 02:02:05 -0400
Received: by mail-vk0-f46.google.com with SMTP id d64so105263244vkb.0
        for <fio@vger.kernel.org>; Mon, 06 Jun 2016 23:02:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKapHkMhGrnb1g=b9Pz_D_Frx8OSP65aiXBBM_KgVy5wpSz-kw@mail.gmail.com>
References: <CAKapHkMhGrnb1g=b9Pz_D_Frx8OSP65aiXBBM_KgVy5wpSz-kw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 7 Jun 2016 07:02:02 +0100
Message-ID: <CALjAwxgBd3cGc3==9rQrkM3GW7=87MRLM6aMeSToDhyeTR75tA@mail.gmail.com>
Subject: Re: System IOPS vs. fio IOPS
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Karan Singh <karan@redhat.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 6 June 2016 at 22:41, Karan Singh <karan@redhat.com> wrote:
>
> I am running a FIO job and at the same time monitoring bandwidth /
> IOPS using iostat command. What i found is FIO reports total IOPS as
> 431 ( 215 read , 216 write, see below output ) , but iostat r/s and
> w/s reports in the magnitude of a few thousands.
> So my query is
>
> #1  : Is r/s and w/s fields in iostat output corresponds to read and
> write IOPS ? ( https://serverfault.com/questions/342273/disk-iops-count-in-gnu-linux
> mentions r/s and w/s as IOPS)
> #2  : If yes then why does they dont match with FIO IOPS results ?

See below for a guess.

> #4  : Whats your favourite command / tool to monitor system IOPS ?

It depends on what level you want to record the statistics. The
diagram on http://www.brendangregg.com/linuxperf.html gives some good
starting tools.

> # fio --filename=/dev/nvme0n1 --name=rw-4M --rw=rw --ioengine=libaio
> --bs=4M --numjobs=1 --direct=1 --randrepeat=0  --iodepth=1
> --runtime=300 --ramp_time=5 --size=100G --group_reporting

Your block size is huge - won't the kernel wind up breaking this up
and submitting multiple smaller requests to the device? What's are
nvme0n1's queue/max_* values? Do you have better correlation at
smaller block sizes (e.g. 4k)?

The information on
https://www.ibm.com/developerworks/community/blogs/58e72888-6340-46ac-b488-d31aa4058e9c/entry/exploring_the_linux_storage_path_tracing_block_i_o_kernel_events?lang=en
will allow you to trace I/Os going through the block layer so you can
get a better idea of what's going on (note that fio often tells you if
the kernel did merges in its block device output).

-- 
Sitsofe | http://sucs.org/~sits/
