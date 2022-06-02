Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D2D1C433EF
	for <fio@archiver.kernel.org>; Thu,  2 Jun 2022 09:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbiFBJ7F (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 2 Jun 2022 05:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbiFBJ7E (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 2 Jun 2022 05:59:04 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DF7D104
        for <fio@vger.kernel.org>; Thu,  2 Jun 2022 02:59:01 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id q21so5788922wra.2
        for <fio@vger.kernel.org>; Thu, 02 Jun 2022 02:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=9NAoUncIKN+0VKcQv47dmMS4awYY41L1hks3o2mx2GY=;
        b=OvPRnw1E6t7A3ujPVzWNyiiK4lKVRHUWeffhXTTXEcGuGcYyqlckYHSo3DCQx++hh6
         8gNbp2N5USG+kjv3538gk2cYDLTR7jNL7o+K5uxLa9QF96RlBgBbdNm8qOFs9DjpvZ04
         uH7iDoyQD5CjQyU+OiYK+mrtFkRIFtkcRj/VHdHWjdtKpqJO+bRSFIf/isvmgOnp2wBc
         V0sAAqtLUp2te/IDjjSihv82ComgTQZ+mbcEdq7iLzfiD9L/fFuplVn7ufqhS2hxNy9F
         ydDZ/eam1nG9Gq89n0katxEUStnphHYG+Q6ALI4um62PPC5rrhmbgovk0rbNQKPXeAKD
         /glg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=9NAoUncIKN+0VKcQv47dmMS4awYY41L1hks3o2mx2GY=;
        b=as6sg5IiRu9VHjN54bwVMR3jEsken3/aMjzDc8dB0lfqEcBBYKP4KsKM3EAxqpFX6n
         R/aOk7PeJuACLgELKQC3VSzxOgw11MLiiyu8yKJeQgRKOBVUqUXevIMhT7HwhJ9luXIJ
         zLCWC0RjM22XrP+4HDK39PYkPj+NAACzlU9xd1U8YW1vhoR08+D9jTxCW5FXDSTDEPd5
         XIWbW42eYF43MR799dwwRsOXMTWwh+Y5JNDwuqkWhKR2Nxy6lgyqLQXCB/mb4gj5KtnD
         uBvJPhMIdQzaNsgxO6XRoGd3agV0f7MKf1BVG+uw/S9mdTMHw1HHVOmAxxi49iptizty
         ygXg==
X-Gm-Message-State: AOAM530P9LKA67yuE+18UXRRxn70mmUNT82e7Hvoqq2WpAxoimor0Jdn
        oNfjgCIC48mzVHLuqzFBeoU2uw==
X-Google-Smtp-Source: ABdhPJzJ/0CK0MwbjNU/sn/fpc1kKJ7kQ+PvsPVsG5132QCYyWhxyC/FGmv/DNdeyajp3Jnx+OhxiQ==
X-Received: by 2002:a5d:40c7:0:b0:210:3135:e662 with SMTP id b7-20020a5d40c7000000b002103135e662mr2914976wrq.280.1654163940363;
        Thu, 02 Jun 2022 02:59:00 -0700 (PDT)
Received: from [127.0.1.1] ([193.52.24.5])
        by smtp.gmail.com with ESMTPSA id s8-20020a5d69c8000000b002102b16b9a4sm3892288wrw.110.2022.06.02.02.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 02:58:59 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     fio@vger.kernel.org, shinichiro.kawasaki@wdc.com
Cc:     damien.lemoal@opensource.wdc.com, vincent.fu@samsung.com,
        Dmitry.Fomichev@wdc.com, niklas.cassel@wdc.com
In-Reply-To: <20220602091310.97189-1-shinichiro.kawasaki@wdc.com>
References: <20220602091310.97189-1-shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH] t/zbd: skip test case #13 when max_open_zones is too small
Message-Id: <165416393950.4124.5331352321324788072.b4-ty@kernel.dk>
Date:   Thu, 02 Jun 2022 03:58:59 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, 2 Jun 2022 18:13:10 +0900, Shin'ichiro Kawasaki wrote:
> Test case #13 of t/zbd/test-zbd-support fails when the test target
> device has max_open_zones smaller than 4. To avoid the failure, add a
> helper function require_max_open_zones and use it to skip the test case
> when the device does not have required minimum max_open_zones.
> 
> 

Applied, thanks!

[1/1] t/zbd: skip test case #13 when max_open_zones is too small
      commit: 26faead0f3c6e7608b89a51373f1455b91377fcb

Best regards,
-- 
Jens Axboe


