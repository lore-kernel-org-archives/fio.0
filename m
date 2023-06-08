Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A7E8C7EE23
	for <fio@archiver.kernel.org>; Thu,  8 Jun 2023 18:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbjFHSp5 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 8 Jun 2023 14:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbjFHSp4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Jun 2023 14:45:56 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50DB193
        for <fio@vger.kernel.org>; Thu,  8 Jun 2023 11:45:55 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id af79cd13be357-75d5051fad3so86302785a.3
        for <fio@vger.kernel.org>; Thu, 08 Jun 2023 11:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686249955; x=1688841955;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ctcX65H8EYp624IZgmBs5kQFKCk7UPtyDkc1SLI1IKM=;
        b=dqzsN9FwtOPBTb292o5/JzK/0Nc8s8L9lKg1qLzGE13pIaVU6naVRJxNl+sXHnnUrA
         oOJUScKEfO24xN/E4PKnI2XOmryCl9vuWvQAuD+2sMNaFKQJR72NmdagxuZ7Tikt/69s
         Igt68fc3450isePEexnRqR77HBfkwx//sPqHWG6YYXhgAph0B6Phw67kbb+WTn0P/HjD
         EhmLQAJ8SAMK9L/mJ731FdrA1Pmi6iA5klJ0NTXU96Z6tWG/ksFnYuSyiGltqsE0dGs6
         fXmJJrbnFN376XhDXz1SGs8WtPq1wGTK3H7ELOI5m/dnPG78qySarFUutpMZFZwvM/HI
         NFOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686249955; x=1688841955;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ctcX65H8EYp624IZgmBs5kQFKCk7UPtyDkc1SLI1IKM=;
        b=XSOx9Q+8V0PSW1khnxcNm5jLNqHm7TrwrPUjJ0sQae1BlCfu45z/bPmDKpgiGOka6R
         uUIm+Nfqjia3UoHruKfyj3BjpSnMENuHpR6InlIaweLVTP5q4q68jCGHtcIcyE7CGQcv
         RJmTVszUPoIhpQs3zhRLW0woqwt5xN8YFrN37LiRdKpJUc7shneonZePKV9S2Vk9Ge5W
         brSpUZXooRj5GqIFA/4Kl6bsBOFnxfv3rplBR0GGK/VK1MES/J2L8kgEm3Go1Tbz3IGD
         YwWJzYUOvP8qldvQs1N8eIqEx6C6M6EMiOntTKTzpKdlilYyhcpB4cJfEaA54RjPemLj
         ZF4Q==
X-Gm-Message-State: AC+VfDyrRxMqhBt8uUfuYvS5lQZekSlUpIj3fVloMa7TL6YGn0Z8DrAP
        WWFqM1oFjYfxhOsAHnobGXa/EHN27BYBvg==
X-Google-Smtp-Source: ACHHUZ4LaHGmNTaoCeezfkfTpC+zs6WOPAsMOdM0q3c5B4qoeZRqp87sbmikZQnte71igzf1QBNirA==
X-Received: by 2002:a05:620a:2f0:b0:75e:d895:6a53 with SMTP id a16-20020a05620a02f000b0075ed8956a53mr6264725qko.46.1686249954608;
        Thu, 08 Jun 2023 11:45:54 -0700 (PDT)
Received: from [192.168.1.241] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id f13-20020a05620a12ed00b0075b00e52e3asm517394qkl.70.2023.06.08.11.45.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jun 2023 11:45:54 -0700 (PDT)
Message-ID: <be2ca491-c88d-0db9-f7d4-ecf71d485845@gmail.com>
Date:   Thu, 8 Jun 2023 14:45:53 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2 0/7] zbd: clean up code and fix bugs for open zones
 accounting
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20230608070608.1256970-1-shinichiro.kawasaki@wdc.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230608070608.1256970-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 6/8/23 03:06, Shin'ichiro Kawasaki wrote:
> Fio with zonemode=zbd does accounting of 'open zones'. However, the meaning of
> 'open zone' is confusing because its definition is similar but different
> between fio and zoned block devices. The first patch in this series avoids the
> confusion by renaming the word 'open zone' to 'write zone'.
> 
> Also, recently three bugs were found related to the open zones accounting.
> Following three patches fix the bugs. The last three patches improve test cases
> corresponding to the fixes.
> 
> Changes from v1:
> * Reflected review comments on the 4th patch
> * Added Reviewed-by tags
> 
> Shin'ichiro Kawasaki (7):
>    zbd: rename 'open zones' to 'write zones'
>    zbd: do not reset extra zones in open conditions
>    zbd: fix write zone accounting of almost full zones
>    zbd: fix write zone accounting of trim workload
>    t/zbd: reset zones before tests with max_open_zones option
>    t/zbd: test write zone accounting of almost full zones
>    t/zbd: test write zone accounting of trim workload
> 
>   engines/io_uring.c     |   2 +-
>   fio.h                  |   2 +-
>   io_u.c                 |   2 +-
>   io_u.h                 |   2 +-
>   options.c              |   4 +-
>   t/zbd/test-zbd-support |  64 ++++++++-
>   zbd.c                  | 292 ++++++++++++++++++++++++-----------------
>   zbd.h                  |  25 ++--
>   zbd_types.h            |   2 +-
>   9 files changed, 248 insertions(+), 147 deletions(-)
> 

Applied. Thanks.

Vincent
