Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3111C433EF
	for <fio@archiver.kernel.org>; Mon, 17 Jan 2022 23:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235277AbiAQXVq (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 17 Jan 2022 18:21:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234551AbiAQXVq (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 17 Jan 2022 18:21:46 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5A0C061574
        for <fio@vger.kernel.org>; Mon, 17 Jan 2022 15:21:46 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id f24so17526819ioc.0
        for <fio@vger.kernel.org>; Mon, 17 Jan 2022 15:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=RPAZKid5wzn4VqIRXd+tYZcyGRQuAj/WAO3m5RVkvjg=;
        b=xOkq/GkrchyW7vC5wbf8W4WkHPHLTL/n+9M6IHTcB/dWqaQzIxB2JwXZBNfETupPYJ
         qypWJCTeGzWwQZ3UCs8sN2CW/cTNtDYNv4R421K3RdER10l/F/LWWAm96pnXn1ynL7u7
         6ewWMJj7Rf1XxDAZToI4L07AecP3PHyXXyNLtEbSL3SEfjqtiQmOOVrYRJ92xHDkpuST
         ml0LH1wHjPtM4eTX9eA/cTHhbms2ugbawYhWqLnWewLYcjcXjO0n1pXApVmAQU1GzZK2
         eLOH2AZy2pU1jfgz9/4SxIIdLmsJgUvkuavAvQvis0UP35VhDu6XmqbERuVPwKwUVVuJ
         lebA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=RPAZKid5wzn4VqIRXd+tYZcyGRQuAj/WAO3m5RVkvjg=;
        b=R+bO9gvVK9iQTvjIllwUk/Rer1i0nlYaVss3VYqcatjrHbwWu6McOoDB7t2UzRNZos
         q15gVCrZrZE6kfX/dmAzSZMUERvsC7kJl4ruYgcCa8YVtCSav4xEZ7weY3DvE7H5GWzz
         i+wiDHbGFECwuH8JukefUp/Vcxl8OsuB+C9T+rrKgEgGEl3iFW5A3W/nr1lOY2K7Rc0d
         OesBGMcHTnhsJNLA28PloCUuYfx6R1Hj4tdD0ozlIac5sZNYl1yfOrCz0G+MepklWhFv
         dexUPL782vYH88KlzaHyEKVqY++bGmwjP0eAcAqOxZadTOQYms8labl8kMFocnCqtobf
         aI9Q==
X-Gm-Message-State: AOAM533/X5dHd70dxZCK+eyBMD3H4hxuClCpuvrKTg6yyoD8AcCCj3OI
        p3ZbtzCqFNpYLoUsq0h8n2xIG/uDZTyT7Q==
X-Google-Smtp-Source: ABdhPJyWXc0Ilo7pzSzaACYvsjNb8Yiu6yC86jpwPlv/1CPgJ+OZWI0KsLSklQruXFAeaVxXw6CQZQ==
X-Received: by 2002:a5d:9d96:: with SMTP id ay22mr6543687iob.130.1642461705847;
        Mon, 17 Jan 2022 15:21:45 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id c3sm11817774iow.28.2022.01.17.15.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 15:21:45 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     damien.lemoal@opensource.wdc.com, fio@vger.kernel.org
In-Reply-To: <20220117155045.311453-1-Niklas.Cassel@wdc.com>
References: <20220117155045.311453-1-Niklas.Cassel@wdc.com>
Subject: Re: [PATCH v3 0/2] cleanup mixed stat functions
Message-Id: <164246170529.353841.4149720922233727100.b4-ty@kernel.dk>
Date:   Mon, 17 Jan 2022 16:21:45 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Mon, 17 Jan 2022 15:50:52 +0000, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> The mixed stat functions are called in case option
> unified_rw_reporting=both was used.
> 
> Patch 1/2 simplifies show_mixed_ddir_status().
> Patch 2/2 moves common code from the mixed stat functions
> to a new helper.
> 
> [...]

Applied, thanks!

[1/2] stat: remove duplicated code in show_mixed_ddir_status()
      commit: 53d966f8177e0ada3bf52930f75f7b30817ea8c2
[2/2] stat: move unified=both mixed allocation and calculation to new helper
      commit: b182f07738d39f7969c3376375131dd2d3d7016a

Best regards,
-- 
Jens Axboe


