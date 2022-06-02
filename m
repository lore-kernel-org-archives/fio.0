Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C23B4CCA478
	for <fio@archiver.kernel.org>; Thu,  2 Jun 2022 08:24:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbiFBIYN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 2 Jun 2022 04:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232157AbiFBIYM (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 2 Jun 2022 04:24:12 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F651B78E
        for <fio@vger.kernel.org>; Thu,  2 Jun 2022 01:24:11 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id k36-20020a05600c1ca400b0039c2a3394caso685157wms.2
        for <fio@vger.kernel.org>; Thu, 02 Jun 2022 01:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=L6JCaQScsC3I/bXBi41PUod5cLc4dy5OBW/Lc8EAFoM=;
        b=3X6V7a1UE2WidrkaOV4GyO4JqrPt9MgWdC/TjFw85OtqSByA+bcRUejyF+1Tj4OI5X
         t2z2D1oHEUR+Iriz2KHJB/lnZwrjxwy1Sxst0a4XcbW0wFQGdQEeCXz8HwexgatBy/3M
         fSgJQs43nRh+zizbVXn6m6z5YB0kGTWSmOZm1cRBGVbicaGiytmPj12Wk4UAJS/Sxzxd
         lctHUlV6VFN186XDblcmnIkfik5RbYIS1/YMWJoaWmde7Z/xTJT2MV8Qlhw75HDtZrNO
         ZQNd9Bk0dgseKAc21bMiS0gfh/LAxgSJ0Kg87C/HSCP58P/zmjo/NzsPgvSrsUJbWoSd
         2WFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=L6JCaQScsC3I/bXBi41PUod5cLc4dy5OBW/Lc8EAFoM=;
        b=G0SX8V/H8ogux/s6v0y3OQlCQStIfeiseflhyayQcbDuBZt9SsrGqFzbgA0xlnwov9
         awoTlyXqUtXtEWIKFr4vQzFlaA/ht6F4KMEOS79u5qrp/9AgEpNOxU/0e0HNBR8fgFZG
         eCQUWhw+lPod6nvHDtQdRKgj1mf0dwcYUYr3CMDGQxtZ+Kq8BRVs/ydwgdRYSj/KoE2i
         CzmrMZoEHVofkisVkph7c8aphzUnGC7yoXIbP6u21M32GWDVlH74vch8Voiy4LFpxkH7
         u3wG86zQz/De9/aL4u9upqTmEmlXItuxWROsJEF/TQmaDaKvvxuN+od/LAGv8aIAoeRU
         76MA==
X-Gm-Message-State: AOAM532i/8T2smUXEE5LgGWJXAvEp1jReklaLmLzr8kWWdqBolojPh7j
        Tobvl8x2DDFnjwi0rk56C7Wwlg==
X-Google-Smtp-Source: ABdhPJwDdsvXVmzTpZZUZWUUjtk1WZ1Uw9Jad9+WrXikusvKDUoQMcZ+hPoE+foabhoxBQdvEPniOw==
X-Received: by 2002:a7b:c20f:0:b0:39a:46fb:64eb with SMTP id x15-20020a7bc20f000000b0039a46fb64ebmr2828710wmi.151.1654158249685;
        Thu, 02 Jun 2022 01:24:09 -0700 (PDT)
Received: from [127.0.1.1] ([193.52.24.5])
        by smtp.gmail.com with ESMTPSA id q15-20020adff50f000000b002102e6b757csm4279727wro.90.2022.06.02.01.24.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 01:24:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     ankit.kumar@samsung.com
Cc:     joshi.k@samsung.com, fio@vger.kernel.org, krish.reddy@samsung.com,
        anuj20.g@samsung.com
In-Reply-To: <20220531133155.17493-1-ankit.kumar@samsung.com>
References: <CGME20220531133739epcas5p31aa9479d49d5ae82a85b493bd0bb4e47@epcas5p3.samsung.com> <20220531133155.17493-1-ankit.kumar@samsung.com>
Subject: Re: [PATCH v3 0/9] Add support for uring passthrough commands
Message-Id: <165415824892.62192.6828408260468929567.b4-ty@kernel.dk>
Date:   Thu, 02 Jun 2022 02:24:08 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, 31 May 2022 19:01:46 +0530, Ankit Kumar wrote:
> This patchset adds a new I/O engine (io_uring_cmd), which enables support for
> io_uring passthrough commands. This work is based on upcoming 5.19 kernel.
> https://github.com/torvalds/linux/commits/master
> 
> This engine will use most of the existing helpers from io_uring. The I/O
> preparation, completion, file open, file close and post init paths are going to
> differ and hence io_uring_cmd will have its own helpers for them.
> 
> [...]

Applied, thanks!

[1/9] io_uring.h: add IORING_SETUP_SQE128 and IORING_SETUP_CQE32
      commit: 1bca8ad1e18249f13ef532947e0ce6a88105290c
[2/9] configure: check nvme uring command support
      commit: 76a490bb98dcfe03be9b4453b8fe401cc2a77f7f
[3/9] init: return error incase an invalid value is passed as option
      commit: f43aab595c1b8832d5f2641606f5bd5a7cdd22ea
[4/9] nvme: add nvme opcodes, structures and helper functions
      commit: b3d5e3fd80e3834097578e92d1b788065b8346e1
[5/9] engines/io_uring: add new I/O engine for uring passthrough support
      commit: 855dc4d44e000b68c01b0e33eae3389b49eb7f7f
[6/9] docs: document options for io_uring_cmd I/O engine
      commit: 3716f9f1bf6db8d4f6500d756912d5ac8cf0a670
[7/9] zbd: Check for direct flag only if its block device
      commit: 59c3200d579004d1d9c2dd3a36c162c780d520e4
[8/9] engines/io_uring: Enable zone device support for io_uring_cmd I/O engine
      commit: 3d05e0ffcbcc48d2876eb0207cb31b48ef857b5f
[9/9] examples: add 2 example job file for io_uring_cmd engine
      commit: dc3259dada4eb016560809850974a627b8d60a92

Best regards,
-- 
Jens Axboe


