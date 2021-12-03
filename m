Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86C97C433EF
	for <fio@archiver.kernel.org>; Fri,  3 Dec 2021 00:54:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240525AbhLCA6H (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 2 Dec 2021 19:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232416AbhLCA6H (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 2 Dec 2021 19:58:07 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FA5C06174A
        for <fio@vger.kernel.org>; Thu,  2 Dec 2021 16:54:44 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id p23so1772259iod.7
        for <fio@vger.kernel.org>; Thu, 02 Dec 2021 16:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=1gIFXoSJRhv18AUC+7oAxOio9fJ/fg+OCYrzkoJ0ObU=;
        b=jumxTlDXoskSAehXn/xZSYcGCjDuAXAlDgliyCtY+lW982uHzovhAOBljlGbz/v6w8
         snjTtxts5L1zaU4a33wPcdb7RbDpODeCnJ4Pemh7BxoJp79NH/Qd8V+Cgw85VeHVz/gX
         99iWjIoDxJ30SKqmXHA3kZddzCKtkJRyP1YeX+9nZfcFcMBR7eKiLj8H+KAu6Gxbhk7+
         W+Nq3nNRI2sOTaWx3W9VkAPFZqfff4jcNQjne2WJ+0lrXUXBINo2IRYN9FJLNZGM2oh9
         71JXlprPcLT8Z4xjIX2viXgdD/Q8KnP/Miq6DDsbNfhNtN0+gKVKgXIfKCnM3Z89OchI
         Cp1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=1gIFXoSJRhv18AUC+7oAxOio9fJ/fg+OCYrzkoJ0ObU=;
        b=5eg8OiI0jyJuPZUjuO2vJFlsjceUHBOFzu35tN/5bO0++4pQct8M5e19qis40ujcKQ
         g/56dc++UaCIN8omVm/8xo1jG1J0ThuQNmp/+hqrRUg8qIUJ3Pngb7wyQzfl4ke4uG0Z
         SiaqBG+lrYlVpmmUtphYoXZJK9Elc5m+NYiYNgCyKuFSq19fvlZr8QW7qgbtW6JKn72H
         O9pghT5HoqhbRkOEu2nw38VIX2SVyZBFZ//giG/wVcZ/wUUwZXPkU1n1Pvw9tkKF7ZuE
         SiJcgjDZsIJp64u70pm4Oxzp6jk8UixOcsAnUvxtfKkE2z4JrsMPQQbpoFlSGFPRfint
         i3RA==
X-Gm-Message-State: AOAM531awuTfYMcaqyEjZhReE8034pqDarK0TjJYJ4mu2XQl9Lk63sg8
        8vxO+YUa3q1dZanOaDQzlGodJw==
X-Google-Smtp-Source: ABdhPJxT0dLiJ9v0KaVe22RS7viCrGthuW4ejXp4Jv5ylYpg/juKUk8Hn34WB2GGAxw/JMSMveeaXQ==
X-Received: by 2002:a6b:7c46:: with SMTP id b6mr19070516ioq.129.1638492883865;
        Thu, 02 Dec 2021 16:54:43 -0800 (PST)
Received: from [127.0.1.1] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id f11sm1113982ila.17.2021.12.02.16.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 16:54:43 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Shane Moore <Shane.Moore@wdc.com>, fio@vger.kernel.org
In-Reply-To: <20211202094153.8381-1-Niklas.Cassel@wdc.com>
References: <20211202094153.8381-1-Niklas.Cassel@wdc.com>
Subject: Re: [PATCH] filesetup: create zbd_info before jumping to done label
Message-Id: <163849288314.212069.5601230448523327243.b4-ty@kernel.dk>
Date:   Thu, 02 Dec 2021 17:54:43 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, 2 Dec 2021 09:42:06 +0000, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> For a thread that has zonemode == ZONE_MODE_ZBD set, the zbd code requires
> that each file (for that thread) has a valid f->zbd_info pointer.
> 
> This intent was further clarified by commit 5ddf46d0b2df ("zbd: change some
> f->zbd_info conditionals to asserts").
> 
> [...]

Applied, thanks!

[1/1] filesetup: create zbd_info before jumping to done label
      commit: fd1d8e0ab3dc852193037a3acebcf8b8bdbcd9c5

Best regards,
-- 
Jens Axboe


