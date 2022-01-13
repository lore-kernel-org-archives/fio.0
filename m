Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF44C433F5
	for <fio@archiver.kernel.org>; Thu, 13 Jan 2022 11:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiAMLrY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 13 Jan 2022 06:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbiAMLrX (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 13 Jan 2022 06:47:23 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA05C06173F
        for <fio@vger.kernel.org>; Thu, 13 Jan 2022 03:47:23 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id u15so9383225ple.2
        for <fio@vger.kernel.org>; Thu, 13 Jan 2022 03:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=6inUUsZ2R+RPbWxXVPACizM3x75taQbhXsrZ9fsJQJA=;
        b=KSOtkc0NPrKV87dG0h29crBk8J5Ib/ewSuVyjEcmtV3o2pgoYsrYDDCxZ/8Qur7VSt
         w6uHO50KWZrPxUQCMB/mDjFZzKM1ajINThpAaXgb5nzVsQKYeuTdRgHMWWzFp/Tod42P
         kijCsk+0x90Ug3Dci9qbtk7yKPvQRAXoqOjLPDqL0zbZdHK8tU64U/TnCIeWj6rOJu3Z
         Jz271Hl7ZfGMDDlWwOee6vJT8xYIl4xFxOOkyoxspiVqPqDVM6JdsnB5Iedbw6MUGcUA
         zJuR8x7jlRpez1mDAYE80tHOVf7Hc+0X/UOJ5sSTaKUbt4oMZmjv4XPbQWAAzRHoWKPZ
         cD4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=6inUUsZ2R+RPbWxXVPACizM3x75taQbhXsrZ9fsJQJA=;
        b=awjSCtM/WLfCcoM1xp/k3qHoPaCit934zf3iOONPGyj7F2eM4ifD7n0p5eLduDJvfp
         6YTJHDWiBmL/JUu4sNGlypB4c4b9+bvvOJBsqW7l7Z3hUS5UZ5EIM8ZdMmjOAutpSoWH
         wJwCU/jHH0wCnqJSYUAKlSVmXV8GOap4t5WZ8kp6J9DKahPPJP+8ni2CCi8FjfFg8+i7
         SyqkKJ2x+KJkyzYjLOjlqxvvdGIM6X5j2aUGNLfMNr5XhA6OX0EeUO6KORKmgezt5YwG
         +gqQNuzHmyoEBOskJQMdtKekqWVzf8L/qrZBmxQEfCpMw8jWmseqR/+YYPvlbetQ6mCJ
         ijig==
X-Gm-Message-State: AOAM530YMcqZio+LRz5IgKE8Gbrzknm5b3YScKNXy/nXEy7zwTp0mWfj
        6zsWLOg2dGATyAHnoePAeCC7PWjU9NG+NY3VdRt3KBFOTyXK9g==
X-Google-Smtp-Source: ABdhPJy3mXLEAgsxyR1b+0fHHTSM5oCjxim6otxztPFrU6Kx/Mwd7bVSUtpHmJ+q0PgRWN3yVYFysRaGtGD40wzxYpw=
X-Received: by 2002:a17:902:e54f:b0:14a:1bbf:9cf0 with SMTP id
 n15-20020a170902e54f00b0014a1bbf9cf0mr4109126plf.158.1642074442641; Thu, 13
 Jan 2022 03:47:22 -0800 (PST)
MIME-Version: 1.0
From:   Robert Balogh <ethrbh@gmail.com>
Date:   Thu, 13 Jan 2022 12:47:11 +0100
Message-ID: <CAA4OwwXP+YTqcGdsS6Dbi7WwCQh1HRTd=4zc=e3ytMmn8Ke=Zw@mail.gmail.com>
Subject: FIO performance measurement between volumes
To:     fio <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

hello FIO experts,

I am a beginner in FIO, and I met with a problem.

Currently in my Ubuntu based server the "/dev/vdb1" volume is attached
to the "/home/batman/fio/cindervolume" path. FIO job is configured
like this

    [global]
    filename=3Dfio-172_20_2_13
    directory=3D/home/batman/fio/cindervolume rw=3Drw
    rwmixread=3D60
    rwmixwrite=3D40
    bs=3D4k
    rate=3D500k
    direct=3D1
    numjobs=3D1
    time_based=3D1
    runtime=3D14d
    verify=3Dcrc32c
    continue_on_error=3Dall
    group_reporting=3D1

    [file1]
    iodepth=3D1
    ; -- end job file --

FIO is started like this and works well:
    /usr/bin/fio --size=3D10G
--output=3D/home/batman/fio/cindervolume/fio-172_20_2_13-process.log
/home/batman/fioApp/fio-seq-RW.job &

FIO version I use: fio-3.25

My next step would be to attach a 2nd volume for example "/dev/vdc" to
"/home/batman/fio/cindervolume-2" path, and I would do performance
measurement between the volumes. I was checking the FIO user=E2=80=99s guid=
e,
https://fio.readthedocs.io/en/latest/fio_doc.html but unfortunately I
cannot figure out which parameter might help me to solve this topic.

By-the-way is this possible to do with FIO? If so, could you please
help me by giving some direction/hints?

thanks for your help,

/Robi
