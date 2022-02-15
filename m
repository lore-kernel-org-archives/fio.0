Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82D8C433EF
	for <fio@archiver.kernel.org>; Tue, 15 Feb 2022 17:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbiBOROy (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 15 Feb 2022 12:14:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238064AbiBOROu (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 Feb 2022 12:14:50 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4CC11ACED
        for <fio@vger.kernel.org>; Tue, 15 Feb 2022 09:14:40 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id q8so1759260iod.2
        for <fio@vger.kernel.org>; Tue, 15 Feb 2022 09:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=GtJMtHByjWOk/szJzQ+cecPSjqFTP7Ak4BtWB/vuSsg=;
        b=bh73oHdBNM/dVP9rw+Z7Jcf9KnJQHbgrpCoCYtdVLkKIp4VSp0jT7ifARVx+cLSXf7
         zKJoi3QmGPaYy7gxi6vlDIFg9KJPAa8IVwxZC248zPiFbPXkf+X2tDC0eCCgHh7Kq7Cx
         UpWotzLOo9+E5x7yj7ayKTpC0N+5PS8Su9ieaHLBDpxKYX1hsGGiLHKRLl/oNB7wJCMf
         I/Ls1GBcAY7kgSWvswXNVBvZj8QFlfpxhlKVaRDrauT/EXFE1uKMQVJu9R+pkJbO086s
         THW4mE/hYQJbU/hYgayaX/SL9LLvit+mKTnttsesWp6BHA1ZwSxq7xE6ZTTpMVJ/f/Tv
         eNDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=GtJMtHByjWOk/szJzQ+cecPSjqFTP7Ak4BtWB/vuSsg=;
        b=JbL5Zv7tdulM/r2ESu25RDAxoZ0+2JXzIvm9auRBgxYiHjMhbp1NTUCApaMNggjLA+
         90JemVLvfQjvqv9NpcdZ5nYCit0/CGAtcaFhF8+HyumfUW+ZsZApDeAc0afHLiBCSo7F
         am3qgH6FLd0RUIMcaNfqp2H8fK+aPavLp/+RouQZo/IPV7AduytxjljI7JHly3Jdjttb
         XBjRZ6M5p9dWQspCJO5FjGkqAsZRilY6StKIoq24HqjNbqEnbJvslVHPURWuleEDtDuH
         tUJpWo4Sci0VZB4etBhscJQO008yQb37LKaUoyqZooWU9JgQlMyIRbUmC/84FBO8Kshc
         F7KQ==
X-Gm-Message-State: AOAM532NADdsSBqbSTxC3CUq46YsK3n0PaJMPk/J9M0f/cmGEKI6tZhE
        nbv6goFnq6OutczV6ZsPx6vGoN0I1uoiHQ==
X-Google-Smtp-Source: ABdhPJyCaUryFn1wiRvylbsjtceGRI77nVvz4Tufp7bIPmpBuMD3JODWvZ8J4qHMlgjtuN/pTjLzkw==
X-Received: by 2002:a05:6638:3806:: with SMTP id i6mr3258633jav.314.1644945279306;
        Tue, 15 Feb 2022 09:14:39 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y29sm3494846iox.46.2022.02.15.09.14.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 09:14:38 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     fio@vger.kernel.org, Vincent Fu <vincent.fu@samsung.com>
Cc:     Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20220215133027.931-1-vincent.fu@samsung.com>
References: <CGME20220215133048uscas1p1a894d691bd2ee6e391b2cc8e4f22d143@uscas1p1.samsung.com> <20220215133027.931-1-vincent.fu@samsung.com>
Subject: Re: [PATCH] ci: detect Windows installer build failures
Message-Id: <164494527860.136522.4533623618028319973.b4-ty@kernel.dk>
Date:   Tue, 15 Feb 2022 10:14:38 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, 15 Feb 2022 13:30:30 +0000, Vincent Fu wrote:
> From: Vincent Fu <vincentfu@gmail.com>
> 
> When the Windows installer build fails, the build script actually
> continues running and does not detect the failure. Use ls to determine
> if the MSI file exists in order to detect whether or not the installer
> build succeeded.
> 
> [...]

Applied, thanks!

[1/1] ci: detect Windows installer build failures
      commit: 84b4423497a9953ea78be771ae004620610b8179

Best regards,
-- 
Jens Axboe


