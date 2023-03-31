Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E941BC761A6
	for <fio@archiver.kernel.org>; Fri, 31 Mar 2023 18:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjCaSla (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 31 Mar 2023 14:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjCaSla (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 31 Mar 2023 14:41:30 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A4BB478
        for <fio@vger.kernel.org>; Fri, 31 Mar 2023 11:41:29 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id o11so22136372ple.1
        for <fio@vger.kernel.org>; Fri, 31 Mar 2023 11:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680288089; x=1682880089;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JibGmTTgs1+iXwOlvt/2kYExjz4bK6A77xSvML13QZI=;
        b=Txm95it3W1L841QLqAYkVRpsth9cZ5fKd07bUiMS9E+3FQ2VJ7WmARfy09Iz8Tm4kA
         ohF6vBTBHw22jEKL/bvoAKuSXhbw/Hl7K+vuBTrG/rifRsipbIIrRr01bwBtrP/GXAVX
         5OhkMZg5xsCNT4OXnQoOpLppCUPLfgWC+uEfeCir8hT6Q/0b8f91N2bEFIAWmbbvwzh0
         eC6uP/qJqzQSE8F99OFI3U6HRp+OtWgDhWNmdi3qrFeIDDKkXF/GkGQ42by/LTAnfGZd
         4UGn7zxAs2Qm2ZrpebHg/p28np07bhHQzUkV63vTuVCC2xM6hMCCivCzk1HwKQtZuTJG
         8DyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680288089; x=1682880089;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JibGmTTgs1+iXwOlvt/2kYExjz4bK6A77xSvML13QZI=;
        b=AHo64qHjTcf2IW7pEPa+OqFhKX3dg31dZX2gMGoVvjHtPktbUK2M5FncMy68Lg5oGO
         gb+Zga39DN0uMc5qSiHMCq2eFU1kTIj9D59FjoVAVNLrOQMb6nU9MdzvRtqUSTxUW/Ue
         BmAPiCNWnD6Pf6ER7AzO1q8qZdwljJ7ndb4GVWU3kqhuc9ge892lZ2oXGw/GyAlQiu7A
         Hb3LcJClssgMCNt5O5RjeQcb/HsvUe1ULXIFe0aYVmFPAA3xTQyMD2rrehhAM6pKZ55b
         ZBR+/cwmXojD9qe8Y6eeeTVZi/IHiceWeeENt8b9RzhnHO9pJoM9TMEUr0vlaRkB3CEZ
         ohXw==
X-Gm-Message-State: AAQBX9dznRxobcJ4CGOw5SVTU5vw20Qlc71n/SvxkxgyxjFRG2R/+BtZ
        fOO5WgfdTI+DMWGRPtwrMTeYGg==
X-Google-Smtp-Source: AKy350aP5+pAzTtM3fNcX0yocd3E1oFK7U1eXcjy8h0ZXoaeN+9YP1UtLcCkj4NGfslDgXTfrnyefQ==
X-Received: by 2002:a17:903:41c6:b0:1a2:1a52:14b5 with SMTP id u6-20020a17090341c600b001a21a5214b5mr7362172ple.3.1680288088711;
        Fri, 31 Mar 2023 11:41:28 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f12-20020a170902ab8c00b001a1c74554f3sm1867765plr.185.2023.03.31.11.41.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 11:41:28 -0700 (PDT)
Message-ID: <dd139789-17e2-f99e-9362-40a266782719@kernel.dk>
Date:   Fri, 31 Mar 2023 12:41:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2 1/2] fio: add support for POSIX_FADV_NOREUSE
Content-Language: en-US
To:     Yuanchu Xie <yuanchu@google.com>, Vincent Fu <vincentfu@gmail.com>,
        fio@vger.kernel.org
Cc:     Yu Zhao <yuzhao@google.com>,
        "T . J . Alumbaugh" <talumbau@google.com>
References: <20230331183703.3145788-1-yuanchu@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230331183703.3145788-1-yuanchu@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 3/31/23 12:37 PM, Yuanchu Xie wrote:
> As of Linux kernel commit 17e810229cb3 ("mm: support
> POSIX_FADV_NOREUSE"), POSIX_FADV_NOREUSE hints at the LRU algorithm to
> ignore accesses to mapped files with this flag. Previously, it was a
> no-op.
> 
> Add it in fio as an fadvise_hint option to test the new behavior.

I just applied this, but then I pondered if we'll be breaking normal
installs that don't have POSIX_FADV_NOREUSE available? Maybe the
libc define predates the kernel actually implementing it by long
enough that this doesn't matter? Let's see what happens...

-- 
Jens Axboe


