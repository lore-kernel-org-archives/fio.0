Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E895BC433EF
	for <fio@archiver.kernel.org>; Tue,  8 Feb 2022 16:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236721AbiBHQ26 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 8 Feb 2022 11:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234343AbiBHQ26 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Feb 2022 11:28:58 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745ACC061576
        for <fio@vger.kernel.org>; Tue,  8 Feb 2022 08:28:53 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id w7so21808237ioj.5
        for <fio@vger.kernel.org>; Tue, 08 Feb 2022 08:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=dmt9nUSRQGDkLSM0t/JJx10Gs+7gCd/GQN5rE0xrpKk=;
        b=jEIfauPvT0bXydOpL5avMMynBV3CzZACiYzXtrVRtkPRKt4RFFjdr9L1xjQUxojU5K
         JTFHMjdQTnXKumI5yJ+dxEM6ux5SjwHxky9SVxXJj4TRLjZta7BCgCwGQr839qouW31F
         84LcCgliYMQdfJKrHb0Iib7a8iBhzFLLmxNgswCCOC0FcNaWh1kn53p1RgBLC35w2Vem
         UFuTzFN+Iuil3667kKldMCNKrGYtTOKWjhX8HA+D/g1kFJNZmCc8S4elm/IGMVRMJBFK
         V6i5SxwkRKtSNJjq9zgDh6h6WSATiMaU4awcfg3qtrdELM1wRSD5SuuDvL+NcRu+jldF
         5++A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=dmt9nUSRQGDkLSM0t/JJx10Gs+7gCd/GQN5rE0xrpKk=;
        b=n90MTFOw1i/KL0V3eBvc9p8JiZ0UAFzp+CeaRNSPrEUeK545l62domScKqU1fSrjDs
         PzfVRBwSM3ja6CfCfSKm03WC2SOcVeMUmFmpmncsrksmx/xBknRQMOW3tU8kLW/SRoXf
         4C9FdGJ7h9UZL6qVqexZu9qSBxKypOBqGRGidV5nwt49oaImVpzjAsYi3tmpczM+PlQj
         gsQRVmefZ9zg5PBqeCFhoz/Gd3MCPDR9bcEhEWm7MKo8IkcGddiheDDzxCQTy+JBHaVJ
         XtMGZlBwo7Wz1U5/Up8aW5f6pERL1sbyvy3sDvAfcuv3OtBsZHtHoOcS2m0Y+ayA4WTd
         spoQ==
X-Gm-Message-State: AOAM5331DJ/Bf4zmbYLUjeBZzrAs7faBLD12/1q+kZ9HcvfTmV4hNU7+
        1Fs8xbgWwADe1YOigT+lapO5lxR0dGvygufg
X-Google-Smtp-Source: ABdhPJzti7MO+OB7/Z/VB2IIUouXgzqNVl2qVHr4SmN87q7LhSmY+DFIPfqlLOss5hU3SFbQZv4LFw==
X-Received: by 2002:a05:6602:2492:: with SMTP id g18mr2472265ioe.24.1644337732648;
        Tue, 08 Feb 2022 08:28:52 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p11sm8801056iov.38.2022.02.08.08.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 08:28:52 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     fio@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <1644336039-12774-1-git-send-email-sandeen@redhat.com>
References: <1644336039-12774-1-git-send-email-sandeen@redhat.com>
Subject: Re: [PATCH] fio: really use LDFLAGS when linking dynamic engines
Message-Id: <164433773190.131753.16473087003889385904.b4-ty@kernel.dk>
Date:   Tue, 08 Feb 2022 09:28:51 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, 8 Feb 2022 10:00:39 -0600, Eric Sandeen wrote:
> Fix stupid braino on my part.
> 
> 

Applied, thanks!

[1/1] fio: really use LDFLAGS when linking dynamic engines
      commit: df597be63e26ef59c1538b3ce2026c83684ff7fb

Best regards,
-- 
Jens Axboe


