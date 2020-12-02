Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbgLBS4X (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Dec 2020 13:56:23 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F5DC0613CF
        for <fio@vger.kernel.org>; Wed,  2 Dec 2020 10:55:43 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id v14so10287837wml.1
        for <fio@vger.kernel.org>; Wed, 02 Dec 2020 10:55:43 -0800 (PST)
MIME-Version: 1.0
References: <CAMzroCjoMa0LD5tZhVvrkNPG=c_vGW0A1RVKQYN8jgY8LX7=HQ@mail.gmail.com>
In-Reply-To: <CAMzroCjoMa0LD5tZhVvrkNPG=c_vGW0A1RVKQYN8jgY8LX7=HQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 2 Dec 2020 18:55:16 +0000
Message-ID: <CALjAwxgwFeY0qy0aF2X+BGUVQEJYcSrKjNY0FDgagvC6NBKs1A@mail.gmail.com>
Subject: Re: Difficulties pushing FIO towards many small files and WORM-style use-case
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: David Pineau <david.pineau@blade-group.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On Wed, 2 Dec 2020 at 14:36, David Pineau <david.pineau@blade-group.com> wrote:
>
<snip>

> With this information in mind, I build the following FIO configuration file:
>
> >>>>
> [global]
> # File-related config
> directory=/mnt/test-mountpoint
> nrfiles=3000
> file_service_type=random
> create_on_open=1
> allow_file_create=1
> filesize=16k-10m
>
> # Io type config
> rw=randrw
> unified_rw_reporting=0
> randrepeat=0
> fallocate=none
> end_fsync=0
> overwrite=0
> fsync_on_close=1
> rwmixread=90
> # In an attempt to reproduce a similar usage skew as our service...
> # Spread IOs unevenly, skewed toward a part of the dataset:
> # - 60% of IOs on 20% of data,
> # - 20% of IOs on 30% of data,
> # - 20% of IOs on 50% of data
> random_distribution=zoned:60/20:20/30:20/50
> # 100% Random reads, 0% Random writes (thus sequential)
> percentage_random=100,0
> # Likewise, configure different blocksizes for seq (write) & random (read) ops
> bs_is_seq_rand=1
> blocksize_range=128k-10m,
> # Here's the blocksizes repartitions retrieved from our metrics during 3 hours
> # Normally, it should be random within ranges, but this mode
> # only uses fixed-size blocks, so we'll consider it good enough.
> bssplit=,8k/10:16k/7:32k/9:64k/22:128k/21:256k/12:512k/14:1m/3:10m/2
>
> # Threads/processes/job sync settings
> thread=1
>
> # IO/data Verify options
> verify=null # Don't consume CPU please !
>
> # Measurements and reporting settings
> #per_job_logs=1
> disk_util=1
>
> # Io Engine config
> ioengine=libaio
>
>
> [cache-layer2]
> # Jobs settings
> time_based=1
> runtime=60
> numjobs=175
> size=200M
> <<<<<
>
> With this configuration, I'm obligated to use the CLI option
> "--alloc-size=256M" otherwise the preparatory memory allocation fails
> and aborts.

<snip>

> Do you have any advice on the configuration parameters I'm using to
> push my hardware further towards its limits ?
> Is there any mechanism within FIO that I'm misunderstanding, which is
> causing me difficulty to do that ?
>
> In advance, thank you for your kind advice and help,

Just to check, are you using the latest version of fio
(https://github.com/axboe/fio/releases ) and if not could you try the
latest one? Also could you remove any/every option from your jobfile
that doesn't prevent the problem from happening and post the cut down
version?

Thanks.

-- 
Sitsofe | http://sucs.org/~sits/

