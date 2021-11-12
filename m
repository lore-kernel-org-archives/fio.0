Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31692C433F5
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 15:50:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 095AA60C51
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 15:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbhKLPxp (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 12 Nov 2021 10:53:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbhKLPxo (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 12 Nov 2021 10:53:44 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D051C061766
        for <fio@vger.kernel.org>; Fri, 12 Nov 2021 07:50:54 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id i12so9353337ila.12
        for <fio@vger.kernel.org>; Fri, 12 Nov 2021 07:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=2EcfliJUX077acG85LFJlEkkwrgkPqKZMyhobDeyRlU=;
        b=lozzJi8iYwBzZ8itxUeYp4QgLXmmVHmvgr19NWp2D4n/iJsx5fNaU/jGbG8Ye/wvcL
         FlUUJ9sRM2XaGIjb9EQZtzrNHZTE18drqUTbRI2CxOkZB/4Pg4aF4598eKrJgDO2x3tg
         ix0QWFoh3E8N27hvlXWeJRQ9ggoPgWZUqrsufIQeZBCer9m9LTZMJuBI/CyMkhAop5cW
         aE2bAEHbcXcW7g/oT6fpq8xH+lt5qGU7WxVV0wawdqdWVffPaQO4DD6KS+47g9LjIxLg
         K2rH7F6u0sEvYHAjpANf356Cs+rvurMvQ252jyMMxJ0SkEeZaGqN4NqAWHVIIsmrbB7D
         FCbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=2EcfliJUX077acG85LFJlEkkwrgkPqKZMyhobDeyRlU=;
        b=bWxnpFkU8YoqZryNibPAvk/TyTpv711r9oabZmzCE/u99NROOHETWHNqYvUjbXPq/7
         yKt0GlCE/hgCuvdqthJrIp/jDbsXel7UAsXDH088WxTo8rzdydkX6PDsBykHvm9ftMYt
         WmopGQhJiZBLWWQmTKV5YSFn60AGZAANi7XDxM320BpIYx3LwQ6k+EIDZcD4aAUj+AeS
         9Lv4pDn1zM8N51sgLIRgEUnVt6/sHbyJYV2t/9sV+dfdg1SfvpicS7dc8N5On6unXPcO
         EQNQfkB0Bk5wPHXdwwmQFyg6AcwjTy/3JZGw4hXRgoluPFeFJ2Ljxr/FQCRLpgV3V8GM
         VBhg==
X-Gm-Message-State: AOAM5330Yp3JjrJITy9mBLm6byHRvFyvsNm/loj8P9YLY8RJbfutvVoO
        HcYI0Fr9MNZ+bB20dX3Jf3Iq76viAqZ7+Lo8
X-Google-Smtp-Source: ABdhPJzxc5b/FH2t25dzqVAsZDnZMZ5aKrio8+3ecJnha0FIQJht57cdnl1RSUCI6E2HYCuzerjivw==
X-Received: by 2002:a05:6e02:1025:: with SMTP id o5mr9710211ilj.133.1636732253474;
        Fri, 12 Nov 2021 07:50:53 -0800 (PST)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y6sm4573834ilu.38.2021.11.12.07.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 07:50:53 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     fio@vger.kernel.org, damien.lemoal@opensource.wdc.com
In-Reply-To: <20211112095428.158300-1-Niklas.Cassel@wdc.com>
References: <20211112095428.158300-1-Niklas.Cassel@wdc.com>
Subject: Re: [PATCH v3 0/8] cmdprio cleanup series
Message-Id: <163673225236.25539.17847129114114949931.b4-ty@kernel.dk>
Date:   Fri, 12 Nov 2021 08:50:52 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, 12 Nov 2021 09:54:38 +0000, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Hello Jens,
> 
> Here is a cleanup series that improves the cmdprio_percentage and
> cmdprio_bssplit options in libaio and io_uring ioengines.
> 
> [...]

Applied, thanks!

[1/8] docs: update cmdprio_percentage documentation
      commit: acf2e2d96645b9299a0cf2d54fcb99169359f688
[2/8] cmdprio: move cmdprio function definitions to a new cmdprio.c file
      commit: e27b9ff0e34922f7ec40f8a34472b03842aab795
[3/8] cmdprio: do not allocate memory for unused data direction
      commit: a5af2a8b73faa9f28e676f754280dd177ac01f07
[4/8] io_uring: set async IO priority to td->ioprio in fio_ioring_prep()
      commit: 8ff6b289751c0750b9dc2e3245c14db7461ef2a7
[5/8] libaio,io_uring: rename prio_prep() to include cmdprio in the name
      commit: ff00f247a6e764ec445aefc1ab6acf3c0817ca65
[6/8] libaio,io_uring: move common cmdprio_prep() code to cmdprio
      commit: 127715b61286b1b77cd2c3fe7efacc01d71222ea
[7/8] cmdprio: add mode to make the logic easier to reason about
      commit: 97f2d4840d5dedae0d4baa79c78784bd80d82a5d
[8/8] libaio,io_uring: make it possible to cleanup cmdprio malloced data
      commit: d6cbeab4b33194688f4e96fe3df1feaacdc08d2b

Best regards,
-- 
Jens Axboe


