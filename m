Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D244C433EF
	for <fio@archiver.kernel.org>; Wed, 22 Jun 2022 17:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377384AbiFVRqH (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 22 Jun 2022 13:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377401AbiFVRqH (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 22 Jun 2022 13:46:07 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DB334674
        for <fio@vger.kernel.org>; Wed, 22 Jun 2022 10:46:06 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id h20so5980182ilj.13
        for <fio@vger.kernel.org>; Wed, 22 Jun 2022 10:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=bMqB7ZX8UUdB5RVfoff6SM3/vs4fMR1YgcclZrXrDl4=;
        b=unm8owpst6aKF2gnM0AhyW5YoEl3j0VqJ0oldUzyks5O4CNZbDoFX2U+boF9BskP2K
         ftF8g3AdD0gwz8fdyk8dno2s5fxjRJTYmiequdYM3hZzjdEm54EqMhZ+T30VZLPbs1Zc
         i3sfTB3+G6jPbe+Bflp+BpYl1rzz796QrPKcAEi7hhQPZX69ZEEUkUUA3kbdbjj0Ai0s
         J7jUit8lylKC9lY9T7c1+Ky0of4iq17mPdJpSwZHhAFlnP/h9ytiqTJtkE7nOGN0mtAQ
         gzkbScaiKP5sotJGroOoLs+RSQaLs/8BEQoMpHuBMwpVOyP9Jr45AKFvt1LRNeQ7O30h
         i9jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=bMqB7ZX8UUdB5RVfoff6SM3/vs4fMR1YgcclZrXrDl4=;
        b=O4v7PlOtZGvjwUM83cZVFNsvTAqDCTgdWJBBDDchgelnE0kdE+Z4aetwHi+4MYFYPK
         s1vSvgownvsDY51spiwyCB9PvOPoO/87Xa4+ebpP3nFnbzd6FskNdChpSqb1b6ryYSxO
         32THLrgYlRbSV0QxlQm4rwKA19SaTz9ditlmrZ1hEjZsstBUNgnVrImZeyUF/aY6yBnj
         WSXOIadCVhSUWWGuND68iR3pGkBJuC5wbmdEmnYeP9keV2tCKu1KtAuDrUG0omISGkdT
         H/UO7+2fSkX8NIsb+1WxFKxIvppYj+BQvp/r7tAM2u8DJxB8ydlbxg5vrAe93zQVfI3v
         cY1Q==
X-Gm-Message-State: AJIora+FpvOlChC+sQ1AEoMGx7m/MYBrvygfNeRtSDsKcjz7aJ2IuSws
        /bbwm342XJ/al8dIcdvMXctF4g==
X-Google-Smtp-Source: AGRyM1sxl7ZjhXCHe32OfMlv3E3s8ST+cX8xwD402tyZ9SygLnXVLnFBudygeuk4ZmeI1BWwu0oPVA==
X-Received: by 2002:a05:6e02:1c8a:b0:2d9:db6:eac6 with SMTP id w10-20020a056e021c8a00b002d90db6eac6mr2604744ill.106.1655919965777;
        Wed, 22 Jun 2022 10:46:05 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b6-20020a5d8946000000b00665862d12bbsm9468119iot.46.2022.06.22.10.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 10:46:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     ankit.kumar@samsung.com
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com
In-Reply-To: <20220622112546.13503-1-ankit.kumar@samsung.com>
References: <CGME20220622113122epcas5p209ab7fab23d77d895b8a16ccf812041f@epcas5p2.samsung.com> <20220622112546.13503-1-ankit.kumar@samsung.com>
Subject: Re: [PATCH 0/1] *** option to disable xnvme build even if found ***
Message-Id: <165591996518.77146.1360883566006370815.b4-ty@kernel.dk>
Date:   Wed, 22 Jun 2022 11:46:05 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, 22 Jun 2022 16:55:45 +0530, Ankit Kumar wrote:
> Add config option to disable xnvme ioengine build even if
> its support is present. Remove enable xnvme build option
> as by default we are anyway probing for it.
> 
> Ankit Kumar (1):
>   configure: add option to disable xnvme build
> 
> [...]

Applied, thanks!

[1/1] configure: add option to disable xnvme build
      commit: 6aaebfbe7269f95164ac83a04505869f96f5f83a

Best regards,
-- 
Jens Axboe


