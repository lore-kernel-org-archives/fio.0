Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD04CC433F5
	for <fio@archiver.kernel.org>; Wed, 17 Nov 2021 23:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B254C61269
	for <fio@archiver.kernel.org>; Wed, 17 Nov 2021 23:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241516AbhKQXRp (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 17 Nov 2021 18:17:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241501AbhKQXRn (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 17 Nov 2021 18:17:43 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C675C061570
        for <fio@vger.kernel.org>; Wed, 17 Nov 2021 15:14:44 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id l19so4564765ilk.0
        for <fio@vger.kernel.org>; Wed, 17 Nov 2021 15:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=MJSWZ0kMQ2/iqa8VBGfEAvd+qkM3H7Va2vRjaK5YC0U=;
        b=hRsAJK2sTKCEvLZjyqqqbhIQFEOLPQim4BJuplkcRry38+V4sEugMS2YPGhB/Hd9yf
         bqZB7grrlMJLtVcU11clIwu9mNTDCFjpBzrw47PlV50/0kr+vEqp5SriHSSk5ZS7NLJT
         cXaHC/WQZasabxzI0rBB/p1rbjMbCabyn6MuCBdpIgk/w4aKAgMUSisKaeYP6GyVX1ZX
         IxD4hca4cB1255RbRPlL8G7BcWVr069GmJWVH8bUBDrHIwAWvh9yPcXx7PAwZcioJvgJ
         qutWt4eqm0al6Yb3qsCFDsJas65lHxtSt+LZiMkeWY/o+eG3NymLze/IcqPKe7EFQagp
         VGBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=MJSWZ0kMQ2/iqa8VBGfEAvd+qkM3H7Va2vRjaK5YC0U=;
        b=qRmBm+LeqQiU7mQKBO8A/P2S6SGzVfBpBEMtg+B95RTzntCb4Yo7dr0Q9lNrTLkUkt
         rsaGQ0DDXvOaHFewdSEK7nLmv/5Z/W8tjYUFLh3LZPMnxPdQqYqq162DM+0s9Yp98F68
         7steHQDAp6oNNso2UPpzbYw+XLOB3PKY6NUeZNf/eIUHjnCQmCR/rMhjilQ8CGgy6MTB
         rdk/j3vfFFJw3LTSz6QEDQRUOO36ViNK6KMZSg89oOEfWZPh3TFnkWOuLo9y612j3CrB
         IDKILxmSr26GRXx1pePqbuTxomfmPdfeYjPC/xgjP6BK+6MaC8Ww48nvgtiGgKU/+QLO
         UIkg==
X-Gm-Message-State: AOAM533mzUYwbQr9CgHD1NWZukUWN/ggQBJUg6S4vd09qzMUCvlO7icI
        /BTXm6jQjF6c6pk3Kz3YoME96Xd++DF28DUT
X-Google-Smtp-Source: ABdhPJz5lUHE+Q7bQi6OVvdlwiq+/gvC1b/qMKjYFcR/ZmPdHi75N911UackLV10rEZr5cWtH6iL0g==
X-Received: by 2002:a05:6e02:190b:: with SMTP id w11mr13158642ilu.211.1637190883691;
        Wed, 17 Nov 2021 15:14:43 -0800 (PST)
Received: from [127.0.1.1] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id r3sm759344ila.42.2021.11.17.15.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 15:14:43 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     niklas.cassel@wdc.com, Gwendal Grignou <gwendal@chromium.org>
Cc:     fio@vger.kernel.org
In-Reply-To: <20211117221918.3050439-1-gwendal@chromium.org>
References: <20211117221918.3050439-1-gwendal@chromium.org>
Subject: Re: [PATCH] Makefile: Fix android compilation
Message-Id: <163719088335.258518.739015978128297012.b4-ty@kernel.dk>
Date:   Wed, 17 Nov 2021 16:14:43 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, 17 Nov 2021 14:19:18 -0800, Gwendal Grignou wrote:
> Inclue cmdprio for Android as well.
> Without the patch, make for Android fails at link time:
> 
> engines/io_uring.c:824: error: undefined reference to 'fio_cmdprio_init'
> engines/io_uring.c:456: error: undefined reference to 'fio_cmdprio_set_ioprio'
> ...
> 
> [...]

Applied, thanks!

[1/1] Makefile: Fix android compilation
      commit: 5711325cbb37d10c21a6975d1f1ebea11799c05e

Best regards,
-- 
Jens Axboe


