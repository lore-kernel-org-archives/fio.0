Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A517CC433EF
	for <fio@archiver.kernel.org>; Sat, 28 May 2022 02:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236288AbiE1Chj (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 27 May 2022 22:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiE1Chj (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 May 2022 22:37:39 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837465D5C0
        for <fio@vger.kernel.org>; Fri, 27 May 2022 19:37:38 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id j6so5783874pfe.13
        for <fio@vger.kernel.org>; Fri, 27 May 2022 19:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=iRUJwrLE57vN2lCvz/Dh69G4uwGlOMpR1FJtV9xrARU=;
        b=hZhMgcl1yOwsNFGptC9bTJAqWKmkn3GiT9JhYpN5iVajOYpIu+jWc9FhRjXmz0PBha
         nx699uG64HYFvf0qNnOjcwKVCbR/w0euz8j1Vv6bHC8nrhUN30zGZ3el1b5BMVQLKyMX
         kVe9uqSShI+eQOap6SdEytgZaYpNioE6a7NDEeH/wJg8ZU5HJ/AQelKMi76a4BzgFhd4
         hCzQphJbWp01ljamyoKx+RzTclrP6sPRkuevnt7nqp4u0GXx996+kJUMoS2fMK4+kx54
         CNuz79ykBBZB3BokroMRUG0TKlgR7qF3k7XsR7FGT/jeovkegpEbSeTGDpkhAfNUwZNn
         CZAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=iRUJwrLE57vN2lCvz/Dh69G4uwGlOMpR1FJtV9xrARU=;
        b=IUfeom6bpc0AuJZ/FpT7FJx6965TkGkyF6yi1FPLOH1tiFjWAT9233pJYlTGPxLiCi
         80ZvrjH/XaU4jotP+Vk6z1eI9U5NtKpqlk5O0Ej4od5PWzyTN5RvT/UTulqqNaluBkI/
         +m0yf905qprhG7esi9nlx6B36Y67i1zeIyM6Mx43CTq6sv9Us7KcMnclk4t//tE5GI6K
         vcfHCSc3LS7A4Mr4rBG02/IF9H2oOu348d5tMA0UbkXJu3Q+rWJrprZ8HwKJG7u2vK5i
         8vglnyNadGFaRpk1oAnk+QPrTNWOcUmA7M/kSeeoK6QQm9+5WG+3H38cXorQbB/XvtBG
         6xYg==
X-Gm-Message-State: AOAM530dI4yJhkYdcglv7joXpQdhPtuS5xPpJbVDPvnSYC0hZlnz4Vty
        q+AJRvuDTvIDGKv1dBwGqISuK/TgvkzSWw==
X-Google-Smtp-Source: ABdhPJz7pnjAOtDN8PuU8oMPMZhMpcaK6+P7usKmS7z8TXRTMv6gbu7dkM8MZBv1hbB1cyDqS6sqiA==
X-Received: by 2002:a63:c008:0:b0:3fb:793:73b7 with SMTP id h8-20020a63c008000000b003fb079373b7mr10263982pgg.266.1653705457827;
        Fri, 27 May 2022 19:37:37 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i16-20020a170902cf1000b00161929fb1adsm4382644plg.54.2022.05.27.19.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 19:37:37 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     fio@vger.kernel.org, vincent.fu@samsung.com
In-Reply-To: <20220524142229.135808-1-vincent.fu@samsung.com>
References: <CGME20220524142325uscas1p197b28727cdb38d34f866b97b0a1932e5@uscas1p1.samsung.com> <20220524142229.135808-1-vincent.fu@samsung.com>
Subject: Re: [PATCH v2 0/5] (now) five cleanups
Message-Id: <165370545696.603124.2341254653939345805.b4-ty@kernel.dk>
Date:   Fri, 27 May 2022 20:37:36 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, 24 May 2022 14:23:24 +0000, Vincent Fu wrote:
> Jens, please consider these five cleanup patches.
> 
> Changes from v1 (cleanups, parse /proc/meminfo for huge page size):
> - Drop patch that parses /proc/meminfo
> - Documentation patch about huge page sizes fixes default size
> 
> 
> [...]

Applied, thanks!

[1/5] steadystate: delete incorrect comment
      commit: b29472cbdbce66ad9905b58f04ac5ed9e9be0090
[2/5] configure: refer to zlib1g-dev package for zlib support
      commit: 95f791d3ad7d0cf3b024d51713d4861663ba8ce5
[3/5] HOWTO: add blank line for prettier formatting
      commit: a3a6f1058aa41db20794bee1df0bec4019c14d42
[4/5] t/run-fio-tests: improve json data decoding
      commit: db2637ec09786c5610006414f28c2b21a3c3c165
[5/5] docs: update discussion of huge page sizes
      commit: cb8dcafa69ef6fddd22d41c60083cb68bce92daa

Best regards,
-- 
Jens Axboe


