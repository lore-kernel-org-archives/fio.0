Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6768CD5BA7
	for <fio@archiver.kernel.org>; Tue, 19 Sep 2023 12:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbjISMiZ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 19 Sep 2023 08:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbjISMiY (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 19 Sep 2023 08:38:24 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F79F3
        for <fio@vger.kernel.org>; Tue, 19 Sep 2023 05:38:16 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id 6a1803df08f44-6515d44b562so31472826d6.3
        for <fio@vger.kernel.org>; Tue, 19 Sep 2023 05:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695127095; x=1695731895; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XdEetaQaqlgmsbQ0TzwFGNWhKv31gIgWg/qI7FecQHo=;
        b=KNkpTFoC72ZWGKIC4Ke/7dFnvHGkfvJkcejtiFRE3Xt9L0L6bWBdBIxnNV2qtZOVlf
         Et2N+qzcGeR9EfNKrKNcy1ZLwMSNSWoAsR4T1dlM51FDpegChMyql19yv7hpwZy1B6nu
         l7WR3ra+M3uQsq+XJoTU4Ryc92cnWdVBpRY7NzwfETZ0BFzgiQ2KQQsld7alSJMol6Rk
         hsPUljFZvl4vTs01GWnpGMyI3Ov5YMtSY48nlGC8dpvyQXeJXI8LVearUn9K0rYsGbxE
         wGdrBsRsxUs1/VIKV6iuINRRmd0MV4VduPBPdTuijwnI8c2CH6I8MbPAyjwKafmvQPQQ
         xcsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695127095; x=1695731895;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XdEetaQaqlgmsbQ0TzwFGNWhKv31gIgWg/qI7FecQHo=;
        b=u02hpkvqEXDWRfGZk2/4SlMlt/F3XrEBn9AS+lkpdE5oA/hfgJHwbA6FxNwZXYbwRi
         8oomnH+x29mDGBT2ZwMlxuFRNWMrQ2vX2d50Fi68jaGe7GsC/yO2y4by65BfH2247bVi
         LiP0cXxXSaV53Dob6/rmbSV4bOrH/Jzsy5ip1aXb7LPW9B/mtlIYxGrGT2va4kdMm1BT
         w5vHF21ZTXG1VA43NUxpJDvlANp3tuCrW1gxPAkx64p5EJd3FlK97OrKaxPiQqbiLRmm
         sGqCt424Z1lIHfR4M/MigjxYL0Wt3x2YWDP8nH6QhuspZHIMREE28w4CN7vH0svKFu33
         1iwA==
X-Gm-Message-State: AOJu0Yy9CWi2umCa3ENc204nvDCFGTU59GoHS3R4i2n2MUGMaptab1YJ
        mLS3kpX0PGJiFeyq4JfHY9nlQOyyuno=
X-Google-Smtp-Source: AGHT+IE8fJFhwueSrvs3XdzaOgHG7EddXAGXH7MlAXg+ZzX04pyM0t6LZgLxy9Da9fI3ZUhfnttnww==
X-Received: by 2002:a0c:f2d2:0:b0:64b:e135:a3b0 with SMTP id c18-20020a0cf2d2000000b0064be135a3b0mr11506640qvm.19.1695127094922;
        Tue, 19 Sep 2023 05:38:14 -0700 (PDT)
Received: from [192.168.1.208] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id o10-20020a0cf4ca000000b00656329bb3b1sm3730752qvm.10.2023.09.19.05.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Sep 2023 05:38:14 -0700 (PDT)
Message-ID: <d210f947-6457-f46a-45bc-a167e8de330c@gmail.com>
Date:   Tue, 19 Sep 2023 08:38:13 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: Clat calculation
Content-Language: en-US
To:     Jay Han <jayhan258@gmail.com>, fio@vger.kernel.org
References: <CAJ3QLKcSM6oRGuyzJ4tquzP5UUfju7KQfkuBZpHdz_eGHL0Gvw@mail.gmail.com>
From:   Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <CAJ3QLKcSM6oRGuyzJ4tquzP5UUfju7KQfkuBZpHdz_eGHL0Gvw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/18/23 12:54, Jay Han wrote:
> Hello,
> I am seeing a stiff delta between the fio clat vs blktrace data and
> wondering how fio clat is measured in terms of the I/O processing
> step. In blktrace, I measured the time delta between the complete(C
> action) and issued(D action) per LBA basis.
> 
> Can you tell me how fio clat is calculated please?
> 
> Thank you,
> Jay.

Here is an extended discussion of fio's latency calculations:

https://github.com/vincentkfu/fio-blog/wiki/How-does-fio-measure-latency
