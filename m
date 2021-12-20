Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 219D3C433EF
	for <fio@archiver.kernel.org>; Mon, 20 Dec 2021 14:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234329AbhLTOit (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 20 Dec 2021 09:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234352AbhLTOiL (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 20 Dec 2021 09:38:11 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E54C061396
        for <fio@vger.kernel.org>; Mon, 20 Dec 2021 06:38:11 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id g26so6360992lfv.11
        for <fio@vger.kernel.org>; Mon, 20 Dec 2021 06:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudlinux.com; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=XoimhOe1xWm1wFslAuCNJAxGAs4fhcPrcO6JBj1dY7E=;
        b=M6n4TwQr6qLnns7WCPxrv//vVc0nTiO79dijam07zNbuQUMjtu1WAZYNPpb2A9l57K
         ajlVyZEP0upraDs0uXD7BJIGg2AeddTFabaMHTbIY0lJ7e1KeuDbmRvg4k/ErYMnXlG8
         ANYcdqub8xY/nLg5CWwLphkMEylJkmZlnQ8s3uz8r6o2mgDMK3rqpHTPvD65QT/k0J2N
         YGTOxe6mAs8LWiqkPQaxHdB3vLfV3ENeTJ9RNg5F4pcIaos2rCrTEjr4ztmbnyDqmDuq
         lL9GpNpLDAykV9LblKaQnF05nXjml/n+NTrbSZrjzORLyJSKkpf9eIZfpDylfdXvHgkp
         OQRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=XoimhOe1xWm1wFslAuCNJAxGAs4fhcPrcO6JBj1dY7E=;
        b=F0v6cKtad32xKObxsWX6kmedGhOZzcsv7/MCJgWtCyw6KWM3D3PWLHr5jyCAxgBzrd
         zNJACgPG9IHQ4qs87CumdznA81VhJfr0Bb3B2zNR6RHRveETsul2Jf4Sqoqxo49UVyIS
         9G3Sax0AmiCwxUSWx0iPKql5+1vcMMI0yJcRb4LY4NP3OOJgLnPo7GR2IA0711DLJxV5
         vjVODyY6LBakh3SB7sstJlYMfNIs8/jleszM4QA7p9XP8ubLXo9tz6L1khJ2nw/QuufT
         sgsTsQMmBOtT+vZeWokS9FkPpIUtVHAfDKPJmg8pKojyDhJat2leATxSQsg3/VvWM8v6
         Nv4A==
X-Gm-Message-State: AOAM5321XQF2/Xg8oWO25X07clWM8F4lHcfNenqVq3DfSo5YAyXsTFEq
        KkIUUeOrkzCJb34j/Z48tmLI0g==
X-Google-Smtp-Source: ABdhPJzTJPln/ggiDlO99S+lVvfgEvrAZwIx3C5pwF4gZv8KWRExOtjRnzJ82O+IvTeA0hhttO2rDQ==
X-Received: by 2002:a05:6512:2027:: with SMTP id s7mr15476819lfs.678.1640011089544;
        Mon, 20 Dec 2021 06:38:09 -0800 (PST)
Received: from [192.168.222.111] ([37.139.80.10])
        by smtp.gmail.com with ESMTPSA id t19sm775980lfq.79.2021.12.20.06.38.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Dec 2021 06:38:09 -0800 (PST)
Message-ID: <7cc48a89-7bc3-bd55-733b-c9d40fecb0ab@cloudlinux.com>
Date:   Mon, 20 Dec 2021 17:38:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Seyed Mohammad Fakhraie <fk.smoh@gmail.com>
Cc:     fio@vger.kernel.org
References: <CACzyWQx0YZgwyJLRzBESL-8EoLzWzyFrqWMsVb0hs1Z-K7TMSA@mail.gmail.com>
 <d3c7a9ca-af7e-9d70-f229-74558d17cfe2@cloudlinux.com>
 <CACzyWQzih6gCQ4vYGA9Hwj-Zq4_d+YKC1j=secP8W9nr7bZCgg@mail.gmail.com>
 <44a99ee0-4856-51eb-0172-9d635582223e@cloudlinux.com>
 <CACzyWQwCvsCkh=Ui_cr5Hh8jqZGEkX4B1YwujEnR6nYutjPveA@mail.gmail.com>
From:   Dmitry Antipov <dantipov@cloudlinux.com>
Subject: Re: Using FIO to benchmark Gluster
In-Reply-To: <CACzyWQwCvsCkh=Ui_cr5Hh8jqZGEkX4B1YwujEnR6nYutjPveA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 12/20/21 06:41, Seyed Mohammad Fakhraie wrote:

> I created a replica-3 setup on a single machine. It's description can
> be seen below:
> 
> volume Name: gv1
> Type: Replicate
> Volume ID: 14fce60f-78e1-4021-9939-81abcd71f761
> Status: Started
> Snapshot Count: 0
> Number of Bricks: 1 x 3 = 3
> Transport-type: tcp
> Bricks:
> Brick1: storage-node-8:/data/brick1/gv1
> Brick2: storage-node-8:/data/brick2/gv1
> Brick3: storage-node-8:/data/brick3/gv1
> Options Reconfigured:
> transport.address-family: inet
> nfs.disable: on
> performance.client-io-threads: off
> 
> I'm using Debian 10 with Gluster 5.5.
> After running the test using gfapi the same error showed itself during
> randread :
> 
> failed fio extend file 1vm-1G-rand-read-3rep to 18446744073709551615
> 
> The job file:
> [global]
> ioengine=gfapi
> volume=gv1
> brick=storage-node-8
> direct=1
> create_on_open=1
> ramp_time=1m
> iodepth=1
> numjobs=1
> openfiles=1
> bs=4k
> [1vm-1G-rand-read-3rep]
> filesize=1G
> time_based
> runtime=3min
> rw=randread
> write_bw_log=4k-read-3replica-ro.results
> write_iops_log=4k-read-3replica-ro.results
> write_lat_log=4k-read-3replica-ro.results

Reproduced, I'll take a look. To make sure we're seeing the same issue, could you also check brick
logs (usually /var/log/glusterfs/bricks/pool-[whatever].log) for something similar to the following:

[2021-12-20 14:27:18.193027 +0000] E [MSGID: 113038] [posix-inode-fd-ops.c:5318:posix_ftruncate] 0-test0-posix: ftruncate failed on fd=0x13e5838 (-1 [Invalid argument]
[2021-12-20 14:27:18.193163 +0000] E [MSGID: 115063] [server-rpc-fops_v2.c:1214:server4_ftruncate_cbk] 0-test0-server: TRUNCATE info [{frame=50}, {FTRUNCATE_fd_no=0}, 
{uuid_utoa=1287dc8e-2896-4580-a14b-ef84ea9aad84}, {client=CTX_ID:3acbbb24-88af-48cd-9da0-62922a7855a3-GRAPH_ID:0-PID:671237-HOST:fedora-PC_NAME:test0-client-0-RECON_NO:-0}, {error-xlator=test0-posix}, 
{errno=22}, {error=Invalid argument}]

Dmitry
