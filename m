Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7455AC4321E
	for <fio@archiver.kernel.org>; Thu,  1 Dec 2022 02:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiLAC6w (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 30 Nov 2022 21:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiLAC6v (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 30 Nov 2022 21:58:51 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFAD7B4C2
        for <fio@vger.kernel.org>; Wed, 30 Nov 2022 18:58:47 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y17so353437plp.3
        for <fio@vger.kernel.org>; Wed, 30 Nov 2022 18:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9vjTyF5l4jB2epP5EN+9ZZhW6oPOs7rEnmQulfiqzrY=;
        b=AamDRfVRNegDCFPHrf+Xh/2p18wXM15BPWK+69EJi+S1QA3VkYGjQo7tB/WLLYpv3V
         tSuL9VVo439t0eic2Ja7nyM8wmtgHl9Ssh2y3fMIoWN3MqR4wsyWDDgYazCE/0SaDJsc
         mCs4P2kB12Y5SQw1r5Qj0MMF6R8uZwFwHnZ9ZrTu5HiN6Xek48y14zLzl/wcDUV8HNmU
         i2x4pbUi9l6LqRKJiuKo2jBbcVHXUZ2k3l+hsRYK3DL8tMCN0bV1ORi+U/LLGSYLO3O0
         UFeNpHsCgHIXigCv4g7x4fu/2hqMS5gBwW87VodU6fMtdJWXQZtIn8mn3gHL7BgqxYN9
         vHLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9vjTyF5l4jB2epP5EN+9ZZhW6oPOs7rEnmQulfiqzrY=;
        b=1MjSolJ4BnrKn9JfJ6WDxQcVSUbZd40eSr4/wNXPaXvJxZUVMpvFZFzHxkWgyQyuKv
         PAfmkMeHtHk7j4+XhMwCcWrA3nI+ptYTPpgoHtUnXEJj5SF/ISS+SiaJ9r/EtXnJBUOs
         XluZmntggNBejbfik7bERx2uIokK9KYYGLFWs2ZvS2dIqbpq9QkCxnKppzTo54LGUpYp
         MzAGjLAeG8/6jTgLWubDAInfLL2wKIpXCk0rEi+I+kXJSnnzFgYqjCUVlsxUb8g/PUzY
         3RrvEuzeUq36LpTwjkTErvv3MYY5+zKNm+Y5qmcnQZ8Um03cB1kbYep0DuaBBxnF8Sjl
         Twrg==
X-Gm-Message-State: ANoB5pmev+mNXFBkASVhsjsknNOWtgrqnwyUv3OcVdfTMJLUcvKlftZw
        Z//jr5Q6HpThm1J4MwdU5Ju+hA==
X-Google-Smtp-Source: AA0mqf4Acxb5RMiJrf5kJlVNRmCRkep3GEKUiUY1xT70kbqj3InthsGPJDV/Htt/VkYhJ2Ing7YKQA==
X-Received: by 2002:a17:902:9004:b0:17c:9a37:72fb with SMTP id a4-20020a170902900400b0017c9a3772fbmr57229647plp.82.1669863526766;
        Wed, 30 Nov 2022 18:58:46 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w15-20020aa7954f000000b0056283e2bdbdsm2064342pfq.138.2022.11.30.18.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 18:58:45 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20221201024425.2340442-1-shinichiro.kawasaki@wdc.com>
References: <20221201024425.2340442-1-shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH] backend: respect return value of init_io_u_buffers
Message-Id: <166986352552.521856.14903014426125799848.b4-ty@kernel.dk>
Date:   Wed, 30 Nov 2022 19:58:45 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d377f
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, 01 Dec 2022 11:44:25 +0900, Shin'ichiro Kawasaki wrote:
> When workloads require large buffer for I/O, fio fails to allocate I/O
> buffer but does not report meaningful error message. It just accesses
> to null pointer and fail with signal 11. This symptom is observed with
> the command line below:
> 
> $ fio --name=job --filename=/tmp/fio --rw=write --bs=1g --size=1g \
>       --iodepth=128 --ioengine=libaio
> 
> [...]

Applied, thanks!

[1/1] backend: respect return value of init_io_u_buffers
      commit: 6d8fe6e847bb43cf7db5eee4cf58fd490f12be47

Best regards,
-- 
Jens Axboe


