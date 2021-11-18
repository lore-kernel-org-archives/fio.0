Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A44D5C433EF
	for <fio@archiver.kernel.org>; Thu, 18 Nov 2021 14:38:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83E6B61155
	for <fio@archiver.kernel.org>; Thu, 18 Nov 2021 14:38:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbhKROl5 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 18 Nov 2021 09:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbhKROl5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 18 Nov 2021 09:41:57 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691CAC061574
        for <fio@vger.kernel.org>; Thu, 18 Nov 2021 06:38:57 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id m9so8300346iop.0
        for <fio@vger.kernel.org>; Thu, 18 Nov 2021 06:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=0uxY9iciPXGzkE2u1mt/0fZWJ/ac7Y49LNeO67XPTFc=;
        b=Z6F42AHCm1DVRwmk6zJ4X7pXTvGm41nFpHA9n/tBtz7Bk6IAYuwGSbtbeeEnHyLxfh
         FJKFuttRwiXUPDa/X5wvE4HSni5ODvYzuJDhVzUlJk+IjCcP4uvazNEUzw1qTcsVFo2u
         WpBWKkTlpeXjbJUdWqwe62ggj1dmMxt/j13G0Wj+Kv4DIXN2WXuGJbX46UeSc9Bgj3t0
         qBkNMXdxP47o5TqOxRwaYOce+CkLQAU2jOeuE2KEKKLs51b8lXcbV6tjBe1swYtXZbP5
         L8Z+YZKnNIrexGWemFy8/NDgnAv9SyFxWIOxRQEsW9kzGW5uMpJSnoZM2RT6n+LrMofJ
         0ENQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=0uxY9iciPXGzkE2u1mt/0fZWJ/ac7Y49LNeO67XPTFc=;
        b=BFPEpYJL/9uqQs2TufZROHXYUxpkueE7WAdOyicjTrs6MKkAMiRHErkAtETX2PY1aa
         1vMa5xjefTMaQxRY0DpapnpULXcsqN9+KZJxV1VX9elqLDGO6lcI0WXkeHqGy916Z8Gm
         KJr6tYw9he3vvP5R0Sd5bkqAawyhw19lhLa6+7Fpivd9Wp08+HcFuJE4Jil1rHcJs8Zc
         Vbyx6UUj50lc6viQpwiUHh0QJe+DctIqSQp0ECAZIJlimsoLSIW1pLhvgwEyXhXGsjHL
         +6vsdJnuwd/geNQjsDqH7HSFEPwyBQcY0dOziJT3ZbpJTjeSymSrfp4/tEnNUCYtSUqf
         I12w==
X-Gm-Message-State: AOAM530YtmmPVej1rgVeJyZ87NG0XuhgZlgVGj+Uv+5MjymHGpnW352W
        1MjR+QbwgRTguwGamTBIUM34ZFhlcbRBZk38
X-Google-Smtp-Source: ABdhPJzW/ZsDObTDSnlKRtkEed7LGQ58bJqbuGGQPsG9nnuswQdWF3Zp83yO7CN7kEDXbQ0ZfEPF1Q==
X-Received: by 2002:a02:a816:: with SMTP id f22mr21130087jaj.81.1637246336637;
        Thu, 18 Nov 2021 06:38:56 -0800 (PST)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id j8sm2443232ils.62.2021.11.18.06.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 06:38:56 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     fio@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
In-Reply-To: <20211118052729.132423-1-damien.lemoal@opensource.wdc.com>
References: <20211118052729.132423-1-damien.lemoal@opensource.wdc.com>
Subject: Re: [PATCH v2] fio: Introduce the log_entries option
Message-Id: <163724633588.285149.15104774031782788896.b4-ty@kernel.dk>
Date:   Thu, 18 Nov 2021 07:38:55 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, 18 Nov 2021 14:27:29 +0900, Damien Le Moal wrote:
> When iops, latency, or bw logging options are used, fio will by default
> log information for any I/O that completes. The initial number of I/O
> log entries is 1024, as defined by (DEF_LOG_ENTRIES). When all log
> entries are used, new log entries are dynamically allocated by
> get_new_log(). This dynamic log entry allocation can negatively impact
> time-related statistics such as the I/O tail latencies (e.g. 99.9
> percentile completion latency) as growing the logs causes a temporary
> I/O stall (IO quiesce), which disturbs the workload steady state. The
> effect of this is especially noticeable with workloads using IO
> priorities: the tail latencies of high priority I/Os increase if the
> IO log needs to be grown.
> 
> [...]

Applied, thanks!

[1/1] fio: Introduce the log_entries option
      commit: 0a852a50c315776de0b43185e30576f15a420a24

Best regards,
-- 
Jens Axboe


