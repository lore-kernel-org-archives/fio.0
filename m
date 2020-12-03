Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbgLCRoJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Dec 2020 12:44:09 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDF5C061A4E
        for <fio@vger.kernel.org>; Thu,  3 Dec 2020 09:43:29 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id s8so2734971wrw.10
        for <fio@vger.kernel.org>; Thu, 03 Dec 2020 09:43:29 -0800 (PST)
MIME-Version: 1.0
References: <CAMzroCjoMa0LD5tZhVvrkNPG=c_vGW0A1RVKQYN8jgY8LX7=HQ@mail.gmail.com>
 <CALjAwxgwFeY0qy0aF2X+BGUVQEJYcSrKjNY0FDgagvC6NBKs1A@mail.gmail.com>
In-Reply-To: <CALjAwxgwFeY0qy0aF2X+BGUVQEJYcSrKjNY0FDgagvC6NBKs1A@mail.gmail.com>
From: David Pineau <david.pineau@blade-group.com>
Date: Thu, 3 Dec 2020 18:43:17 +0100
Message-ID: <CAMzroChp5r587roLaLu8fHDr6NXMnKHfEue=8R_LovuvNW_auw@mail.gmail.com>
Subject: Re: Difficulties pushing FIO towards many small files and WORM-style use-case
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hello,

I was using Debian Buster's packaged version (3.12 I believe). I'm now
using the latest built from source, and it seems much more cooperative
on various fronts, though memory issues can still be reached with a
very big number of files. I still tried to reproduce the memory issue
and had difficulties reproducing the behavior previously observed; but
maybe the numbers used are a bit unorthodox. Since I could not
reproduce it quickly, I kind-of dropped the subject for now (sorry
Sitsofe, I hope that's not a bother?), as I'd rather focus on my aim
if you'll indulge me.

So, I'd like to start with a few straight-forward questions:
 - Does allocating files for the read-test ahead of time help
maximizing throughput ? (I feel like
 - Is there a list of options that are clearly at risk of affecting
the observed READ throughput ?
 - Does the Read/Write randomness/spread/scheduling affect maximal throughput ?
 - Is there a way to compute the required memory for the smalloc pools ?

That being said, I'd still like to try and reproduce a workload
similar to our service's with the aim of maximizing throughput but I'm
observing the following behavior, which surprised me:
 - If I increase the number of files (nrfiles), the throughput goes down
 - If I increase the number of worker threads (numjobs), the
throughput goes down
 - If I increase the "size" of the data to use for the job, the
throughput goes down

Note that this was done without modifying any other parameter (they're
all 60 seconds runs in an attempt to reduce the skew from short-lived
runs).
While the specific setup of our workload may partly explain these
behaviors, I'm surprised that on a 8-NVMe disks (3.8TB each) RAID10, I
cannot efficiently use random reads to reach the hardware's limits.








On Wed, Dec 2, 2020 at 7:55 PM Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
> Hi,
>
> On Wed, 2 Dec 2020 at 14:36, David Pineau <david.pineau@blade-group.com> wrote:
> >
> <snip>
>
> > With this information in mind, I build the following FIO configuration file:
> >
> > >>>>
> > [global]
> > # File-related config
> > directory=/mnt/test-mountpoint
> > nrfiles=3000
> > file_service_type=random
> > create_on_open=1
> > allow_file_create=1
> > filesize=16k-10m
> >
> > # Io type config
> > rw=randrw
> > unified_rw_reporting=0
> > randrepeat=0
> > fallocate=none
> > end_fsync=0
> > overwrite=0
> > fsync_on_close=1
> > rwmixread=90
> > # In an attempt to reproduce a similar usage skew as our service...
> > # Spread IOs unevenly, skewed toward a part of the dataset:
> > # - 60% of IOs on 20% of data,
> > # - 20% of IOs on 30% of data,
> > # - 20% of IOs on 50% of data
> > random_distribution=zoned:60/20:20/30:20/50
> > # 100% Random reads, 0% Random writes (thus sequential)
> > percentage_random=100,0
> > # Likewise, configure different blocksizes for seq (write) & random (read) ops
> > bs_is_seq_rand=1
> > blocksize_range=128k-10m,
> > # Here's the blocksizes repartitions retrieved from our metrics during 3 hours
> > # Normally, it should be random within ranges, but this mode
> > # only uses fixed-size blocks, so we'll consider it good enough.
> > bssplit=,8k/10:16k/7:32k/9:64k/22:128k/21:256k/12:512k/14:1m/3:10m/2
> >
> > # Threads/processes/job sync settings
> > thread=1
> >
> > # IO/data Verify options
> > verify=null # Don't consume CPU please !
> >
> > # Measurements and reporting settings
> > #per_job_logs=1
> > disk_util=1
> >
> > # Io Engine config
> > ioengine=libaio
> >
> >
> > [cache-layer2]
> > # Jobs settings
> > time_based=1
> > runtime=60
> > numjobs=175
> > size=200M
> > <<<<<
> >
> > With this configuration, I'm obligated to use the CLI option
> > "--alloc-size=256M" otherwise the preparatory memory allocation fails
> > and aborts.
>
> <snip>
>
> > Do you have any advice on the configuration parameters I'm using to
> > push my hardware further towards its limits ?
> > Is there any mechanism within FIO that I'm misunderstanding, which is
> > causing me difficulty to do that ?
> >
> > In advance, thank you for your kind advice and help,
>
> Just to check, are you using the latest version of fio
> (https://github.com/axboe/fio/releases ) and if not could you try the
> latest one? Also could you remove any/every option from your jobfile
> that doesn't prevent the problem from happening and post the cut down
> version?
>
> Thanks.
>
> --
> Sitsofe | http://sucs.org/~sits/

