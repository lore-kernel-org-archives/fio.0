Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C8C9C4332F
	for <fio@archiver.kernel.org>; Fri,  2 Dec 2022 21:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbiLBVfr (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 2 Dec 2022 16:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbiLBVfp (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 2 Dec 2022 16:35:45 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3B0EF8A5
        for <fio@vger.kernel.org>; Fri,  2 Dec 2022 13:35:44 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id p12so4269476qvu.5
        for <fio@vger.kernel.org>; Fri, 02 Dec 2022 13:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=teHL95eGvzObaqYZypJsZwKlRPQmiGqhLNRBXycE5gc=;
        b=CxKX6On3vxkglLTobatEPSRveU/JN6dB2T0BdCXLD0MbPJeGaHxdHb0kAFEAefH6+4
         jIq2i9C6E96mAPtDhXUSz4zQ2BqLf7yNMH2QTQEsKc/i5Ebtily74aNlinXGzwvHy7HV
         7CIi2+dE7csD5ceylQLlGo++dcOtE/HxDamLeN0MWB+cfVuYP3eNkz9Q7vz3Pg26ur/A
         UowtWYGiMSEqgu/jVcHog1Pmy5T/GdSwtn1vRGBcUMuztGHcXyn1Di2UvC/4hJkJrOyq
         6+PXajixDQFITMh1C+G+j+OCa/mVXfndI/azCMWYs3712RHhtLPHGRPmsuKWP3F9Ziy9
         LaAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=teHL95eGvzObaqYZypJsZwKlRPQmiGqhLNRBXycE5gc=;
        b=Id934dKyh/yepTtvJ3QxCzHdLyptTPNHDo2RMlghtvxerQoE57TxB06AIc9QMKm0yX
         7NH7PSXw9GO+0R0amneFbURRPRrsNtpb7bPLBIf7ug8Yr36rd6fYhXTxk+Vk9uCw4Gbz
         NaGZap2DcnaOHOo0r8Aezo7vGwbyH/0XQqETyeKjJ0PyYnNulBvYo/BV6TmqqlCN3zvb
         V/WpMsuSTRjkJ7RP8WDITURGEsq0KpGsaS/ebeEXl8uTf3MZ/RWjvys8ofKX1c9vWvWP
         /jjNhTHIgfPicaaOUJsbvms3kG85iUYgFgmuP9dZqxggj97dloyka4X6xMdwwQZ1eABX
         vikg==
X-Gm-Message-State: ANoB5pnpsWuLSi3qRuOhlReQWVy/5Q2ywz/CFFOqHiE5rtiA0mmY5Vvc
        FVx9QLZwk0LSLZax7U6V5TA=
X-Google-Smtp-Source: AA0mqf6E2wQJMA6eoJR+34q5WT7kcz+EsnMqXiVW1A5gRtgHVrrR28Y52EFmqDi4084Vm10O/qRErA==
X-Received: by 2002:a0c:f40f:0:b0:4c7:884:7731 with SMTP id h15-20020a0cf40f000000b004c708847731mr19681839qvl.117.1670016943077;
        Fri, 02 Dec 2022 13:35:43 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id c19-20020ac81113000000b003a57eb7f212sm4839371qtj.10.2022.12.02.13.35.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 13:35:42 -0800 (PST)
Message-ID: <dabde822-adf4-53c3-2a0c-d14af7ad496b@gmail.com>
Date:   Fri, 2 Dec 2022 16:35:41 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 00/10] Add a libblkio engine
To:     Alberto Faria <afaria@redhat.com>, fio@vger.kernel.org
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
References: <20221201220803.52057-1-afaria@redhat.com>
Content-Language: en-US
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221201220803.52057-1-afaria@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 12/1/22 17:07, Alberto Faria wrote:
> The libblkio library provides a unified API for efficiently accessing
> block devices using modern high-performance block I/O interfaces like
> io_uring and vhost-user-blk. Using libblkio reduces the amount of code
> needed for interfacing with storage devices and allows developers to
> focus on their applcations.
> 
> Add a libblkio engine that uses libblkio to perform I/O. This is useful
> to benchmark the library itself, and also adds support for storage
> interfaces and devices otherwise not supported by fio, such as
> virtio-blk PCI, vhost-user, and vhost-vDPA devices.
> 
> See the libblkio documentation [2] or KVM Forum 2022 [3] presentation
> for more information on the library itself.
> 
> [1] https://gitlab.com/libblkio/libblkio
> [2] https://libblkio.gitlab.io/libblkio/index.html
> [3] https://static.sched.com/hosted_files/kvmforum2022/8c/libblkio-kvm-forum-2022.pdf
> 
> v2:
> - In the HOWTO and manpage, point users to the libblkio docs to know
>    what drivers and properties are available.
> - Avoid mentioning libblkio API symbols in the HOWTO and manpage.
> - Don't document FIO_OPT_STR_SET options as having type bool in the
>    HOWTO and manpage.
> - Prevent null deref in fio_blkio_init() error path.
> - Fix total_threaded_subjobs() to only count jobs using the libblkio
>    engine.
> - Force `td->o.disable_slat = 1`, as request enqueueing is fast and it
>    is not possible to know exactly when a request is submitted.
> - Have all type declarations near the top of the file.
> - Be more economical with blank lines.
> 
> Alberto Faria (10):
>    Add a libblkio engine
>    Add engine flag FIO_SKIPPABLE_IOMEM_ALLOC
>    engines/libblkio: Allow setting option mem/iomem
>    engines/libblkio: Add support for poll queues
>    engines/libblkio: Add option libblkio_vectored
>    engines/libblkio: Add option libblkio_write_zeroes_on_trim
>    engines/libblkio: Add option libblkio_wait_mode
>    engines/libblkio: Add option libblkio_force_enable_completion_eventfd
>    engines/libblkio: Add options for some driver-specific properties
>    engines/libblkio: Share a single blkio instance among threads in same
>      process
> 
>   HOWTO.rst                                 |  95 +++
>   Makefile                                  |   6 +
>   configure                                 |  25 +
>   engines/libblkio.c                        | 914 ++++++++++++++++++++++
>   examples/libblkio-io_uring.fio            |  29 +
>   examples/libblkio-virtio-blk-vfio-pci.fio |  29 +
>   fio.1                                     |  78 ++
>   ioengines.h                               |   2 +
>   memory.c                                  |  22 +-
>   optgroup.h                                |   2 +
>   10 files changed, 1192 insertions(+), 10 deletions(-)
>   create mode 100644 engines/libblkio.c
>   create mode 100644 examples/libblkio-io_uring.fio
>   create mode 100644 examples/libblkio-virtio-blk-vfio-pci.fio
> 


Applied. Thanks.
