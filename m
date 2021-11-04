Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE469C433F5
	for <fio@archiver.kernel.org>; Thu,  4 Nov 2021 07:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B491460EC0
	for <fio@archiver.kernel.org>; Thu,  4 Nov 2021 07:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhKDH4k (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 4 Nov 2021 03:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbhKDH4k (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 4 Nov 2021 03:56:40 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47FCC061714
        for <fio@vger.kernel.org>; Thu,  4 Nov 2021 00:54:02 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g10so18178974edj.1
        for <fio@vger.kernel.org>; Thu, 04 Nov 2021 00:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=upcloud.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=05gg2/xKS0AQyqyB4M4b6JlSEqhp28MlCzUbyhnNQTQ=;
        b=c1Lx4Qj5DqsY3+2WQfRzdgt+bLylcubbGobb/2p/c7V3zKt1xrmrNZe3f2MA6VKlUf
         6l7B+wj2ZRhIKelUcPyg7iOpNfzt3PmEMZ+pZVR/RoRV/vMoPvjucC/dgdR7c79R0BiX
         YANaquRM8u4m5m3JwY+Ubk+nskdg5Hg/4vYx8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=05gg2/xKS0AQyqyB4M4b6JlSEqhp28MlCzUbyhnNQTQ=;
        b=IA3X2rN4pY5CvrglK59OFvB9XjNLXvf23bn2yosOVVtDWhxrsBQOwSyEJgG/Tjxhpw
         G/9QAoh6PHnI3v4D3QCMmfM/meenr2MqonLDu9CaMmzjJ/6THHoYtTcEKyJLf4jgEPfu
         LJiaimUKjfsEc22MlTfjZhv14PK3yssa4JtQ9GcAE1Ev7Mv2AvbkMAZn8pcUzINmqr8I
         kULS4WwZ8Wi6A0Vkg1yPuAXX+HzHYu8ZBDnD1bpo21GNIeI3vkkuQO8p4ABuEKFcXn4n
         +VC9bQVCJgGdzuz0rktcL3jZVphC97ssEwfepzaxdL+pMw0IfyNl73YTSM/y3SbE/RtK
         r0VA==
X-Gm-Message-State: AOAM533sWAzOT4jaDXH+zyh/XcfRfsUFUs1sfT0VwTk+08o0ZupMKBCj
        WvCdE3pQxb4FSRNLK7jgMjbSVY3dnRpQJ4vFB2BGTmHBQ10iCM0=
X-Google-Smtp-Source: ABdhPJxgas1Pwr6S3ZBM4bJJE2UclCydcK6PsQtNyKkxcjked4foxA2nIsMNjo+b5I5kjPo4V0z9Wpj4OkXyPFYtmVs=
X-Received: by 2002:a17:906:144c:: with SMTP id q12mr10797065ejc.72.1636012441088;
 Thu, 04 Nov 2021 00:54:01 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Ville_Skytt=C3=A4?= <ville.skytta@upcloud.com>
Date:   Thu, 4 Nov 2021 09:53:50 +0200
Message-ID: <CAOdXSVR_qaU2q1YcBFC3DxQSS+2O-rs0nEFehBs+EC8EC5jT2Q@mail.gmail.com>
Subject: Predictable glusterfs log filename in world writable /tmp
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hello!

I happened to stumble upon this:

$ grep /tmp engines/glusterfs.c
glfs_set_logging(fs, "/tmp/fio_gfapi.log", 7);

IIUC glfs starts appending to that file if it exists, which would mean
a vulnerability to arbitrary file append via a symlink. Briefly
discussed in private mail with Jens, agreed to send here for info.

Cheers, Ville
