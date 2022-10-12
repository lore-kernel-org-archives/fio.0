Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18CC1C4167B
	for <fio@archiver.kernel.org>; Wed, 12 Oct 2022 13:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbiJLNTy (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 12 Oct 2022 09:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiJLNTt (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 12 Oct 2022 09:19:49 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37D317074
        for <fio@vger.kernel.org>; Wed, 12 Oct 2022 06:19:46 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 204so16448890pfx.10
        for <fio@vger.kernel.org>; Wed, 12 Oct 2022 06:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bb8VRHGZpd0VnuJBZ+KSIWBK0tE0/6N/GZeIniPG4+Y=;
        b=3Q3XlqPqEXP1biJ9FFFlUM0mgfoH2LwqxeAraAAy0tWrQqIYnu4F6bfwW1QeeZiv8/
         hiYEcLL+UJbU7k5ec2vkEaG2rntHg2yqY0f1w8ECbOxP6k8gNLSmp7rzizb+uOyB1LAi
         AYTsnZT+pMoEZ0j1G2gNFZXWMFHVKEaG+l4mD4GeZuQOonoMbhdIF9UP2fY4LQjDETuh
         OtHbxML/YE2T428GbkIkAdlKitq4ePDZ2lW+r5XrpJX582Nv0YIcFqLDrP8ZP+9ZiON1
         eJqNqrec7fai4bSDiicwESl8HSrfTRz29rLig0vX9g1tvZpj+ZpO/y9QkK/9xl3xtVVH
         g/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bb8VRHGZpd0VnuJBZ+KSIWBK0tE0/6N/GZeIniPG4+Y=;
        b=mWkuLnbJ+lA4HofaRZvYmsMzK9zTwroPhQKyp+EZ7G0RHDLqpsRm/P2rGYV5d0poVL
         oEDX8TEA4fsO/LxRBntosN67LPd4m7IvxHiQl2YEBBRMDtzFMMtJO9Hq7YHCJuG9IcpG
         lnslN3xV51xi6nFGVqTgoWLXCjPLxoBz+4y/DIzLzi2Dv8ZD2c4v79GkRkN2cme5aoJn
         s/uJyhn2LB1da4meNE6PQ+LMYuPKb/n7cIYC5qmSd/DXDFBzKCMxPFa2afY1zCB8SzNm
         8oowSg5wtVx5VeBDTXlxsDmkpV++l3CNQOEYXKsIVxO+Q6SHqv0wkVEOEGYzIuGZbFKJ
         C+pQ==
X-Gm-Message-State: ACrzQf1KcBUGGc7IG1qRGFLi9ExkR0kLBBzKEcamEpR6zrBH2uwJYuNg
        ohMOOF4V984PdIm8vELWnfrVOw==
X-Google-Smtp-Source: AMsMyM7/7BlAYGJfR3a67UsjSOIhyDWW868itOonmCa2nwPr2M0P1zc0HzBsc2Uo3dd4Ccz1KZDCyg==
X-Received: by 2002:a63:6b83:0:b0:460:c07c:553b with SMTP id g125-20020a636b83000000b00460c07c553bmr17860910pgc.209.1665580785773;
        Wed, 12 Oct 2022 06:19:45 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p2-20020a634202000000b004393f60db36sm9610197pga.32.2022.10.12.06.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 06:19:45 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     vincentfu@gmail.com, fio@vger.kernel.org
In-Reply-To: <20221011105935.10455-1-ankit.kumar@samsung.com>
References: <CGME20221011110947epcas5p2f840397a3e45e1d9326619a10d52ffa3@epcas5p2.samsung.com>
 <20221011105935.10455-1-ankit.kumar@samsung.com>
Subject: Re: [PATCH 0/1] Add missing flags to the uring passthrough engine
Message-Id: <166558078491.51388.13375358126701883071.b4-ty@kernel.dk>
Date:   Wed, 12 Oct 2022 07:19:44 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, 11 Oct 2022 16:29:34 +0530, Ankit Kumar wrote:
> Add flag IORING_SETUP_COOP_TASKRUN for ring setup, to the uring
> passthrough I/O engine. This was introduced to the normal io_uring
> engine with commit 4d22c103
> 
> Add flag IORING_SETUP_SINGLE_ISSUER & IORING_SETUP_DEFER_TASKRUN for
> ring setup, to the uring passthrough I/O engine. This was introduced
> to the normal io_uring engine with commit e453f369
> 
> [...]

Applied, thanks!

[1/1] engines/io_uring: set coop taskrun, single issuer and defer taskrun
      commit: 07f78c37833730594778fb5684ac6ec40d0289f8

Best regards,
-- 
Jens Axboe


