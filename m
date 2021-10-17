Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62827C433EF
	for <fio@archiver.kernel.org>; Sun, 17 Oct 2021 13:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D2B760F93
	for <fio@archiver.kernel.org>; Sun, 17 Oct 2021 13:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241353AbhJQNDE (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 17 Oct 2021 09:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237546AbhJQNDE (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 17 Oct 2021 09:03:04 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180FCC061765
        for <fio@vger.kernel.org>; Sun, 17 Oct 2021 06:00:55 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id w10so12083748ilc.13
        for <fio@vger.kernel.org>; Sun, 17 Oct 2021 06:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iURf0vc1j4EwKrS0waJT27loSBf8j6wLcAbz6sheQrQ=;
        b=bmBC1P9DwYFzmqiVcH/gcAcm592seEjWZ/WLfAXx3C1FlfN6+kDWPvqhDw/NmsKwom
         4UDVb3uBlKybwSX+y0YB4bTv04izq8HIrOQ747320oQUlqp4sfn/8I/+lZncPTqlC+9Q
         5jLNlL/Wupi2WyL92sNKLa3StpggxwTsFBKOByoka/j/KpIHy2kJtUgTZIWTNc5NiRHn
         uUS+/sNnJmqoIWTPx5Jcwe4Wu5E00SHzNs+X9fADnEuAK8IS1/MPE3SdvP+fcfsr31pB
         AL9B5aAKe2uM2+k2TNZHmz6DZNIP1BOGwFJP+G4KY/WkltK95D8yMWWPyce8+SSgYFmQ
         UL1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iURf0vc1j4EwKrS0waJT27loSBf8j6wLcAbz6sheQrQ=;
        b=RMQ3Fs4MHPBlJ3dwWlYdrS/qlRbimbDj//aCgBKcsqE8zUPAoYVBnXMcLV+ogdwz2Y
         gWjwpul6SZW3WX4W9UTp12ahr8EfQlpesXi3qZ4feFFx6/qA00FUIx/K3T7Bn7DiVolt
         1AsiPJOp/DNsFJCbpd2MwgTPkKku1XfRBz3pS6vVYq2/rERqgRSh7TdZMT9YtjUSJrb6
         uLK0IvamM2mfu+2jaRDeUjhxt3J/LBiFGNnnV+USlfBjfJoSpQRsJjS4bzfY6KPsMgfL
         NTaJA6nehNMK+/OcC3TIFl1dyNjFxFCYAOCPVPkULj4olJZjiKFD4/j69ymZHaJLQlsi
         iYzQ==
X-Gm-Message-State: AOAM533vm1hO/ey401sI6yzG+qvinOG2ARyAeryA9P/2bBFYlzL5DlO6
        POlfS6YFT1gmoMoih9rMmuQA3Q2B6Fz7bQ==
X-Google-Smtp-Source: ABdhPJwKAbSqnrSUZYPzI+zDycTswy5B2MuObSxEvmAzJyK0PIMQ9ubQOwa1nIPY4HuquAl0mFGgZA==
X-Received: by 2002:a05:6e02:1807:: with SMTP id a7mr10269747ilv.285.1634475654290;
        Sun, 17 Oct 2021 06:00:54 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id l125sm5252639ioa.2.2021.10.17.06.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 06:00:53 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     fio@vger.kernel.org,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: Re: [PATCH 0/5] zbd: Fix failures unique to specific zoned devices
Date:   Sun, 17 Oct 2021 07:00:51 -0600
Message-Id: <163447564648.89671.7279990360998687348.b4-ty@kernel.dk>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211013060903.166543-1-shinichiro.kawasaki@wdc.com>
References: <20211013060903.166543-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, 13 Oct 2021 15:08:58 +0900, Shin'ichiro Kawasaki wrote:
> Recently test case failures of t/zbd/test-zoned-support were observed, which
> were unique to specific zoned block devices. Several test cases fail when the
> device has large zone size in GB order. Some test cases fail when zone capacity
> is unaligned to block sizes. Some other test cases fail when the zoned block
> device has strict open zone resource limitations.
> 
> This patch series addresses the failures. The 1st patch is a preparation for the
> next patch. The 2nd and the 3rd patches fix the failures observed due to large
> zone size. The 4th patch fixes the failures observed due to zone capacity
> unaligned to block size. The last patch adds an option to the test script to
> support strict zone resource limitations.
> 
> [...]

Applied, thanks!

[1/5] zbd: Remove cast to unsigned long long for printf
      commit: ee5e3436012aad0d2a06c7638dad39f01ee44c1e
[2/5] zbd: Fix type of local variable min_bs
      commit: 07fc3f57d106e58e0bcfff1a46ec8b4266770388
[3/5] t/zbd: Do not use too large block size in test case #4
      commit: 1f5dd7fa0f2425b5c21ce2fbe2944a57df462632
[4/5] t/zbd: Align block size to zone capacity
      commit: 1ae82d673cf5e704b93da56655f6189f43a1592e
[5/5] t/zbd: Add -w option to ensure no open zone before write tests
      commit: ccf9d1efdae8a440fff750037117428f27e40b43

Best regards,
-- 
Jens Axboe


