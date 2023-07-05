Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B54EFEB64DA
	for <fio@archiver.kernel.org>; Wed,  5 Jul 2023 22:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjGEWAL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 5 Jul 2023 18:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjGEWAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Jul 2023 18:00:11 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AFC9F
        for <fio@vger.kernel.org>; Wed,  5 Jul 2023 15:00:09 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-25e847bb482so27234a91.1
        for <fio@vger.kernel.org>; Wed, 05 Jul 2023 15:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1688594409; x=1691186409;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cXTPZiy65c3sANxRWbBVd8J6Cp5H/RHynv2wrAVkrLA=;
        b=KHyU0w8DvEMXwmP96qHM6pSUvJoMK9DWPlMKe2T8gOPbtug7oY1V7C+trjsYlPefEP
         8x0YQ/BJ39vdDGkpj1q/JCzdgIoKF85dfsQdklPbxKVt1hZbz5WNqJ3VMY4IFRcn19Wq
         hC6fm1YJXshGCdRJXII8Lv2CIPRggZIPQV43QW11uPcglwZhYmz/JVCfSsCCDgWgpDJG
         HEqwjNkXmt7w/CLjP59mGwJI+EoCCfeYKdsrWtbAW8Zg3E3XmtZ0DfyV2MEmLj1Uf+Yk
         LLPKOaHfOGFo/OSwe+KUpFUPRG4k8z/PpLHKWZ08aTyo3HGOOaeKxlHtFv/aYpjD7wUI
         CAjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688594409; x=1691186409;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cXTPZiy65c3sANxRWbBVd8J6Cp5H/RHynv2wrAVkrLA=;
        b=FXWzNlviA9pzdPr7oOq6V2irdhD49JHm+TkBQVV1vgnPuCwp9SZeRsZRluH06msV0w
         GzysoG/ynfWViu0Tz2Yk0zeFBWMWKfUKzRUmZgJdmUt1y56cz/tx2jVeOJ0pncSaVrkc
         vPoiMqklmrrOYyybQ7XIDLkCpaQxRiiDfkSFEEkb3qBoKe9H6cApNkhGiwiPY7SUqXqb
         ofaRf5FsY9atKgJDeFGqkPdwuxv7WQ5bzcUa80Ox4twVXLC+pnkMPstYPCK8slsPCg3k
         MUZzuvs/Tay+jcaZxO9860i2/G9KklkoUKa4LzUfUrLWK8swXsngm73WcS8L12wZta8X
         kA+w==
X-Gm-Message-State: ABy/qLbxekrfr6wrReh2A3daz4D6AXt4Hfw+ZV/1poDc17BO7JCXB0dx
        0npzPPR/JhrYAE499SzrQQLtkCoye2f4XeYUXzo=
X-Google-Smtp-Source: APBJJlFkGybOF0qtX/2m4jEdom3ZVX9UDA7yBRbAGYNE6hwjR3yRhNF5yUoD2c2oNK2xPN1/BMKC8Q==
X-Received: by 2002:a17:90b:4c50:b0:263:204c:3c80 with SMTP id np16-20020a17090b4c5000b00263204c3c80mr48759pjb.4.1688594409113;
        Wed, 05 Jul 2023 15:00:09 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u9-20020a17090ae00900b0025ec54be16asm2162139pjy.2.2023.07.05.15.00.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 15:00:08 -0700 (PDT)
Message-ID: <c82a1e63-aaf7-ef38-cbfd-5a8d29c877bd@kernel.dk>
Date:   Wed, 5 Jul 2023 16:00:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] zbd: Support finishing zones on Android
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     fio@vger.kernel.org,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
References: <20230705212915.3373438-1-bvanassche@acm.org>
 <34a1a73d-9edf-b3db-e9d5-e912febdb869@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <34a1a73d-9edf-b3db-e9d5-e912febdb869@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 7/5/23 3:58 PM, Damien Le Moal wrote:
> On 7/6/23 06:29, Bart Van Assche wrote:
>> BLKFINISHZONE is missing from older versions of the Android NDK header
>> files. Hence, define BLKFINISHZONE if it has not been defined and detect
>> at runtime whether or not the kernel supports finishing zones.
>>
>> Cc: Damien Le Moal <dlemoal@kernel.org>
>> Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> Late as Jens already applied the patch, but anyway, looks good to me.
> 
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

Thanks, I think these replies are still useful even if it's already
applied, as it's still documented on lore.

-- 
Jens Axboe


