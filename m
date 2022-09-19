Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1233AC54EE9
	for <fio@archiver.kernel.org>; Mon, 19 Sep 2022 13:12:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiISNM2 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 19 Sep 2022 09:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiISNM0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 19 Sep 2022 09:12:26 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6467C20BF8
        for <fio@vger.kernel.org>; Mon, 19 Sep 2022 06:12:22 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id z9so10298974qvn.9
        for <fio@vger.kernel.org>; Mon, 19 Sep 2022 06:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=FArj3W3NVWoskACckq5Vx710XcRIVT/YrrmItbvs3ak=;
        b=HjyNN4StyFEnU/8PBOWCxbnTyKMNxIksaY6wtoJN3ESJ+zAxRhrSDynJPVCCSUdb9R
         p6qZqpSrZyTiZyTyF8PeB2eHqsdaD8ievwL8iDQx96UAdB3HilJ409cuXQ5/FMHyDlAj
         mAAu/LUCBB9awV47dVUKF6utKA8qUycRZHLyPlhGdBqvNem45bfB23NUzuvledBBMaPN
         9eBy+n6290mUw0f2A6FGomvNkThasuKyI45OTkeu6tx/Jpi8wItwyYjpQiKLu0BDT9fW
         FyWNl+5TlkvnHEQ6pzc2nUqIivi/HiWmQWtL02UbzB3xvdlh6TpPSDOSOANTQ9HguddL
         rwoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=FArj3W3NVWoskACckq5Vx710XcRIVT/YrrmItbvs3ak=;
        b=pdNzFC5p4+g3NC92WwVx/vpTbsUlm59AWomAlDWsRo7g/HDP+vhg0KAU7ZtHvTBhtT
         ZgFIq4WBZAfPv9HByLFp6ySrdKDPIYjiks4jYE+0pnPQlNk0D1MPkz/Ui8d5NFJcCCeS
         1owJZNNNyPsQ3tidpdG5kuR++KcNiRCTwhG8MjsRKB+gJgz2q+BCLSbaEeAeP/aSn0la
         GjSR9CawmKdvCw3VEBFLXP//ltlvooP0Fqg3e6spzSRs/aNNlSYk7LVmsMpbcWZNF+Yn
         p5bIVE+u18nIyuK0vuvcS77pfHUNB8fK4EARPU5QaL8qcRYFu1CYaAy+yoFL+15GyRMR
         cplg==
X-Gm-Message-State: ACrzQf1X4fvEC8Dy1adQ6hX8WjD7i6LWECkux6zeE3s6v1mtrCj0nLzf
        IuzuG9r8bx0f5rIDbl3Pe4g39togE+A=
X-Google-Smtp-Source: AMsMyM4e9vEAEDz0m2AIQ87++qwGyPUtpyunRy4xCjrOB6sf+CCDV31Qo/ksrzwHXuGUMPKQ2smiZw==
X-Received: by 2002:a05:6214:2387:b0:496:c9db:82b0 with SMTP id fw7-20020a056214238700b00496c9db82b0mr14781784qvb.111.1663593141586;
        Mon, 19 Sep 2022 06:12:21 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id c16-20020ac85a90000000b00341a807ed21sm10599791qtc.72.2022.09.19.06.12.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 06:12:21 -0700 (PDT)
Message-ID: <9295573b-a112-eaba-f441-99ccad62d5c8@gmail.com>
Date:   Mon, 19 Sep 2022 09:12:20 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: configure on FreeBSD reports "grep: The -P option is not
 supported"
Content-Language: en-US
To:     Rebecca Cran <rebecca@bsdio.com>, fio@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
References: <7b55f5b3-ae72-b99a-9fe1-04d60ba7161e@bsdio.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <7b55f5b3-ae72-b99a-9fe1-04d60ba7161e@bsdio.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/18/22 23:33, Rebecca Cran wrote:
> It looks like commit 7ff204c83595cd7d6b7b6a813d9fda97afd25198 introduced 
> an error on some systems such as FreeBSD, whose grep doesn't support -P.
> 
> num() {
>    echo "$1" | grep -P -q "^[0-9]+$"
> }
> 
> ./configure now reports:
> 
> grep: The -P option is not supported
> seed_buckets                  4
> 
> Is -P required?
> 

Hello Bex,

Does it work for you to replace -P with -E?

Alternatively, what if we replaced grep with

test "$1" -eq "$1" 2>/dev/null

Vincent
