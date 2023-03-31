Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 793E2C761A6
	for <fio@archiver.kernel.org>; Fri, 31 Mar 2023 18:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjCaSyu (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 31 Mar 2023 14:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjCaSyt (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 31 Mar 2023 14:54:49 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A8F2220C
        for <fio@vger.kernel.org>; Fri, 31 Mar 2023 11:54:48 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id mp3-20020a17090b190300b0023fcc8ce113so26388547pjb.4
        for <fio@vger.kernel.org>; Fri, 31 Mar 2023 11:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680288888; x=1682880888;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8byzbraNvS5O9MFVnNaen0b+ljoj02K5Rux/weyMeWo=;
        b=OT/MUrfJ/iALLy3VYBsoBeZJLsw7QL5wMpcyWTgR9C8wVmp6t+7tcWt5PIZEa/LJPA
         p1XozJG9VhxyzPQMyav2y+ilO/NxWELAQuBWmbQWX8gTXTgjISn+urjA4XJ53n9qeka4
         CEiwHSmReCo793ct3DrVvwZ8bKBa9pvGbNqbNPTEYeOooH8OU0/994Sp7JZHkp4dYYpJ
         r1CyqLD2PyqFhq6eQjyYurLMc1oFu+/cjt8FkCc9Y9aEXVJJx3yr3ofnUmOqDzCNtTch
         j9PB/Q0wDDCiZ6Jusx8CVpaccN1KRMVHZ059qb5rAdsgM2EPvi0EeB/f9p1rqQSs7tQu
         BBfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680288888; x=1682880888;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8byzbraNvS5O9MFVnNaen0b+ljoj02K5Rux/weyMeWo=;
        b=Bu0FjCUnpf3IcW2VT8kfTKmLYVrGwQLyX9rh7XVU64b60S+2k3n7uxE3OVvknKG4Wf
         fiTa5KvdIGTpsV4aS17jnDBYlJmeOmxOumUEZ3dlonIKzjxDy3kd+Dpf9arF9M9qjNGT
         Z0LXwqfpNqGX4DiXtj7krBkfdFsIgBhvxHke+LP/cNpAHvLZuoVrshbjI369VMJi2UWJ
         jx9wYoHAfW29N+EVt31G17AdA5BWiFHyK0b3a4QoXY+d3CZVt4wQgFTF1wqpULHyY5Ks
         Yt46Enkl8PMztovddiBSclbm/Tkr3ANF983r6nmAVfPsz2KDv+eub1gh3e19oZh96Pf5
         70JQ==
X-Gm-Message-State: AAQBX9dcFatT4dWFZNmxjf2u/5M+47EGSpRlPSAWm2vLBLvlgI3R1lcc
        5GfRlnvqIk6Vl1KbQE05ri7dPg==
X-Google-Smtp-Source: AKy350YObMBxVuSL3nFzfIHZdbAtMD5doUs00ZzrY2RnArrFqoynf/ZgNdPG1YOjfWHMqCPdep9Adw==
X-Received: by 2002:a17:902:c94d:b0:1a2:74bc:31d8 with SMTP id i13-20020a170902c94d00b001a274bc31d8mr9654720pla.4.1680288888169;
        Fri, 31 Mar 2023 11:54:48 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z7-20020a170902ccc700b0019e30e3068bsm1914322ple.168.2023.03.31.11.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 11:54:47 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Vincent Fu <vincentfu@gmail.com>, fio@vger.kernel.org,
        Yuanchu Xie <yuanchu@google.com>
Cc:     Yu Zhao <yuzhao@google.com>,
        "T . J . Alumbaugh" <talumbau@google.com>
In-Reply-To: <20230331183703.3145788-1-yuanchu@google.com>
References: <20230331183703.3145788-1-yuanchu@google.com>
Subject: Re: [PATCH v2 1/2] fio: add support for POSIX_FADV_NOREUSE
Message-Id: <168028888732.124837.14963863099152501384.b4-ty@kernel.dk>
Date:   Fri, 31 Mar 2023 12:54:47 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-20972
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


On Fri, 31 Mar 2023 11:37:02 -0700, Yuanchu Xie wrote:
> As of Linux kernel commit 17e810229cb3 ("mm: support
> POSIX_FADV_NOREUSE"), POSIX_FADV_NOREUSE hints at the LRU algorithm to
> ignore accesses to mapped files with this flag. Previously, it was a
> no-op.
> 
> Add it in fio as an fadvise_hint option to test the new behavior.
> 
> [...]

Applied, thanks!

[1/2] fio: add support for POSIX_FADV_NOREUSE
      commit: 109aad505302d2924396774f267eca7451f8fb14
[2/2] docs: add noreuse fadvise_hint option
      commit: 109aad505302d2924396774f267eca7451f8fb14

Best regards,
-- 
Jens Axboe



