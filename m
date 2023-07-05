Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83AF8C001DF
	for <fio@archiver.kernel.org>; Wed,  5 Jul 2023 21:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjGEVte (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 5 Jul 2023 17:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbjGEVso (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 5 Jul 2023 17:48:44 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178CF1BCB
        for <fio@vger.kernel.org>; Wed,  5 Jul 2023 14:48:26 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-7748ca56133so62610839f.0
        for <fio@vger.kernel.org>; Wed, 05 Jul 2023 14:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1688593706; x=1691185706;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n3YlyKDs4JKXuOqsxMn/IlDTc7W/Mhzc7COGLMf59lQ=;
        b=AnQNhVgV6RIyrxD/0izvqiMXDM7vR3dH7eHYBkQM8vRjb8n1IOANwE3nA58xwx4b2a
         sW0git7XLBWQrg28ggHnhoyFVsVWftwKI+lJFgDumA74+X9v+dryhTFbxB4MwNDxYmwj
         TlJznFxQNIr46XX5v3l/2HbrZE+CxzR9ybb7pRfVn44S4aqdNlotkXRVYBDF770YtahP
         gXSMWj9g4zjel4nT1s5KnVmY+a0MOVZWAfb5ZScaFYk18fTNZaaAa2QXRH9h90nJmJ13
         IT7ln04ewSc95fGZScYegxS4599P/aNWl+3tJkoEqSvLqcng7qfeHs51B3GEXdWyp1JE
         hbYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688593706; x=1691185706;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n3YlyKDs4JKXuOqsxMn/IlDTc7W/Mhzc7COGLMf59lQ=;
        b=dV65gbsrTbIOLL3+sBU/yg7eybWkOPKvXzvh6tVNro7fRYxK5tZQ8ui1EK3Gv7IFaf
         rZddcrUmHrOUBnd1ArbIk0l5I/6VeqmkxDHQL1YuGzQXm9D1IJ0pg+d8b13ohpKHHewd
         lRmZ4IXoDPZ9EgKxUTZ3ZMyK61pm+xLeo5uUsDmrAGs+nuedB8jFpWbQhCKP7L8RjJuO
         8U09dI3BS4LI8liy42DZeEISzvC3ErM3RvJYAoDyz6Cvs6mZk4mH/uZcQAikxepfew7U
         Azrx5V7KEozTfp7YA5HCH79hhBg/zTHYd4jz9MPpgj0ib7PPFhLGvhEA/LfFNl4OoKr/
         m/GA==
X-Gm-Message-State: ABy/qLbqtmZe+ockjN6ZpOOiuQlYZTfngfa9FMAkyq6iJFxTnurVM0nW
        lYcj6l58a5IAgPl70rqfjYwUkQ==
X-Google-Smtp-Source: APBJJlH0qPRLsomXic+ncUZTR7vjs1wke+Pwz6Tx0/qDfDf6mzQtPoWzXDK3/HfITs2HNh1LxUFWUw==
X-Received: by 2002:a05:6602:474e:b0:77a:ee79:652 with SMTP id dy14-20020a056602474e00b0077aee790652mr508319iob.1.1688593705994;
        Wed, 05 Jul 2023 14:48:25 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p7-20020a637407000000b0050be8e0b94csm10115pgc.90.2023.07.05.14.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jul 2023 14:48:25 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     fio@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230705212915.3373438-1-bvanassche@acm.org>
References: <20230705212915.3373438-1-bvanassche@acm.org>
Subject: Re: [PATCH] zbd: Support finishing zones on Android
Message-Id: <168859370491.821197.17184142887920905060.b4-ty@kernel.dk>
Date:   Wed, 05 Jul 2023 15:48:24 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-099c9
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


On Wed, 05 Jul 2023 14:29:15 -0700, Bart Van Assche wrote:
> BLKFINISHZONE is missing from older versions of the Android NDK header
> files. Hence, define BLKFINISHZONE if it has not been defined and detect
> at runtime whether or not the kernel supports finishing zones.
> 
> 

Applied, thanks!

[1/1] zbd: Support finishing zones on Android
      commit: 8e2b81b854286f32eae7951a434dddebd968f9d5

Best regards,
-- 
Jens Axboe



