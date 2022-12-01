Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81819C4321E
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 19:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiLATvM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 1 Dec 2022 14:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiLATvL (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Dec 2022 14:51:11 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F037FB43CC
        for <fio@vger.kernel.org>; Thu,  1 Dec 2022 11:51:10 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id h16so2291893qtu.2
        for <fio@vger.kernel.org>; Thu, 01 Dec 2022 11:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:cc:content-language
         :references:to:subject:from:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PP3CmO3BI63iahUMT05wVdKS8WwukeYYbe9ZmJ4LY5Y=;
        b=k6JCLgrvfKHfMNqlmQjJSzKpIuJLPS2BkPE68hce9FBI/xwE4FlMzupR3VRkQlzFI2
         UFrAcRhu73IWSQiPdJYWAFMSD845VObPLwXuhOnnMSgruvKWK4Q76/5QcVbnnqWIBexd
         g5B+NYS1sheiVAgA/CxBS4nvpQxy7MQSS+ZS5NRddCm/6RLs0t9n+7z/EqlI3uIGksE4
         9Gej9ZQcY/i5W2B6BXUo3k31iBUwEX/ifw5LEE15oDjTkKvJVkWrsI7H5aREDLFRiNbq
         OaaDZICLreEuf2WnxbaUDH8bH8I5ERsw6tyR4VicaJVxCwkmlVchYFq+WcCElWa4SHak
         EPoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:cc:content-language
         :references:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PP3CmO3BI63iahUMT05wVdKS8WwukeYYbe9ZmJ4LY5Y=;
        b=V+jJOign0iHwuYN/PUs7otVObMwTT+2dTVNNJDSvAI5Lpm/QLhlxoh2PAdZBL9FLLY
         h++Fa0jl3ztnnzdEMqc0uQkYF9mLN5rh6cWv0Poc7UVmtGpo3cZmoS/LsjUhX/+nOMnt
         R3D60tKLpiaATdzsEzN046TbVQ3UK78nqxvOffNhqxD9vVR9RtnsxRUllOlade/5llrl
         FqZqGZcY4gt9ka5Cr+EYr898iFT4d4Igenga5HtrRLMFJS1YeS3KNO2r51s5tkMiCXMt
         YrlSV5tcE0ql2k6zFH9NB+LCUIyEV4HZ08w9DoWR82dBVnHW+Y1IAvq7BD53tjP7uJ89
         PTEA==
X-Gm-Message-State: ANoB5pkdWQN1800gh0IwO3qjgDih3Bz9nGyNXZx4gUtq3AQ/yl9Eiu3G
        js1ymRREeiemvRqfkFW2RGstN7ugqUs=
X-Google-Smtp-Source: AA0mqf5PRcl0/NAKwuVs1N5X+YBNVs3LqcGzgxikadukDgrRm9F4P0ZcE/kELxqNUIEWDj9CiipqYg==
X-Received: by 2002:a37:ad0c:0:b0:6ee:91b3:2484 with SMTP id f12-20020a37ad0c000000b006ee91b32484mr58870159qkm.648.1669924269957;
        Thu, 01 Dec 2022 11:51:09 -0800 (PST)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id k25-20020ac81419000000b003a569a0afcasm2944094qtj.66.2022.12.01.11.51.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 11:51:09 -0800 (PST)
Message-ID: <a452131d-99bc-a801-9188-ea6febb9cc33@gmail.com>
Date:   Thu, 1 Dec 2022 14:51:09 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
From:   Vincent Fu <vincentfu@gmail.com>
Subject: Re: [PATCH v2 0/1] documentation update for size
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
References: <CGME20221201052003epcas5p27b512af6c584d1e7e4ba95efb3668371@epcas5p2.samsung.com>
 <20221201050832.18513-1-ankit.kumar@samsung.com>
Content-Language: en-US
Cc:     fio@vger.kernel.org
In-Reply-To: <20221201050832.18513-1-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 12/1/22 00:08, Ankit Kumar wrote:
> There are cases with fio option size that the number of bytes of data
> transferred is less than what is specified. This can happen if there are
> gaps or holes while doing I/O's or if we are running a mix of sequential
> and random workload. Update the documentation for that.
> 
> Fixes: https://github.com/axboe/fio/issues/1486
> 
> Changes since v1:
>   - Drop the code changes and only update the doc as suggested by
>     Vincent.
> 
> Ankit Kumar (1):
>    doc: update about size
> 
>   HOWTO.rst | 7 +++++--
>   fio.1     | 7 +++++--
>   2 files changed, 10 insertions(+), 4 deletions(-)
> 

Applied. Thanks.
