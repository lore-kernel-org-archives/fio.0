Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B5CCC433F5
	for <fio@archiver.kernel.org>; Mon, 17 Jan 2022 14:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbiAQOWI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 17 Jan 2022 09:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbiAQOWI (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 17 Jan 2022 09:22:08 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DF9C061574
        for <fio@vger.kernel.org>; Mon, 17 Jan 2022 06:22:08 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id a18so8499847ilq.6
        for <fio@vger.kernel.org>; Mon, 17 Jan 2022 06:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=IgbFgfZEfwrQ/0EQJiZhktQDwmDcW4F+093y63yyVLA=;
        b=dK0Img8mfGWAC1n/d95/ugea+I6Tjpoy+GFTHRD1hP8EkJHcsNji6gkCrUfmpasvot
         f+Au43JkXwpbq6viU8iBrgLBchqNVox48UD4YyFvrDcgCf2tPoAf2XP8w6UAJDU5S317
         4S/gyFOE1sZ8tTQP0jZXSJqCfNbReEAwWM8ZB/lef6JWPPzjie6pPTqZXUWb0sfhbOBB
         knemMfVCSfeAJSRd+btPdQYH+IkkgG6nu3nETT4np7/1m7Vnd/wYeiLPbCfJ3ILDAvAG
         WbtCdMzH3TNgbwCYekiED/SUTJvcFaYIKGiwaYQb++SBkgJExoNjJJGO1vRlQUc1dQ4w
         lbnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=IgbFgfZEfwrQ/0EQJiZhktQDwmDcW4F+093y63yyVLA=;
        b=5iOAqj66kd3G6oNzGCIJSStWpAdD5fSY2mWBlHnkm6rn7Dn6ya9F67B3XtJxi4Xcf/
         7lzdbVClCsAV/h83UxpNai14CFM6wLqai9+a7SfFrIus1s4Af3jqkjs+rVeVLgzRR4E9
         kbZAbo/FIUCFwTA3TiYcLWxjKlngh8h6ByGRvnDWTXLQM5aaRV6z9Yx2OO6wKpy/3gXi
         R66gUR+pZPLkd2nI1SfaTNZaeloRnX3FFxE6bv1QRcHNYp7mnb/5OFRT7zoEpeH47zcM
         3mgCgrahCcgnE5Bhn0LT3ZCw/p3DlGACD8TT2uy2A0yYSmIrVVn44gtnHtRB9RPFhzPo
         hW9A==
X-Gm-Message-State: AOAM531HJJsfvQabi8AV2mmWWXq15ATgpT22sSQaRlOjPzuPIWnWnY6p
        quz2QTPqhYCJM2vDlIo0M78Op0+bGl9TXw==
X-Google-Smtp-Source: ABdhPJxe1qGzY5G/YbeEF1exK+8JwhZcz85h5o4IxXn1bWefvwpaxY6WS1xPtfbAo3d+Q+OOA87tkw==
X-Received: by 2002:a05:6e02:17cd:: with SMTP id z13mr11977305ilu.219.1642429327681;
        Mon, 17 Jan 2022 06:22:07 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id a1sm9435863iol.55.2022.01.17.06.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 06:22:07 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>
In-Reply-To: <20220117021127.9259-1-damien.lemoal@wdc.com>
References: <20220117021127.9259-1-damien.lemoal@wdc.com>
Subject: Re: [PATCH] init: do not create lat logs when not needed
Message-Id: <164242932434.334361.15941992438255016254.b4-ty@kernel.dk>
Date:   Mon, 17 Jan 2022 07:22:04 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Mon, 17 Jan 2022 11:11:27 +0900, Damien Le Moal wrote:
> When any of the options disable_lat, disable_slat and disable_clat are
> used, there is no need to create the lat log associated with the
> disabled latency. In addition, when write_lat_log is also specified,
> this change avoids the creation of empty latency log files.
> 
> 

Applied, thanks!

[1/1] init: do not create lat logs when not needed
      commit: ef37053efdfb8c3b8b6deef43c0969753e6adb44

Best regards,
-- 
Jens Axboe


