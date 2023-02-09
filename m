Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 522AFC05027
	for <fio@archiver.kernel.org>; Thu,  9 Feb 2023 23:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjBIXb7 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Feb 2023 18:31:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbjBIXbx (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Feb 2023 18:31:53 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7941CDD7
        for <fio@vger.kernel.org>; Thu,  9 Feb 2023 15:31:51 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id h24so4052655qta.12
        for <fio@vger.kernel.org>; Thu, 09 Feb 2023 15:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y1Z+qOKcl40Dg5B146WpWfKW+7u4/4me3522G+2g6vI=;
        b=C3rOvIK+MrrAw+usX1tddBdiVU/86LRSswTQB1wdG+UbsbQWkBnorq5RnVPjC8bQ5p
         NtMoxiK58OIyrJ4Mt2zXNatQFhIztaV4o7sTW6qtTkmYturFo0UQbz1rPVnXYlKlO2kS
         21eNQK+13LW/qQNEPvnLXnpKgDSp490AjXfMQuBbj08K8AnenQ7wcfMXjTMa79+24Zyl
         eIXRX6RkiSXfVewXwnNgy4YXEoAPT1dJOV11nGsi849Iun59Q5DpiTCDobcFs8v6W9zX
         VVxSugcjUjN/fLmdlzK8sF+G6m9fgxqJyoePxvwjm5V+BGLdVVHWlrXYwSQY4vajWYrL
         8mnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y1Z+qOKcl40Dg5B146WpWfKW+7u4/4me3522G+2g6vI=;
        b=KtwfBgX/+BUhtz8G/2T5zSunO09Xqv2OvFC8FG33+0Ub7TYs2Rgwwd9jZvkRGjOrkR
         x+1xYlKojfpgRaqvwIeEO658ygtBc2UrLydMZifCi5GlLmMMKzBhbP0fY1LLbUbefXWx
         336pzKlPKiqauwynA6FEI6EagMhiQCluaXTykOMnYqfdftFYVuiAXiZAkyYVoj84mZGb
         z/sOtdw3NqkQ/zum8M8N66utS7K1sjc1Y7aTI+vRCbrMoSnF/Op6T3+xXaUOtilYH2iz
         6ZAgs3ihYYSSPzBgotjuW9xvx4HO2giubcYupllrTTWRjSOUCoigjW23qjJzjVlOkGQk
         byug==
X-Gm-Message-State: AO0yUKUdBQG4bD2O5sPPqQh7TjM0SNO3l1w9T0/WX8Qurz51Sts+hcOz
        q3wjTGxWV5d6DGT12HyQW9g=
X-Google-Smtp-Source: AK7set/ydoLeBC770vUU9QrnbGjj9l4OBGlP/bBRfdvUlNomhxq43LkzRJASir4r6ghXnJwtCDM5/A==
X-Received: by 2002:ac8:5706:0:b0:3b8:29f6:8ac6 with SMTP id 6-20020ac85706000000b003b829f68ac6mr20786371qtw.12.1675985510505;
        Thu, 09 Feb 2023 15:31:50 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id g66-20020a37b645000000b0071a02d712b0sm2337001qkf.99.2023.02.09.15.31.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 15:31:50 -0800 (PST)
Message-ID: <1b7fdef3-b130-fabe-62fe-d3183e6db0be@gmail.com>
Date:   Thu, 9 Feb 2023 18:31:49 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCHv2] fio: add fdp support for io_uring_cmd nvme engine
Content-Language: en-US
To:     Keith Busch <kbusch@meta.com>, fio@vger.kernel.org, axboe@kernel.dk
Cc:     its@irrelevant.dk, damien.lemoal@opensource.wdc.com,
        Keith Busch <kbusch@kernel.org>,
        Ankit Kumar <ankit.kumar@samsung.com>
References: <20230209171236.1113887-1-kbusch@meta.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230209171236.1113887-1-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/9/23 12:12, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Add support for NVMe TP4146 Flexible Data Placemen, allowing placement
> identifiers in write commands. The user can enabled this with the new
> "fdp=1" parameter for fio's io_uring_cmd ioengine. By default, the fio
> jobs will cycle through all the namespace's available placement
> identifiers for write commands. The user can limit which placement
> identifiers can be used with additional parameter, "fdp_plis=<list,>",
> which can be used to separate write intensive jobs from less intensive
> ones.
> 
> Setting up your namespace for FDP is outside the scope of 'fio', so this
> assumes the namespace is already properly configured for the mode.
> 
> Based-on-a-patch-by: Ankit Kumar <ankit.kumar@samsung.com>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---

I haven't looked at the patch yet but it does pass the main tests we 
have set up with GitHub Actions:

https://github.com/fiotestbot/fio/actions/runs/4137029644

Vincent

