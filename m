Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BD7CC3F6B0
	for <fio@archiver.kernel.org>; Wed, 10 Aug 2022 13:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231727AbiHJNDq (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 10 Aug 2022 09:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbiHJNDZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 10 Aug 2022 09:03:25 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B05D6CD25
        for <fio@vger.kernel.org>; Wed, 10 Aug 2022 06:03:25 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id k14so11627286pfh.0
        for <fio@vger.kernel.org>; Wed, 10 Aug 2022 06:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc;
        bh=YjObjZOOk8gs0zBjuBvWJkrm5pGI7YFKT/y5k5gSOj8=;
        b=EuYFoCFITq5RjlIAaXTsw5QBeof/PLE4dI8MPxgf7KLztvloENktgMOTf3v1Ofr1RP
         FuCgRNjrSns/cpbb3a7RwXPFIf5wPtIKE7fxPvNAoW1Tkdfy+6MianIQq0BJPBjBC7aO
         uiKxQGIzt+2hnXXARdidyk9GqGilFmyufaCEeTSTjhIwLYZhIJ0hqzeA+oo7vCZaBKlY
         vQff7xCP/0eB1GnE1i13+yIA3Zf2wAIQIDD4mFzxDc27C6+VUdaLdUynUFIY7etlMMuS
         ZxEEUyDEKQKAYcBAqUf7Wu1pp7shtXUmjdli7ZlesR/71eE24UmyvRPxYIIKHg8eKMdc
         1ArA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc;
        bh=YjObjZOOk8gs0zBjuBvWJkrm5pGI7YFKT/y5k5gSOj8=;
        b=CA0zQb7rJDlIj4Db+mtWtnPKdsOXhAEJV+K7GsBNy9v8LL6ksK0RQ96Owvs2212x/q
         n7N63vmQTEQnOj9ve9SGWARsYski/HT8h/0ef4GCEkjNBMbXmiaGL/DpnJI0yGSRkTb9
         P1WH1X88jdzHpko2XO7PJgNavLdOMq/qyXpvOdUVlJdpkWuw3cLwYenCdbO7eIZ76cR4
         LLTY/Pp+3f74kBgu8VIGXzfxKCFZDxOslj0vvFr99dKYMTSBqHvPzkpM/rG4Wgk4uZDw
         4yFD+iEShhTMYYxqWcYvP7GoT1l12GLkeLzcZe5yltEpX/1vTr2wTJxH/zpyU24cm7Jg
         DewA==
X-Gm-Message-State: ACgBeo2K+rTBz7J+ZRFtEtK8eiGULsldUmN0qGFfKaARj0S3pA3s9GOr
        qZigL9wetD0L4O56rmKWvWuYnOeE8Ovt7A==
X-Google-Smtp-Source: AA6agR7mTfn5gzxT0S5Xq7JXpoi5U3uRWR1hvFBNdej7LeYBDK7OPWTnWBXqgvtvtkpOVPYq4MnyZg==
X-Received: by 2002:a63:d0:0:b0:41b:c075:acb5 with SMTP id 199-20020a6300d0000000b0041bc075acb5mr22692638pga.480.1660136604226;
        Wed, 10 Aug 2022 06:03:24 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x25-20020aa79ad9000000b00528f9597fb3sm1863851pfp.197.2022.08.10.06.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 06:03:23 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     fio@vger.kernel.org, vincent.fu@samsung.com
In-Reply-To: <20220808175133.37920-1-vincent.fu@samsung.com>
References: <CGME20220808175150uscas1p29cea1de374da02264662429884c9eedf@uscas1p2.samsung.com> <20220808175133.37920-1-vincent.fu@samsung.com>
Subject: Re: [PATCH 0/1] ci: upload tagged AppVeyor installers as GitHub releases
Message-Id: <166013660312.2208223.11692095298319740004.b4-ty@kernel.dk>
Date:   Wed, 10 Aug 2022 07:03:23 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Mon, 8 Aug 2022 17:51:49 +0000, Vincent Fu wrote:
> Jens, here is a patch that should allow AppVeyor to upload Windows
> installers as GitHub releases. This will require you to change the
> authentication key in the patch to get it working.
> 
> Here are the steps:
> 
> - Go to https://github.com/settings/tokens and generate a GitHub token
>   with public_repo scope.
> - Go to https://ci.appveyor.com/tools/encrypt (and login) and encrypt
>   the GitHub token from the previous step.
> - Replace the token in the patch (under auth_token: secure:) with the
>   one from the previous step.
> 
> [...]

Applied, thanks!

[1/1] ci: upload tagged AppVeyor installers as GitHub releases
      (no commit info)

Best regards,
-- 
Jens Axboe


