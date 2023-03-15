Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3271AC61DA4
	for <fio@archiver.kernel.org>; Wed, 15 Mar 2023 23:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbjCOX0i (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 15 Mar 2023 19:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjCOX0h (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Mar 2023 19:26:37 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1A3F96B
        for <fio@vger.kernel.org>; Wed, 15 Mar 2023 16:26:36 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id jl13so146083qvb.10
        for <fio@vger.kernel.org>; Wed, 15 Mar 2023 16:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678922796;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fMtECiYqEvRM75bmZDgeQPU8dGOW+dTUuvE6xdJ07/4=;
        b=l6NVyMIdIaivTkYACe4XvNG4/xMIReDAO2xHSC3gtcbnqJtzMMaUAXbC+jWLjwEbnD
         uws5JHL3IjCOluqLSA5gjvh3hhyCNTfOgVcJtdgqDpITz93BoqeMAesl4QKth47qjgHF
         hqMH6eb9Bm1PByWta3GrBHsALvmbKzAma1iMw3Dblsfp3w9Z4wkZOWf9uTP6PvVeBKtj
         eknUzHIudF6JUyhj8le4QqHwoa7TOIkFe+51AgMIgxMD0tzJXvzsPsgl1i4YdqfrJjCP
         NWUuXK7filNdWa+1sn/oZ93aLQFpnFB5vSAxR2VAKA9ENAIy8fTdIcDRW3+0V6HVfo04
         OSWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678922796;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fMtECiYqEvRM75bmZDgeQPU8dGOW+dTUuvE6xdJ07/4=;
        b=nLJO8mxVvDzJ4PQqx6rqfCnF6coIW+2qhHOfXZMbL/R9F9+1vWZDz1Sss6l5RExdwh
         DSttZvW7vZ23faomesY+mFUXUtWnglC+YknHZvS8HYiGjkR0AmE6bFfBVwcqgiaMKtbz
         oNoxxFKY9+zI9733iwHwKZcIv+YPh1iPyiTs4oUlIWOw/cnOyZSINjRVGJvuXFy829wk
         X898wawYVATpuhwg1V1Zon6AqFuv2o32FEb072bemOiaWVg+cT8WW49BzYIKrk25uYA5
         XBuQ0oYKfGvlvdiWB3JV4nnb491Nx4DsijYlLY0lXQxKdSlDdtSIJUYNIDPsd34sGpd4
         Jhyg==
X-Gm-Message-State: AO0yUKXbRXIEbDfqzWCdPPDlVe7yrm9CvBlXSZC/QvK4ubM8pPXt0G8Z
        amwWUC16dha8iuDd5lpG6sg=
X-Google-Smtp-Source: AK7set/yr1uE+5Uxp7ldPup32SJ/9SV4nz62I46RAFqtZgK9UVI4HvgpCEkqqN+BVmAhg1p8ZA1qJw==
X-Received: by 2002:ad4:5be5:0:b0:5aa:dcd6:a76c with SMTP id k5-20020ad45be5000000b005aadcd6a76cmr16212871qvc.44.1678922795735;
        Wed, 15 Mar 2023 16:26:35 -0700 (PDT)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id u19-20020a37ab13000000b00725d8d6983asm3193973qke.61.2023.03.15.16.26.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 16:26:35 -0700 (PDT)
Message-ID: <db711a58-ed95-ba93-2838-783027bd9b0b@gmail.com>
Date:   Wed, 15 Mar 2023 19:26:34 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] stat: Fix ioprio print
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
References: <20230310012839.9532-1-damien.lemoal@opensource.wdc.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230310012839.9532-1-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 3/9/23 20:28, Damien Le Moal wrote:
> When using per-priority statistics for workloads using multiple
> different priority values, the statistics output displays the priority
> class and value (level) for each set of statistics. However, this is
> done using linux priority values coding, that is, assuming that the
> priority level is at most 7 (lower 3-bits). However, this is not always
> the case for all OSes. E.g. dragonfly allows IO priorities up to a
> value of 10.
> 
> Introduce the OS dependent ioprio_class() and ioprio() macros to extract
> the fields from an ioprio value according to the OS capabilities. A
> generic definition (always returning 0) for these macros in os/os.h is
> added and used for all OSes that do not define these macros.
> 
> The functions show_ddir_status() and add_ddir_status_json() are modified
> to use these new macros to fix per priority statistics output. The
> modification includes changes to the loops over the clat_prio array to
> reduce indentation levels, making the code a little cleaner.
> 
> Fixes: 692dec0cfb4b ("stat: report clat stats on a per priority granularity")
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---

Applied. Thanks.

Vincent

