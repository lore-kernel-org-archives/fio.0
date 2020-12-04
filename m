Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730293AbgLDOmw (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 4 Dec 2020 09:42:52 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C973DC0613D1
        for <fio@vger.kernel.org>; Fri,  4 Dec 2020 06:42:11 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id v14so5721697wml.1
        for <fio@vger.kernel.org>; Fri, 04 Dec 2020 06:42:11 -0800 (PST)
MIME-Version: 1.0
References: <0de8d04b-bcaa-415a-4587-c5bd7f674079@sabaini.at>
In-Reply-To: <0de8d04b-bcaa-415a-4587-c5bd7f674079@sabaini.at>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 4 Dec 2020 14:41:44 +0000
Message-ID: <CALjAwxipZXaJ9z3WVJoukR=tt8OikcKDHDa5uCxuWQS_Y0Toag@mail.gmail.com>
Subject: Re: Fio verify crc32 fault
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: Peter Sabaini <peter@sabaini.at>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On Thu, 3 Dec 2020 at 17:27, Peter Sabaini <peter@sabaini.at> wrote:
>
> Hey,
>
> I've got a fio verify run on an NVMe that gives me a crc32 verification fault, however it's not reproducible -- when rerunning on the same NVMe it comes back fine.
>
> Also I'm getting a funny "error=Invalid or incomplete multibyte or wide character" error reported, see below.
>
> Any hints for this?
>
> Many thanks,
> peter.
>
> Test output
>
> Running command: sudo -n fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=fio_test_verify --bs=4M --iodepth=64 --size=95% --verify=crc32c-intel --runtime=7200s --filename=/dev/nvme0n1 --readwrite=randwrite
>
> fio_test_verify: (g=0): rw=randwrite, bs=4M-4M/4M-4M/4M-4M, ioengine=libaio, iodepth=64
> fio-2.2.10

^^^ Your fio is VERY old... Does the same thing happen with a recent
fio (see https://github.com/axboe/fio/releases for what we're up to)?

-- 
Sitsofe | http://sucs.org/~sits/

