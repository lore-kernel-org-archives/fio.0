Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 051ABC433FE
	for <fio@archiver.kernel.org>; Sun, 16 Oct 2022 23:05:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiJPXF1 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 16 Oct 2022 19:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiJPXFZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 16 Oct 2022 19:05:25 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4C027153
        for <fio@vger.kernel.org>; Sun, 16 Oct 2022 16:05:20 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id b25so5725860qkk.7
        for <fio@vger.kernel.org>; Sun, 16 Oct 2022 16:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f+h7XbOeWyoPkjrVOroOv0pqTmKlZcQAbjuRAL/Mkvk=;
        b=S+BxILLkMH7XBYaCZrnFhDgedOnFnfPgLXRAE0tfSCQN68PQX803QUhHAPJc2HUtZL
         876xZcQki6RaehkzmU7iGvtC3SA8yQcBencNlFErHHPd2bQRszlAwC6vB3roW01sebXc
         8F1q+tODct7brkwJiVUmu8yrgbuMR34jeAb5j/XAmWgCNh5rCJGY5JegwEo3BOIVlFOZ
         q91L+B3JOF07T1iVbjACqNI46GROu9yYwb9yd0ncEvoaqA4PSo0eqESnCZrS+0/gW5Vk
         DM5r+cxmOpOOI+DoUk+INjEKjBFh88zwkAez5FmX1bbwJDfG5w3O7s89SOEWmXqDXYsM
         XxNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f+h7XbOeWyoPkjrVOroOv0pqTmKlZcQAbjuRAL/Mkvk=;
        b=SWotYC0HAEHENXzRv0bTTfLIIuzrYE5llb+RK9GlPRlLvFu0MiXEHJoc0k1LYGNSUw
         g2gLF8Q+nYYZz6Gqr8Y7aP56cGfZv5+tSC1TlzQ+4hu3+DMo/Ar1aHlixtLFu+kbbQqy
         dxRGk5nmFJ1O0pOa65wpYbLWXSwxMDt6a5cCiLd3QT80ryjVe2s9AbANZOCTXfmoFlJW
         8ObATVTQqERKQxgNPXxQrUAsAQ8oxoLwDOJOCaYkVNDcL8ZmMDj1HYa+dEua9hAyCl/J
         dOXSBchdlIqN62G6BT0CPnESjqGNNDx0AjqP3dFJ8avr2Dj9SihjIhKsYnl5YBTz1eb0
         fmJw==
X-Gm-Message-State: ACrzQf2T1tAJNhQzyrEN/55nNZQSHkoNxk+yml+39engO6Q0wIMMay30
        1Timq55/t9zTfado7NYG4YmLmg==
X-Google-Smtp-Source: AMsMyM4Nu5CQpZsKDPOKIqwwaU+vu+9AcOs4ERnNP6zyhW7VG6Mni0xw/bouMoFIXf5xo4iqFIXY8g==
X-Received: by 2002:a37:a9c3:0:b0:6ee:dfb8:d4c9 with SMTP id s186-20020a37a9c3000000b006eedfb8d4c9mr3114403qke.16.1665961519873;
        Sun, 16 Oct 2022 16:05:19 -0700 (PDT)
Received: from [127.0.0.1] ([8.46.73.120])
        by smtp.gmail.com with ESMTPSA id d8-20020a05622a100800b0039cd508f1d3sm6690801qte.75.2022.10.16.16.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 16:05:19 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     fio@vger.kernel.org, Dmitry Fomichev <dmitry.fomichev@wdc.com>
Cc:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
In-Reply-To: <20221016014309.53682-1-dmitry.fomichev@wdc.com>
References: <20221016014309.53682-1-dmitry.fomichev@wdc.com>
Subject: Re: [PATCH 1/2] t/zbd: fix max_open_zones determination in tests
Message-Id: <166596151755.4882.11867405337101093315.b4-ty@kernel.dk>
Date:   Sun, 16 Oct 2022 17:05:17 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Sun, 16 Oct 2022 10:43:08 +0900, Dmitry Fomichev wrote:
> The test script erroneously falls back to using libzbc for finding out
> the max_open_zones setting if the device being tested is not a SCSI
> device. This causes false positives if libzbc is not installed in the
> test system. To fix, unless the option to use libzbc is explicitly set,
> set this value to 0 for non-SCSI devices to let fio find the actual
> max_open_zones value using the system block interface.
> 
> [...]

Applied, thanks!

[1/2] t/zbd: fix max_open_zones determination in tests
      commit: 842fb796d249ef4c2b97a54442aa8055668888a0
[2/2] t/zbd: add a CLI option to force io_uring
      commit: 0360d61fbfcc1f07bcdc16672f5040f8cf49681f

Best regards,
-- 
Jens Axboe


