Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A74C4C433EF
	for <fio@archiver.kernel.org>; Thu, 10 Feb 2022 23:08:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345403AbiBJXIa (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 10 Feb 2022 18:08:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238904AbiBJXI3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 10 Feb 2022 18:08:29 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE912C66
        for <fio@vger.kernel.org>; Thu, 10 Feb 2022 15:08:29 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id o12so6555179qke.5
        for <fio@vger.kernel.org>; Thu, 10 Feb 2022 15:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U4WJX9CwgR64onSn+0HZB322kfbdhpQsQJ9BT4ZF9VI=;
        b=oylPX5v1jDr2KVmHNsKPr8kWJ2AzNbmG7+5oTpiNS4ChQQLXnpZmp247uMgdhkgF7j
         sTiYx1qhM1i0oF+iACWgejdeo+m9jTFCBbHJW7d9GskHiO+FSB6ifNJtqGe+LAvdQmee
         QduE5/sueOhd+UGJ3fvUeU0Vn/6NCo8HKGDW0xHkJwePV8ekg86GHjHMJwUOCfIg2sj3
         r5f3Kvn+wRSr0OLqWV+9fYABU1lAs+0AiACi/p40RX394+nBYhZyXs76KaD9Xc9DRoAW
         5mP6uxMIBBaKocpiRpEtTtKlsfY7ChJhpvvHm+3GXnUupqW5wO8caJebUymyiSMd8Fvs
         T0LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U4WJX9CwgR64onSn+0HZB322kfbdhpQsQJ9BT4ZF9VI=;
        b=STIO+Bqjwi2Tr7xZkHNazqvIzJlVSwvP0i8MPaDBEiUECgg+p4kUPkHBCCuM96+UjX
         BqDZ4Tur2CvPGPDWRw/4mj2emXiv/4lagWCHIEOtUCyFz2mGnfduJpTcWoLBkdheND8l
         rzlNxcrm8++xlB2373rx5gt0AVoUp4BxhmcIEgdFapKm+qy25OF3Lu/wz1Uy1h3DnDbZ
         SdHt44bP84qvXAw/Vp4Nxh7Fl9W7NbdJT4D7gTRlYdRUIZpWSrF64aZEgOGiT+B0LGgX
         3TMvrR4acO47RkiJ5h/M5HCLDYVKEZv9n8w9PhL/YMixdCQ7BuLdO/FRUpBSNvlUtcTZ
         culg==
X-Gm-Message-State: AOAM5338xkd/pZSVQ4+7FwRV5uot7BMQ1hlCTWKI7UXwekF63G4Nr+eW
        kQKjeHscpee7/e3fvcMHXUzMtMbu07BlPg7lCRlZLQ==
X-Google-Smtp-Source: ABdhPJzKrk3FKaD5/heXPeLCVJRwUx7QhWJ1HLOzFQmBlQv27vcLfAMpAQtEm3tfmi5naDd8EJEHkNp4NpwpRBnD+rE=
X-Received: by 2002:a05:620a:4251:: with SMTP id w17mr4949999qko.284.1644534508996;
 Thu, 10 Feb 2022 15:08:28 -0800 (PST)
MIME-Version: 1.0
References: <CGME20220208010644uscas1p132e264f9a90c2e515846440393203738@uscas1p1.samsung.com>
 <CADqNVTrbc+gtK1PuLLZqaGTTeppXckTP-TFPaRT__iF63+f3Kg@mail.gmail.com> <65c1d4d55d0a41c1934d46b2c09dd9a6@samsung.com>
In-Reply-To: <65c1d4d55d0a41c1934d46b2c09dd9a6@samsung.com>
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Thu, 10 Feb 2022 17:08:15 -0600
Message-ID: <CADqNVTo7oQKPQb=Thd326YwT+8sgfmXAG6MK6ooVkJgzkxxbuw@mail.gmail.com>
Subject: Re: Odd (wrong?) behavior with :<nr> suffix on readwrite parameter
To:     Vincent Fu <vincent.fu@samsung.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Feb 10, 2022 at 4:53 PM Vincent Fu <vincent.fu@samsung.com> wrote:
> I tried running with randrepeat=0 and saw the same behavior you did. With the default randrepeat=1 fio will always use the same random number seed for IO offsets, but even with randrepeat=0, rw=randread:8 always started at offset 0.
>
> I agree with your assessment that rw=randread:8 should start at a random offset.
>
> Vincent

Thanks for the feedback on it. I'm slowly getting more comfortable
with the fio source base; hoping to be familiar enough to find and
quickly fix it soon.
