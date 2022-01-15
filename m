Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 948FDC433EF
	for <fio@archiver.kernel.org>; Sat, 15 Jan 2022 16:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbiAOQE3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 15 Jan 2022 11:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiAOQE3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 15 Jan 2022 11:04:29 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07607C061574
        for <fio@vger.kernel.org>; Sat, 15 Jan 2022 08:04:29 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id s6-20020a7bc386000000b0034a89445406so9519971wmj.2
        for <fio@vger.kernel.org>; Sat, 15 Jan 2022 08:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WHH+KhB0N7pyMVetK4aO0aHefUQOqFsS9+YCHPETSI8=;
        b=OVRSBus8HEDPjN/dDTvfOAR+g/JuJZTRAYY1u0CuEb3KhVZ9ImiqJsX/qLYLgt/jxf
         6AKmyUXTDIm+qOtdwww/pfTb7rROcj95DYshDWZMYfAzZIT3XI9W2qPUXBdYhEY7xWtM
         W8wxs5fXV099gAXqG+p8jWCmL4tKw3PfDyznR7AAZdDil9f29tv6Qn0ZeXvsm6QMGADk
         7PTjv484XFdf4RO6yLO6licoXJmh3Jf6U3ZOTqnCeVtFNI6EzChJk3szvUKLovTyKRPX
         r7zyXo8mOVPS5Ey/IFjniLRC9f2r6h+83NWx27w/NJw3WtIKIvBPZA4MgZBmr1PsNJ0N
         PuvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WHH+KhB0N7pyMVetK4aO0aHefUQOqFsS9+YCHPETSI8=;
        b=mAueKar3NRnqi2mVYqK0Bk7Z63GIG4ePUtPvSEmeyp63LnmCSfnY+rYDn2M9r3bLuE
         pLvVa+wKKLsxg5QY8k779oSXdfolRP3XAkU/GIzxKOmXaMIBYO3oIKZJYnkXK8WjVaRa
         A4XP2keeh3y4JEYZCKCSflRiy3g1i+GHgJfJ64wkSvTtUjJghcnE2sSGWGxlXZGKt7EB
         vPUsdZq+toTnmOGMb8pa5yi7ILj0zMBEIpkFIgw/hBl6AhetmG1EUSIyH6Z5GFSa65FR
         HWU+2nnrHWpjQKaCNfrZdtxCIS7y2MuH1x+PlqXMg3+xiUE0RXj72wddZzwkpRq2cXO/
         Pwtw==
X-Gm-Message-State: AOAM530mgq1DKLJ8V0b69ly31NSOiJpumEQXo/RASvIvdi2sO5IWJvzW
        ZDitYq02e6dRls//tvFfQ4GRs0fSSEbnUPwJ8ED6gP9Shmk=
X-Google-Smtp-Source: ABdhPJyPHEQbnBpH6tHTuqaNgtLQSBPqZgmkyo3+uXuVFYkt+Ywh0PvlSnspHIHDdow5meZ6Bw8wXXcYeqFME572NVE=
X-Received: by 2002:a1c:f718:: with SMTP id v24mr20217138wmh.186.1642262667611;
 Sat, 15 Jan 2022 08:04:27 -0800 (PST)
MIME-Version: 1.0
References: <SJ0PR84MB1434F97AE046381C181A3514F4529@SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM>
 <SJ0PR84MB1434CE895980F3953C93BA6FF4529@SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM>
 <SJ0PR84MB143421DA1431C54AAEA77699F4529@SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <SJ0PR84MB143421DA1431C54AAEA77699F4529@SJ0PR84MB1434.NAMPRD84.PROD.OUTLOOK.COM>
From:   Sitsofe Wheeler <sitsofe@gmail.com>
Date:   Sat, 15 Jan 2022 16:04:01 +0000
Message-ID: <CALjAwxiV7s8FgH7c4K+2zWEU_8Ds_XKntr1GF-NPujDfd9gfEQ@mail.gmail.com>
Subject: Re: FW: re; fio / test result diffs
To:     "Gibson, Thomas" <thomas.gibson@hpe.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, 13 Jan 2022 at 00:57, Gibson, Thomas <thomas.gibson@hpe.com> wrote:
>
>
> My company builds SDWan network appliances and use SSD's and NVMe's for s=
everal key purposes.
>
> In order to qualify upcoming new disks for our systems, we typically run =
2 hour test runs using fio, for the following:
>
> seqrd, seqwr, seqrw, seqrd_seqwr
> randrd, randwr, randrw, randrd_randwr, randrd_seqwr
>
> We've noticed that single disk mode tests (ie seqrd, seqwr, etc) show hig=
h numbers than their counter parts in multiple disk mode tests (ie seqrd_se=
qwr).   But we don't understand why.  This may part normal, but we don't un=
derstand how testing functions to explain this.  And if it's not normal, wh=
at factors might account for it.
>
> I've include a table of test data below.  You'll notice, as an example, t=
he seq read and seq write numbers are much high than the seq read part of s=
eqrd_seqwr and even high than seqrw.
>
> I've also included a package of fio and test execution files in case that=
 helps.
>
> Also prior to each test run, we do a prefill write to the disk and a clea=
ring of the buffer cache, if that helps.
>
>   FIO            SSSTC_CVB-8D120_FW_CZJG801
>   Seq Read                               533MiB/s
>   Seq Write                              317MiB/s
>   Seq Read/Write                   138MiB/s & 138MiB/s   ;  why values ar=
e lower here?

An example job from your tarball (included here because it's easier to read=
)

; Random Read,Sequential Write
[global]
ioengine=3Dlibaio
direct=3D1
iodepth=3D16
randrepeat=3D0
bs=3D256000
time_based
runtime=3D7200
log_avg_msec=3D500
[SSSTC_CVB-8D120_FW_CZJG801_2ndrun_r640-RandRd]
filename=3D/dev/sde
write_bw_log=3DSSSTC_CVB-8D120_FW_CZJG801_2ndrun_r640-randrd
write_iops_log=3DSSSTC_CVB-8D120_FW_CZJG801_2ndrun_r640-randrd
write_lat_log=3DSSSTC_CVB-8D120_FW_CZJG801_2ndrun_r640-randrd
rw=3Drandread
[SSSTC_CVB-8D120_FW_CZJG801_2ndrun_r640-SeqWr]
filename=3D/dev/sde
write_bw_log=3DSSSTC_CVB-8D120_FW_CZJG801_2ndrun_r640-seqwr
write_iops_log=3DSSSTC_CVB-8D120_FW_CZJG801_2ndrun_r640-seqwr
write_lat_log=3DSSSTC_CVB-8D120_FW_CZJG801_2ndrun_r640-seqwr
rw=3Dwrite

What does fio's summary output look like for that job? On Linux, fio
prints disk and CPU utilisation information in its summary when the
job finishes - what does it say? Alternatively take a look at the
"iostat -xzh 1" output while the job is running and see what the disk
utilisation is like.

--=20
Sitsofe
