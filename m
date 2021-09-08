Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3116DC433EF
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 20:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11F466115B
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 20:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbhIHU2A (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Sep 2021 16:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbhIHU17 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Sep 2021 16:27:59 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0791C061575
        for <fio@vger.kernel.org>; Wed,  8 Sep 2021 13:26:51 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id 62so2133087qvb.11
        for <fio@vger.kernel.org>; Wed, 08 Sep 2021 13:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=CO9tvCv2cWu3iyVeuMIDOG6PDFl0+Shgl/30MLp20lQ=;
        b=hX9pZnyPtMCWPaV43+m0jHOrVxJtvIBBZE9z35MGf2atkKxIosls6CDvyx/qKrqiDH
         K7BJOv7RmhcOBQ+BGc8TyppHpDxdY8iXmGRmlIKGWx1nFll8xTAF5jyQ01HmMNzHxlAU
         XBpFrebdySjrGDsMeuVDzRfw0M+qiUHN2y+ag=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=CO9tvCv2cWu3iyVeuMIDOG6PDFl0+Shgl/30MLp20lQ=;
        b=4FmWydRLWzAySZN3yCTSgrw+rjyycASIXFr4zrbrJMMgXVE4lEdQrOCPvmW67/yGTp
         IxWYwHpbi7CFXVfj4NHZ/BCFe4716Opoj/Yif0MD+vSFp24Nn/D8d+fYT3MdO4lJQWKy
         ytEDTvLtnGQaTUq2DiNTN0ek63X83cV+rrR22Xp1EYMh496Tn2gtw2imoHsnht+3ksZs
         t6j04h4PmXsekI5eD4c4xHouLncBr+Lbm1OPfDNHEd11cPUM2+eSY3uhUbom+ph8LAA6
         x2amsc4i0Cn9MKeX7rcxM2u/jF0TWgawl/Ja5mhb1On8hf2bd+ylEh8UZbRlgSVbvDpb
         ZqCg==
X-Gm-Message-State: AOAM5311wrfBZbusS8JV0N2bZinEsgCPF+bKBgR+/5J6wCHuzGiOH6d8
        f4GIq2uFEt1aThmkHgbZGgrNxow2PDBu7g==
X-Google-Smtp-Source: ABdhPJxiuWK2CzrdJbyZ1/0JZm0uBPVRUhOdEZNRIa3DJcnE77rVBpmgRaQLpVwu7Qq1M+hv9KyM2g==
X-Received: by 2002:ad4:5bea:: with SMTP id k10mr194349qvc.23.1631132810596;
        Wed, 08 Sep 2021 13:26:50 -0700 (PDT)
Received: from meerkat.local (bras-base-mtrlpq5031w-grc-32-216-209-220-181.dsl.bell.ca. [216.209.220.181])
        by smtp.gmail.com with ESMTPSA id t188sm170763qkf.22.2021.09.08.13.26.50
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 13:26:50 -0700 (PDT)
Date:   Wed, 8 Sep 2021 16:26:48 -0400
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     fio@vger.kernel.org
Subject: Test delivery to lore.kernel.org
Message-ID: <20210908202648.ady2e5zaeuti3kmw@meerkat.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hello:

This is both an announcement and test of delivery to the lore archive for this
list, which can be found here:

    https://lore.kernel.org/fio/

If this message shows up in the archive, then everything is working correctly.

-K
