Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87FCDC433EF
	for <fio@archiver.kernel.org>; Thu,  7 Apr 2022 01:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiDGBot (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 6 Apr 2022 21:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238032AbiDGBoU (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 6 Apr 2022 21:44:20 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0C11F1A07
        for <fio@vger.kernel.org>; Wed,  6 Apr 2022 18:37:29 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q19so3690679pgm.6
        for <fio@vger.kernel.org>; Wed, 06 Apr 2022 18:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=2jJo82DzxagFDRmoGPd0axLF9upxwkpQzzT/A0IyeDc=;
        b=Y9+5O08yDerz+zgjt7iploTnUjNPfacRrzNudW8g1UejdjVE1hs9VtwhsLxprQFXcr
         2A7z9yttVrli3seklvP3eU90bhs69F38Dp/jyG2JE7Vd8UUNe7irNkzUL4Dg8pK8/nWz
         4hMKTw75kNH19r/xmllhNFVIPMROR2hXf9AicP6ROBCxH+J0doJ86nkyLWyFp+KYTimO
         ggJm/AFpRsl/XGIULZFu6R6JXxBGwAvyARxLVACMZFF1jehFk31TrMi5+2/vU9dCeVfu
         t0SF6ODW1dN6S0xt7ACznNvT5QSA/ttsM7As4OywXo944buKiyP3GmiEqthqG/4Wyr6I
         RHJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2jJo82DzxagFDRmoGPd0axLF9upxwkpQzzT/A0IyeDc=;
        b=goyKWD/tF14yPsdabB/mE/bYiVNarucsDAUnqqkEqw8q1wfLBVeoXJ69mqfJTmMSmv
         lmYnxtvFT9NgPtYxWahCaDbrj1p1lrs8FD2NFJa9oS2YRMHiNqZWqE8/k4WMWl4aWQGV
         vO41l0ss6hkD4oDnELcN9l1tuSTIeAc10tQEBGtfY40IUJ0/T5zdw7oQtZDYo14Ro3mH
         un+shw5NQmoHOH1/WkQQ32SmNc+FSCyuE4gZAKQxdMq7eRARtcwSXUi/p0UMH2Axxrgy
         iKvOZdRw5gjHdF32eqzvAH+PAK/SbuDLVHTuLD2B5/roWdeCpGM6WnhjDHn/PKNIanIl
         Ar9w==
X-Gm-Message-State: AOAM533PrhfxPl690yF/M0m98otGt7l9uK+FBm2UIz5i72SPp40hCA2V
        /Q1kbqlVcfMaIf2XWnvNLeolPg==
X-Google-Smtp-Source: ABdhPJwluUUzqIQc/lJZAUOOqxnkSMbLGkvyJ0WvDURIHKcNp5Bl5+P4D0SZ2GfXrkXblHpacryRPQ==
X-Received: by 2002:a63:6bca:0:b0:39c:c5e3:81dd with SMTP id g193-20020a636bca000000b0039cc5e381ddmr880066pgc.379.1649295448486;
        Wed, 06 Apr 2022 18:37:28 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p10-20020a056a0026ca00b004fb44e0cb17sm20796363pfw.116.2022.04.06.18.37.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 18:37:28 -0700 (PDT)
Message-ID: <2744cb88-e873-7b7b-d9ef-eb94d1c08d62@kernel.dk>
Date:   Wed, 6 Apr 2022 19:37:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 0/3] iolog: add version 3 with timestamp support
Content-Language: en-US
To:     Mohamad Gebai <mogeb@fb.com>, fio@vger.kernel.org
References: <20220406170530.2198263-1-mogeb@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220406170530.2198263-1-mogeb@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 4/6/22 11:05 AM, Mohamad Gebai wrote:
> This set of patches introduces version 3 of the iolog replay. This
> version adds support for timestamps on both iolog_read and iolog_write.
> The 'wait' action is no longer supported with version 3, as the same
> behavior can be achieved with timestamps, and it keeps the iolog file
> easier to follow. This could also allow to potentially deprecate the
> 'wait' action eventially.

Change looks good to me, but it would be nice with some actual commit
messages. #1 has one, but it's formatted pretty strange. 2 and 3 don't
have any. At the very least, there should be a basic description of
"why" the change is made in the commit message.

Can you send a v2 with proper commit messages, and #1 formatted that
isn't a strange list?

Thanks!

-- 
Jens Axboe

