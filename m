Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3039EC433F5
	for <fio@archiver.kernel.org>; Thu, 25 Nov 2021 16:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241928AbhKYQTV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 25 Nov 2021 11:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243854AbhKYQRV (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Nov 2021 11:17:21 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F01C0619E9
        for <fio@vger.kernel.org>; Thu, 25 Nov 2021 08:03:20 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id l8so6313153ilv.3
        for <fio@vger.kernel.org>; Thu, 25 Nov 2021 08:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=qBoGKktr+uUQDHvgpa7INqCnHIR5qH7xaWZeuQoTs3Q=;
        b=bkuo97HmlfFDA0Q2cBqoYUo1S4Own2SoG7eF5aXmkqHd8Sl5fvXXkZila6oVPaWgdj
         u+nRSNQXRdslEKGO+k67+MKXjnogVnSwbS73+1rzwpvpg602m8p/Mgva9Wzi9RVe0hIR
         ZpfW97bH3o6CKnaSuylnOPcVKVk8Bj6heUboc1g9Uesv/ARs+52BiXi4LnOvTV38LUmO
         T70aRn22Ae/fU6p+0rEDVMdT4MWTooL+naX1rXfaJvR64AzXytBUlGQO675fFmmQa4RE
         92/3GC6cccHTeoJ9kmNB6V3x6iA0nPeFLvGMLLP/N1O5qksOJNyUptJMGKG16peTnh/n
         6VLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=qBoGKktr+uUQDHvgpa7INqCnHIR5qH7xaWZeuQoTs3Q=;
        b=iRQmo+d6QMXJIR8pZArH3iR0wef9XIcCF1gcfd6itDTtIcpmb+glYZyUhXoPSUEJcM
         qCM+klF+e4dMK5uD/ODtAQJdP5BUEQKL3psaQfF3UyE5p1OPxj1JybJx5oVMlZ6kKWf9
         usSA1UdQauNOPztDmjvrLLIDrx2WLuEF980QwXsw3qEm5WhPM4KQD7qmaNr9RsF49LFA
         LnvLZTzCsT4GVjf5fGoj03qKmFtBtTqXw9nJfdi4mhhsen+WA/qcYwMzSAOPTpNxt9B0
         A0M1K5h1VjuJ1P2bXw/oZwY3rRUdR+akNytcWpXB3aENZR+EVomGBSGgbNas0lmtS8mS
         1dsA==
X-Gm-Message-State: AOAM531hFPpRmm1LZrjq1V6HGltFNbeNMbP9VuHaoVKWcgG6N10Vt7J1
        dpr2ymwg51sJyn8wFhdaWfpMkw==
X-Google-Smtp-Source: ABdhPJxs2VEED39j5ji2Pt2wCSdCAyO6aj5y886J4GZH8X6G1XIEfKnI7+vh117nlm5jXk5jeyp9Kg==
X-Received: by 2002:a92:d106:: with SMTP id a6mr25205775ilb.234.1637856200216;
        Thu, 25 Nov 2021 08:03:20 -0800 (PST)
Received: from [127.0.1.1] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id s3sm542950ilv.69.2021.11.25.08.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 08:03:19 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     fio@vger.kernel.org, damien.lemoal@opensource.wdc.com
In-Reply-To: <20211125132020.109955-1-Niklas.Cassel@wdc.com>
References: <20211125132020.109955-1-Niklas.Cassel@wdc.com>
Subject: Re: [PATCH v3 0/6] cleanup clat prio stat handling
Message-Id: <163785619722.524307.10661115801657371681.b4-ty@kernel.dk>
Date:   Thu, 25 Nov 2021 09:03:17 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, 25 Nov 2021 13:20:29 +0000, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Hello Jens,
> 
> Please consider this minor series which adds missing information about the
> existing behavior of the per priority stats.
> It also cleans up the per priority stat code, no functional changes,
> so that it is easier to follow.
> 
> [...]

Applied, thanks!

[1/6] docs: document quirky implementation of per priority stats reporting
      (no commit info)
[2/6] stat: add comments describing the quirky behavior of clat prio samples
      (no commit info)
[3/6] stat: rename add_lat_percentile_sample()
      (no commit info)
[4/6] stat: rename add_lat_percentile_sample_noprio()
      (no commit info)
[5/6] stat: simplify add_lat_percentile_prio_sample()
      (no commit info)
[6/6] stat: make add lat percentile functions inline
      (no commit info)

Best regards,
-- 
Jens Axboe


