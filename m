Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1E4C433EF
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 04:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232002AbhLJEiU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Dec 2021 23:38:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbhLJEiU (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Dec 2021 23:38:20 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A4A1C061746
        for <fio@vger.kernel.org>; Thu,  9 Dec 2021 20:34:46 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id q16so6990590pgq.10
        for <fio@vger.kernel.org>; Thu, 09 Dec 2021 20:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=JB8UDnX42sJCheEbcEK+UEEOqWV8w58HPANEf+rA3lA=;
        b=Dn7VRtQdcpOwgdSxure9RZfoIBjmM3qqhJ+gfw3aNUmd/eKGWQSx3B5Lo1HIXAnZp2
         SyAPgaAvhWdeA4xu296slAJ6Qu/HiQ160y39yZfSSp3mQSg9+z7CBjHy01pXqihhoHR+
         P5RGkVG5R8/rhmMq/sC1JaoVZliGOPig6Hg2S3F6sYSuwPRsMj4jZdjJOWhFzS8DhrEv
         vINSn7L6EjFDoG1XVRLzvvdjvj3ZD/1mVJ5K2FVLTYRvuWiF/FHYFzaFil6kMQZb1T/v
         ne0CFqLvQmEkRkfq8t13v9j18w7qpe4ZH0PG+HbnDRYvJ/22pLFC8WMc2jJxLW1sLAvT
         MsOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=JB8UDnX42sJCheEbcEK+UEEOqWV8w58HPANEf+rA3lA=;
        b=Z0qzDGfke3WE5N32o+MS9Bj+Z8y9IXyoBkmRqJHEobQ4hExVbC+gDBrV9Y03dsapgY
         aFc9gjoQfANq6eiyM2oJNpjSn/I6UtIly2EAcxjo5PJTPfegP3kRTEsoFqyrv5wOd7cn
         TYJiuaJCguak39FmP/7VZ5Egi/2agx/ByeBznP6oPVjybk6zN3gemJI/3yHgm7M1W12z
         9CNS2OsOBBftw85bmLjnaYVeC+wVQW/aeX3r8uFztGmNKJrzExIxSutveBegk1kPFYJS
         qE3gMZF25M4xEwFicp/LYNAGRSyWE4dtIcfW0PUS+MOrTfeNqcq/q1FxwC7ncWf4zQg4
         0XeA==
X-Gm-Message-State: AOAM533oneDuoD9OZ2YSMZkkFYasaAK7+IsvUFB7OJqBm1dafMHFQVUa
        Y3cSImuYZd5KQKtuBVztuZ3bDw==
X-Google-Smtp-Source: ABdhPJwVkRc9FL42B4kUNkwF6BWkB0qPGy5BYuiyYVQAwHnHEl2pAsF2oZjJwPCL9Izr0HOSbj4PWw==
X-Received: by 2002:a65:654a:: with SMTP id a10mr38874712pgw.22.1639110885287;
        Thu, 09 Dec 2021 20:34:45 -0800 (PST)
Received: from [172.20.4.26] ([66.185.175.30])
        by smtp.gmail.com with ESMTPSA id n22sm1282923pfu.2.2021.12.09.20.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 20:34:44 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        fio@vger.kernel.org
In-Reply-To: <20211210012041.310670-1-damien.lemoal@opensource.wdc.com>
References: <20211210012041.310670-1-damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH] ioengines: libzbc: disable libzbc block backend driver
Message-Id: <163911088329.491028.9793884023592423519.b4-ty@kernel.dk>
Date:   Thu, 09 Dec 2021 21:34:43 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, 10 Dec 2021 10:20:41 +0900, Damien Le Moal wrote:
> libzbc includes 3 different internal backend drivers:
> 1) The block backend: this backend relies on the kernel SMR support and
>    uses regular system calls.
> 2) The SCSI backend: this is a SG passthrough driver for SAS drives and
>    for SATA drives accessible through an SMR compliant SAT (SCSI-to-ATA
>    translation layer).
> 3) The ATA backend: this is a SG passthrough driver for SATA drives not
>    handled by the system SAT (either kernel or HBA SAT)
> 
> [...]

Applied, thanks!

[1/1] ioengines: libzbc: disable libzbc block backend driver
      commit: 79eb6c9a17de959d72ee51c601b2764225101282

Best regards,
-- 
Jens Axboe


