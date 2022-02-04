Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A01DC433F5
	for <fio@archiver.kernel.org>; Fri,  4 Feb 2022 00:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356190AbiBDATK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Feb 2022 19:19:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245100AbiBDATK (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Feb 2022 19:19:10 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F76C061714
        for <fio@vger.kernel.org>; Thu,  3 Feb 2022 16:19:10 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id l24-20020a17090aec1800b001b55738f633so6720902pjy.1
        for <fio@vger.kernel.org>; Thu, 03 Feb 2022 16:19:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=Ohh9tJyC9FdpU/eGPNZiIpRJm2dccT3XaXWFtoBsF/c=;
        b=iBRAy3I0Lfv5wdldkttc40Fqy88l6nClv2qfAjWXHZW6pIzclZZ3nFGFoBPfI/InFC
         F5+h71UrQXi/pztwtg2TD+TSdIEo5wNUjGK9eGg4bhLRNpqTXdEGRnCKRrnhI23f9A7T
         W6XGURFnGM4D0fpS8GFj5rOlfW4jUPcEk4cYkQcA5X8DdYGb9wr4VcZ6BK6L4+fzfpE2
         f8/aIOewgREygLsuIYewZsSpKM309cQe5mXnWn2aA/X9EnBdYNkeLQtrWFPqb3DsikVf
         Jp2/Zo0NCK1LnJiLxaTEtBIkiHNqyOnJkiSlUkFwWLaqI34g9fnU7WTf56yvR99wOca3
         VYEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=Ohh9tJyC9FdpU/eGPNZiIpRJm2dccT3XaXWFtoBsF/c=;
        b=myH+mfQ+ijTISoPYqZVbq9QWzNSpWeiaxmqQhecERa5gLXb4WBPOvfmkBEowLPE35v
         UIyd7Y0ITAOihc17PHbNZWq2V+a2hHhrZaI7rOoz+BkD8moiJKJAVeYdRx64IpB1S2g1
         OK91+Tv2Eafhrb9rzQNNNyAHpJ04gHlCBLx5YQT49kAM7hxUW8DroKFWVFPQURYJGnMO
         L3A2sqIzzhLzIjIf0hsS9TIZdQhPTa8wl2cjRWZWcnxm6T0v2JihVdQ5RMUECh5uRxmT
         OPL2/Jk9VFcA3oY4LuNsK04Fn0SeBd/ePTvAIARR4AQ44pIls4p/nwv44NAtYM+sWwB8
         MOUA==
X-Gm-Message-State: AOAM531Bwu/JP9Kn9jG9jGAgd9wguMZArMFKe0njFADsvUcZJEs+4heM
        qj5NMidPOKGTiNqWXnYbPhpjIeWY3v31fw==
X-Google-Smtp-Source: ABdhPJzxqIqs+ksehXNAQqmTU7DmYctGnWTe9V0LpYFpBB5NGWngg8vQ6rPxsgKPGnL5DlPymk4h2g==
X-Received: by 2002:a17:902:e302:: with SMTP id q2mr450650plc.92.1643933949541;
        Thu, 03 Feb 2022 16:19:09 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id a38sm169961pfx.46.2022.02.03.16.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 16:19:09 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     damien.lemoal@opensource.wdc.com, fio@vger.kernel.org
In-Reply-To: <20220204001741.34419-1-Niklas.Cassel@wdc.com>
References: <20220204001741.34419-1-Niklas.Cassel@wdc.com>
Subject: Re: [PATCH] stat: make free_clat_prio_stats() safe against NULL
Message-Id: <164393394880.425950.2129151961498526663.b4-ty@kernel.dk>
Date:   Thu, 03 Feb 2022 17:19:08 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, 4 Feb 2022 00:17:49 +0000, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> The sfree() in free_clat_prio_stats() itself handles NULL, so the function
> already handles a struct thread_stat without any per priority stats.
> (Per priority stats are disabled on threads/thread_stats that we know will
> never be able to contain more than a single priority.)
> 
> [...]

Applied, thanks!

[1/1] stat: make free_clat_prio_stats() safe against NULL
      commit: e23aa8174d6a1242d81491ce30f10a8d5f9acb10

Best regards,
-- 
Jens Axboe


