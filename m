Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA210C04FE1
	for <fio@archiver.kernel.org>; Wed, 16 Aug 2023 13:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245455AbjHPNgN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 16 Aug 2023 09:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238377AbjHPNfz (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 16 Aug 2023 09:35:55 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A232135
        for <fio@vger.kernel.org>; Wed, 16 Aug 2023 06:35:54 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id ada2fe7eead31-4476a9e8812so2763903137.2
        for <fio@vger.kernel.org>; Wed, 16 Aug 2023 06:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692192953; x=1692797753;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pqc590BXau0eYCmE2wEFD1mIUoZLgeXhTxu63CN/Kvg=;
        b=M/sjGZrVGatvw3oTVvnCjF/1YK1SEwRaLsTjdOuO+6ZSQ7cq07RF4AQgFganN+RFxu
         kRY1eg3VpfWCQRuNlPEnSFhaidSRbGlfGTscAV5yxjKufcibUl8Mhgal7dV3s/3sA+pZ
         8n5XfloNwxOOZ0x1ImTbmH4xYdu44he1jBDgzd/MTRJ0eiBdd0TfW48H4iVYhi/tnjrF
         pFm4l4nK7mcw/hQ2Yf93rM/sJvv14P7p4s7ExdW12vT3vrwOBAPr0e/NIC41QbcSCMmy
         iQi6RbuirnJh1eMpzlyJnpbP+KMX5p9Xn6BGlFxuOv72cDXg6mU69ppxI9kbDMX2q29Y
         HBRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692192953; x=1692797753;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pqc590BXau0eYCmE2wEFD1mIUoZLgeXhTxu63CN/Kvg=;
        b=SfhUpVi0Xy7Pd6rJLZn0E+KT7xwzXx5+AJ8G1NsJQ3yK1yt5H5Mj8V5UNpb6twr87/
         j1a3Nvn+V8C2SHrT9p0G5RIiHcjiQnD3ZWaaab3hqPPBNdpq1zPYcr9g+fx6DLosaLuO
         fx1+M0gcOPhCFZXsJT5KkzG0oBcCkterHJhari02KSiByuWWagdCjBytgHRE1LM7RjDi
         VbvhVGeF/S5Izi8SMVh7GxzZFSw470bH8IzSBtp+ZFJ9JACZRg1kXWVniVlhD8AMJ/bH
         t+iTyz2dPvTf6uOK3KSAm89dbUALvJTpMtuecRY2D9OefFFjNGDs3mB3LWW41ijdsO8q
         4h9w==
X-Gm-Message-State: AOJu0YwI9UYOPbUy4rLKOOi8TBcD2I7AAUqrAE+HUVa05MPmk1nZqoXk
        B1MedwyLVkMG/OVGj5NDGC4=
X-Google-Smtp-Source: AGHT+IGfgIKRHAbjf3vYI01lBFwWMMgGcuhnpMy0f2FvClKU3QP5sPM793kNQpSyoJBPlLBzXBNskA==
X-Received: by 2002:a67:b648:0:b0:443:6a5d:b312 with SMTP id e8-20020a67b648000000b004436a5db312mr1677355vsm.14.1692192953572;
        Wed, 16 Aug 2023 06:35:53 -0700 (PDT)
Received: from [192.168.1.208] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id h17-20020a05620a10b100b0076cd2591629sm4442561qkk.6.2023.08.16.06.35.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Aug 2023 06:35:53 -0700 (PDT)
Message-ID: <ec881daa-594e-2344-0d26-ce53593e2e88@gmail.com>
Date:   Wed, 16 Aug 2023 09:35:52 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] examples: add example and fiograph for protection
 information options
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org
References: <CGME20230816042708epcas5p293b76e5b342877751083b0bcae448c5d@epcas5p2.samsung.com>
 <20230816094616.132240-1-ankit.kumar@samsung.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230816094616.132240-1-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 8/16/23 05:46, Ankit Kumar wrote:
> Add missing io_uring_cmd ioengine options to fiograph config.
> Add two example job files for the protection information options.
> These include one for DIF i.e. extended LBA data size, and the other
> for DIX i.e. separate metadata buffer case.
> Add the corresponding fiograph diagram for these.
> 
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> ---

Applied. Thanks.

Vincent

