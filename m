Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A62C433EF
	for <fio@archiver.kernel.org>; Fri,  8 Apr 2022 18:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235019AbiDHSfT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 8 Apr 2022 14:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234781AbiDHSfS (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 8 Apr 2022 14:35:18 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1298EDF0A
        for <fio@vger.kernel.org>; Fri,  8 Apr 2022 11:33:13 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id g21so11604022iom.13
        for <fio@vger.kernel.org>; Fri, 08 Apr 2022 11:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=Zw4mOlgIM14FNTJ9IytIoOJjWN6GWa281LgsH7XqeOI=;
        b=D6gdGU/pGo4jYqDhnsaQcMvUiRmlGO5FOcTjHDWefDYRu96D4/JXiUKEmgyALm8Cd6
         74uxgH0P/e7IcQ9PtJCNU2bL71AbGHV2MCFO/zp7owzRsTyqT9LIl9+dt31qzKR9bCX8
         zD41Uu/qgrcTPZJruLOw56tstPLdGjtA8bxej6491xAAdjtg4ysiZcBkxRfqJd4tbJLM
         NMpuJDzx++BJDQP7cwSyYH1OPM97YkGh2e38ablXIy3NwQqxxnc0ZZYLzaNLGc4/8smt
         xqvnVrK9Z+SITAcPxbAIXRgRRh/JdrwO70B7aInBwRJp2fw2e5GA3cD73U6HkIro+LB/
         CPAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Zw4mOlgIM14FNTJ9IytIoOJjWN6GWa281LgsH7XqeOI=;
        b=gUMkYiG74IiQzyMUBuh5BnqcWzr9XLBF4/YEaql3ANZMcNyTFmu0Yg6k6O3GwSNYqh
         UpsUQVcv6X/Ra2iXPsw1s0EWoQUoMX1LpcVXJ/jifdDt1cK4QI0SmRIPg6eayRQBaGQV
         hQQDEjWv2Bs0ky3+F70g95QPglmJtlBq9Vok3tJD9LSp1AbZUswb88KinwF0pDZ26rco
         4O8BhtBZZ8GNK/GasMorOLsjGyQHw533iE3DPftTuy/WGIUM+j7ry1pHSBX6JC7zfA3C
         TRZnQSyapzir7/aLCRdjZpuO+FtW3f1C18xt8tqqA1nJR5e/ZVHk+qQ4lqX410woJ9sm
         iCgA==
X-Gm-Message-State: AOAM531+ThX7lNUD/AW6MFCY3qnHicZNiIsmiEoDuKV0dvoPkKlS7CId
        KWSx3QV6ZNpzwdgm+LheuFceJA==
X-Google-Smtp-Source: ABdhPJyZRlf2LpH+itx/g4vEmpanRm/Gj6yMUfUXJ8xIkxwrj2XLRyY8MoTR35qyHrgdqX0Rqsnlcg==
X-Received: by 2002:a6b:3c08:0:b0:64d:1af2:8ebb with SMTP id k8-20020a6b3c08000000b0064d1af28ebbmr4123044iob.95.1649442793331;
        Fri, 08 Apr 2022 11:33:13 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m7-20020a056e02158700b002c61541edd7sm15114249ilu.3.2022.04.08.11.33.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 11:33:12 -0700 (PDT)
Message-ID: <36b20148-a51e-989f-5468-1dfc9f29dcbc@kernel.dk>
Date:   Fri, 8 Apr 2022 12:33:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 0/3] iolog: add version 3 with timestamp support
Content-Language: en-US
To:     Mohamad Gebai <mogeb@fb.com>, fio@vger.kernel.org
References: <20220407174031.599117-1-mogeb@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220407174031.599117-1-mogeb@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 4/7/22 11:40 AM, Mohamad Gebai wrote:
> This set of patches introduces version 3 of the iolog replay. This
> version adds support for timestamps on both iolog_read and iolog_write.
> The 'wait' action is no longer supported with version 3, as the same
> behavior can be achieved with timestamps, and it keeps the iolog file
> easier to follow. This could also allow to potentially deprecate the
> 'wait' action eventually.

Needed a fixup on 32-bit, otherwise looks fine to me.

-- 
Jens Axboe

