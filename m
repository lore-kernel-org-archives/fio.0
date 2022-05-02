Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D7E7C433EF
	for <fio@archiver.kernel.org>; Mon,  2 May 2022 13:38:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385334AbiEBNmZ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 2 May 2022 09:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385368AbiEBNmY (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 2 May 2022 09:42:24 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59262FD3C
        for <fio@vger.kernel.org>; Mon,  2 May 2022 06:38:52 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id v139so13654349vsv.0
        for <fio@vger.kernel.org>; Mon, 02 May 2022 06:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EnbdrycYVjoD1WKKfrhmzi55PxowLnRhNpWE9r9Xu4s=;
        b=NheQ40k1SWn1nZzKBru+LLtdPybPFiduk2fSaG0YIXVnckZeqHGDIhd+puEfUzfE5k
         +9XX2iMgwtlD1DYe0dNMLhAQMrDqI4AcX+ax5EndRmTV44gSuSMVFbAn3B4/h6rjOuT5
         GWKYAMqewb1kG8Mf8x/bvSTPbBm7fwC86gV8EOGFgxqUD7LAKDmQZQrTvsyoFi2EmCTH
         41pEMb7qLgw64G65M/UIoM0XdY4qdBuAHYVryp65zFAnBTXbcBgmTGzOZd6TG+sRgNku
         iyL7Aggq6E7XBw9/yNfLqd8h+UqjVglDq8TB8vmRoFXLlYkZ274KcSjZQzYRFbga/aon
         f4hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EnbdrycYVjoD1WKKfrhmzi55PxowLnRhNpWE9r9Xu4s=;
        b=QXs/9bu9oeglPjl4u1DIWCR+mjC9/71qRFxRoHYuCoOUsCpmqiFHGaPJhYb+zjnlci
         SN7qyeJyZYkTBdcyE/r8Px8zXT931l058hs0Rz23VuvTcZn9lNHLI8tMQywrTwGc7Mff
         Hn0NhWarwdpjV9IB9OCzlLxrTRgveyFFaRGDHOuwAGuYmBUsOXbCjPy0UWouRKuNGf2a
         TYmJMlI5xuq00snI2vlEpb23OzF0MgADIrirXUT0HoNob+3l/u0cwx1VrWqUK4uOJ+23
         HKK8yXfTeTG2njeO4pF6zJLq9Jo2bXfejgXgD8JSftwcURyCHyBAUPAdsHqCfJyoKXeH
         ypHA==
X-Gm-Message-State: AOAM532G8TNZFs19Law7FD4bKY/ZoelxqYLhrhuqLAW2eh1RabMh91lF
        zYFeG3tV1ttPK1GzvYhm+zd6XNTzCvM8DGh14JJa7kiM
X-Google-Smtp-Source: ABdhPJyV3x4t0uzO/QHR/ociEBIt+Kb4yq7Y06RX3LBn0y2l2h36ijGf/Cqkcs8phQF5/1Ivgn3DaMslCDYRTSdaaws=
X-Received: by 2002:a05:6102:1161:b0:32c:d856:d1ba with SMTP id
 k1-20020a056102116100b0032cd856d1bamr3208948vsg.12.1651498731458; Mon, 02 May
 2022 06:38:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAH0a3kZD0L8otacwyOY=Ek0phxVfYcB+ZPEq0pfhVS5oaZ+Wgw@mail.gmail.com>
 <6e6da881-6c3c-965f-e2cf-caa5a0b5c16a@opensource.wdc.com>
In-Reply-To: <6e6da881-6c3c-965f-e2cf-caa5a0b5c16a@opensource.wdc.com>
From:   Sagi <sagiahrak@gmail.com>
Date:   Mon, 2 May 2022 16:38:40 +0300
Message-ID: <CAH0a3kaoan+Dx+PDpVnAW_nPFY_bXJrob+ezRWWhzBfjdfFo7w@mail.gmail.com>
Subject: Re: http engine dependencies?
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Awesome, thanks!

On Mon, May 2, 2022 at 4:34 PM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
>
> On 2022/05/02 21:44, Sagi wrote:
> > Hey!
> >
> > My name is Sage and I=E2=80=99m trying to use fio with http IO engine (=
s3).
> >
> >  On fio configuration stage, the http-engine isn=E2=80=99t being instal=
led.
> >
> > I was looking in the configure code
> > (https://github.com/axboe/fio/blob/1588c8f571f67a004571e51cdbb5de97c3e4=
f457/configure#L1818-L1826),
> > and tried =E2=80=9Capt-getting=E2=80=9D libcurl4 or similar packages I =
thought would
> > be relevant, but I couldn=E2=80=99t make the http-engine work.
>
> You need to install the development packages for the libraries too (e.g.
> libcurl4-devel or whatever it is called on your distro) so that the libra=
ry C
> header files are also installed. Without these, the engines will not be c=
ompiled.
>
> >
> > I'm using Ubuntu OS, would appreciate any hint or help :)
>
>
> --
> Damien Le Moal
> Western Digital Research
