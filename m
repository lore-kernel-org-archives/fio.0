Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42BC5C433EF
	for <fio@archiver.kernel.org>; Tue, 15 Feb 2022 18:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235980AbiBOSFD (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 15 Feb 2022 13:05:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbiBOSFC (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 Feb 2022 13:05:02 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3F7C1146
        for <fio@vger.kernel.org>; Tue, 15 Feb 2022 10:04:51 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id c189so18023123qkg.11
        for <fio@vger.kernel.org>; Tue, 15 Feb 2022 10:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+N656Ko8ITmpNQrYgkSsBgKznfCtmsDAwoVfKrWBqYU=;
        b=CzCCTWpssYbEwp5CO0IyqKQC44A8vq9WzhxpgO+sbfM5VMNqWczatJ3xrDgOp+q8Pk
         BvzebwhflS/Lo++QSTv85+Kb7h1Dagcq4+7DNwFBGSBI26LdgvQeX7eqM5Kx77BhbWi/
         4WD7V2tT7FJG98+U2UtopIKCr3v9WMtUUukS2O+pLgedVJvry441VuOA9jWcMDM1IVyN
         zMlZEJY1tEJ9d4lFrqRNgXDBkiUiByo9wyRT9gWC1QDaa3qVJGX4CSOlt/Oboyf+9Xaz
         yJPPOZ4GwgkQKfmUodQCLxNMAjMk9WfKpxG/lxhHllHhvaqaRaXNxe4ykVYENNtA0lZa
         VPFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+N656Ko8ITmpNQrYgkSsBgKznfCtmsDAwoVfKrWBqYU=;
        b=s277Ji8XlLcCS20CJUm0h4tCO2CYnJm9D/2kNfzIVrlcJBu8recu8i2wz9shknm2zP
         ZSrhoeAiIkUzRmboaxzBpyFT4jE3qTX9iqVe9mtJeeVLduxnCnvF7G/KwgtkZz9zAdTt
         lxPy2GzkTOrZcXLZ/aACAGVpybwaPHjdmJgpZ+07JBg71gWYZARsAwISrM+yb6kPj44S
         2USPv4/51yZgdRjcjZFimzRLp5H+pK+CSgm48CbdzuoM6HEGgnSmQTMKHMTwh3Jdhj9c
         O84oi5y7Un+gqCOd3ctLboRZOUCR7ZeWiKoCUHt+j+SDFMpOwYkLb20nUIZygqjB1PNJ
         CJkw==
X-Gm-Message-State: AOAM532EFvpWH1TdNHUKEm3Z6kyIENiVOq8vEH0Do9hntfpycWD3eiIZ
        XJ3PZoEnp28nNLIC2eR/PBwv/A8kHA6Wu/pmJrcPbw==
X-Google-Smtp-Source: ABdhPJzGKVx/UAxL8lWzfyR1TI3mhz6xWTUHmzllUXxJ8FCQjLubNbK3gEGD7esKUt/AWejRIryjN+K+n5AgzXnVrV8=
X-Received: by 2002:a05:620a:4594:: with SMTP id bp20mr101790qkb.381.1644948290538;
 Tue, 15 Feb 2022 10:04:50 -0800 (PST)
MIME-Version: 1.0
References: <CGME20220208010644uscas1p132e264f9a90c2e515846440393203738@uscas1p1.samsung.com>
 <CADqNVTrbc+gtK1PuLLZqaGTTeppXckTP-TFPaRT__iF63+f3Kg@mail.gmail.com>
 <65c1d4d55d0a41c1934d46b2c09dd9a6@samsung.com> <CADqNVTo7oQKPQb=Thd326YwT+8sgfmXAG6MK6ooVkJgzkxxbuw@mail.gmail.com>
In-Reply-To: <CADqNVTo7oQKPQb=Thd326YwT+8sgfmXAG6MK6ooVkJgzkxxbuw@mail.gmail.com>
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Tue, 15 Feb 2022 12:04:38 -0600
Message-ID: <CADqNVTovHTKqr7+UcMUL+pDscQb9zZ07i5KUUL4heeNN-oLQWQ@mail.gmail.com>
Subject: Re: Odd (wrong?) behavior with :<nr> suffix on readwrite parameter
To:     Vincent Fu <vincent.fu@samsung.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Feb 10, 2022 at 5:08 PM Nick Neumann <nick@pcpartpicker.com> wrote:
> Thanks for the feedback on it. I'm slowly getting more comfortable
> with the fio source base; hoping to be familiar enough to find and
> quickly fix it soon.

This one was actually a really easy fix. I've got a PR in to fix it now:
https://github.com/axboe/fio/pull/1342

Thanks,
Nick
