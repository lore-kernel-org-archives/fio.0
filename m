Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 166BCC0015E
	for <fio@archiver.kernel.org>; Fri, 21 Jul 2023 21:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjGUVX4 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Jul 2023 17:23:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjGUVXz (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Jul 2023 17:23:55 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F173586
        for <fio@vger.kernel.org>; Fri, 21 Jul 2023 14:23:53 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-760dff4b701so34525539f.0
        for <fio@vger.kernel.org>; Fri, 21 Jul 2023 14:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689974633; x=1690579433;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fMKpgLvad6ZOH2LnfIUqAFUOPgTv3Mo4C5QUDZA4y8w=;
        b=VcVkMu+l3Y4DjryDxf2cSDB35m5T08HW/snhSz7jmrtONITLMu8AQYyquSSaRIY2KH
         whqZ8MOaidBuIvI7kvcS5g/jCiuJf98DsAnvaeze/znwVUHg7Voz/ciwY49t9T0Bs5r1
         E8YyHQiokOqvjMLonC3SHll0RpBrn2QWKZCENBRHRTEjLPzSYHwyCNa0H9lOlFqeqrTe
         +yWWC0V/7qfZboabJwx9V0+vdpT+B+7jSO77msVCvI0Wv9RK6lY4MCTIvDYm+5Xw1ote
         VtOHZnxu5IILcHTGzqcQZC+rKNyXiQBiwyt88zy4Ttl8lXtv9r8zvwj89hntRaejq+91
         3LpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689974633; x=1690579433;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fMKpgLvad6ZOH2LnfIUqAFUOPgTv3Mo4C5QUDZA4y8w=;
        b=BBCR0WD77Wc2y4Iui5gknL/w+TQNIT7cectCRk8FmwY30Kt1R/QnQqm6RGC/8YFVzm
         /SYQfXFzBfan+0z9Khl2sOC0AjC0vHC41nRDVKm3Q85X0gsdH13dDPjDe8T/BVl2JJjy
         CdzeMR/bwX/1xb2H6nA1HMS5eKqurrh/d6LPQHvIgHuv3LqE0ayg+H8N0Qq68YYWGgA0
         +HF7Eiti0hy4W9A7m2qPaqhhts6F2U9V0k77iaq8JFCM42B/BkaK1SH0WJRHGGTsKLAw
         6OVhRQ4D7W85vNC9Yp30y91/enIq2MvvHjiPOuCqvKv3B4eIifRkAZXoJ61g5SRKIi1t
         pqoQ==
X-Gm-Message-State: ABy/qLZbcdP2pfkIQgq4HF0o6BU8md0GnuUp8e8y2yLuCssofm8YjLte
        /fNxqrfGHbftxnq81GN/ttfFXA==
X-Google-Smtp-Source: APBJJlFXJYjsY9ct4WlzmtBLMOxk1lRwtLOL8lXb13QDSDibtlG1pkqpwYNKGCmZZaw/0QXPKRw8CA==
X-Received: by 2002:a05:6602:3e87:b0:780:cb36:6f24 with SMTP id el7-20020a0566023e8700b00780cb366f24mr3052887iob.2.1689974633252;
        Fri, 21 Jul 2023 14:23:53 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id eh15-20020a056638298f00b0042b00378ec9sm1231652jab.34.2023.07.21.14.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 14:23:52 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     fio@vger.kernel.org, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <dlemoal@kernel.org>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
In-Reply-To: <20230721110510.44772-1-dlemoal@kernel.org>
References: <20230721110510.44772-1-dlemoal@kernel.org>
Subject: Re: [PATCH v3 0/6] Add support for I/O priority hints
Message-Id: <168997463239.19502.8288582061966068143.b4-ty@kernel.dk>
Date:   Fri, 21 Jul 2023 15:23:52 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-099c9
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


On Fri, 21 Jul 2023 20:05:04 +0900, Damien Le Moal wrote:
> Linux kernel 6.5 adds support for I/O priority hints, which can be
> used (for now) to specify command duration limits for block devices
> supporting this feature.
> 
> This patch series extends fio I/O priority options and adds new options
> to allow users to specify I/O priority hints.
> 
> [...]

Applied, thanks!

[1/6] os-linux: Cleanup IO priority class and value macros
      commit: d4d503a557d4a664ff3fd7a811966df038d06634
[2/6] cmdprio: Introduce generic option definitions
      commit: 2838f77aa80605c13cd18ce5e941005a42cec4a4
[3/6] os-linux: add initial support for IO priority hints
      commit: b3048c1b564fc793ee11004a17b2a4de5a82be27
[4/6] options: add priohint option
      commit: 860462dad312ef121766f5d17b1df7b05d1f47ee
[5/6] cmdprio: Add support for per I/O priority hint
      commit: 79012fece0a0ecb02ad6a3322913980efdb1d726
[6/6] stats: Add hint information to per priority level stats
      commit: 219a868280716e4e221b57269ee3b8a39ea9c29b

Best regards,
-- 
Jens Axboe



