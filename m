Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 847BCC4332F
	for <fio@archiver.kernel.org>; Fri,  4 Nov 2022 18:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiKDSQV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 4 Nov 2022 14:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiKDSQU (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 4 Nov 2022 14:16:20 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBDA40457
        for <fio@vger.kernel.org>; Fri,  4 Nov 2022 11:16:19 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id x15so3502389qtv.9
        for <fio@vger.kernel.org>; Fri, 04 Nov 2022 11:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VQ+Uw936qPaMPDOzfEP6DO8Fo12dV8H3vi85sE9esGE=;
        b=podRJzKWJ9lSZdKxRgw5zZu8mR5Hp68qF1aXzmvo8UdQJssloc29oDkKAk+KybBK58
         0wms3ZbgV+cW/Uwk7vRwBN0NlSgbekJlauKN+r02k5kiY9f9rsAP33Rk2UpqzjLQtXci
         gxm6fD8Ju7WGcm9hjOwXjwhJWZCC1VYsP/twdsOQVLSLwDPo9R90Rsbp/62EymBhbOA0
         TKGUrIJ+F7zvcc92I7WEQV5ZgYsJXxd7IyTNcqeDzfRUsxjze3AdiBvtTJH9VJ4dwEAT
         Zl3Uaqp8TG5JlYdo9rNRjH3evszKt20cBm52svGPNxrYMJXddSvlSz2LI1+3+pfFD5pV
         0aLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VQ+Uw936qPaMPDOzfEP6DO8Fo12dV8H3vi85sE9esGE=;
        b=uQd7lwrqb51mPLZWSUCNkIhxNYl2o7J7eWPTqG8svYDo/QA7HLlzu5MOh98W72fQ91
         8LOrUmxOfpLjZ7LYpUdVpa2QmUFY6PELcaF8ZhAesbPcNAAx6GQf/zHi0hRAbmyKDs0D
         7xbjflpuHj1wiMswTFpWkY5AnL8ZiyF4T46Hy4vAGaFm9Idcrg49984K11DsjDD6BV5b
         f346YCPB1Yy3gD8sH01gOzy1tLg/rGXbxWdByZpXG3DBGfHbyunslUVa8dkseWUaqMA7
         mlFEiWCZSUjdJiano9K6I3KVmiIniXUkkxB/sFk8jVd4q/1P3TGywRU3rWD44s1UresP
         yxqg==
X-Gm-Message-State: ACrzQf3KrL2ue/P2QIvnCPbhlmo8N2DJz1bTcV4yHZtm3sF5Y4TZaiUf
        hiTVmktVjmnVG9D3vqDxvMZV7nDcx4c=
X-Google-Smtp-Source: AMsMyM6aF8c1QRuC7cCKSqA7w6jVx8XGcaS8nUyTmdnl71Bx/fiQahS1DOiFeM5GCnAjeo8ksdSlrw==
X-Received: by 2002:a05:622a:4106:b0:3a5:108b:7858 with SMTP id cc6-20020a05622a410600b003a5108b7858mr28479219qtb.55.1667585778577;
        Fri, 04 Nov 2022 11:16:18 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id cr9-20020a05622a428900b0039cb59f00fcsm2828106qtb.30.2022.11.04.11.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 11:16:18 -0700 (PDT)
Message-ID: <4a740786-062f-4c8f-83e8-ab0dd8dec444@gmail.com>
Date:   Fri, 4 Nov 2022 14:16:17 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 0/2] fix FIO_OPT_STR_SET and update io_uring doc
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org
References: <CGME20221021114404epcas5p279068edb23eb2a58902424ed123df48d@epcas5p2.samsung.com>
 <20221021113236.32340-1-ankit.kumar@samsung.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221021113236.32340-1-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


On 10/21/22 07:32, Ankit Kumar wrote:
 > This series has 2 small patches.
 >
 > First patch deals with type FIO_OPT_STR_SET.
 >
 > FIO_OPT_STR_SET suggests the passed value should be
 > empty or boolean value ([0|1]).
 > But for the given type it accepts any integer value as there is
 > no limit for min and max values. Add a limit for that during
 > the option initialization.
 >
 > Note: With this the existing job files, test scripts which
 > used to pass any integer value will not work.
 >
 > Other way to fix this would be to update the typehelp for
 > FIO_OPT_STR_SET as "empty or integer value (opt=100)"
 >
 > Second patch sets the type for sqthread_poll to FIO_OPT_STR_SET
 > instead of FIO_OPT_INT. This I believe is what was originally
 > intended when the option was added.
 > This patch also adds the missing types for io_uring options
 > in the documentation.
 >
 > This now fixes the issue:
 > https://github.com/axboe/fio/issues/927
 >
 > Ankit Kumar (2):
 >    parse: set min and max limit for FIO_OPT_STR_SET
 >    io_uring: update documentation and small fix for sqthread_poll
 >
 >   HOWTO.rst          | 6 +++---
 >   engines/io_uring.c | 2 +-
 >   fio.1              | 6 +++---
 >   parse.c            | 2 +-
 >   4 files changed, 8 insertions(+), 8 deletions(-)
 >

Ankit, I merged the second patch that cleans up the documentation. The 
first patch may break existing job files and I'm not convinced that 
doing so is worth it, although I agree that your fix is what we should 
have done from the beginning.

Vincent
