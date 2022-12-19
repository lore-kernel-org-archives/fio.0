Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DCCFC4332F
	for <fio@archiver.kernel.org>; Mon, 19 Dec 2022 17:00:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbiLSRAR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 19 Dec 2022 12:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbiLSRAM (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 19 Dec 2022 12:00:12 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1770912D21
        for <fio@vger.kernel.org>; Mon, 19 Dec 2022 09:00:11 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id o8so5041445ilo.1
        for <fio@vger.kernel.org>; Mon, 19 Dec 2022 09:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TZ+TCW7IeKpcEYJ0Src/t8CxKKXJqzf0vPcAqcBSYls=;
        b=6p1tV2vnpdcAIGIDLGDFV5ZG7V1JwYMPojEgxuJPlWWd9mqGwVHeWSSrZW3aHPBnCs
         OUM59LRWWztg0bSrP5T8FQj9mUovgZ+zswj1+hKoGxj31BTLCaWsx+XIe+4BY26Ho7Bz
         +UZ2L5GXr7xOk7AsrYOGgfZwIietUyswHemCRkVIw5kFbyy+AZTgc+Z2RJ7ErJqP6VW8
         bpxSU3jQrRwP4xbLYk9596T7UKg7seCuMX9yOibTB9YzAh/0o2463V9KL2bOv1AgKx92
         szNc6n6DYG6moM78lX54MgP0RrOOJAyqrU9+nwZNIXgHaP8UsKUGr9RrIFIxuAOym5Jf
         Pbqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TZ+TCW7IeKpcEYJ0Src/t8CxKKXJqzf0vPcAqcBSYls=;
        b=Tjg7P+k/2D58bsuh81Ab6TfkoBjwyLQ72eFkLCKwS0u1FAx+RazevIih7V2h+u6N2i
         Ew8/mwYOsazJDf2mCQC8iZ7xEvUvWUkazcp8EZ66gRlm1sif+ru9E8P7qQUmSA9FETUd
         yCNtfVEOVBZ8kHEStn4qn7/nwRPIlSMYVCJ5ehBtYyaR81ihxBgKcOLIEo53ReLLlqpu
         FRYu8BLHAPS0r8AJDVKJA7bizc58wT3QeQyxGt8IQsodn7xELYnyThhvX2jrcthPZ0VT
         Hb1oahtypurHy8Lx1UpPfvpyojjHAPFxgxEheq8iPWNKCz8x6iYEdTb5PDg9MH/h0W+d
         RMNg==
X-Gm-Message-State: ANoB5pmj8/uHojvq2gYPHdo66jH20w57q4yEeT712qpfvaSIbdxgolue
        rwxFk6zF5rxXf27XcInSRPkfxQXOlHlEg8Zb68M=
X-Google-Smtp-Source: AA0mqf77NWm8Cs4GsgUR4T5B0uQhHGWcjbGsmr0uj8C8LT37IzbO7Gne6Oeom/iYPqsrF1HFdnnZiQ==
X-Received: by 2002:a05:6e02:1072:b0:303:66a5:c50 with SMTP id q18-20020a056e02107200b0030366a50c50mr5893935ilj.2.1671469210314;
        Mon, 19 Dec 2022 09:00:10 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b15-20020a92dccf000000b00302aa2a202dsm3454217ilr.64.2022.12.19.09.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 09:00:09 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
In-Reply-To: <20221215015606.2767187-1-shinichiro.kawasaki@wdc.com>
References: <20221215015606.2767187-1-shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH 0/4] clarify usage of options for zonemode=zbd
Message-Id: <167146920922.37776.9521597265497168547.b4-ty@kernel.dk>
Date:   Mon, 19 Dec 2022 10:00:09 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.11.0-dev-50ba3
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


On Thu, 15 Dec 2022 10:56:02 +0900, Shin'ichiro Kawasaki wrote:
> Options for zonemode=zbd have some confusions. Clarify their usage by improving
> HOWTO/man descriptions and example scripts. The first patch fixes a minor issue
> found during man page update. The second patch improves the descriptions about
> max_open_zones and job_max_open_zones. The third and forth patches show how to
> use zone_reset_threshold, zone_reset_frequency, trim workload and 'z' postfix of
> size option.
> 
> [...]

Applied, thanks!

[1/4] man: fix troff warning
      commit: a0274f429672c10bb113e8d9214369143f71af1a
[2/4] HOWTO/man: improve descriptions of max open zones options
      commit: 1c97d909f748d12de73245d4464b47bf56a5726b
[3/4] example: add a zoned block device write example with GC by zone resets
      commit: f65f4f2d6dbdc9785fefdc5789e5b1ba4fa09dce
[4/4] example: add a zoned block device write example with GC by trim workload
      commit: a5000c864aa8e7b5525f51fa6fecec75c518b013

Best regards,
-- 
Jens Axboe


