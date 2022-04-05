Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B99C433F5
	for <fio@archiver.kernel.org>; Wed,  6 Apr 2022 03:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiDFDqn (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 5 Apr 2022 23:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573051AbiDERtt (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 5 Apr 2022 13:49:49 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E392D1111
        for <fio@vger.kernel.org>; Tue,  5 Apr 2022 10:47:50 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id y6so11528385plg.2
        for <fio@vger.kernel.org>; Tue, 05 Apr 2022 10:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=x5CYRoku6x2v5Y4wX3HoSI1x5XEkrwiNSEZBq8m+fX0=;
        b=1oCb1g3xcLds5FIcXhEC4Jg8RLeXqCeM8aGc0VJaCGMLX5B+6fa7gQ7OZxhIGfcAUM
         LEhqEgA/+INDfLLKuFziscSBlgaetbRbbM+obbuHVSNoxhPrPiPLydptf+kwTxll0pWn
         9tLZ0Q+jFQqu0Ye1YGirMSOZok+yLaB+ZOt7FwmsdF99mUYBRnblFOnQKOAYPF2h2jCq
         xUMxJ8F9Oxn0/TZnYx0+QNbeO0jRYh+lXIfuRmmIRLEXuLB1PSwqTR4UHebe7gZH/Iaq
         J1v6+SHkOwd6pz198CymtSk1Ao9Lxel56nCFoaagfkmSV7z5Jo4kCeaWL/bF9XxVtU8B
         fL2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=x5CYRoku6x2v5Y4wX3HoSI1x5XEkrwiNSEZBq8m+fX0=;
        b=r0RT9PmPbaFXLY+NkgnRJcgwBsVn27dbK1wh2K3urgXKy5GjtecSv4x5UphfJdoZrv
         XFzQJJ8ILKDqv7bQ45ziYN5ntGpsquNa+MO4LPavYhJQHcEc+0gMzPT7jzKOKDdNthqQ
         5l+YNGDEzszxVTCwmkODHyL4Ly+qxAKIjtmtzDNzTPxkQ//gQnwyj2XRoxmbkrF4fkL1
         UOw399Nl/Fzrmlz1p6a1NMyz/Lugv8D4xd1UbpMUg8wrf+KXdH9PYYxRTe7Ff0pIm/Cd
         LEby/AGrgKv4xLKEe/1iZ0s/227uPcaWZCDgwBm1jhwK9v3TesAerlnJPIqKCi1BVDR/
         yUIw==
X-Gm-Message-State: AOAM532w7OL7c69HU8JHES9dGR8WELvr4v4VwnKqkW06sLmR31+MtLm0
        s386ymiggvoX7AVq0yg1cjrc7w==
X-Google-Smtp-Source: ABdhPJx6BiVxr2HS2IqwFue1oZLNcEVccvxR9Y1m+4hI/x7TNppmhn1o5SaKDivYy+n26ROZjKlG8g==
X-Received: by 2002:a17:902:d4cc:b0:154:3a3b:4172 with SMTP id o12-20020a170902d4cc00b001543a3b4172mr4470018plg.165.1649180869609;
        Tue, 05 Apr 2022 10:47:49 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s19-20020aa78d53000000b004fdaae08497sm15486077pfe.28.2022.04.05.10.47.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 10:47:48 -0700 (PDT)
Message-ID: <8646d40c-c6f4-453b-933e-a6f2ec0735ea@kernel.dk>
Date:   Tue, 5 Apr 2022 11:47:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] smalloc: fix ptr address in redzone error message
Content-Language: en-US
To:     Vincent Fu <vincent.fu@samsung.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <CGME20220405173250uscas1p13f0d0f79cc363938edabf8215c9c1768@uscas1p1.samsung.com>
 <20220405173228.186744-1-vincent.fu@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220405173228.186744-1-vincent.fu@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 4/5/22 11:32 AM, Vincent Fu wrote:
> sfree_check_redzone is passed a pointer to the address of the *header*
> of an allocated block. This does not match the address of any of the
> buffers returned by smalloc. Adjust the value printed out to refer to
> the address returned by smalloc associated with the header in question.
> This makes debugging easier because it allows us to more easily identify
> the buffer where over-/under-run occurred.

Thanks, applied.

-- 
Jens Axboe

