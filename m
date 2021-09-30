Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0F84C433F5
	for <fio@archiver.kernel.org>; Thu, 30 Sep 2021 16:05:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFF5B61269
	for <fio@archiver.kernel.org>; Thu, 30 Sep 2021 16:05:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348186AbhI3QHX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 30 Sep 2021 12:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348211AbhI3QHX (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 30 Sep 2021 12:07:23 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D698C06176E
        for <fio@vger.kernel.org>; Thu, 30 Sep 2021 09:05:40 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id x2so7475505ilm.2
        for <fio@vger.kernel.org>; Thu, 30 Sep 2021 09:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OcvNfeoGyWbdVSILo5UItcYYmZCqjZUhEWweIaKfK1M=;
        b=gXQLZYc3bAoec4XXbh04g8HNLFS3EHNXQoz983XPttXYySazOaFXxlhEg+hlvYu5iR
         C8aKnlloQyyig10Q7QVM/JdC+k9pb/5ww6+RiOEUbInFAtu/lo1rvwZBPPMClc2PytSY
         kWzceIsfVEiCLT8+v/MvEzBCrjliA0LuwDPsFOLznURiq10+KqWwgkWrHRGdHqvx5unY
         oSbG/5gnaM+R10juj4/ffkVOZz0sbLcHoVWd0C6duFEusZvStjZsNmK940o2v31ZagVt
         LYWZixmB7eTPtuHb1QvxkAEp6cWXHLSjB/F1sN7T5ssUk02Bmi9zlTquujpF8CUvRzMO
         sU9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OcvNfeoGyWbdVSILo5UItcYYmZCqjZUhEWweIaKfK1M=;
        b=lHPHCRl1Act3CZOW0pPiJZsXNrbVV/niAmVxQOi6yV3XMvaZDhaUk5hzJYFcTs3bMw
         kxQ5CaidJlW1VOGfrnihwdLVjXkMsfmR+tjpdV3rsDtbFrK7AGuoG2ZV9pQTspA6pcYj
         nJMcRycVFTz16j+kx0vsoUJAwlomZ14uuOZ5q0mFqEKL4gPUvPWXxnTL38QqZ/dorObT
         Obbl9A5oabpY6fRNzYDVu44TAaAzHSXDjaTcTSKW/1fcHZ29Zzozxjfo2+xzhiZxNs/j
         DDNtUXGIFoV73AlkYz8sk/qAHcty2C9EHX1qSOkyzG4Y8HnHhQuHC+17w9Kcp9erqW7h
         UNhQ==
X-Gm-Message-State: AOAM530M+KsXvSvsgLz8Kbf8FqML9q57QqFs0zZRLr7OpXkI/o+ZePh/
        tcQNk31CMkUz2TYRfDP/NBjlgg==
X-Google-Smtp-Source: ABdhPJzAW9uxaiFb0txNqlXeQv2zzrVo1T6YroXLIDYFAZktMvrjCaT66RB75uGL2lJxcsNAsKnqgg==
X-Received: by 2002:a05:6e02:19cc:: with SMTP id r12mr4989405ill.256.1633017939850;
        Thu, 30 Sep 2021 09:05:39 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a4sm55933ild.52.2021.09.30.09.05.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 09:05:39 -0700 (PDT)
Subject: Re: [PATCH] zbd: Fix unexpected job termination by open zone search
 failure
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        fio@vger.kernel.org
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20210930000236.4116945-1-shinichiro.kawasaki@wdc.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ce005012-79fa-87b7-5ace-6303b12b1023@kernel.dk>
Date:   Thu, 30 Sep 2021 10:05:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210930000236.4116945-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 9/29/21 6:02 PM, Shin'ichiro Kawasaki wrote:
> Test case #46 in t/zbd/test-zbd-support fails when it is repeated
> hundreds of times on null_blk zoned devices. The test case uses libaio
> IO engine to run 8 random write jobs on 4 sequential write required
> zones. When all of the 4 zones get almost full but still open for
> in-flight writes, the helper function zbd_convert_to_open_zone() fails
> to get an opened zone for next write. This results in unexpected job
> termination.
> 
> To avoid the unexpected job termination, retry the steps in
> zbd_convert_to_open_zone(). Before retry, call io_u_quiesce() to ensure
> that the in-flight writes get completed.
> 
> To prevent infinite loop by the retry, retry only when any IOs are
> in-flight or in-flight IOs get completed. To check in-flight IO count of
> all jobs, add a new helper function any_io_in_flight().

Applied, thanks.

-- 
Jens Axboe

