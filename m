Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6015EC433EF
	for <fio@archiver.kernel.org>; Sun, 17 Oct 2021 13:23:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A95561212
	for <fio@archiver.kernel.org>; Sun, 17 Oct 2021 13:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343661AbhJQNZX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 17 Oct 2021 09:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343648AbhJQNZU (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 17 Oct 2021 09:25:20 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962D8C061765
        for <fio@vger.kernel.org>; Sun, 17 Oct 2021 06:23:10 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id n7so13260951iod.0
        for <fio@vger.kernel.org>; Sun, 17 Oct 2021 06:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=90svJ5Dd5w7KRMqK8MF+J2Z0vTWY3I7jG1FdzY9e3N4=;
        b=wDFXPjZDjiu2DzGRAewr0+/oTEU1aA4MtHkFD04KuVpxoA13HX5NzBxdC3ml1Y4f3U
         Vv7CLS2Zbz7G4ZSlJaY5pJr39A6kzIUPuS7tJjkUigWe3BBgi+tyxg3EXsGV458nwnbi
         /PEyjgrwhi9Oazfj+JzdILR7x+IbX32Oiss/S6MzrV+Q09tkRhGeLCHHor6old/q925D
         Q9kBoxNppIlZ8UC4bIDzsLOJp5ZLdVm6fiaL9ip6nNMC9a9obRNqO3Z1bAtGlHvYBdWF
         woUDhK0YfIfjc21RYmLJvUf71SSAtJPoqC+ly0MSSLfpV6l6ZvbytdVaRkm3X1vvCjJd
         wEjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=90svJ5Dd5w7KRMqK8MF+J2Z0vTWY3I7jG1FdzY9e3N4=;
        b=VYinWeIGWyLS+EC/TriYz60YYty9hvPrcZZs0+LPKFFqNHQasgpyV4Doi2fI4DzTAF
         g+VGPM1Y7hmbI3LMl8okDMvMQUBywNO9cd8ylLwBVBv0xxJXcN0aFHjPlE6Jomso+ivn
         m3tc0juEIUpbHajtDX87InJxRmngAR9naaFPUZuw1Ue/tM6r055IqurbZhq1EhkPwx8C
         BMFgOBkP1niGQijm37QOrXRbCARgVQsWoEifLenPU7dQk0W1UcOFaflUqObGfqSxUl0U
         03XXDfTaOTdEPorVVzAOlapBztNfXK4d4R7SRvfmr0F//b+CibtWw274OsrhUel4PAws
         Xkjw==
X-Gm-Message-State: AOAM531bKDP1PCxtDTDJotjGKQS1U+D+UuhQlFnD6F9Szo543qziRinh
        1F/2ilz8XfUWl3B0Vw4f54Vyg50oxbx8VQ==
X-Google-Smtp-Source: ABdhPJwCk0NYwNAkiNNvARC8GstqCaWfqO3EhaGl3ZfqKllLPKyb6+Vbmb6oRkPMnxFehZvjGJzzEQ==
X-Received: by 2002:a05:6638:3396:: with SMTP id h22mr14886035jav.13.1634476989845;
        Sun, 17 Oct 2021 06:23:09 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id 188sm5362191ioa.22.2021.10.17.06.23.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 06:23:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     fio@vger.kernel.org, Vincent Fu <vincent.fu@samsung.com>
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2] run-fio-tests: make test runs more resilient
Date:   Sun, 17 Oct 2021 07:23:06 -0600
Message-Id: <163447698332.96080.15783257566127835141.b4-ty@kernel.dk>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20210921212639.61319-1-vincent.fu@samsung.com>
References: <CGME20210921212712uscas1p2aa572cf95c6782ee69be4dac7beb8f50@uscas1p2.samsung.com> <20210921212639.61319-1-vincent.fu@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, 21 Sep 2021 21:27:11 +0000, Vincent Fu wrote:
> Catch exceptions that occur during test setup/running/evaluation. This
> makes it more likely that the entire test suite can run to completion
> even if some tests fail in an unexpected fashion.
> 
> In particular I have seen failures in FioJobTest_t0014() when the test
> is run on a bare metal machine. Without this patch these failures make
> the entire script grind to a halt.
> 
> [...]

Applied, thanks!

[1/1] run-fio-tests: make test runs more resilient
      commit: aa9f26276e1961fab2d33e188f5a2432360c9c14

Best regards,
-- 
Jens Axboe


