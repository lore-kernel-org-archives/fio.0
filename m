Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E511C433EF
	for <fio@archiver.kernel.org>; Tue, 21 Sep 2021 08:06:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D57D760F70
	for <fio@archiver.kernel.org>; Tue, 21 Sep 2021 08:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhIUIHK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 21 Sep 2021 04:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbhIUIEx (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 Sep 2021 04:04:53 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402A9C061757
        for <fio@vger.kernel.org>; Tue, 21 Sep 2021 01:03:22 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id bx4so26624268edb.4
        for <fio@vger.kernel.org>; Tue, 21 Sep 2021 01:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=gLSmKuYK/4xwRF19M4AewtPkhCvrJJvAXaL5CpQU1s0=;
        b=WbaFwr+t76xIEquepTgg8hZ86QK0IKpY0qp/QqtrAt76uy6pQyuHUyLu2ec9fJPqfD
         SD66+xqv2q36F/GOCRkjs13aRJNhCYrVwWDfxRnx5lVyoSa+j6PUZVferZxgcf/AhqN/
         9OcyYzQfRQoxS1wF1XkPtRL1h0eB6aRtD3V+7D1Fw0sjfr0E8fjOdmpCOsCzmaIkEqJE
         wL/g1aWGBygYlVfaZqFuLMk9PNifGIYbgCcfecZFJO5yll7hyofWAqmES+6+O5W+aSTU
         3+430a60gHCz3Pe7TFlFdHgjyHwzWpOcACZx6PW7NftXC+5/HS0l0192XdNceqxnbefL
         UWjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=gLSmKuYK/4xwRF19M4AewtPkhCvrJJvAXaL5CpQU1s0=;
        b=vRVHDN7iUH1ggK6qOAcuMIjpQT37rNDDeFMSzp9dA15YswcpEsOwaju39rRnfydc+m
         R9GlvaD0acI8Kt0Sl8PZs6c5JzEReI7bwr43gpH6xg3LRmW4Q8sWLnxPRBBx1LcmQXH4
         tirfT8ld4u1MZfyaT/UGBpi26uLiwukTrJdIIVwKPnrzB0hJyZPVyTh84gmKhU6BCQuR
         RU6Jumbx/pwbtEHs2qFjRIAmpZMG2LOgXAePV8oZ0iqyIFiH70/JW0JMdUA/EoVJTSEh
         MPeGHXjwTelp8D4GhPOFdN5HKm/Ar02wkEqXBuXqiTYiKXAMu5J9f2gx5Tt29lsaHwfG
         uxKQ==
X-Gm-Message-State: AOAM531UC5yVKlJOBkm64Pa7cX06Kr6m5rAJ9RJhyMY+AmyycAf845li
        XA9Te+wpDJGxkyTNhXtC3DbZFzDZv9Q=
X-Google-Smtp-Source: ABdhPJwa+3hQgC1rQj1rd8f2xawAq4pv3bMo5xj0glXUJyjkJdqxWFvxF0IvhgmfLEUVPdkkKqHaOA==
X-Received: by 2002:a17:906:7847:: with SMTP id p7mr32599107ejm.335.1632211400590;
        Tue, 21 Sep 2021 01:03:20 -0700 (PDT)
Received: from smtpclient.apple ([94.134.250.199])
        by smtp.gmail.com with ESMTPSA id k16sm4613870edr.33.2021.09.21.01.03.19
        for <fio@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Sep 2021 01:03:20 -0700 (PDT)
From:   Houkun Zhu <diskun.zhu@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Weird Throughput Pattern in Fio
Message-Id: <2C1E8E62-03D7-4613-A54D-EED6262C3221@gmail.com>
Date:   Tue, 21 Sep 2021 10:03:19 +0200
To:     fio@vger.kernel.org
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi guys,

I=E2=80=99m using Fio to generate workloads for Lustre. But I found a =
weird throughput pattern, it always has good performance at the =
beginning and then drops and remain at lower speed. As it is shown in =
this figure from telegraf collected data (https://ibb.co/Mc4hw4B) , the =
throughput suddenly drops and remains at that low value all the time. =
Did I set something wrong?=20

PS, my workload settings:
[global]
fadvise_hint=3D0
direct=3D1
numjobs=3D6
iodepth=3D32
ioengine=3Dlibaio
directory=3D/mnt/lustrefs
size=3D100G

[job]
runtime=3D2d
time_based=3D1
rw=3Drandrw
bs=3D4k
rwmixread=3D90
------------------------------------------------



Best regards,
Houkun

