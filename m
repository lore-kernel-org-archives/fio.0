Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF473C6FA82
	for <fio@archiver.kernel.org>; Mon, 12 Sep 2022 21:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiILVA2 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 12 Sep 2022 17:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiILVA1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 12 Sep 2022 17:00:27 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C3D13E0B
        for <fio@vger.kernel.org>; Mon, 12 Sep 2022 14:00:25 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z13so673109edb.13
        for <fio@vger.kernel.org>; Mon, 12 Sep 2022 14:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=JO++8qgNmw8S50xdWbA/OKCJFOLjYs6W+RgMXLPJqEE=;
        b=IAnnJgr53PD0pWO80hLnLBKITzW9wAAt6xx20trv6PzzPauk0HXMv6upmpjFd5OYdN
         0sxkvQbA3rweSgCDlTa5+9Uc5HV0P+gnXDlNrx0X9r7OKzoDLqT+jl1WOMd43r0E59fQ
         l6f1fRqFO/WLaCGSmvN2dqlsIhyUOCElgwLYx9j0w38E3CCnjmAFYplZWdYsy+im2f9a
         TIJ22NEV2y6+0BNxkKXiBblZ0FiK/L1crCOlDTDQRxVUEwmMqr8mtaIZeLMwcsL36aNK
         pGG5l13N6ySQgVHToe/4eiAg0/p5632eFQc8AaVBnq/09jA/sG37Ih7H5e7R0mtQFJSp
         2Ojg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=JO++8qgNmw8S50xdWbA/OKCJFOLjYs6W+RgMXLPJqEE=;
        b=jHa/CwyDOETqE8su0riD8gCU23anYLTxz9pdl42jh5eLyvZl72xXHLUCVINCHmVpS/
         AdnJmJhK0Hz6cxAm4h/+iddnTRgJ3e0mnUpymRM5Ei3JRgkAmfV3tZONbYT3GEyhTyPd
         7ckjlfzN/lax64Fo14wHgBQTpHw0g+b0fEwQaC4AwaQ+8MWKuqBQqbur8z/7+GqgO8+f
         4Nov+F1ModaCmnEb+Uq7NnUyfSkkyuIYff2kKTuFK7M25nNEU43HaF3UMlonXGaEhMMu
         3UMzZ1TKGCko2L5v5v51S9+atoIUkdk5H81LcsjksPGVd4g3aUELiqYL6dFSNJTR+tLe
         5R9g==
X-Gm-Message-State: ACgBeo1T5uaDqXbYNlNrWkDnF1CsRqaMS9ANb2CQF5G0kHzqDCMK601a
        XWd/nRcTL+jmrAgzyIkhZdT3uPzGdulPvFqvsbZAP8Ek
X-Google-Smtp-Source: AA6agR46SeBdLrhAU7xhtL4QI4xFYKp4NXxPf7flmyWYFsyg+ujlLjC93hd35Fa1n9nz7OjgxUaMqdEdnGFWp+c012E=
X-Received: by 2002:a05:6402:5243:b0:451:6d52:5928 with SMTP id
 t3-20020a056402524300b004516d525928mr8971621edd.328.1663016423844; Mon, 12
 Sep 2022 14:00:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAF+0mvkU08G6DJnvpaRcwxkMKLzQGcrYO_-EyrPz1NxN0ZUOhA@mail.gmail.com>
 <051fc206-3dfa-262a-ae12-c53d148d69a4@gmail.com>
In-Reply-To: <051fc206-3dfa-262a-ae12-c53d148d69a4@gmail.com>
From:   Matthew Eaton <m.eaton82@gmail.com>
Date:   Mon, 12 Sep 2022 14:00:12 -0700
Message-ID: <CAF+0mv=LAr7Y2ChE1=1aCBDiwxUx7hWUgJBga45gZ2DSiCaNnQ@mail.gmail.com>
Subject: Re: Fio latency reporting
To:     Vincent Fu <vincentfu@gmail.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Mon, Sep 12, 2022 at 8:10 AM Vincent Fu <vincentfu@gmail.com> wrote:
>
> On 9/10/22 03:05, Matthew Eaton wrote:
> > Hello fio group,
> >
> > I'm doing some analysis on latency outliers and I read that fio can't
> > report latency higher than 17.2 seconds. This seems to fall in line
> > with my testing as my logs show latency outliers max out at ~17
> > seconds. Can anyone confirm if this is accurate?
> >
> > https://fossies.org/linux/fio/doc/fio-histo-log-pctiles.pdf
> > "Note that the highest max latency for any bucket is 17.2 seconds =
> > (64 * 2^28)/1000.0 ."
>
> ~17s is consistent with this comment in stat.h:
>
> https://github.com/axboe/fio/blob/master/stat.h#L48
>
> 2^(29 + 6 - 1) = 2^34 = 17179869184 ns
>
> If you need to measure longer durations you should be able to just
> increase the value for FIO_IO_U_PLAT_GROUP_NR.
>
> Vincent

Hi Vincent,

Thanks for pointing me in the right direction. I'm taking a look now.
