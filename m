Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D57C433F5
	for <fio@archiver.kernel.org>; Tue, 14 Dec 2021 13:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234553AbhLNNrj (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 14 Dec 2021 08:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234548AbhLNNrj (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Dec 2021 08:47:39 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C88C061574
        for <fio@vger.kernel.org>; Tue, 14 Dec 2021 05:47:39 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id y16so24115745ioc.8
        for <fio@vger.kernel.org>; Tue, 14 Dec 2021 05:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=ThvA5BhzBBuAfbJwHmx0q+X6OwBhjGHCKacP3xroxgo=;
        b=wysz5YeKY/glCdF8AWmFAdRSEvTy1rVaNElHaWLiCHXsOiMIwjjy/AvFkYRdQu2Xn+
         4MfXKCu1rlVtFbwpdLZR1X+Ftq2x980oQsRZQU4la8M89LlDDaea4bRuzVjf2VgWvGho
         ScyIq9jpH9mUc6tj0CnbVoejbjm8uB2lbhU04PSgRPDyHZKUqnul3+Y/nZC+F+mUonSV
         P2M5vGxy2OZIQV7BCnPfE89S5rXKfIq4MJUSuut6sajxa0LlyT1JorY91hSkVdLfo5LN
         p6Q9vDMstuxppygSfHb6gfgd/7leOEWMWpD6UWWWEk+H8LaRB5iuAeLPnsFuHF/CQiKn
         mdxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=ThvA5BhzBBuAfbJwHmx0q+X6OwBhjGHCKacP3xroxgo=;
        b=HaPv1fcBadNFDUD2VEGkuYea/C6MB3y/YH6H0C7xPfNJsIOWUmxtsVbkkn1ezMymZW
         5n0M2IjJzacjmdztVAX1V0RYheySl1+p3wYIR+XmGQVyfkil0yLmSEp4PO1hJzICbftU
         PTCI+uuZOMZF+mT6ADplucSCxmFK1gOIBo/w8e2uT5OPk7WUPHARJ8lBvePTOmzP3iw1
         dPpcvhxxjegvnX2LJrRw0UF4d6EvT/gctOxUjQ4WWjE0ojrGT4W5p8srS47kP8G2xPX3
         TnfW1ZWmgSDKbMX+1BC3JSWUYiqSz10X2WX+bu/5R1fltoqWxp8Bp9ap6eG5H9rILuCL
         Sg4Q==
X-Gm-Message-State: AOAM531R8c79VQmRDS+BrF7kPP8ypGhKYKh9Z3hq1m1cSdQFtE6X6HgH
        ir3/tTOGTldvieXFlu0mj0giBrMzhwS20g==
X-Google-Smtp-Source: ABdhPJw2GTML3bOyJ+Q2fRBnqT8eQgX/EXbQDNt/UU+FMPGWiBKBvB28kaDSLBcsDtYa8Hj/cLw4rQ==
X-Received: by 2002:a05:6638:d0d:: with SMTP id q13mr3155469jaj.382.1639489658122;
        Tue, 14 Dec 2021 05:47:38 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id y21sm8626773ioj.41.2021.12.14.05.47.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 05:47:37 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     Sitsofe Wheeler <sitsofe@yahoo.com>, fio@vger.kernel.org
In-Reply-To: <20211214111756.52968-1-Niklas.Cassel@wdc.com>
References: <20211214111756.52968-1-Niklas.Cassel@wdc.com>
Subject: Re: [PATCH 1/2] ci: temporarily remove linux-i686-gcc build
Message-Id: <163948965609.169813.10701989406965329810.b4-ty@kernel.dk>
Date:   Tue, 14 Dec 2021 06:47:36 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, 14 Dec 2021 11:18:03 +0000, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> GitHub Actions was recently enabled in commit ce1b5612ce99 ("ci: add CI
> via GitHub Actions").
> 
> The new CI configuration was not properly tested before being merged,
> as the linux-i686-gcc build currently fails for the master branch:
> https://github.com/axboe/fio/actions
> 
> [...]

Applied, thanks!

[1/2] ci: temporarily remove linux-i686-gcc build
      commit: cea3243fb3bb44d541c2b3fb82ee45eb669b6fe6
[2/2] ci: use macos 11 in virtual environment
      commit: d685f07ecb0f2ff64e475fe0ddf86e69b295fbf6

Best regards,
-- 
Jens Axboe


