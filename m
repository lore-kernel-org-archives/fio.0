Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7399AC433F5
	for <fio@archiver.kernel.org>; Sat, 16 Oct 2021 11:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 545D5611C1
	for <fio@archiver.kernel.org>; Sat, 16 Oct 2021 11:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240368AbhJPL7a (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 16 Oct 2021 07:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237354AbhJPL7a (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 16 Oct 2021 07:59:30 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E5AC061570
        for <fio@vger.kernel.org>; Sat, 16 Oct 2021 04:57:22 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id g2so9939483ild.1
        for <fio@vger.kernel.org>; Sat, 16 Oct 2021 04:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TCHT7yrB/JCeaQQDHJNc0cOTL0OuNH8asp8TM7u4B/g=;
        b=Bi3CnSmYvGQILE5DCGQi3wKo062xQH1FyEx4/MjzULLeTuMFNB1oBp/2W6ymVvbBKN
         m/6+bhgLFFvHkrNejCNfjI+fpC0+ZnD6GvE9sgUEj9EjlvWUCDT+Puhi05WuW8CVhWw4
         n8wvG3AVbVN8MYi39hAnk97/LaSy/ml2/blCCJyhT8kFLOtI9wQL26XmW+kdbq55daWA
         ujNonW26SnjpE6Wlycz423snu9AyJ1RLxhNjnDuhVF40/O+PvbtflMnosSxYf97EEcaV
         /DYj5GegmzpM16IQW21ewk2qei7pnPlGnnXONab2yNIZbAgfOceCGxGAWqdM5QWc/GRB
         v57A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TCHT7yrB/JCeaQQDHJNc0cOTL0OuNH8asp8TM7u4B/g=;
        b=qQas8TqVjvj7drIB9K485cwNQ8xG7LNc6wDFDSqwqnANMuWhDmrPcOyDseV6lHQIG9
         yTXKNJiPVlmpyRcScs9UXa5n8hcegfJp4palEdEc5E0jOcW5PDGc4eVH+c/RUYfYSq0Q
         GH6Nqdu1C1wucSSDIpkCkzLAbPhukGIIjzbvqQhZsV9SSo167/KFxw7f0isbjRUW9S7d
         ypGLs0Vj1DQIhlqc0f0UDx1N1dvNhs40IhPV3v9V8b7tZuZfXr8hvWmMLr7E3eWrDMDX
         oEWmuvGi3xayVKHj1kkOy6DpvxmYAnsogrG7y29c6w1UPVG/9ESwE45v2dQe0EMM29rT
         8d6A==
X-Gm-Message-State: AOAM530UWJgYtAfr512YUc8Y1pfQ9y0DdYNocF9ioUMZjPiRnwEJZJCq
        FPr0cMUYXIneCUSbbue5HLhuuhHvc8m4VQ==
X-Google-Smtp-Source: ABdhPJzEgwwNSYNcJ083siHABmFATj0ZeNp55d44uKAn/pWhhv3JIxNiePEdQ336C3DutwjsAgnPnQ==
X-Received: by 2002:a92:1a42:: with SMTP id z2mr7589146ill.270.1634385441527;
        Sat, 16 Oct 2021 04:57:21 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id v17sm4196675ilh.67.2021.10.16.04.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Oct 2021 04:57:21 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     fio@vger.kernel.org, Rebecca Cran <rebecca@bsdio.com>
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/1] engines/http.c: add fallthrough annotation to _curl_trace
Date:   Sat, 16 Oct 2021 05:57:18 -0600
Message-Id: <163438543038.603853.6070971626041807312.b4-ty@kernel.dk>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211016061738.76654-1-rebecca@bsdio.com>
References: <20211016061738.76654-1-rebecca@bsdio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Sat, 16 Oct 2021 00:17:38 -0600, Rebecca Cran wrote:
> To avoid the warning from clang "warning: unannotated fall-through
> between switch labels [-Wimplicit-fallthrough]" swap the "fall through"
> comment with the "fallthrough;" annotation from compiler.h.
> 
> Since the second "fall through" comment isn't really a new fall-through,
> remove it.
> 
> [...]

Applied, thanks!

[1/1] engines/http.c: add fallthrough annotation to _curl_trace
      commit: d853907223ca610c85a81cfe238ffd93b97520e7

Best regards,
-- 
Jens Axboe


