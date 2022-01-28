Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E3FC433F5
	for <fio@archiver.kernel.org>; Fri, 28 Jan 2022 21:49:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351645AbiA1VtX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 28 Jan 2022 16:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiA1VtW (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 28 Jan 2022 16:49:22 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A98C061714
        for <fio@vger.kernel.org>; Fri, 28 Jan 2022 13:49:22 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id d5so7662795pjk.5
        for <fio@vger.kernel.org>; Fri, 28 Jan 2022 13:49:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=gPtMpV6GtCpNMRLa1nTgfgtM1XqksQOPuNvQQ0EYj4I=;
        b=Lzmiz89/fZa6PhlHQ1/hq30Ab7CkjKvoTKuFmjvv5XbAijqunSEHCuTHa2Ml/z1gAd
         6Tv5VPr7f+uuFKVCtOGLPNdq/cfFX0uwN+V3l2O2IFak0ZE8Ciwd8aSFmJAk74Xhsvvs
         oey3lu+Zl/M3NwY3UnU9IcxXzJ0BjuuPRefQxxHoVyfSKpqVS/4mWZpfKCG9/4RjurzA
         V+ta9u6Jb1xGF2J4nT0qeIZY3T/tYB23RoXzAp4hDTV+aAmsXzWzMH57i6rCiX8akcnw
         5q7Ikq0NHUP6D/A42VwbKPBWd4j6+Nf/yxfoMtzQwJ8CAlbbwoQHaIMWaq5WbPDtEqov
         xFdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=gPtMpV6GtCpNMRLa1nTgfgtM1XqksQOPuNvQQ0EYj4I=;
        b=N8IGf2fh5xrJ+E+smf+CkD1BUfdLiiOlsPuT7UhmBl13XTbd6EINL6H1Quzl94Sbyt
         vvimey7/hx/mf0pp2Wy9+hXnUPRU8cM7xT/IHsb7vXwkdWil0TKmUP/67HSWAb38mV+d
         m0jD01A25hqKoPAdqS93sVrFsxJL/kooXLDXB/iJLkI9GxsbcXshG8DiVDiPWsCyvLUo
         5c/kXIAV+UNcjcd3y8mt0C+L385s8ITmuPdcNK4u8O3YaCJairLdHk5sEapuClECzf8E
         TOErLYLxttgViQLXCCvTtlv2NXjbiqXZKsJw6KwPlZBQC51RSDp2UJCvtnbj3nUYf/BJ
         UnvA==
X-Gm-Message-State: AOAM533bXUvURPbWf+oXV+D63uWbLu76KgieTlNVculvYQ5Prf8jPvAy
        4fVOCrWptkecERwDu9bZ4LytJdSviUSQnQ==
X-Google-Smtp-Source: ABdhPJz8G/gVvLL/b/3rOexdo9r38+xxQ8VIwNC3QKXRimCU1SR3sdk2de8/9Pqe5Vqt41mBPw9v+A==
X-Received: by 2002:a17:902:b40b:: with SMTP id x11mr5975901plr.75.1643406562045;
        Fri, 28 Jan 2022 13:49:22 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id x17sm10126061pfa.105.2022.01.28.13.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 13:49:21 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     fio@vger.kernel.org, Vincent Fu <vincent.fu@samsung.com>
Cc:     Professor Pro <annivation@gmail.com>
In-Reply-To: <20220128214611.165312-1-vincent.fu@samsung.com>
References: <CGME20220128214648uscas1p1093b2602603486134890a51b38270e45@uscas1p1.samsung.com> <20220128214611.165312-1-vincent.fu@samsung.com>
Subject: Re: [PATCH] Makefile: build t/fio-dedupe only if zlib support is found
Message-Id: <164340656149.379855.17440986206155843998.b4-ty@kernel.dk>
Date:   Fri, 28 Jan 2022 14:49:21 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, 28 Jan 2022 21:46:37 +0000, Vincent Fu wrote:
> df284fbdc23974c931865a8ddb7d171606b3c778 added zlib support as a
> requirement for building fio-dedupe.
> 
> The current patch changes the Makefile to avoid trying to build
> fio-dedupe when zlib support is not present.
> 
> 
> [...]

Applied, thanks!

[1/1] Makefile: build t/fio-dedupe only if zlib support is found
      commit: dd75d6d0d4121ab9ca6ca571fbc1b2bf7fe89dad

Best regards,
-- 
Jens Axboe


