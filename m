Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95021C433FE
	for <fio@archiver.kernel.org>; Fri, 21 Oct 2022 17:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbiJUR0x (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Oct 2022 13:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiJUR0v (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Oct 2022 13:26:51 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52B8204AF9
        for <fio@vger.kernel.org>; Fri, 21 Oct 2022 10:26:11 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id r19so2079815qtx.6
        for <fio@vger.kernel.org>; Fri, 21 Oct 2022 10:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uSH8YZ3CI1LJcUxpkDxX0/5QFYzpU4wqHlrWU52TP6E=;
        b=a659uncUz71AT6kHMS/JoB8qg4iDoXpkUnf4h3MxuONmVwkbqmpssxgPH3CdITfMTM
         cSnt2uPsPcxzEF3Yhisy/3APkrrOb5J7ZJXE9sbDbS4M78tXZcuPabCYFUcvriuAHfDU
         0Cv4JjMb8lXO0uxF2QGqtNoxmyusOwjGTtmQ8V0xsg5kZelWxDOJdgMR2l4+cu+3fSnn
         wpDZkJ8lL922RqtmwDITUY3hS8A8IA2Hwh6wQJG/+4n0cDDmNsCWBlFKaFrnejfxismo
         958ieNwFlXUKZ8ffjFt6oqSOX28An6+nnSwez86YiCpHF8k0PCMeiWJzwzNColB2OzXU
         ol0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uSH8YZ3CI1LJcUxpkDxX0/5QFYzpU4wqHlrWU52TP6E=;
        b=mNVjWoon7+KLUAgmg1Z218wFwyt0AtA4dRZBHj68jyYJsjdNwZo/qca6sY4hFLryFd
         zQR8gj2vuRyELikIYHbYz14Zy7FnQfWDT2/abPahDhJuMjB8WtdV6tTwNviRKvtZuUst
         vygqNulFlzIAhAFJVnKEsvRfIoRY1hv6k6EPGuVKmiyxWjJJMBa2ZjSivf3s4oPJQyHL
         kZIM4WfKD3hkjcNUP+ql23Ekez2XZu/OZDL10K5HV/MDvtSRyLVraFgVKhWF6iglosSD
         YkN/IPhgxXFCppMKNOTAgnE3BFThC1z38VbToOe5uJLfFylilTLi3KsBMZ+JnxKKJGPR
         pDFQ==
X-Gm-Message-State: ACrzQf0eg9sPy6Qlc140T/k5Kzo6dWdmO8RLAUadrB2wy0y+QjCVF5cp
        nw7GomBCFqD82Db9BvsozJ0=
X-Google-Smtp-Source: AMsMyM71Y33w5IO8jVpqjkgc9ThLJkJ5OCf1GI8FyFalXGZNSOZXvsfq0sK+0WxVcl3ePV3RBxCX2w==
X-Received: by 2002:a05:622a:1787:b0:39c:d695:8590 with SMTP id s7-20020a05622a178700b0039cd6958590mr17400575qtk.104.1666373170744;
        Fri, 21 Oct 2022 10:26:10 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id c25-20020ac86619000000b0039543f89109sm8149222qtp.96.2022.10.21.10.26.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Oct 2022 10:26:10 -0700 (PDT)
Message-ID: <b4bb377f-a6f0-5fd0-21c0-c24d5ba8f2e3@gmail.com>
Date:   Fri, 21 Oct 2022 13:26:10 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 0/1] fix segmentation fault with option bandwidth-log
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org
References: <CGME20221021070023epcas5p4fb87f4bf54dee358f193f66d910dd624@epcas5p4.samsung.com>
 <20221021064900.12341-1-ankit.kumar@samsung.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221021064900.12341-1-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 10/21/22 02:48, Ankit Kumar wrote:
 > The log parameters for aggregate read, write and trim only specify
 > log type. As a result the io_log data structure doesn't have the
 > relevant thread_data. While specifying fio option bandwidth-log this
 > results in segmentation fault.
 > Add a check and use DEF_LOG_ENTRIES for such case.
 >
 > This was introduced with the commit 0a852a50
 >
 > Ankit Kumar (1):
 >    stat: fix segfault with fio option bandwidth-log
 >
 >   stat.c | 5 ++++-
 >   1 file changed, 4 insertions(+), 1 deletion(-)
 >

Applied, thanks. I added a fixes tag and lightly edited the commit message.

Vincent
