Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4480FC433F5
	for <fio@archiver.kernel.org>; Tue, 18 Jan 2022 13:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241937AbiARNhr (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 18 Jan 2022 08:37:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239194AbiARNhr (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Jan 2022 08:37:47 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D42C061574
        for <fio@vger.kernel.org>; Tue, 18 Jan 2022 05:37:47 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id d3so17543839ilr.10
        for <fio@vger.kernel.org>; Tue, 18 Jan 2022 05:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=IbNwLEPdFO4X6cY+TlmnNo4jZ8g9kgi+72wJ920UMVg=;
        b=SQQZe+sOdHcLGcgXk9V2LhCFQP3WHfgV6e0xiMctdwiV2aFwwQbm9OsAuYHGkZ7dKe
         TQoJfWCTxxVb2BaO5uxVauZXjSV/M7tZsTwFDc+xYucVlWtKai4vN7iFiciNX7dbRDd/
         SbukZ8138z3Liufc0GNkmr6g5C4wF2HxTs/GXwtveiNLwR0WdlU0h2QKHHCxMEX88sFg
         r2ur3PKvp7Gu3DwFJR5+rj/9E+ordrAQBOAGGzRNMzW9EUIEE74hqaB+NEm250vczKAk
         MuN1LJWy4zBaJ9FyJBwXBWYxAtnyXy9cMr1OpFYcbYkn851sc9ukSOZ0L7b+BBeKGLzT
         t6cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=IbNwLEPdFO4X6cY+TlmnNo4jZ8g9kgi+72wJ920UMVg=;
        b=KXe1gmdHqwYu3O2xhod7/lZKD0OBX4gUDVkIqnOrc3L8/6G3yqA+wYSbDRAA8uh8ZU
         xOHOM+0YK94Uws5pZDXGskcMYNvkKctxQ5fWcXFVpdEaOWci3sBDBqwdWgb7CyRLb3zt
         FH974/MMOaqJgskTRIjyqbuMKGlb/3N2Ig1+yfdIh11yjJn19745vFF1boEbWXcfhNVh
         5Gw5feZDSdXas7jS0owWCfMRkJWNIzGrUh29FN5VabrJeiURnkvokSCPyJc6zO48LHZx
         EyjeVFn/j4XYHssH0GWRxZvwpfTg5XS6JxfgmgMJWLRrEQ56ueovgvz20uduKFsAk72N
         dfpQ==
X-Gm-Message-State: AOAM533cgMoZgwyhcpMHj3VhyZ2yDiTO9ChqrJgn7ctlGS1HccmUeD7T
        KhNg9+P/gBrnAjsTXV2/+DD3sQ==
X-Google-Smtp-Source: ABdhPJw6RySDn6j/0sQ+poIn44Qs3ncBuGopa9WdMRg57uPhiHABWUtWdRx0Jc7CMCK+gTHG4cjw4A==
X-Received: by 2002:a92:cd81:: with SMTP id r1mr5891875ilb.31.1642513065986;
        Tue, 18 Jan 2022 05:37:45 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id a14sm11351614ilm.48.2022.01.18.05.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 05:37:45 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Vincent Fu <vincent.fu@samsung.com>, fio@vger.kernel.org
In-Reply-To: <20211115200807.117138-1-vincent.fu@samsung.com>
References: <CGME20211115200821uscas1p12939025b77aaf0ec414bf1427cf1b72a@uscas1p1.samsung.com> <20211115200807.117138-1-vincent.fu@samsung.com>
Subject: Re: [PATCH 0/6] additional sg ionegine commands
Message-Id: <164251306548.363973.17641802387670405205.b4-ty@kernel.dk>
Date:   Tue, 18 Jan 2022 06:37:45 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Mon, 15 Nov 2021 20:07:17 +0000, Vincent Fu wrote:
> Jens, please consider this patch series that adds to the sg ioengine
> support for the SCSI commands VERIFY, WRITE SAME(16), and WRITE
> STREAM(16).
> 
> Vincent
> 
> 
> [...]

Applied, thanks!

[1/6] sg: add support for VERIFY command using write modes
      commit: e8ab121c88d61624c0925b54013cd57c2dc171f2
[2/6] sg: add support for WRITE SAME(16) commands with NDOB flag set
      commit: 91e13ff509253667c11fce864693849d2cb77b67
[3/6] sg: improve sg_write_mode option names
      commit: eadf32608213dc2a44303fce0b417fbb95d1a0a6
[4/6] sg: add support for WRITE STREAM(16) commands
      commit: 9917adb5d3b9c480ac710af4bc2c9c0421c6a5df
[5/6] sg: allow fio to open and close streams for WRITE STREAM(16) commands
      commit: 5f647ee93b0b8ee07d6cbcef571986f8a18b1234
[6/6] docs: documentation for sg WRITE STREAM(16)
      commit: 71efbed61dfb157dfa7fe550f500b53f9731e1cb

Best regards,
-- 
Jens Axboe


