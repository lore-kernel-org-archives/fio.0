Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgE0XS2 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 27 May 2020 19:18:28 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6D9C08C5C1
        for <fio@vger.kernel.org>; Wed, 27 May 2020 16:18:28 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id k11so4817200ejr.9
        for <fio@vger.kernel.org>; Wed, 27 May 2020 16:18:28 -0700 (PDT)
MIME-Version: 1.0
References: <CACmRju_xOV_8QRqH8=VWiDA1VM2SwmczcObk+HCgExnX4xsXoA@mail.gmail.com>
 <CACmRju8gdCJTsP6MOCVOUth0Zx4+w1BuMy64knZBGOXZ94FJWQ@mail.gmail.com>
In-Reply-To: <CACmRju8gdCJTsP6MOCVOUth0Zx4+w1BuMy64knZBGOXZ94FJWQ@mail.gmail.com>
From: =?UTF-8?B?6YK55a6H?= <yzou0503@gmail.com>
Date: Wed, 27 May 2020 19:18:15 -0400
Message-ID: <CACmRju-Y+Smd41F67+B_DW+=31VOYOUrvVcOKrCv5ObiJ4O3rQ@mail.gmail.com>
Subject: Fwd: iodepth option setting suggestions
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Dear All,

I'm working on using hardware to accelerate the OS stack of NVMe SSD.
By now, we provided these APIs to userspace:

read_async(); // there is a pre-allocated memory request buffer in
DRAM, if request buffer is not full, push request to buffer then
return. If buffer is full, send all request in buffer batch to the
accelerator, waiting for (polling) all request to be completed, and
return.
write_async();// same as read_async()
poll();// if there are some requests left in the request buffer,
finish processing them.

I feel like this is very similar to asynchronous I/O with libaio in
Linux, so we take this as the baseline. But I'm not sure in my use
case, for a fair comparison, how to set iodepth options:

iodepth_batch_submit
iodepth_batch_complete_min
iodepth_batch_complete_max
iodepth_low

Right now, I'm using:
fio --iodepth_batch_submit=0 --ioengine=libaio --direct=1 --buffered=0
sequential_write.fio

Any suggestions about other option settings?

Thank you.
Yu

