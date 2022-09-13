Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADCE4C54EE9
	for <fio@archiver.kernel.org>; Tue, 13 Sep 2022 21:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiIMVEE (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 13 Sep 2022 17:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiIMVED (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 13 Sep 2022 17:04:03 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C986AA38
        for <fio@vger.kernel.org>; Tue, 13 Sep 2022 14:04:02 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id bq9so22702271wrb.4
        for <fio@vger.kernel.org>; Tue, 13 Sep 2022 14:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date;
        bh=xklqbB73Pw4oEV41tZhy3rVdyTN+z5pGoRxyt6B8e2s=;
        b=4NKAMQuK/5+2fnxZLwaZCIVRVOyx8IJjZ2GUUAch2Gs/IkVqUdz3E6JD19EIPdfAvh
         98WQzsPboYOrVLdGzhMM6Zzu5jXa8PVPMjxOH9oefQwGO6TcF79PeEUJ+aYvV6zi8scM
         mlPEvi16fK6MCUFLmvForebN0gOl9eVqIYHd1fFKGsVUIoo/avP0PFwgxE7ZF5k6x3xV
         oYQ3n95uRSGn44S+dhuKRmJa+t0eZK7jK2av2221uj410H0XHPk5sECX7QeQFE14CYQb
         z36a2eEjQ05eWYUHPY6HbKepUd/lLs4ElKXZMoogLeDh2Obp4+epAtEBkXEOOctIlHim
         S56w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=xklqbB73Pw4oEV41tZhy3rVdyTN+z5pGoRxyt6B8e2s=;
        b=65rWsuL2QW3nVTMUcWqd0GHyPax5M8pl1qnAT+KAT3mcAD/4UbMmH2VwwqBmKG68a2
         OeYcST72q0QEX1EN2AUblor3WayMd1nlrpca2y9qHGFC1VkQDCWDl+GP1P02Efr41JKk
         Qt9hWu7+V1jTz5l/M+uZVAVaGEOGA3QfI3qgLrdvuKg07xA2UNDm02acs0k58pUYA+Fq
         csj+/DXC31RzyEB3GocihOLcGDSGQvizmKgmxVKlxSjd+FzI2XahM1gjjW9hkv709zFE
         aCaXJa+mlkg3YGznEFoPoJuLCie66hrm83Ttn8rmHTPTTzG9hi4oNcJ1Psjd5NhswnTe
         VGlw==
X-Gm-Message-State: ACgBeo3LmZr8KXsPM1TwO/juMO3U5IwM4BMIIujBCL4r5QtMDsmJqK9n
        43LG+RgqMK4laqWMj49H2KdKAw==
X-Google-Smtp-Source: AA6agR6PCG8rKIzBfgRQxVpEeS6v0BLpOx3Zufd+xQPilMnU7peeJo2n0wlfUczlgx0jvN+T5O0rkQ==
X-Received: by 2002:a5d:5887:0:b0:220:81c9:8ab7 with SMTP id n7-20020a5d5887000000b0022081c98ab7mr19377877wrf.702.1663103040827;
        Tue, 13 Sep 2022 14:04:00 -0700 (PDT)
Received: from [127.0.0.1] ([185.122.133.20])
        by smtp.gmail.com with ESMTPSA id k42-20020a05600c1caa00b003b4868eb71bsm9154396wms.25.2022.09.13.14.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 14:04:00 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     vincentfu@gmail.com, fio@vger.kernel.org
In-Reply-To: <20220913104527.18734-1-ankit.kumar@samsung.com>
References: <CGME20220913105531epcas5p3576d018441951d5555544a2d5ddefab7@epcas5p3.samsung.com>
 <20220913104527.18734-1-ankit.kumar@samsung.com>
Subject: Re: [PATCH 0/1] number_ios and io_size behave differently for trimwrite
Message-Id: <166310303976.11995.15429775228320580539.b4-ty@kernel.dk>
Date:   Tue, 13 Sep 2022 15:03:59 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.10.0-dev-95855
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, 13 Sep 2022 16:15:26 +0530, Ankit Kumar wrote:
> Add changes for number_ios such that we actually do trim and then writes
> for those number of I/O's. This will make the behaviour similar to
> io_size.
> Update the documentation to clarify the exact behaviour for trimwrite
> workloads.
> 
> Ankit Kumar (1):
>   backend: number of ios not as expected for trimwrite
> 
> [...]

Applied, thanks!

[1/1] backend: number of ios not as expected for trimwrite
      commit: 08996af41b2566565cbcdee71766030a2c8ba377

Best regards,
-- 
Jens Axboe


