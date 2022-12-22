Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 037DCC4332F
	for <fio@archiver.kernel.org>; Thu, 22 Dec 2022 14:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiLVOxp (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 22 Dec 2022 09:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiLVOxo (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 22 Dec 2022 09:53:44 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A851D329
        for <fio@vger.kernel.org>; Thu, 22 Dec 2022 06:53:41 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id ml19so1368720qvb.11
        for <fio@vger.kernel.org>; Thu, 22 Dec 2022 06:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IRE0X45IjedLGSAeunRO2kN0VV4OAulmsK4x6m19ep8=;
        b=O34270+QU6pfc4uPHvfOVxFycWevWRyGNWlXRVPdhgPtxp8FJulottXymRQAQLnw+7
         9widOi2hiwPrZV0B5kkJ3eHzHKhz4gL9ejGJNuV8ilc/4hS4SsC/vtbR+RCXJsCYvDOc
         JLaPdYJh5k/0vU+HY5J5+/Hr0mgX8CqrQgdQDgE8N0GBC4+Q2yBWf8qmlSQB1JJm/dpO
         4v0Bv24pAerFKjpqy7rt3LBu21cTYwJRZYkdUJuWfEWecz8Ijwu8u6S/TEv6AunvWLpg
         NHm0YnjgNwxs1FYfA550NW6Q3LcNL/4caVg4oUrPie6ER+JL/NOvIyym3lJP3aIhV1gO
         XR4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IRE0X45IjedLGSAeunRO2kN0VV4OAulmsK4x6m19ep8=;
        b=GmwfUr6m5hp3xS3h5OaP6JkuiltNYrRox2tVp2ot23yqrZ5Tl7hLeA+pO7MP7cSmkR
         mxv53X4llBmpJJBxU1rnqeNOgO91ARZowGJGgwzyfVK3Vqe/z9AOTl2X7ELzHUxjZiAP
         27zh6UQoSKLJUobZoGsdf2alOl2KBDUUyuztjomIQf23r1vmgGA+RjkiJt/zkTj1hUzK
         vPawUXtG/yq41ImWMUctCPna8vaEOrhGFqkp+C9Vfc3SkRwU6uGKmHIMoeEMf3EQjc/O
         0cVb8SeN8eT46IfRsjsVmlaoomW6m3Vu3IIgmRcY7lY8r0Zdi6whnY5dDMJ+gvrwi7UB
         6NTw==
X-Gm-Message-State: AFqh2krREVi2Dnd0SS+Mz25Gwu+ZreB2cMtInYInBlSrhoAutXzTvfFN
        1AnDfIGkECnPHW5lRJsX59MEYG4dOL8=
X-Google-Smtp-Source: AMrXdXshXvHwf5YKb42xgLhL1JMAXwuqeloF+Fdmm76P6qJpU7Oi5UfzrFbqyDPxmoct+iJMlwQWRQ==
X-Received: by 2002:a05:6214:401a:b0:4c6:a836:98ff with SMTP id kd26-20020a056214401a00b004c6a83698ffmr10361384qvb.11.1671720820726;
        Thu, 22 Dec 2022 06:53:40 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id m14-20020ae9e70e000000b006e42a8e9f9bsm378295qka.121.2022.12.22.06.53.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Dec 2022 06:53:39 -0800 (PST)
Message-ID: <7d9f3cf6-f6fb-54d1-b2c9-c6e7c32344ef@gmail.com>
Date:   Thu, 22 Dec 2022 09:53:39 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 0/4] new options and fixes for xnvme ioengine
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org, simon.lund@samsung.com, m.ynddal@samsung.com
References: <CGME20221222044040epcas5p3abbde8c4a3775d39d237b0b6cf6dd04a@epcas5p3.samsung.com>
 <20221222043951.24590-1-ankit.kumar@samsung.com>
Content-Language: en-US
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221222043951.24590-1-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 12/21/22 23:39, Ankit Kumar wrote:
> This patch series adds
> 1. Few minor fixes and cleanups to the xnvme I/O engine.
> 2. xNVMe recently added a user-space VFIO based backend implemented
>     using libvfn. This allow users to select that instead of SPDK.
> 3. Add subnqn option for fabrics target with multiple systems.
> 4. Add an option to select memory backend.
> 
> Ankit Kumar (4):
>    engines/xnvme: fixes for xnvme ioengine
>    engines/xnvme: user space vfio based backend
>    engines/xnvme: add subnqn to fio-options
>    engines/xnvme: add support for picking mem backend
> 
>   HOWTO.rst       | 27 ++++++++++++++++++++++++++-
>   engines/xnvme.c | 44 ++++++++++++++++++++++++++++++++++++++------
>   fio.1           | 32 +++++++++++++++++++++++++++++++-
>   3 files changed, 95 insertions(+), 8 deletions(-)
> 

Applied. Thanks.
