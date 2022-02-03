Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55EB8C433EF
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 22:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355747AbiBCWbW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Feb 2022 17:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240214AbiBCWbW (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Feb 2022 17:31:22 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13590C061714
        for <fio@vger.kernel.org>; Thu,  3 Feb 2022 14:31:22 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id n32so3418013pfv.11
        for <fio@vger.kernel.org>; Thu, 03 Feb 2022 14:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=1O7xRQWLXEgl0TOaSPNT02RkY23Qk4oSxBKEwrEEsBM=;
        b=C8SWm/hqvL73E9DXE7UA1WLlkdccO2XTNxZYl/NY7fAtSjvdT+tDMwHFW6Vty/CIe7
         t3YO47MK/ifVMbf1Z4Kp/jEDu7RbqBc2fCxmV3VnjZvqVmVRjbOR63W5Va/4V/RQuMwF
         XWmkElHDS3jfsq96McTm9AAIe+NfjVhvk6IvhfD88R3f1dlYya2kSiUT8kChF9qUTiqK
         +THD3s/+GDG32eU9RKst9IKcmaT5T/Qkmck+eGel54+FVHUhTSbY3muvDuyIiidxv2VN
         JNgoxFWp/alCSex3Zqxt4dmE79IIGwMFrzyezA1ha/GrfPTyOlT6AIBGFrS3jtRUoKIN
         efVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=1O7xRQWLXEgl0TOaSPNT02RkY23Qk4oSxBKEwrEEsBM=;
        b=e+wkafUPK114svySTGSc+00SKNHEp7u4kSTQEBCprAiQp7IHD1WkFwIN9WKMnzU9dV
         +JESlgNRfZw7svAb3ACU5LJP/0KsuYSOSQUieK0mZosRxBKV9w/JXk0KleksoT4QCxep
         4Q7zIxwyhrOw1gQDPyvX1P6LjaOzzFksNVnDo7sO60E4lCHaOlbZ/psyhNdH8fzyP/GL
         qi+Bib64yHoLIz/b+LvTOF+5yREWiA0dK+/wkjWO7gu2uF7oMMdCULQOSgA1Nxtz6UDD
         kUaqaekqC2ZR2Wb0PzMtauakfW/zsFfB+9sCfAV2yoh0EdElmZ5VKJfZOKPgnAQnpkND
         P3Tg==
X-Gm-Message-State: AOAM530fDLGjKImc/A8bfHVanZBULhDvJvbEnb+dcGnuW7oWu1JNC3L4
        pgaX3rT4lmUFanLH1SZu8gTNhi3jqUPtDDXM
X-Google-Smtp-Source: ABdhPJyReUT0UtJH2aBsYUgvW3ChEuJNXqM4l95lQjJ3LVyIIhjaLpPD5jl/0Svadv5YN3oHkMgk3Q==
X-Received: by 2002:a05:6a00:a1e:: with SMTP id p30mr224953pfh.66.1643927481530;
        Thu, 03 Feb 2022 14:31:21 -0800 (PST)
Received: from [172.20.10.2] ([2600:380:7677:2608:7e4f:2c76:b02e:3fbc])
        by smtp.gmail.com with ESMTPSA id mw14sm13857pjb.6.2022.02.03.14.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 14:31:21 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     fio@vger.kernel.org, damien.lemoal@opensource.wdc.com
In-Reply-To: <20220203192814.18552-1-Niklas.Cassel@wdc.com>
References: <20220203192814.18552-1-Niklas.Cassel@wdc.com>
Subject: Re: [PATCH v2 00/18] multiple priority latency stats support
Message-Id: <164392748047.413580.10804793760949974506.b4-ty@kernel.dk>
Date:   Thu, 03 Feb 2022 15:31:20 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, 3 Feb 2022 19:28:23 +0000, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> While the regular latency stats support collecting data for clat,
> slat and lat (clat+slat) at the same time, the per priority
> latencies can only track either clat or lat, and only for two
> different priorities (high/low).
> 
> [...]

Applied, thanks!

[01/18] init: verify option lat_percentiles consistency for all jobs in group
        commit: 13f475ad58ff97e5ca0ecd311a6f039f74d51c12
[02/18] backend: do ioprio_set() before calling the ioengine init callback
        commit: 61b20c5c7b86d2c0840237843002c073345e34fd
[03/18] stat: save the default ioprio in struct thread_stat
        commit: 2df7f0812fa7aa3bd8e700aeb0004f8eb522a76a
[04/18] client/server: convert ss_data to use an offset instead of fixed position
        commit: 2d5bf2a5912738e967e844084b46f976fb655443
[05/18] stat: add a new function to allocate a clat_prio_stat array
        commit: 4ad856497c0bf74c1161192ac10bb01bed92ce3d
[06/18] os: define min/max prio class and level for systems without ioprio
        commit: 971eef801cabdb52e82f0db549346f66fc331677
[07/18] options: add a parsing function for an additional cmdprio_bssplit format
        commit: 68be99668eab06f2917eebf56d77832cfc5c4a2d
[08/18] cmdprio: add support for a new cmdprio_bssplit entry format
        commit: f0547200d6d48dd847cae48f8db08cda0a38fd89
[09/18] examples: add new cmdprio_bssplit format examples
        commit: 4927ccc96357b182746f3b7ce9fa3d7162131547
[10/18] stat: use enum fio_ddir consistently
        commit: 2e5455223ed239eaa516491d33aed8e49325ec04
[11/18] stat: increment members counter after call to sum_thread_stats()
        commit: a381c018f3811e701a1fdbb2c0ed2a6981a18443
[12/18] stat: add helper for resetting the latency buckets
        commit: 2f045d2e1129e53ad69fe98488194e946d9d8102
[13/18] stat: disable per prio stats where not needed
        commit: 691310e297f1d1c9b016d8ff36b00991ece951e7
[14/18] stat: report clat stats on a per priority granularity
        commit: 692dec0cfb4bcf2ddcb6438cfbe73d585c7a3bbc
[15/18] stat: convert json output to a new per priority granularity format
        commit: 1cbbba655caf4f68d0dfcaabff5069a51b8cbb9e
[16/18] gfio: drop support for high/low priority latency results
        commit: c53048b3a68bd0fc6a1ee219141b547363ac74ca
[17/18] stat: remove unused high/low prio struct members
        commit: 5f6ecbcd49bef3b1be4ccbb648af6b80e13a3feb
[18/18] t/latency_percentiles.py: add tests for the new cmdprio_bssplit format
        commit: f79e4dea85ad1ea20e7e512a9c4a6d1baadd9f49

Best regards,
-- 
Jens Axboe


