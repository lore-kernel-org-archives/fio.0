Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58037C433F5
	for <fio@archiver.kernel.org>; Tue,  8 Feb 2022 19:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376631AbiBHTKs (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 8 Feb 2022 14:10:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244714AbiBHTKr (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Feb 2022 14:10:47 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE27C0613CB
        for <fio@vger.kernel.org>; Tue,  8 Feb 2022 11:10:46 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id j12so15598120qtr.2
        for <fio@vger.kernel.org>; Tue, 08 Feb 2022 11:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=VnyyGZcykD+QDIazN0OoTWfbt+SOZMgghAm2EJjwD9A=;
        b=JtfSu0EB5moPv9FLqpqwU9hyfVR1bALdCPEhxNMFanmxGrDcq40+YQit57L1ROMGHY
         Hcoz2c9tq2lrvZE7f+DfH69/7OiW922WlaggSX+yg0aUcSwJ6Ea5atktidGGvaG6h6hW
         HLl8j4d8wxwYr4GCNXCBOyizLjKWO/+OSPJs8WbWoysVGV0dtxN16KliTj1S4XJcJnnn
         n0M0DbAVe7GQPpnDpyLx8I8IaOxc+uVxeaKQ9RZ60F4VqJfAYgF76RvT/E3uPZF8BAxn
         CJETaBcIDOKIO2Phv51xISqpR8uIXHLMV5E1oHOct4Am4w6OpGsTrDzRFNU43MvVuIjx
         RueQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=VnyyGZcykD+QDIazN0OoTWfbt+SOZMgghAm2EJjwD9A=;
        b=1Feai2NVlX01Ggm9srmQ7CCBzPpNyGIvcCyDrsI5ywbU727hdgqTB+AaYH4KFX4gF5
         EA+VbSVdkjjjhyTTEpHp2jB3DvDvb1MtXHeErspxCJSXbRR0sGl/7JgwA1qV4GofGacP
         5Z4dezVWBqGbV7TiCDb2uZ//3V60Pa+VXoZ1MY5bKPec24OcdkevNVvmqypvUdgOR0SO
         7EB1G2eHn8EukThg6X59L27HJXZef6EmwvbvmOBRfK6fOSrDjnbKUmP9g/+0nUhN4nMm
         uUFOku7bDEPf5CxfU4YSS2aYNgklgX64DtTl7TzXNc2VBEm9L8UpJaFigXDZ8KkSazT/
         bUmQ==
X-Gm-Message-State: AOAM530vlaLeQPDodnTBP1rVQjPC8cXGNo+/5Je9nQuREaZrtncKm3zy
        VjWQq18J7TgUbJCi0O3+Re5AKW82r114dBncYxBCV8rGI3ET7Q==
X-Google-Smtp-Source: ABdhPJzV8dEtQy3eKf6gkli9UhjXhq6VAAh8CNnf2tjgVtbEqpWF1jyaykDEzB/l0u+p6S/e14tljZd3og78Gu/KQp0=
X-Received: by 2002:ac8:578e:: with SMTP id v14mr4043031qta.345.1644347444916;
 Tue, 08 Feb 2022 11:10:44 -0800 (PST)
MIME-Version: 1.0
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Tue, 8 Feb 2022 13:10:33 -0600
Message-ID: <CADqNVToxJ4e5ad+YESuhD5SMy9js4cwMd8=7xcXFf7rW8a3+ng@mail.gmail.com>
Subject: Fio docs say io_submit_mode=offload with async IO is not reliable?
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I'm learning about io_submit_mode and avoiding the coordinated
omission problem. The fio docs cover the mode and give two examples of
using it. But there is a comment in the docs that says

"Note that this option cannot reliably be used with async IO engines."

I don't really understand why? Further, both examples in the docs of
using the option specify the libaio engine, which is asynchronous,
adding to my confusion.

Perhaps the comment means to say "sync" and not "async" - I could see
how pushing I/O to a pool of threads in the sync case could be odd,
but not necessarily "unreliable", so maybe not. Just trying to
understand what danger the comment is trying to warn of.

Thanks,
Nick
