Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8366C433F5
	for <fio@archiver.kernel.org>; Mon,  3 Oct 2022 15:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiJCPJF (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 3 Oct 2022 11:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiJCPJE (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 3 Oct 2022 11:09:04 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20AD63A17B
        for <fio@vger.kernel.org>; Mon,  3 Oct 2022 08:09:03 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id z191so8286294iof.10
        for <fio@vger.kernel.org>; Mon, 03 Oct 2022 08:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=g534ajI44j3Qkf1j5Gcml2iA2qjgH4i/yUg7NOBBoUU=;
        b=qEMwb6npiIgBDexxsRunE0i5ImXXzCwyDFT3yHo3qgVdMLknxLuPNPRI7f4c6G96H0
         2W3Ku2OzLRk7Qt5KRyjBudEUvrga32BW6Bu7IfkWLBd5ftNZVHtFIFKoWk3t/8gPuHaL
         oipKW46ZHgMQG+QAZvhFWt95hIaiIFM0GCDSJgfIzqLXBn05p1a9WSXpdGsf5pM6XEDx
         c2R/wo63lSDDljlMib/4QTb+OckHcvA+lvuV6UpgOA5YGwm9xtssjydKLy5OtZtIJWQQ
         XeZ0Edp/vW7PBwBOrwd9uAvbWWoxafxpKsI7F2JjfAglTcOvtotGD3T5Sesdpjd0jWQk
         KcRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=g534ajI44j3Qkf1j5Gcml2iA2qjgH4i/yUg7NOBBoUU=;
        b=Aasbtnmvjc5ggJbSTVonnPawZpuqypMz1YZvVYe71tz7Y7bBRZ9iNQCl26SslOQzuW
         BC0LvxQjUMii9U4Rd7aUFpvry98F/x8/f9ED89zjAVM+wwj+orpvY+a9182EFT8mZt2x
         azLsKDwLdfPEec4MrODJ8+v/C1vqI+JcLy6pG4+YrQL78aoUq7UYM6+NUtH+Et7B3r6w
         O2a4C9SdLmdKr32fMmNkXeMwzimY/j3WGWJra1JYfYldHw0FASypwcgq0vfUkcze5ply
         q8PiaF4JiP26IHyD7+WB+lYdgnVZ1JhMaa8gomVLPkHY3s/mePdfA9yDqW/LY9Qv2smf
         huJg==
X-Gm-Message-State: ACrzQf33dq1mdexnFQJ6r4ZDL/LbLxerNqWcb1M/xrXvsWFw1VHUFk/u
        pTDhg1OEeXnZTLMvjj7MJjmBJg==
X-Google-Smtp-Source: AMsMyM6RST52wkmOJ4sYHkjOnya71YrQbKiiHyjQRMisuhLl32MxlRaplpaueJnt8ATVLHoB69rtgg==
X-Received: by 2002:a05:6638:d0:b0:362:83eb:92b9 with SMTP id w16-20020a05663800d000b0036283eb92b9mr3424444jao.215.1664809742405;
        Mon, 03 Oct 2022 08:09:02 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w15-20020a02b0cf000000b0035a00f672a0sm4115502jah.112.2022.10.03.08.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 08:09:01 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     vincentfu@gmail.com, Anuj Gupta <anuj20.g@samsung.com>
Cc:     fio@vger.kernel.org, ankit.kumar@samsung.com, gost.dev@samsung.com
In-Reply-To: <20221003033152.314763-1-anuj20.g@samsung.com>
References: <CGME20221003034159epcas5p1018bd8a2413cdd569a6d01b135163d35@epcas5p1.samsung.com>
 <20221003033152.314763-1-anuj20.g@samsung.com>
Subject: Re: [PATCH] engines/io_uring: add fixedbufs support for io_uring_cmd
Message-Id: <166480974152.9399.17085754765963422452.b4-ty@kernel.dk>
Date:   Mon, 03 Oct 2022 09:09:01 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Mon, 3 Oct 2022 09:01:52 +0530, Anuj Gupta wrote:
> This patch enables fixedbufs support for io_uring_cmd. This has already
> been done in t/io_uring, just do it here as well.
> 
> 

Applied, thanks!

[1/1] engines/io_uring: add fixedbufs support for io_uring_cmd
      commit: 0ebd3bf6186852408503f428c7a74fedd34214cb

Best regards,
-- 
Jens Axboe


