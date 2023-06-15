Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEBFEB64D9
	for <fio@archiver.kernel.org>; Thu, 15 Jun 2023 17:45:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbjFORpT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 15 Jun 2023 13:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231906AbjFORpR (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 15 Jun 2023 13:45:17 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80032724
        for <fio@vger.kernel.org>; Thu, 15 Jun 2023 10:45:15 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id 6a1803df08f44-62de3360ce8so26824946d6.3
        for <fio@vger.kernel.org>; Thu, 15 Jun 2023 10:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686851114; x=1689443114;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EMpPuwqK4vSV+AlXI8gbAgXFkczUa0ze4X2DGEUuMNY=;
        b=ruWcAu+8zqLznQTUapw95sKtEr0n3QKWkRlPI76PtruGfw7rRZi6tCJOceUIcKH3NP
         w0jVnAxRplctN1/LAR7aVg582csiroCQLKlgl3+52L1s0bvVThlRH69NhikUvShdOVlH
         Fox+KtBF3xvJMppbIRRSPVz1e4jyd5c0s/jqTm6L5NCPLinMqLtKuckt1jyJno/V/UAS
         qyBUZh4lN4U7TBN+P0rRpQimTfYPSkP8QMd0lq1VNX8anVJmnUPySeFgL2iffZHEaGQs
         C910HpVD+FeqHsOkNFunnFcJUkcl74iKlFtUCwN1LV6/OCvfI+JWHfuOBZlC0JRGfvOk
         QJLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686851114; x=1689443114;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EMpPuwqK4vSV+AlXI8gbAgXFkczUa0ze4X2DGEUuMNY=;
        b=EibsvRJsmis1nTLsazC1o8Wp/XQS3jBDLF2NSmWzZxkGTQFmOXsoo4AqV+Ss9Bu2ce
         uAk5yeu85+qxf3teCBeQNoreoMx5DppqsBCV/FRl3g7a/GEtKbFoKp/wL0AU2t648NWv
         BWdsjJyA71N1JkeeyjpHFEMwm/hSQOtjk+n4FhcAnu70a5wPMrLbZSjDHjQZYJYF2oB3
         gWSiQqZmfxfsr4e9LqOOy2KkeHmZtEPJJ4kpWtjMsQTZ4v7dQibZlukJawSl8LjsRjj6
         vqoKwVUZLaZsbDH4uK5ZTvpZF6khfORNC7MNxNCyPlVslV9OE5zRVwEW6yxNtBzUVkwC
         jC8g==
X-Gm-Message-State: AC+VfDxIM6uQ/RR6MyqLHevO9tPmaSE0s2c/nOVH5lIopEw2WAoyrM11
        mHN3y0rOLTx7NqqF8wV15cDs2mER55c=
X-Google-Smtp-Source: ACHHUZ6X8HqEgQOVJKjFwE+4tzA6CRW7Y36jAttzAXvEqNNUXn7sreIa7802Nkh+9lZqNSsptwjtjQ==
X-Received: by 2002:ad4:5ba9:0:b0:621:83d:3a47 with SMTP id 9-20020ad45ba9000000b00621083d3a47mr21723869qvq.39.1686851114271;
        Thu, 15 Jun 2023 10:45:14 -0700 (PDT)
Received: from [192.168.1.241] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id v18-20020a0cdd92000000b0062fe4391d87sm1687021qvk.27.2023.06.15.10.45.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 10:45:13 -0700 (PDT)
Message-ID: <38ec17db-fb46-f7ca-0b13-ec5ca8dbf14b@gmail.com>
Date:   Thu, 15 Jun 2023 13:45:12 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
From:   Vincent Fu <vincentfu@gmail.com>
Subject: Fio blog post on test coverage
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc:     gost.dev@samsung.com, a.manzanares@samsung.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I am happy to announce that the fio blog has a new post. I surveyed 
fio's options and summarize test coverage in our automated tests. How 
many of fio's options are protected by automated regression testing?

Take a look:

https://github.com/vincentkfu/fio-blog/wiki/fio-test-coverage

Feedback is welcome!

Vincent
