Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F069C433F5
	for <fio@archiver.kernel.org>; Fri,  8 Apr 2022 18:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiDHSfK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 8 Apr 2022 14:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238435AbiDHSfI (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 8 Apr 2022 14:35:08 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405E9EDF0A
        for <fio@vger.kernel.org>; Fri,  8 Apr 2022 11:33:03 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id d3so7035549ilr.10
        for <fio@vger.kernel.org>; Fri, 08 Apr 2022 11:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=K9eUqfCmRwTPSPs4ICv/5uYxf61cAo6MFH676tsXfmI=;
        b=RL5t4aKLdMuGu/xoXH2uDxYmbVEId9ToVhjNWQSCIfEKONOzbhUM7Zo4AtZNnu9zcV
         16c5B7GCpGP0V7jzkVCmqlC553/ZpXT7FNwKCM/2G7RdrDM3a1rWWwlGZ51TdQheVpj9
         LhP5UPwASKCz8FClNYxKMgwYZVhz1K5Un37f9Oxe1ccguLfqqvEbbnr1YlvS6Bo7E/yh
         rfoDLOM3vWYStIM6r3itD0YMZ8+GMcrt3olRakyxM1hNsL1Md1i6lK3ORghn6/C5YeMI
         C4sJDFj1SQ+i6loP7elWVpLXmIHoRlBqyTdTlW3yMwHquOOmKo8yq9H37MFWISMz14uI
         6j6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=K9eUqfCmRwTPSPs4ICv/5uYxf61cAo6MFH676tsXfmI=;
        b=h6UFpHDoEuuE86VWjJTi8gM7ZBNX4pN7Y2zRoxJaoldeBAUAL3sIIEhLde6WCd7nUB
         WuO7OFl0xdGim9WgIQK3wwxY8ngcC9lYI4P4Y+azHjPhOMC+bnCmVkzVPYAZ5AXDpaiS
         J2XJBfGEDnNuLeVhTVtmUsAwfDWT/p1fYRKz+jUpcmknMSajQPhdRYbaxn+NFeLzR6ro
         Z+evxd47TB1ZLgunJHgip7IPq7+s3JGxRvjjIK87xscSx6Hi1cwsxI5LUoEd9kj7/3zl
         TmEQn1iF7IgfIQLbmtEoY1oOUeE4CzP+VzItzsB9BHDsSgKHs8aMk2J3SoItXWmIjrng
         Nrvw==
X-Gm-Message-State: AOAM532FG0wvdpOZid2QSxZhBZCUvar+E7iHXne45iFJszDSyPSk8BqZ
        8IJZ3xI6Xv5UtRhpWLKmIxYGvjBxC3pW4w==
X-Google-Smtp-Source: ABdhPJxEcAJfjnTqN5pg28BgpZ+j8a2UgAyDTP6r9VLbGfZ6HjK1/ZxGNeV4P+tF3+laFC+IoLL7RQ==
X-Received: by 2002:a05:6e02:1d03:b0:2c7:e33f:2557 with SMTP id i3-20020a056e021d0300b002c7e33f2557mr9824775ila.15.1649442779951;
        Fri, 08 Apr 2022 11:32:59 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f20-20020a6be814000000b00649d9a4db2asm15454085ioh.27.2022.04.08.11.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 11:32:59 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     mogeb@fb.com, fio@vger.kernel.org
In-Reply-To: <20220407174031.599117-1-mogeb@fb.com>
References: <20220407174031.599117-1-mogeb@fb.com>
Subject: Re: [PATCH v3 0/3] iolog: add version 3 with timestamp support
Message-Id: <164944277899.290267.16179004402932554676.b4-ty@kernel.dk>
Date:   Fri, 08 Apr 2022 12:32:58 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, 7 Apr 2022 10:40:28 -0700, Mohamad Gebai wrote:
> This set of patches introduces version 3 of the iolog replay. This
> version adds support for timestamps on both iolog_read and iolog_write.
> The 'wait' action is no longer supported with version 3, as the same
> behavior can be achieved with timestamps, and it keeps the iolog file
> easier to follow. This could also allow to potentially deprecate the
> 'wait' action eventually.
> 
> [...]

Applied, thanks!

[1/3] iolog: add version 3 to support timestamp-based replay
      commit: 315bbf01119ea783554d274add04db98c0a3b433
[2/3] iolog: add iolog_write for version 3
      commit: e8cf24e570e0bda05dd8f9c390911ebc280956ea
[3/3] iolog: update man page for version 3
      commit: 5c2c0db4c5d9911f381546ae7d0d07d15b3ccc64

Best regards,
-- 
Jens Axboe


