Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC4A2C433EF
	for <fio@archiver.kernel.org>; Mon, 18 Jul 2022 11:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbiGRLY0 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 18 Jul 2022 07:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbiGRLY0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 18 Jul 2022 07:24:26 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E00219B
        for <fio@vger.kernel.org>; Mon, 18 Jul 2022 04:24:25 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id m10so4565864qvu.4
        for <fio@vger.kernel.org>; Mon, 18 Jul 2022 04:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7TLeL5qBZHuZuthsBmcY8zZI424cwNYtEnX/XN6MNpo=;
        b=bpJ0AbwQnWF8UnYh89scQWyGuxugOjTpJSxQadg8rONj7L9icllHd947+RqIpCUk31
         1jYHrd1ER7HKFJRl4K2l9XsgqtpGxP08M1Sxv5yGLUmeX2dDketLjsK46xkN16QCr3cp
         3XJZiNZRTtHOnfzMHNIZVY5oZ+/5LqVwJbpe0LTvSPOEO7d1gGwTe816vMSbQ1MCZqhP
         dMaQ5yM/zh11jwp+hxI/fTlRbU2GNXqpzSwTIdNPuM18hoSsZ8qXJHHebghREmXzIVZz
         GAecqae5GBl3xhXdY2TxKc/p4sXPoGFZ7bsaItJCj6RRmYc5b7GNXB3JHSR5rqvArogI
         /BEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7TLeL5qBZHuZuthsBmcY8zZI424cwNYtEnX/XN6MNpo=;
        b=eAx/q/kdjZJn+tUDzLy1YTs3hI1hkQW1D4Zk0HnBWAN4wJRQajSXrki0OOvPDIPYVk
         KkrlWl7n7l52tIUf2DwCwkleUL/wcFjZeVY/8hry7Um4IV/Y8jw2+H01HqlLN710lVcd
         4Guv8j97pBKcwWiwAt9qa+8rjGsxGHxiLPx4jCkCew1b14ZvGf+0ggNxFZ0O67cY4T0J
         HNWmUv43ve+RUhY7gPIdNZatEzwvGwiC8KzOFLdLYzp8QlQWTyZCJDn19AbhnZjz3lpQ
         Libfn3GYP8ysNufJWfu3NLVfFXCtViUrOCynz68sTixQHXzjMPb9efBeKhfphtRypQMt
         d9Pg==
X-Gm-Message-State: AJIora8JOoOs4cBFhSQM2z/7QS8RoNCa0IwWIR7+MPxBx6k063PaO7P0
        yspVM8pTBJqLCBmXyxzPUwv2JVgnDIE=
X-Google-Smtp-Source: AGRyM1t+gA6C82II4Qxq3Opl01WBj/JbZUaYUcAm7U7e5QfC5azJnADfaFiywgtyDXhuQ+RVWDvyRQ==
X-Received: by 2002:a05:6214:2409:b0:432:bf34:362f with SMTP id fv9-20020a056214240900b00432bf34362fmr20586736qvb.66.1658143464816;
        Mon, 18 Jul 2022 04:24:24 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id bn29-20020a05620a2add00b006b5ef0aff29sm1816236qkb.87.2022.07.18.04.24.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 04:24:24 -0700 (PDT)
Message-ID: <79535fa5-66c4-d7df-73f8-a128e9b4150b@gmail.com>
Date:   Mon, 18 Jul 2022 07:24:23 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] engines: add engine for directory create
Content-Language: en-US
To:     "Friendy.Su@sony.com" <Friendy.Su@sony.com>,
        fio <fio@vger.kernel.org>
Cc:     "Wataru.Aoyama@sony.com" <Wataru.Aoyama@sony.com>
References: <HK0PR04MB23884338D98BC24EB547AB9BFDA99@HK0PR04MB2388.apcprd04.prod.outlook.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <HK0PR04MB23884338D98BC24EB547AB9BFDA99@HK0PR04MB2388.apcprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 6/11/22 03:34, Friendy.Su@sony.com wrote:
> 
> This engine is to measure performance of creating directories.
> 
> Signed-off-by: friendy-su <friendy.su@sony.com>

This all seems fine. My main suggestion is that there seem to be several 
of these file operation ioengines. It seems like we could eliminate 
duplicated code and make the codebase easier to maintain by 
consolidating the ioengines (filedelete, filestat, etc) that follow this 
similar structure.

sync.c is an example that implements several ioengines.
