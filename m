Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 815C2C433F5
	for <fio@archiver.kernel.org>; Wed,  1 Jun 2022 02:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349229AbiFAC6n (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 31 May 2022 22:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235209AbiFAC6m (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 31 May 2022 22:58:42 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B603F49931
        for <fio@vger.kernel.org>; Tue, 31 May 2022 19:58:41 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id d26so418284wrb.13
        for <fio@vger.kernel.org>; Tue, 31 May 2022 19:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=sIiHW7uoiIFCWxuLA6XjqHR5jrXUMRGGsoUVgdqcr8w=;
        b=Gm6BQTj+O9W5Je7LzS6lW/AJJbFYjQuAsxV3Z2Xu5eAZkdrR4Xl+gwtl1f8QYY+KAT
         826uto1SL1pkRY5Hcyx2uQ7lcJW9rVpV+Y0pgcOzvdiCX/qJDllOiiFhoxFMLMg0FyPY
         IaKX744JasqfUfH+JVxIIGnZjeZHe9mjIBmPBI4T7J4IDJMAMOaLgp1TztTvO9BFDPtW
         TrlbmmVH/uyNcVSEI2bHs/YjYRFa2MH3BdePcNIlxxGlQalLMhDTplgdFZdMWNSWod3i
         n0jAyKipclVdyCyzjYJF+toig5TQOCvPTaa/dha1MDngzut0TnRNQKF2ctxdKd1BdmOi
         sweQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=sIiHW7uoiIFCWxuLA6XjqHR5jrXUMRGGsoUVgdqcr8w=;
        b=0U3An/jSpn5mEfyUauAeRV1ICZhVkHJ9lFqvkl1jYbvVM0DoR61Dt/3ny0mKjodPdb
         4wGmoN4fA1i5v573rDF6YZhJN8NjvnA7+R1gLt2BZmNfOKbiC2e8JLWZdxhTr6CvfpQE
         LQIbTZJ7xEFhwA4lMh/B2qIYO5b0bZfVB4yL0rF/ZkgKCg7mq6/mFKx1e70FLDuvRAtM
         XgkqGt2qpCmUT7ABOJZJ171jYDQg6tKgagAl8G8lYq3mufz8tc5wSrXg1fgVfdvaCgk4
         cs7DfRJZFikHFvbS1ihWXBxIjPAIKSV+rOzBzEWIh12tWS4EAJYVpNdhi7uyXd9g3UJY
         kaLQ==
X-Gm-Message-State: AOAM533hA4QMS/JmYIpPr2uNWHeCRu27jDpJPx/g3gERFzZsyDlkbET1
        xicTXCAQEwoQXN9maMSIeZdGQH+ym0kQ4IwW
X-Google-Smtp-Source: ABdhPJwaqZTAvblT9UZTMy1cq5wPxTNjJW1jBXW+PsXyxOwy7ITYpBZDAM4OhGTNlOEBqyhSMmWRLw==
X-Received: by 2002:a05:6000:2a2:b0:20f:d8ca:744d with SMTP id l2-20020a05600002a200b0020fd8ca744dmr39408519wry.354.1654052319941;
        Tue, 31 May 2022 19:58:39 -0700 (PDT)
Received: from [127.0.1.1] (cust-east-parth2-46-193-73-98.wb.wifirst.net. [46.193.73.98])
        by smtp.gmail.com with ESMTPSA id n16-20020a5d67d0000000b00210bac248c8sm111509wrw.11.2022.05.31.19.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 19:58:39 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     fio@vger.kernel.org, vincent.fu@samsung.com
In-Reply-To: <20220531214857.169864-1-vincent.fu@samsung.com>
References: <CGME20220531214912uscas1p2d80942edd01e3f12d80514ccf3ab9f6d@uscas1p2.samsung.com> <20220531214857.169864-1-vincent.fu@samsung.com>
Subject: Re: [PATCH] docs: update language setting for Sphinx build
Message-Id: <165405231912.7636.853325851782784514.b4-ty@kernel.dk>
Date:   Tue, 31 May 2022 20:58:39 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, 31 May 2022 21:49:11 +0000, Vincent Fu wrote:
> Sphinx 5.0.0 no longer accepts None for language. Remove it and Sphinx
> will use English as the default and no longer emit a warning.
> 
> For details see https://github.com/sphinx-doc/sphinx/issues/10474
> 
> Sphinx warnings cause our documentation build on GitHub Actions to fail.
> Failures were observed for recent macOS builds which upgraded to Sphinx
> 5.0.0.
> 
> [...]

Applied, thanks!

[1/1] docs: update language setting for Sphinx build
      commit: 5ceed0be62f3ce8903d5747674f9f70f44e736d6

Best regards,
-- 
Jens Axboe


