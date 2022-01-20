Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B56B9C433F5
	for <fio@archiver.kernel.org>; Thu, 20 Jan 2022 18:41:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347743AbiATSlD (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 20 Jan 2022 13:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346978AbiATSlC (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 20 Jan 2022 13:41:02 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCA1C061574
        for <fio@vger.kernel.org>; Thu, 20 Jan 2022 10:41:01 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id s11so7983831ioe.12
        for <fio@vger.kernel.org>; Thu, 20 Jan 2022 10:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=Wav8mekjxanXwTY7KlAYRNnJv4kFgfRts3HbysFTfHE=;
        b=VL7TrjHVE5xMU2s4/l2tw+hoN9fZ733x33aZAxmDNuuTsaJSp+b+MxN2Fd7p5Fj4DJ
         iikKqXham3QiO/D/YGr8cixY6M79ueggO7/jLZUfHIHcFZIuJfmWi5nnxpaG2Dzzo8wH
         t4VNMbHNKIN90G6EUfy5xvU1bTl5AtLTS/3KaXPTzwsGFPpD6QkhFA/r80gifqQDFuGv
         D4MuZOzs2Fl4cXHvhKfcUoqb78+A4/Ths5Om7J/wx4VmnU8JLdwMEjSvyVvYABNlc76p
         L08JVNNdiHsOhDk5cFguuaM5lOziouZw3MI+qjnk4liTi3kXAlxsIbfSZy1YjGKjf8R4
         qjEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=Wav8mekjxanXwTY7KlAYRNnJv4kFgfRts3HbysFTfHE=;
        b=TcIEuOo8XF81zL27VIVzyMUz+AJhvFz/UNrQtayH6Q9tbIi7AAziGVG/WgtHz+/otD
         AwdlgzXz8WsZIaqw4QAjw2tCMrONFX6dA/qnk9Yj71NYuFabhgd9GpN3JHruRyj65JMC
         d5kMucJy4Q03qqaGU/bpiHpqwqBEzSL1ep5a3RyZu3TIVDb42hNq3rrHuludhHPqwvbD
         I2256KSp9amGi7L2cxtS0rp4jh405pBJG6qevfiZd/fdjbvY8DOBNVGKHjwwRDlPBy0s
         j9ehCUmvLtuxCAWqD/FQmPxt8H25LBsGixtHKkvmVD9sTes7SMFp3V6B6MgIVU6k1iYD
         Ipcg==
X-Gm-Message-State: AOAM533W0OutV8cM+TM5fjFz0rpRkQldrU2q8kynNkqSsWvRzc0kXNMm
        S5TKWfEGFpqIF6GRe75wBaU62sAi2nw1pQ==
X-Google-Smtp-Source: ABdhPJxStfoFvy+fALHW2o4r3Ef2Z3KDOmzmwjy88TqJa4XcJ76ipOJZnK7cG5T4alfaKtCFv1XN4A==
X-Received: by 2002:a6b:7307:: with SMTP id e7mr96373ioh.19.1642704060727;
        Thu, 20 Jan 2022 10:41:00 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m18sm1661001ilc.68.2022.01.20.10.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 10:41:00 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Lukas Straub <lukasstraub2@web.de>
Cc:     fio@vger.kernel.org
In-Reply-To: <cover.1642626314.git.lukasstraub2@web.de>
References: <cover.1642626314.git.lukasstraub2@web.de>
Subject: Re: [PATCH 0/8] blktrace: Add support for read_iolog_chunked and fixes
Message-Id: <164270406008.190391.17980794060634478741.b4-ty@kernel.dk>
Date:   Thu, 20 Jan 2022 11:41:00 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, 19 Jan 2022 21:14:04 +0000, Lukas Straub wrote:
> This series adds support for read_iolog_chunked to blktrace and fixes some bugs
> along the way.
> 
> Regards,
> Lukas Straub
> 
> Lukas Straub (8):
>   blktrace.c: Use file stream interface instead of fifo
>   iolog.c: Make iolog_items_to_fetch public
>   blktrace.c: Add support for read_iolog_chunked
>   linux-dev-lookup.c: Put the check for replay_redirect in the beginning
>   blktrace.c: Don't hardcode direct-io
>   blktrace.c: Don't sleep indefinitely if there is a wrong timestamp
>   blktrace.c: Make thread-safe by removing local static variables
>   iolog.c: Fix memory leak for blkparse case
> 
> [...]

Applied, thanks!

[1/8] blktrace.c: Use file stream interface instead of fifo
      commit: 5ab088aa50aec5875d37f0ccc31711a9d50ededc
[2/8] iolog.c: Make iolog_items_to_fetch public
      commit: a21ed2b50116e96f5f2d9c0dcf2e3506d7397ef8
[3/8] blktrace.c: Add support for read_iolog_chunked
      commit: 10f74940073380f6cb15608053b36a796f879dec
[4/8] linux-dev-lookup.c: Put the check for replay_redirect in the beginning
      commit: d9d60dbf49bfa62b5bd26f078533088f1de17b6f
[5/8] blktrace.c: Don't hardcode direct-io
      commit: d0b12843fd441460bd9a0172169b028a74f76b10
[6/8] blktrace.c: Don't sleep indefinitely if there is a wrong timestamp
      commit: f36bd1341690e0c63718c32465e173874bf56727
[7/8] blktrace.c: Make thread-safe by removing local static variables
      commit: 661592d44383069fe949ec68154c2d8079cf02a0
[8/8] iolog.c: Fix memory leak for blkparse case
      commit: 3a3e5c6e7606e727df1788a73d04db56d77ba00d

Best regards,
-- 
Jens Axboe


