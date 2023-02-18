Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA19AC05027
	for <fio@archiver.kernel.org>; Sat, 18 Feb 2023 02:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjBRCxD (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 17 Feb 2023 21:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBRCxC (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 17 Feb 2023 21:53:02 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D86F5E5BB
        for <fio@vger.kernel.org>; Fri, 17 Feb 2023 18:53:01 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id d29so330630pgb.3
        for <fio@vger.kernel.org>; Fri, 17 Feb 2023 18:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S4F/KaWmPEKqVrxLAPW1WE5RVjLFoW+h65COmIMotYU=;
        b=ylWzb+1gUoCki5S5+bwsWg2UEC9ycGlNZjK8S6KjF+5ql5nyxEUHOVd7Ms/j01XAIw
         39+QPdal2y7mMfNYPMDPfYn37Jv0lPQ1PmFPq717VtgU5HIpkJLCXKOnll06f3rlM/tg
         bLrxyVj+gYVvJjd7YKADna3JbPe8upui4k3/cy2Lh2bbhhXZd/0bDgrLJCByrTkuw7i+
         Y9r1eqlr+v8YsTbVgCqQQKrcuMiX2kiA18rSQwwvN7l+JcuduBOlw3d5ondMNYCqGnhh
         eSG2FY2UgcsrsBzcnAoN9mLdSJAi8AASA1JMf/rT1Sxgwf90lj5cfHrLyMlicob2NPmC
         aZJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S4F/KaWmPEKqVrxLAPW1WE5RVjLFoW+h65COmIMotYU=;
        b=bNnVWTcwtfajfSRdwESOZ+qqHLZGFR56dd5XSUJH9uu5SeKEXpEk5GOMboeLj+1pX5
         dukNhTynnHMg1b754SopRsQxNbO9DVSfKPlH6cyRl3YAkzToMtf/0ELBR5ZZuD4oIqW2
         sP7nEjJ0dB40XspWGvNSpuDKXmPj5tb+llQQUv2ucFCO9FBVhPLAz5VIZyFboSB29p7r
         NQ5+sufGeiWtGCzTTeIrDz32vn+Qib94Iue0fuMVjIFeIc012l1FcUwwzOgWsZvvODl2
         NgTu6Kpiide6kK5iPjAc903dgdCeskLAeveP4F0c+2mBr6n0p9xqOXlek1aLIDyaJExI
         lAJg==
X-Gm-Message-State: AO0yUKVQQ4NxfXoM3JYOYd9/2XYdEX+H4T/SgP2TG5KDUgiH0MfSjBuK
        gBWRFn85v/p3SOhpIFYERhYOAXJa6jBZqMpw
X-Google-Smtp-Source: AK7set9KIaxx9FV6TGHnKlPkKvZVVa4BQW5H8K5Z7N9oL7SFP7jo7ZxrTCyqpsdVeCba0ibmQqAmJA==
X-Received: by 2002:a05:6a00:2e92:b0:5a8:ae97:25f2 with SMTP id fd18-20020a056a002e9200b005a8ae9725f2mr3215207pfb.0.1676688780623;
        Fri, 17 Feb 2023 18:53:00 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x18-20020a62fb12000000b005a79f5d9f53sm3670547pfm.165.2023.02.17.18.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 18:53:00 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     fio@vger.kernel.org, vincentfu@gmail.com
In-Reply-To: <20230217070322.14163-1-ankit.kumar@samsung.com>
References: <CGME20230217070403epcas5p1f2c7eec62578c28429e8029681f7d341@epcas5p1.samsung.com>
 <20230217070322.14163-1-ankit.kumar@samsung.com>
Subject: Re: [PATCH 0/1] fix runtime when used with thinktime
Message-Id: <167668877990.5727.9183088641840206980.b4-ty@kernel.dk>
Date:   Fri, 17 Feb 2023 19:52:59 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-ada30
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


On Fri, 17 Feb 2023 12:33:21 +0530, Ankit Kumar wrote:
> Runtime for fio jobs when used in conjuction with thinktime,
> thinktime_iotime and thinktime_spin were sometimes more than
> what is specified. Added a fix so that fio doesn't spin or sleep
> for any duration beyond runtime.
> 
> For the first cycle when we specify thinktime and thinktime_iotime,
> fio starts by doing I/O for thinktime + thinktime_iotime, which
> should just be for thinktime_iotime. Addedd a fix for that.
> 
> [...]

Applied, thanks!

[1/1] backend: fix runtime when used with thinktime
      commit: f9fc7a27cae5ea2dbb310c05f7b693c68ba15537

Best regards,
-- 
Jens Axboe



