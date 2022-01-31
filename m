Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9503EC433EF
	for <fio@archiver.kernel.org>; Mon, 31 Jan 2022 18:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343914AbiAaSSl (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 31 Jan 2022 13:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343549AbiAaSSl (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Jan 2022 13:18:41 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502CBC061714
        for <fio@vger.kernel.org>; Mon, 31 Jan 2022 10:18:41 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id e17so4919743qvb.8
        for <fio@vger.kernel.org>; Mon, 31 Jan 2022 10:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZZGJxbXCsLD7BmOIv2SfNKT5DLUnSfPBiy6n4fo80Jo=;
        b=T/1mQN0mwFaNtYyrY4SXhLYPD04HGKmTaj3X86zNa+WSMqdsjouZfVLMI3Im0LZdzs
         NJjkGSOUJfK00BA0KbOUlzRm/TF0adXjfE+vIe1K2NO3Zccoj3caxeUFfkb5W9wqF8pz
         +5EXsRVwoqeXTcMx048NOS6f9RAYh9U3ChutaIhXRCwebFWtr2jx/4EIME8+XOPXnxS2
         rP9dkpcTLsbLx1HDsT8o04eF+qpvwPU0FTVdZeljhfO5fA4HrRF1kDNO0eQ2l3dc5o+f
         WqSgHIkRz4H/0QaJt25Yldt5hywIv90YEjkd1tyQXxzX1pFqIZG79+phWC9x8fdQtfrx
         CqKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZZGJxbXCsLD7BmOIv2SfNKT5DLUnSfPBiy6n4fo80Jo=;
        b=EEl1+V5m4AUoXKF/wpw+WnKXhm5N31/qacDHR65XwgaVBwk2ADyi9O0KAO25fKuD9D
         yV7jMi63yO46pesJV23o9i+AhoAvBhWfRWedfW4bsj/2tr0TdZ2iZ5GoDqadmR39Yt/+
         uu7K+4YGEq9QrGoD3pR11xRtKK9Jspw+W4HPmKPtPP/xkn84/V2KKx9cFkPRnWkWLOeu
         lbn9zf+7UeH2nB3to+eh0h73Tl4XpuDF4eQRve82eK+NeuPJx04b7Y4Wd+ETYtxASEv1
         2Y98ky2HNM11IrwOww16hXXtPY3i4MMualvyMrK5ZEWis2y/mb+PNHt6927Sk0fTpg/B
         NAvA==
X-Gm-Message-State: AOAM531ljrBpzh/iOHpINwr+u9TXvB4mISCjHO8HRKVzhAZhagL8tMSY
        UxD3nv6430rPfFzakYBPrx99BXVoRON7gFHE/X/U28O5RHA8/A==
X-Google-Smtp-Source: ABdhPJwApvcORHvyGTQrg0irexnn7oBLHiseyZN8WDHZAoHRHjhC8X1uR3axxSCqPzZhHZlhtkHRw82mgdeMbzjWz0g=
X-Received: by 2002:ad4:5dc4:: with SMTP id m4mr18874369qvh.54.1643653120329;
 Mon, 31 Jan 2022 10:18:40 -0800 (PST)
MIME-Version: 1.0
References: <CADqNVTpfbX2WiuzUxap5iOEaBJV0H7nup7b78acd9BAin4DAfA@mail.gmail.com>
 <83721719-aeb7-2a64-2cd2-ccc9b5b2113e@opensource.wdc.com> <CADqNVToqmzWAkkxJxe4r9M05H6ZcYRffG5pvdiHUuERMS8ojkw@mail.gmail.com>
 <7a3e701e-e3ab-4dc5-2326-387d80c38061@opensource.wdc.com> <CADqNVTozhnoDrAhpcwWn+_3gPgUS8DnrLrrbtMjeGiuwPvSyjQ@mail.gmail.com>
In-Reply-To: <CADqNVTozhnoDrAhpcwWn+_3gPgUS8DnrLrrbtMjeGiuwPvSyjQ@mail.gmail.com>
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Mon, 31 Jan 2022 12:18:28 -0600
Message-ID: <CADqNVTo2ubajMw9Kmibh+rKhwxpg1460mVsFSrNjbbO-X_trng@mail.gmail.com>
Subject: Re: A fio job that just waits?
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Jan 28, 2022 at 5:09 PM Nick Neumann <nick@pcpartpicker.com> wrote:
> I was hopeful it would
> work on windows as well. While a cpuio task runs fine on windows,
> there is something wrong when you try to run a task after it.

I went ahead and filed a bug for the windows-only behavior where two
different engines don't get along:
https://github.com/axboe/fio/issues/1331

On Sat, Jan 29, 2022 at 12:52 AM Nick Neumann <nick@pcpartpicker.com> wrote:
> In most of the cases it seems like the ETA is confused by the behavior
> two.  ETA jumps instantaneously from 15 down to 10 when the first run
> of foo.fio is complete and the second one begins.

Thoughts on filing a bug for the original issue with the startdelay?
On the one hand, the current behavior seems wrong, or at least
unexpected, to me. But on the other, based on how the code in
backend.c is written, unless it used to be structured very
differently, I imagine this has been the behavior for a while. There
could be jobs/scripts depending on the behavior, so I wouldn't be
surprised if changing the behavior to what I want/expect isn't really
an option - instead the best I might hope for is a new option
(interjobdelay?) that provides the behavior I want.
