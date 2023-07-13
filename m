Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5109C0015E
	for <fio@archiver.kernel.org>; Thu, 13 Jul 2023 16:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbjGMQqH (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 13 Jul 2023 12:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbjGMQqG (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 13 Jul 2023 12:46:06 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72651980
        for <fio@vger.kernel.org>; Thu, 13 Jul 2023 09:46:02 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-401e0ceb4e6so7288141cf.1
        for <fio@vger.kernel.org>; Thu, 13 Jul 2023 09:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689266762; x=1691858762;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5PaFvyC1L4m3XTVJkBrDRLT6eFsPwDGSmfr9nvUZtII=;
        b=o5/ndoHNUbI5QUgwCtzTroEmlTqIk/qGBXpqcOQ+NuHYpa0u2C1OQwE5N0CH36dgl7
         Cze1PR6ZWrUVtGvrm2EGNbIfnRYrroQQdzoSDak4vh2SwmXAUWiUW/kvd8UuLNZ3fsfV
         WfN1ikWpe/osljmRdWj1HwXnwua0PcCDcYDbJIuRu1XWaYAY8roPixaevNZG0IyM+zRR
         o0fN343l99wzuAOW+PAiV7yhpim9Gv5O+IEABLTeGg48HYDtYdlTEL367nf0E9VMjwBQ
         6Ijk4nkfdwJ5HlPhBTyPh1estnTvm9lodDZLkwc/ALBaOZvB5usux+IzTT9A1rv06jwO
         oJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689266762; x=1691858762;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5PaFvyC1L4m3XTVJkBrDRLT6eFsPwDGSmfr9nvUZtII=;
        b=EhJ+euMQjLpyhQk7DpUeFNPF7MW4jyK/4b+Aai5wMj9fOW0B9bcyeItWW8uaOJv0mN
         rq3f1EZ/Nm4P7BK7XH1QK3bq9BtvaVzoIAI3df1vibg03KjbofkTtw18w+EBZyLXysEh
         1TPYQpWb834Usp+u0l8YrldKf987BTkpgkoWogZqbf8NSmcJhqCBOzK1WUw1c/X0dzNU
         N5iRD7c+d8aOsbS/7DDpWzXUgBvxv5qeYNKl+cusifogUguSAIRjC6VlpZ+uXEmCWuN0
         o7HvFVJ2MBHnQKyiEcLhIISULfGkxZhHY1rq2HlXyJotmhdi3oZWGZtuDen4CEW3WGas
         fjqA==
X-Gm-Message-State: ABy/qLbcSD/gcR9vz4BFtvb7fYCpnzXduMh1TZs1ycJszfZuIUlxBCNz
        ftO2O9Li6DJJgc/mraCdt+NnqGuWC5s9tr8G
X-Google-Smtp-Source: APBJJlFaTVHtdHrywvCFwap8i/NFKMmlKqe4OHrFwaoSyxdNAN0OGYceB9yBCaUkMGtCE+XzIfnNvw==
X-Received: by 2002:a05:622a:1009:b0:401:e140:58ab with SMTP id d9-20020a05622a100900b00401e14058abmr2400213qte.32.1689266761654;
        Thu, 13 Jul 2023 09:46:01 -0700 (PDT)
Received: from [192.168.1.208] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id q11-20020ac8450b000000b003f7fd3ce69fsm3210076qtn.59.2023.07.13.09.46.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jul 2023 09:46:01 -0700 (PDT)
Message-ID: <1c23a4b9-e578-aad8-5a49-9600ab55b525@gmail.com>
Date:   Thu, 13 Jul 2023 12:46:00 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 0/4] fdp fixes, random placment id and xnvme support
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org, kbusch@kernel.org, simon.lund@samsung.com
References: <CGME20230712050110epcas5p1282a4e40485cb37545ec7cb55a3dcff1@epcas5p1.samsung.com>
 <20230712102041.20283-1-ankit.kumar@samsung.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20230712102041.20283-1-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 7/12/23 06:20, Ankit Kumar wrote:
> This series now enables us to either roundrobin or select a random
> placement ID from the available ones. In future a non-unifrom
> placement id selection such as zipf, pareto etc can be added.
> 
> The current boundary check for input placment ids was not correct.
> Added a fix for that.
> 
> This series also adds FDP support to the xnvme I/O engine.
> 
> Changes since v1:
>   - Split the macro change and placement id check fix into separate
>     patches as suggested by Vincent
> 
> Ankit Kumar (4):
>    fdp: use macros
>    fdp: fix placement id check
>    fdp: support random placement id selection
>    engines/xnvme: add support for fdp
> 
>   HOWTO.rst              | 19 ++++++++--
>   configure              |  2 +-
>   engines/io_uring.c     |  2 +-
>   engines/xnvme.c        | 78 +++++++++++++++++++++++++++++++++++++++++-
>   examples/xnvme-fdp.fio | 36 +++++++++++++++++++
>   fdp.c                  | 22 +++++++-----
>   fdp.h                  | 13 +++++++
>   fio.1                  | 20 +++++++++--
>   fio.h                  |  2 ++
>   init.c                 |  2 ++
>   options.c              | 20 +++++++++++
>   thread_options.h       |  2 ++
>   12 files changed, 203 insertions(+), 15 deletions(-)
>   create mode 100644 examples/xnvme-fdp.fio
> 

Applied, thanks.

Vincent
