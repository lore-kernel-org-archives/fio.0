Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ACF7C433F5
	for <fio@archiver.kernel.org>; Mon, 10 Jan 2022 16:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237236AbiAJQWf (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 10 Jan 2022 11:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237222AbiAJQWf (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 10 Jan 2022 11:22:35 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39013C06173F
        for <fio@vger.kernel.org>; Mon, 10 Jan 2022 08:22:35 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id y70so18297562iof.2
        for <fio@vger.kernel.org>; Mon, 10 Jan 2022 08:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=F6Mxd3iNA+DRMxLi1b1yRi8E7ZLnYew+GXTWz4ZlL/Y=;
        b=zEb0PCp7f8Wiw5ThFIDJcRDjsgnDBqU4VYm8eO5DgXbjdPn40eCunV0v+h7siBmQ7A
         V3R5kt/c8vlnbM7a8G8b5/+8dotvbjlAaWxvi+xMJ5NwfAktEn9Cgh8N2qclcoEHokw5
         K2tx3y329vvqm9u3n3gGo8Rasg0hML/KIPzX3HPdtpWgLwX2cUHfpsXGuv0X2zKrU5tz
         AvQdJV/KCiWCRJ0V7n4lWHIOr9AtNRhng1sU+FnTaT6Pd0NPKjhAwDe5Z5tsgjR8QO8c
         6PW+Q6Gj3bFw3CdnKMxzDXADCQBNiTHqX4PMNF3euhKG1GWIdasrBZMT2DqzZuWaHfS4
         wW+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=F6Mxd3iNA+DRMxLi1b1yRi8E7ZLnYew+GXTWz4ZlL/Y=;
        b=u2m45lrGNEKFAU41ehWzkJceNXFtPQpXf1OumjrYnMyRSTxf/Gy3vehOMwa3iI/H0w
         oMmfrJr1tcEB0nl/+2dsyJ32OiYIKSah2+dDL9DSyXKXEErl9JZjPfp4kzpLJCsL8sVG
         5tNyg6SGfrxx1Sz03Gppl4swL79Ha1hkAVgDmy0b1A01F/U4gw216aoqQPjOQfEdC8pi
         5gSTRpBH7uMWGI/o4RVmGZax02Qq34Is/GpTBDV7zptle6iQcsWepcx1J99xqP7czhnl
         DKnxMIEP40BbtdxKrycmxDguJaW8F6fINbAMaGoPbIG3qnyXFLgqjIKROsc9u+B0ybOR
         QwEA==
X-Gm-Message-State: AOAM532g8T4BYb9ag5lNJZztzXLYdbWEq4Yk2zl20iOpn6cPgF8iI+E+
        NEVtp6pm/Xd/V7MsTWuH6gG5wQ==
X-Google-Smtp-Source: ABdhPJyJoMF6kyNvpijULIC6X4cLmqW/jqInLOw/gnzs02+4GVBsqQk0lsY15d/P7wpyOwtBkCkPUw==
X-Received: by 2002:a6b:e508:: with SMTP id y8mr103716ioc.177.1641831754519;
        Mon, 10 Jan 2022 08:22:34 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id j2sm4303172ilr.71.2022.01.10.08.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 08:22:34 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        fio@vger.kernel.org
In-Reply-To: <20220110090133.69955-1-Niklas.Cassel@wdc.com>
References: <20220110090133.69955-1-Niklas.Cassel@wdc.com>
Subject: Re: [PATCH v3] stat: remove unnecessary bool parameter to sum_thread_stats()
Message-Id: <164183175404.18253.4958206462679209031.b4-ty@kernel.dk>
Date:   Mon, 10 Jan 2022 09:22:34 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Mon, 10 Jan 2022 09:01:39 +0000, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> We can deduce if it is the first struct io_stat src being added to the
> struct io_stat dst by checking if the current amount of samples in dst
> is zero.
> 
> Therefore, remove the bool parameter "first" to sum_stat().
> Since sum_stat() was the only user of the bool parameter "first" to
> the sum_thread_stats() function, we can remove it from sum_thread_stats()
> as well.
> 
> [...]

Applied, thanks!

[1/1] stat: remove unnecessary bool parameter to sum_thread_stats()
      commit: 016869bebe9bef7cae5a7f9dc0762162b0612226

Best regards,
-- 
Jens Axboe


