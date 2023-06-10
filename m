Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC047C7EE29
	for <fio@archiver.kernel.org>; Sat, 10 Jun 2023 00:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjFJAFK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjFJAFJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 9 Jun 2023 20:05:09 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31CF134
        for <fio@vger.kernel.org>; Fri,  9 Jun 2023 17:05:07 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-656bc570a05so507127b3a.0
        for <fio@vger.kernel.org>; Fri, 09 Jun 2023 17:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686355507; x=1688947507;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e1B5sm/0vsJTsSS5b2hvbCS/6z7Zbg2BVddNN9mPpSA=;
        b=1eqX8ohIaf+eLowiWzvrV0+rdEEr8T1Yj8ASJlM3mpziEOEQq2MioF26Rr9esA2S66
         4Xtwb17Cx7rFFxP6yb+zjsObPrRli0FLr76DgL38sEgB6xlWX5N+Y2UjtqPlnXOSOzCA
         pbY1yktF57F99hvO0vwIRFTfsNSG1BNaiZZhMRNraQea/2LtMz5st7oxmIViCMhf5U57
         Td8DGnpl/RXnL5aA1pOqMSBooLjdcfIZqJuNzStJlOpjoGANf06RvzOFgMItqA7Odaw1
         9Hpe4xxYFN3lLKVVoc68NpC/MXzs2+xQreys6YcsY0CoTIEER8y+dwZ6eijI+YklOLcy
         0kyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686355507; x=1688947507;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e1B5sm/0vsJTsSS5b2hvbCS/6z7Zbg2BVddNN9mPpSA=;
        b=lqOq0R0/2Xk5SS6L99E7S0mjMv6LC78yayNXDIjHI5Lh30aU2N1stjMVRNrVH/UwD0
         E1Z+hqG+cXmnt2NidlNPKU5Nn+ZalyQ7dA+3b/cgkNlJB0S9HH/RnOld1bZY8upEhi4U
         ETVqjHGFnrFolP2rJA/jmalxDJrGpyu/g7C3K1V5izxQzREakb8U4Xr0lACtejy0d0ke
         cOEZmnNmWgC0kthl0oOqHlxKcBWv0e8O+PV95Pe0NQQQjKIcdY79HS+k39ayoe2j2Ssb
         zTtdTFIzjVwqkzj/sEtQe5SAxfL6ugo6SIBbpSUn1APX5mswSItj3/CeagZlwVdrhDMt
         MIig==
X-Gm-Message-State: AC+VfDxDpx0Qe8FzJhsgvn1gx39sw5CQKLXXu3kZoVxEDMrk+T8iSFcI
        LpQhGoXg+54bUZ8yOmA+/7TVh9Lo4UuYYHUmjQ4=
X-Google-Smtp-Source: ACHHUZ7EUWW2nyif7s3Ec+OgmszGQMNxHg7cJMJHck2gF8SFpfP10a4GCB0Aj86+OGosm3ywF/Qoxg==
X-Received: by 2002:a05:6a20:5499:b0:10c:8939:fc48 with SMTP id i25-20020a056a20549900b0010c8939fc48mr3072261pzk.3.1686355507303;
        Fri, 09 Jun 2023 17:05:07 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k4-20020aa790c4000000b0063b8d21be5asm3229506pfk.147.2023.06.09.17.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 17:05:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
In-Reply-To: <20230609235914.1376567-1-shinichiro.kawasaki@wdc.com>
References: <20230609235914.1376567-1-shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH] zbd: avoid Coverity defect report
Message-Id: <168635550571.775565.15821160196830289017.b4-ty@kernel.dk>
Date:   Fri, 09 Jun 2023 18:05:05 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-c6835
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


On Sat, 10 Jun 2023 08:59:14 +0900, Shin'ichiro Kawasaki wrote:
> Coverity reported a defect related to the local variable "in_flight":
> 
>     Using an unreliable value of "in_flight" inside the second locked
>     section. If the data that "in_flight" depends on was changed by
>     another thread, this use might be incorrect.
> 
> The variable "in_flight" is thread local and other threads can not
> change its value. Then the report should be false-positive. Just to
> suppress the report, change reference timing of the valuable.
> 
> [...]

Applied, thanks!

[1/1] zbd: avoid Coverity defect report
      commit: 62ac66490f5077e5fca1bd5b49165147cafc5a0d

Best regards,
-- 
Jens Axboe



