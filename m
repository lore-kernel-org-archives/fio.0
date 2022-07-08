Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB3C9C43334
	for <fio@archiver.kernel.org>; Fri,  8 Jul 2022 18:46:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239676AbiGHSqz (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 8 Jul 2022 14:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239682AbiGHSqv (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 8 Jul 2022 14:46:51 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5BE83F25
        for <fio@vger.kernel.org>; Fri,  8 Jul 2022 11:46:51 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id k14so28640541qtm.3
        for <fio@vger.kernel.org>; Fri, 08 Jul 2022 11:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=mve3A+1l+8rJEfat0m2NQPdVNkolBh4ZsIFQsLeV0eU=;
        b=cLPhH/GBVyYBJ8qr0SinbXmATBnFT9W6q1s6KQXE+KhYPIxVo7hJ0ofXFr+Z3i7XjA
         Mp8AhJPuDz/A/Pha0ZT4kjEntO9iojE+zIcmdhj5JRcnKO+WjZsq5/4f1YNiEkmNmIUA
         YSjNu9vZ44e+vQOWc6tgMUOqtU5o5lNXl0NuTRUV6ht4AAUJAUUqx4o1U7Prd1x+NllI
         7vOpowrC1eIv0xzP0QoMLSZZ1j+O05RqAjgmvpFvBhlBnaTwKCJw/jRuVBYPQzDqi9dH
         yvSsJVvhMABM01ivB54Ktd/DUzIATQ/qXW+wC1UFJ+FK8wFbYYLa3l7GS/qSD815Noq7
         0JgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=mve3A+1l+8rJEfat0m2NQPdVNkolBh4ZsIFQsLeV0eU=;
        b=ONV1lmOCcCl/ugDU3c0dg8AaYoTP28huZZ1kKNFLSeOnkNplofeDVRSKNMlNqItlBG
         0jvA08RAxfECVuusyzP29o/7LNFOZmPk6unpdLEv3VaqUrgeGGWRQHKLY+bMYtuCC2vD
         LnNLCe/wLtfolRM5x5jg30aicsywx7SK2ppJhaZt1h9PgFzCpUfyJou7IVT/k1JvLwsO
         LcOgxriWMswmggY4JRvXpLik+Q030ne1Oqlq0ywh8XFE4evzELHXQOTnN7w8WKsO/n6F
         QVB1xMURZ34afh/i81eG6sFMLc912+/iMqF9S2lO9HTTnY3kIHQhWgstv6FL60OFN/10
         47YQ==
X-Gm-Message-State: AJIora/RI5Kuvq6O9wdQYn+wChvoryt8pmHjoOWVwe5wIJIhVaSMYt1t
        ST4t08i1fwA0qMtS7uPIkPWjfgu4N64=
X-Google-Smtp-Source: AGRyM1vyG09z0eKmebIDBU5R2iTvCort+0WxAVkE/7lKdxHPHbiZicLjAq6XtkphF0aht7CCEWJUQw==
X-Received: by 2002:ac8:5e48:0:b0:31d:3055:b480 with SMTP id i8-20020ac85e48000000b0031d3055b480mr4447481qtx.10.1657306008775;
        Fri, 08 Jul 2022 11:46:48 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id c19-20020a05622a059300b00304edcfa109sm31388220qtb.33.2022.07.08.11.46.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jul 2022 11:46:48 -0700 (PDT)
Message-ID: <4c538332-c855-dbfe-ae47-ecedeff954bd@gmail.com>
Date:   Fri, 8 Jul 2022 14:46:47 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>, gost.dev@samsung.com
From:   Vincent Fu <vincentfu@gmail.com>
Subject: xNVMe ioengine blog post
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Ankit Kumar (ankit1455@gmail.com) and I collaborated on a blog post 
detailing fio's xNVMe ioengine that was recently merged:

https://github.com/vincentkfu/fio-blog/wiki/xNVMe-ioengine-Part-1

Feedback is welcome!

Vincent
