Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E0E2C433EF
	for <fio@archiver.kernel.org>; Fri,  1 Oct 2021 17:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44AF661507
	for <fio@archiver.kernel.org>; Fri,  1 Oct 2021 17:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354760AbhJARTM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 1 Oct 2021 13:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbhJARTM (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 1 Oct 2021 13:19:12 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002E3C061775
        for <fio@vger.kernel.org>; Fri,  1 Oct 2021 10:17:27 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id r9so11296159ile.5
        for <fio@vger.kernel.org>; Fri, 01 Oct 2021 10:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LBG9kSItobjD4FXmySD9YdllX6mBwXflv0rRol5HXDE=;
        b=XnDlw/u/fcpwarVhzgCT+PpIgLgNoJA+hl/2prTfTS3UgpzoZCK2GhsRUfK6eYKP6W
         8nfQQ5d3J668y2D6pRWrPtgxOtHgpoivH2vuPXtfs4nRz5RfS1xo80ZMI/HDR0JEwEaG
         QlNikMetIKdtU8Gd3+O9aXGgDpL3ScbJWF1xQTPhDMRiWiG+q8D7xbLUWLbu7wwQGC6u
         zCoDurQ3Xp0AglCqgWypGXc7/L4mvgfxblP3lun2t5UyHR4La9o2CXaqA5Nh+dS1xxDQ
         LC1vhv1WNHHJKyCEMg8qjdhTSDbAKdmgszowExvq6DfLKpoko43jzuVH5WlRosRAhy9u
         oxkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LBG9kSItobjD4FXmySD9YdllX6mBwXflv0rRol5HXDE=;
        b=B1rUOm2thlpI3DK+/1zmEFstLOrQMMXs1RIpveVMhe1H343fG56tTA/VKWXJ1QOd1M
         DRtbdA6FLZD9NkyAAL8NGECHVxbJTd3CnozAb2Grd1LyAJc8pLQVbLKPc/Es3TdpP/fH
         IqoyEkhfmzQV+T2aGohUdBQGHrit8ocDn2kWldaDC1bZurk03SmQDGSqlTMf0WGoJhDV
         ytV8o5ppf0NtMXGkU98WqfyZohrzC68AMlJpL/llUkMPqJELPrLjjFgFR1Ud/T344uH1
         XdvfGadHAd9dGpYh9Fg/FBDyJR4MfooTh4me0UyWLZUCVKP/4RnVoE5hFtkUnmmti7wf
         UrTA==
X-Gm-Message-State: AOAM532cHz+94NEB44IFZwbNhF9VJO09ObGJl1HHpmg/K8Q5RGF2u/Hi
        VfSMxGfilthd3S1ik89wPLUJfRMKamwMA9tD8M0=
X-Google-Smtp-Source: ABdhPJypnwscsb2nRVUJ6LMxG6CougtsR/TE93R44+1V3cnprjr7geWPfTcBuRW6Sq2S9XT4p2d+wQ==
X-Received: by 2002:a05:6e02:c02:: with SMTP id d2mr9663962ile.152.1633108647429;
        Fri, 01 Oct 2021 10:17:27 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k14sm3789298ili.35.2021.10.01.10.17.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 10:17:27 -0700 (PDT)
Subject: Re: [PATCH 0/2] Fix job completion failure for sequential IOs with
 holes
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        fio@vger.kernel.org
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20211001103257.4130231-1-shinichiro.kawasaki@wdc.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bbb27437-ace2-f276-f68f-072e1d95d18d@kernel.dk>
Date:   Fri, 1 Oct 2021 11:17:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211001103257.4130231-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 10/1/21 4:32 AM, Shin'ichiro Kawasaki wrote:
> Commit 499cded5f435 ("Fix for loop count issue when do_verify=0 (#1093)")
> triggered the failure of test case #7 of t/run-fio-tests.py. The test case
> runs sequential read workload with holes and checks amount of read data. The
> commit affected job completion condition, and resulted in unexpected larger
> read data and the test case failure.
> 
> This series has two patches to address the issue. The first patch reverts the
> commit, and the second patch proposes different fix for the loop count issue
> with do_verify=0 option. I used the workload recorded in github issue #1093 to
> confirm this second patch fixes the loop count issue.

Good catch - applied, thanks.

-- 
Jens Axboe

