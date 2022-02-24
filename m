Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14716C433F5
	for <fio@archiver.kernel.org>; Thu, 24 Feb 2022 22:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234938AbiBXWsZ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 24 Feb 2022 17:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235074AbiBXWsY (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 24 Feb 2022 17:48:24 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AABEAC917
        for <fio@vger.kernel.org>; Thu, 24 Feb 2022 14:47:53 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id s15so917092qtk.10
        for <fio@vger.kernel.org>; Thu, 24 Feb 2022 14:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=lyXRnRYQGnjjINLLLOZznNoTjlJQfPjuETQznJjNhmk=;
        b=Hi1cZOrqjThmimgygPE6Ck6S2YAcNyLH9qfA4bGIsfzYkygWIGvbzQAbOCaP5nTEvz
         /aF4P7GG7oxZlSAZsEKxXdHFvR8XBiP65n+xaMPtnuIz0pirYu8K9vQlu9bPKgI5t57T
         dAJ3wSwyGBAfw+Eacj3mdNp/jRqHOtWe4XI3V7cHs+e1alQS/pzCUUdOcxtUxw4F5F85
         yvMLYMZArWqnFyxST5DIhqspKJtdKn5y4qTwpWPmOG6ivKDzgNPXn1aUzdZw3BOOydRQ
         f44Ui0AIQ7YxRQdGp3XXI4A64zpNJ/gWjetiz16v1bUcsso2Lxv4L9zbnGCrU33r56MT
         oNAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=lyXRnRYQGnjjINLLLOZznNoTjlJQfPjuETQznJjNhmk=;
        b=X6jcj3YOqYJ75a0KhpciqbugvENrRFiWSEMEI12zrNEmHRKuIZoI6Vf8ITQ86n7ZiE
         Ne/8kKxf/2zPaeuC+ija0M14xThLutDJssLSUOyb+qoKyD3mShxgmaM/6wHqugndchvU
         8WS8Zd3D3doryj8WkS6K/DJkvumr9wn7c9xcA7AE3LurbiNF8AGTSIUE+7tKnpsy9gNx
         Dy9aLTpw0ZbV27VDJAmDNLc5GrV2jOV3NuUJ3NNtHbqpayR18qG2lKvj7zgCRXuxaqaU
         stytTQk7+9MGWsVaD45JsOdFz4v3Vb4Q2pULFQXQ2Qtm04M+vprqXFB7bpTbVUyHvpxZ
         TJxQ==
X-Gm-Message-State: AOAM530aE2lr06OaRu+N2mne/6XOPeJ2kY2UGswNc/+wDVIdqklmSuj4
        hb/ceZgO6JzVoe7lzgFlrVfgmIZanPixU+lxlt7+hh0fcd37nA==
X-Google-Smtp-Source: ABdhPJyKnUONoiCGHIUROvtrWLM/px/0fEqGqsR8U1ZjmVYkoL4jQIIk0ShCNT4WSm0RAtc4Xl9AS6qJKBMC3N8m9DE=
X-Received: by 2002:a05:622a:5ce:b0:2de:adca:1ace with SMTP id
 d14-20020a05622a05ce00b002deadca1acemr2737584qtb.491.1645742872372; Thu, 24
 Feb 2022 14:47:52 -0800 (PST)
MIME-Version: 1.0
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Thu, 24 Feb 2022 16:47:38 -0600
Message-ID: <CADqNVTr-gjXmWzy86T8NykZWxyScC5Mh4FBcgYDfyK0PO4JV5g@mail.gmail.com>
Subject: Operations at "end" of job with log_avg_msec are missing from logs. Expected?
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

So if I run a job with log_avg_msec, I've noticed that operations can
occur after the last entry in the logs. For example, this job:

sudo ./fio --name=job --filename=/dev/nvme0n1 --rw=read --bs=4K
--ioengine=sync --iodepth=1 --direct=1 --write_bw_log=foo.log
--log_avg_msec=1100 --runtime=4 --time_based

yields this log:

1100, 213694, 0, 0, 0
2200, 265947, 0, 0, 0
3300, 265465, 0, 0, 0

Is this expected/desired? I was surprised there was no final entry in
the log to account for the operations between the last periodic log
entry and the end of the job.

Thanks,
Nick
