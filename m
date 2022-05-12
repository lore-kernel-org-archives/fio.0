Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 431EAC433EF
	for <fio@archiver.kernel.org>; Thu, 12 May 2022 17:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351775AbiELRDp (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 12 May 2022 13:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354507AbiELRDo (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 12 May 2022 13:03:44 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDF76D4DA
        for <fio@vger.kernel.org>; Thu, 12 May 2022 10:03:42 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id r27so6066335iot.1
        for <fio@vger.kernel.org>; Thu, 12 May 2022 10:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=UnaD7eInXDyX1YwNbJvUe2HqLaBIGK094i2gWHuLUYw=;
        b=YKaGCgZ2PFKy1gQKb6eSbSP4UXWaBP/SOGYn1YazENZgIfsc0whSiLR1EcRQkAmI7c
         hC+0OQxvWZRthVSx+Q+8gwy8uHuq1XIsEXCkkM4iPP9nF92qD/xMGpALn4e0+2K8r5Q5
         z9LpJHl9PNFYxkv7TVxik2z34gBL0Ui/ovqC0mh7gtEpbWwwgzO1Ot13XmfPNYhE03DV
         38cptj/6VfMvgCLorXorjW+EzSbuhevyfiQL+V5E/hZuReYBmAM7WNQkk2AjSit5td/b
         KNB7bndIVrnBKgW8EhXgo+7XEKeWb6y2+ToCgJ4XqX6i1diHNEvebwGL6IXfbpY+xWRr
         j5Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=UnaD7eInXDyX1YwNbJvUe2HqLaBIGK094i2gWHuLUYw=;
        b=yTLpBd3PBodIpQdDl0yNFpKCTIQhVYLX54qMcWFVW/dXxw+z9WB4ftFwq7WNZMnSFG
         Ii4a+1UvsYemv4F5K/zQJilGzsnSHaZNgZmUwBmWw54vxx9iKXTtmSYaKWxK8rCSrD3O
         N+ptpZlc1Qd/ZwaGriTNv2Q3t3yoj1MOA+nF7VEGZwL175pGLG6Gj3Zn3CDBVUlc0A1T
         cxKSTCBO1TDjTsRm2tKCx6aVJ22jFnM4SZjGhQn31V0xEina0iBiECjd71nTELxT2wbC
         f0+XQ45go3jHmSaQl2/1XUAAHprD1JtLjPTxCM6cgpl2wY4QT5ioqblVSysKBIPx7/Hl
         M/Rg==
X-Gm-Message-State: AOAM530cKg+nR/6XR4Svxc4NMB/9PkN+R+fDvaCt+UtPyJ7qjww0ywfs
        Grgx8scNpzwtvAiccIBAzSPgdugIO3lmzA==
X-Google-Smtp-Source: ABdhPJylXnphNAu/2usVNYyjStjZZ70B8z+YcfUEinnDPWCgfp3V3K+V7/w30WKT1oo4dLWw442r5g==
X-Received: by 2002:a05:6638:c3:b0:32a:f5d0:5d58 with SMTP id w3-20020a05663800c300b0032af5d05d58mr522811jao.40.1652375020378;
        Thu, 12 May 2022 10:03:40 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id z25-20020a05663822b900b0032b3a78174esm21322jas.18.2022.05.12.10.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 10:03:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     ammarfaizi2@gnuweeb.org
Cc:     fio@vger.kernel.org, niklas.cassel@wdc.com, gwml@vger.gnuweeb.org
In-Reply-To: <20220512164333.46516-1-ammarfaizi2@gnuweeb.org>
References: <20220512164333.46516-1-ammarfaizi2@gnuweeb.org>
Subject: Re: (subset) [PATCH v4 0/3] Cleanups and Fixes
Message-Id: <165237501945.311600.4111255277695138551.b4-ty@kernel.dk>
Date:   Thu, 12 May 2022 11:03:39 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, 12 May 2022 23:43:30 +0700, Ammar Faizi wrote:
> This is the v4 series of small fio cleanups and fixes. I dropped
> the patches about ENOMEM handling this time. The most noticable
> change is patch #3 (fix clang warning). The rest is just small
> optimization and indentation clean up.
> 
> v4:
>   - Append Reviewed-by tags from Niklas Cassel.
>   - Rebase the series.
> 
> [...]

Applied, thanks!

[1/3] backend: Fix indentation
      commit: 74ee19043ebb12dd6b0aa243f8cdb7ccd63af857
[3/3] Makefile: Suppress `-Wimplicit-fallthrough` when compiling `lex.yy`
      commit: 6f1a24593c227a4f392f454698aca20e95f0006c

Best regards,
-- 
Jens Axboe


