Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB1C7C43334
	for <fio@archiver.kernel.org>; Wed, 15 Jun 2022 21:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348255AbiFOVak (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 15 Jun 2022 17:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347062AbiFOVaj (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Jun 2022 17:30:39 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A66562CD
        for <fio@vger.kernel.org>; Wed, 15 Jun 2022 14:30:38 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id k7so2115036plg.7
        for <fio@vger.kernel.org>; Wed, 15 Jun 2022 14:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=pQrNddHkgdXL9fxABT13U6j61qI38f7J/YdsjmJXHTc=;
        b=P1s6VbZxASLTT9UJUYecj3XJ/XtzZhRsWdedoP2SV2o7ozEklkM3mENq/zIlC39hHr
         bt0YI3Mrh084eVwMPo0FYCELhNNsyaPPwo211JNF8BlG4tw8JNYa31P2L8Hqj7Ekiwdw
         i0fjw6xq/mq1jD1fnRmgYx/yB0WJb+MiE/tVktQGwj6SbBHG3K6v07wBt1K5niqsPY4Y
         xjWDyItvHUQ6yvdnv50nj8tQqeVJ/oruBy41uB8nQEzxJ2CbUg5J0qaUXOiyYyRmekEl
         uQ/gsIKaCEDaXicuaX1uqz4k94+UGQpgfdGfKxjnUB7900WO4e4X+CMM662gPBbWnFFw
         12yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=pQrNddHkgdXL9fxABT13U6j61qI38f7J/YdsjmJXHTc=;
        b=LklO+CiLFNVkh7YucnHxlXzMGRiE4DC0nT1hy6dHVDa8TPei3PLCWU24DA6jg3IA/D
         T/ZEDZsB/EOWAjXXOhZnd+zD0bsiQvhys1BvsBEFbunzpVPfiVlZ0dxsdmWdkE0CwbIC
         VVUiA1eyYtUpJc8LjkL/hIPk6BiUhjECE4aeRnzFklPahMNbDuhUcLIZEMr27Iq/QKNb
         E8MSNti93PGQmBGr8xTkt+2jwnFx+r+nqs/Z/OqWlYhzf0750UYTz7efnXzcx7voS/sC
         BUtsbn+s3pZzN/THXP8kdbAeoJlsX1E6LqfYhNdhDfm3Wm87+eOOEDSRUTWB+dPcllTT
         6UAw==
X-Gm-Message-State: AJIora+olYSWr1cbIJG/ebkoehNKH8ryJA5KDDIfu00G4DfLRQeLEOOC
        lqMjfz2YZTdJKdqNbHphRCjujRsoPm5Zwg==
X-Google-Smtp-Source: AGRyM1vzfp+ToNqdMPAs8Rfb747NIqMnIlVYTjjO7714ikBKWgG4bnBHp3Lmr3EfJhL7FuArmfChOQ==
X-Received: by 2002:a17:902:c411:b0:165:11ed:9287 with SMTP id k17-20020a170902c41100b0016511ed9287mr1498079plk.110.1655328637754;
        Wed, 15 Jun 2022 14:30:37 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id jj21-20020a170903049500b001616e19537esm76775plb.213.2022.06.15.14.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 14:30:37 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     vincent.fu@samsung.com, fio@vger.kernel.org
In-Reply-To: <20220614155822.307771-1-vincent.fu@samsung.com>
References: <CGME20220614155830uscas1p1e1d6595b29fb6960b405d5b295a32ffc@uscas1p1.samsung.com> <20220614155822.307771-1-vincent.fu@samsung.com>
Subject: Re: [PATCH 0/5] Latency cleanups
Message-Id: <165532863709.858685.15018475756909381631.b4-ty@kernel.dk>
Date:   Wed, 15 Jun 2022 15:30:37 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, 14 Jun 2022 15:58:29 +0000, Vincent Fu wrote:
> Jens, here are a few latency cleanup patches. The main improvement is to
> avoid recording issue_time twice for the ioengines that record
> issue_time themselves when their commit hook is called. Recording
> issue_time twice underestimates clat since the first issue_time value is
> used for slat and then the later second issue_time is used when
> calculating clat.
> 
> [...]

Applied, thanks!

[1/5] ioengines: add helper for trims with async ioengines
      commit: d46b4565dfdaddbfdd91976a57b2564aa7a52f62
[2/5] ioengines: don't record issue_time if ioengines already do it
      commit: 4e7e78980ff32627e12b48d72496b701dd200a42
[3/5] HOWTO: improve description of latency measures
      commit: 13ddd98b2a70c55657f952096785ccc64479f0eb
[4/5] ioengines: update last_issue if we set issue_time
      commit: 39f56400f63e43fbe33e391d52f24eb6c79d0098
[5/5] ioengines: clean up latency accounting for 3 ioengines
      commit: 2b82135e42fc5872338ee16e16d317b16abfe308

Best regards,
-- 
Jens Axboe


