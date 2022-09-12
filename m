Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8C7C6FA82
	for <fio@archiver.kernel.org>; Mon, 12 Sep 2022 14:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbiILOim (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 12 Sep 2022 10:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiILOik (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 12 Sep 2022 10:38:40 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B601633A29
        for <fio@vger.kernel.org>; Mon, 12 Sep 2022 07:38:36 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id y9so6855972qvo.4
        for <fio@vger.kernel.org>; Mon, 12 Sep 2022 07:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:from:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date;
        bh=tlZ6tzbnFwjXOInx0wOdJpf+LYdFIjoEQjTt6f64tug=;
        b=Be7dOLbSkUfsq/XTTUCzpUqMhCplCo0FweNr/cmx73AMJ3gEzgzwDJpXYU7Kuq8nbT
         Gxe63lOH+jgB4uCnC2WXOKzFR7G+vemAJTFXuZjCtA0wOXpKv5P13txd0KlCw1Fdsteq
         0Plhs1zPjKUC0bazJHgkhXd9YtIr5AxOM4VxRZAoU6aCoNsm/ujhXfbanf1nCaIK+e7L
         2Eq83Kb0AuTBT/0Fb5EhxYxmNqxdy4pPbE9cp0JGQg/Vien7W6XzCS+GvKtIO4r1snZT
         /JXEUE0R5RvaBezVLXBWaLqFFt1MpkgFOOQ3ZQxvMLnWL+jUk5G+yDUqVsQnUygO29BR
         JAAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=tlZ6tzbnFwjXOInx0wOdJpf+LYdFIjoEQjTt6f64tug=;
        b=MpaxetyAKrLDEgcUfxWpjTyvDYQSx+zlLy/GF9bOcT1efoO573O+qqGcxUjp1Isw+C
         hXy66dtSdx5t4IVbo9uIMM6k4rupHVmdnuL0HxyGnwo4N+E2Azai8V82OyamBIlpF1qV
         Diqt23K25mL9obmqNOAu26HY2RGFiqJqc21PTejLe+6F8ICMcxrm4gwv27svIVy51Hd6
         WTJjRdwJv7KqatL/aFetxosxy4jW29F6gOCX35D8+BZbqWQ+LvfrPwuknyRgCLaIAqPg
         SGIOVL5jljoCK/kBDxkjyvCRJOHr2anbk3SDxrPbopOPp6pSqp5u8AOeB9uK8gYiJbK9
         QWKg==
X-Gm-Message-State: ACgBeo1Vj9+uOM9awSy3ylMLredL2m6OsS86k9Obg416jzwQIQ7kX453
        rSVx4lfDnjZ6NeG52+RAmdm3ImbSoIY=
X-Google-Smtp-Source: AA6agR6GsmHJKUJTPb7R6VS/Md5v6GmpHHv3YTRXFrcKTZNr4elgp03zqOth52MML0YvclMPjD5uvA==
X-Received: by 2002:a05:6214:d0b:b0:4ac:873b:ef73 with SMTP id 11-20020a0562140d0b00b004ac873bef73mr14104035qvh.82.1662993515583;
        Mon, 12 Sep 2022 07:38:35 -0700 (PDT)
Received: from [192.168.1.218] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id u6-20020a05620a0c4600b006b640efe6dasm6821126qki.132.2022.09.12.07.38.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Sep 2022 07:38:35 -0700 (PDT)
Message-ID: <051fc206-3dfa-262a-ae12-c53d148d69a4@gmail.com>
Date:   Mon, 12 Sep 2022 10:38:34 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Vincent Fu <vincentfu@gmail.com>
Subject: Re: Fio latency reporting
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <CAF+0mvkU08G6DJnvpaRcwxkMKLzQGcrYO_-EyrPz1NxN0ZUOhA@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAF+0mvkU08G6DJnvpaRcwxkMKLzQGcrYO_-EyrPz1NxN0ZUOhA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/10/22 03:05, Matthew Eaton wrote:
> Hello fio group,
> 
> I'm doing some analysis on latency outliers and I read that fio can't
> report latency higher than 17.2 seconds. This seems to fall in line
> with my testing as my logs show latency outliers max out at ~17
> seconds. Can anyone confirm if this is accurate?
> 
> https://fossies.org/linux/fio/doc/fio-histo-log-pctiles.pdf
> "Note that the highest max latency for any bucket is 17.2 seconds =
> (64 * 2^28)/1000.0 ."

~17s is consistent with this comment in stat.h:

https://github.com/axboe/fio/blob/master/stat.h#L48

2^(29 + 6 - 1) = 2^34 = 17179869184 ns

If you need to measure longer durations you should be able to just 
increase the value for FIO_IO_U_PLAT_GROUP_NR.

Vincent
