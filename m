Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF8AC433F5
	for <fio@archiver.kernel.org>; Fri,  3 Dec 2021 21:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383297AbhLCVuF (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 3 Dec 2021 16:50:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383295AbhLCVuF (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Dec 2021 16:50:05 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3BBEC061751
        for <fio@vger.kernel.org>; Fri,  3 Dec 2021 13:46:40 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id b13so3012125plg.2
        for <fio@vger.kernel.org>; Fri, 03 Dec 2021 13:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=VMDGUe1dwVF9hJtJ0Fm/O6JacM45Rlj+m7/hZOKZQFo=;
        b=VT7b1svg/ESu5LIyil2HQIJU4NsdhuSX2O7xhwPrKk1D7b8O00Z29MaKVnLN5AFOVH
         Z51922woCp+5bsUeNlTsGJi8xX496dKxZzmgRX0Sc9AIehL//p3BqDbMfI4jaFMajDC5
         IxxinLtw99lWEhX/OqOyhSVlepodu4uA3t6DCbM86GAElksx9/j512NefPFyF92VlKlc
         A+3HrY0Wjbycl9spnOPFeTjuscmzplSeiF2Ah0uOJvkiRp2Rm/Fp0hB9lZguzIvlM7k0
         ngRHs6V6Gx/HhS1oOMApycKmapdVzjiD0Ud0dl18b5YyRy7oqCVKYOgj8o+DYB0iYQDL
         ttbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=VMDGUe1dwVF9hJtJ0Fm/O6JacM45Rlj+m7/hZOKZQFo=;
        b=BCzv7ZDTDPiYwxBCSlg6juPSjheqt4WM+7Gv5zPM5l45KjwxRlgUKs51KX/Kp/RFJD
         reqUm4i+uiPLIB6+qSHMSpgSvVqVXtg1SWyW+Xr5uyeHwt3JK8xo5kZA90pDpFRPeRDm
         ERYrfFeq59i6nZCMFiGFufdG54Ji0WwSbxAV7rYjPHuJ7oUi9mlDwB+kW5AHqFp1u+RE
         tUbUvAqURFSltyd1Z44IqyXKjbGqvT1owpmkADml1px5qBdPuAOzOFwEc8rS0DqhG1MO
         8zThpq8cwVarmKUkR8HjRhKUd6BjOhXu6NvftyYbjAmS1zyIHxUMECi40a52/qiWGQfL
         IQCw==
X-Gm-Message-State: AOAM533edRkiIt9D0aM9/3CBWRg+3VS8Wq7BcS/gEmu2SBTJh3j/9HMy
        vxmPz/gjJx41p/aB4a+LBU5ePAEuztT8/jVJ
X-Google-Smtp-Source: ABdhPJwxKNcZXF5HIq9TU6bAdJeh0Qd+dcXowVLb0P99i1XxwbYJV0uTDOiCAyk4f4udlohFr7SmzA==
X-Received: by 2002:a17:902:bcc4:b0:141:bfc4:ada with SMTP id o4-20020a170902bcc400b00141bfc40adamr25609868pls.20.1638568000191;
        Fri, 03 Dec 2021 13:46:40 -0800 (PST)
Received: from [127.0.1.1] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id j15sm4225713pfh.35.2021.12.03.13.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 13:46:39 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Vincent Fu <vincent.fu@samsung.com>, fio@vger.kernel.org
In-Reply-To: <20211203211050.51241-1-vincent.fu@samsung.com>
References: <CGME20211203211112uscas1p2e92f1c3a04f7bfe27d6fe69d519995d2@uscas1p2.samsung.com> <20211203211050.51241-1-vincent.fu@samsung.com>
Subject: Re: [PATCH 0/2] two small cleanup patches
Message-Id: <163856799961.343715.7693852508365217654.b4-ty@kernel.dk>
Date:   Fri, 03 Dec 2021 14:46:39 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, 3 Dec 2021 21:10:09 +0000, Vincent Fu wrote:
> Jens, please consider these two small cleanup patches.
> 
> Vincent Fu (2):
>   io_ddir: return appropriate string for DDIR_INVAL
>   libfio: drop unneeded reset of rwmix_issues
> 
> io_ddir.h | 2 +-
>  libfio.c  | 1 -
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> [...]

Applied, thanks!

[1/2] io_ddir: return appropriate string for DDIR_INVAL
      commit: 5ea6ec73f15e7eaa4fda497f76fd9dacba36c284
[2/2] libfio: drop unneeded reset of rwmix_issues
      commit: 57fd8dfa7be234bc3a810587c0d0081437786cca

Best regards,
-- 
Jens Axboe


