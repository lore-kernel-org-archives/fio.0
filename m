Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B775C433EF
	for <fio@archiver.kernel.org>; Mon, 11 Jul 2022 13:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiGKNyV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 11 Jul 2022 09:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiGKNyT (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Jul 2022 09:54:19 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57E95FAE6
        for <fio@vger.kernel.org>; Mon, 11 Jul 2022 06:54:17 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id b2so4491367plx.7
        for <fio@vger.kernel.org>; Mon, 11 Jul 2022 06:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=y3SJYXX0GbWIKmmjvyI1sBc5fZcmUYf/QJHPprohxZA=;
        b=ZCRbUGYpaMUoU2juotuvSx0SIvVhhLZMhoPFvSG68xAL9aBDGrL/IEcfxiPzXsiXyp
         ruDQL7N32FYF6uRGhBGJ6msTc9yZX5hVD3yQ6TouoRj73VUBczcJyp52XZxn3MW29Jx+
         A3+gkeXvholBrOwdbL3w/AgOr4jOLWMZkWgyhMCtu85Ftagit8RTcYysYVL0JHow5cjL
         cQl+LT6o98si4PxwcOXQfuCEviT8x4jndTqVRmLcDl83q3IPpdWf1yOGEWqNCI52E0/3
         MR7YifCP9kj/1MJGanoaj7UAio4McY3SWgUtPyajGW6rWA21Jqw0k7a6DdLPeswO0Aqy
         rBjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=y3SJYXX0GbWIKmmjvyI1sBc5fZcmUYf/QJHPprohxZA=;
        b=v58b7rzqndxqKaDtP5Y7ar7Cteu0ZQRCld28Y7O8ouRUrtWuZQb/TQwSFfiY3N8MCT
         aTR7eyx0pvRdWEdbL2CVd8evC2uY1Y9LF80Qw+ftcPG8BgLuhz7Q/o6dysX9r9weYf7j
         F1zVlZyagfTV6Qn1Lga6+S7jXLv+uc8kL8dCav1+7jBinfrB5l99W4u8bfGhoHExWrRp
         pTF6+oG6KtHyKk1SigAq18CoOcSgT3lY6btr3Jma0Vbg8W5jRfOS66fl0jO/IaE0enV2
         rwnQyndkFLVaSzKpCGnU9sJyt0e6mAuYp4JfJVdRuvsWHGMq5IGOrG+51/mVrVVRtCHZ
         llCQ==
X-Gm-Message-State: AJIora9Doensc2SE1orwmogV0h08fJju/BYx4Ibb+XiNOpkSqmcWr0qK
        WtjwypX6OPVWZh0pj7cxYazz5W68SVMDKA==
X-Google-Smtp-Source: AGRyM1vI8CXg5R7KpJ7vUPR1SK9e8XkTPuuRc3HUui0O4QR1bRDNHuc3dN4OJ/xRTgd3ureXvO5HZg==
X-Received: by 2002:a17:902:aa41:b0:168:8d12:540b with SMTP id c1-20020a170902aa4100b001688d12540bmr19260955plr.35.1657547657114;
        Mon, 11 Jul 2022 06:54:17 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c131-20020a621c89000000b005252defb016sm4740368pfc.122.2022.07.11.06.54.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 06:54:16 -0700 (PDT)
Message-ID: <9013e193-10fc-e2b3-4cd5-8a421fbcee10@kernel.dk>
Date:   Mon, 11 Jul 2022 07:54:15 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] Update README.rst to specify secure protocols where
 possible
Content-Language: en-US
To:     Rebecca Cran <rebecca@bsdio.com>, fio@vger.kernel.org
References: <20220711025547.11917-1-rebecca@bsdio.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220711025547.11917-1-rebecca@bsdio.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 7/10/22 8:55 PM, Rebecca Cran wrote:
> Change git clone commands to specify https instead of git or http.
> GitHub has removed support for the git protocol
> (https://github.blog/changelog/2022-03-15-removed-unencrypted-git-protocol-and-certain-ssh-keys/)
> and http accesses will normally redirect to https.
> 
> Update links to use https where possible: all the sites with updated links
> automatically redirect http accesses to https.
> 
> Signed-off-by: Rebecca Cran <rebecca@bsdio.com>
> ---
>  README.rst | 27 ++++++--------------
>  1 file changed, 8 insertions(+), 19 deletions(-)
> 
> diff --git a/README.rst b/README.rst
> index 527f33ab..ce5c0707 100644
> --- a/README.rst
> +++ b/README.rst
> @@ -27,31 +27,20 @@ Source
>  
>  Fio resides in a git repo, the canonical place is:
>  
> -	git://git.kernel.dk/fio.git
> -
> -When inside a corporate firewall, git:// URL sometimes does not work.
> -If git:// does not work, use the http protocol instead:
> -
> -	http://git.kernel.dk/fio.git
> +	https://git.kernel.dk/fio.git

I don't think you checked that one... I've fixed it up, looks like the
cgit redirect doesn't always work reliably.

Apart from that, looks fine - applied, thanks.

-- 
Jens Axboe

