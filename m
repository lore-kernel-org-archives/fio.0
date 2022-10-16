Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E260C4332F
	for <fio@archiver.kernel.org>; Sun, 16 Oct 2022 23:05:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiJPXFV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 16 Oct 2022 19:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiJPXFU (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 16 Oct 2022 19:05:20 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D72927153
        for <fio@vger.kernel.org>; Sun, 16 Oct 2022 16:05:18 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id i9so6581260qvo.0
        for <fio@vger.kernel.org>; Sun, 16 Oct 2022 16:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EFgegK6q7gMZ6gTwhYjcEE5l1iodP2HAn6Ls6Pa3r1M=;
        b=gKNZhFQxBMrahe5TtN201NRWvdErOHyLkv1MYgjDb5Fi7aaE2Xc07tuWZ98mNcoL9F
         8lnrkfhesCH8Rfo3uC4PHnNcfmDwnSV2+Bh43UyYYqca1wc/QpJMg1FrJF51c0FS/zio
         AqqeQe44qicrw4s2pmg3BaUgEVVuCpG/PE4Ajjv2P+zr+yCPvVxEtxKIY6Y3c/pbuHRH
         qdjdkbzfYpePfhAK76PE+FKGchwv5ag2LQfBZlxpvVsLunE9k62T3BFTLfKdIFIk3Hm6
         tLGLtPzV5bCF3zniP8fXT5Mo0trOQYf9VnLj734AlJxodIOU0H/30oPuFZYa0kYVYHwt
         /HcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EFgegK6q7gMZ6gTwhYjcEE5l1iodP2HAn6Ls6Pa3r1M=;
        b=oFiCx+KAeN5eZjw7JgtO1GN878isgvhOx0SYCRN0Hr2GDjC0A9WUW0deFgk2V9Ia+7
         fQNGswD+WMFt1MiwlFjAMV6p8l4S7cGRu5+RI/oOhnAqEQMf7a3hoWvka70N1eewVcCW
         f21z29ek/LaQ2v5Hk4PalnoaywMD9T0QWw+oeDKlOnm8vfvmZ9sRBuf6xWjvBKtFCP1G
         ttFO0UuTQ2uy9bMbgQUClLzuP7j2rkVipLG/WhAZJb6FtnixdEJw6z9pL2j+a0EmmG5e
         EOsbzsTV4GoS+rKap8SM1QxO8svnM9BdL+8u+amNZULmNM3qtJO2syS3ov0fEcAdHjv1
         SUjg==
X-Gm-Message-State: ACrzQf1KvILTsCL1UGYdUlLM4WbGXpRgTaG8sgu4Aq3rMoQDmk20dgV8
        65hhhwH8poP5ouTy6Oaj5uzAxVYxr+c221Jc
X-Google-Smtp-Source: AMsMyM6F1ny3rsL+iwMcWqx+Vt6cAn7AjJ2QujrXOjZ5ILGN/dXIIZ5cGMKlCW0ASNvjpMnb3L7qPQ==
X-Received: by 2002:a0c:dc84:0:b0:4b1:8503:2c41 with SMTP id n4-20020a0cdc84000000b004b185032c41mr6443874qvk.6.1665961517376;
        Sun, 16 Oct 2022 16:05:17 -0700 (PDT)
Received: from [127.0.0.1] ([8.46.73.120])
        by smtp.gmail.com with ESMTPSA id d8-20020a05622a100800b0039cd508f1d3sm6690801qte.75.2022.10.16.16.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 16:05:16 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     fio@vger.kernel.org
In-Reply-To: <Y0sM1PJKEzfv47ZB@localhost.localdomain>
References: <Y0sM1PJKEzfv47ZB@localhost.localdomain>
Subject: Re: [PATCH] fio: warn about "ioengine=psync" and "iodepth >= 1"
Message-Id: <166596151546.4882.9833797692365487843.b4-ty@kernel.dk>
Date:   Sun, 16 Oct 2022 17:05:15 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Sat, 15 Oct 2022 22:41:08 +0300, Alexey Dobriyan wrote:
> Some users are using both ioengine=psync and iodepth=2+
> without blinking in front of the millions:
> 
> 	https://youtu.be/coShLkCriXc?t=840
> 	https://youtu.be/coShLkCriXc?t=890
> 
> Help them with helpful message.
> 
> [...]

Applied, thanks!

[1/1] fio: warn about "ioengine=psync" and "iodepth >= 1"
      commit: 349d5f6c30cc7be60da8878d0b0078697f356897

Best regards,
-- 
Jens Axboe


