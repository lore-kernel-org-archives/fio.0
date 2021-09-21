Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B7F9C433F5
	for <fio@archiver.kernel.org>; Tue, 21 Sep 2021 08:28:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62BEC61215
	for <fio@archiver.kernel.org>; Tue, 21 Sep 2021 08:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbhIUI3l (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 21 Sep 2021 04:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbhIUI3l (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 Sep 2021 04:29:41 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE4EC061574
        for <fio@vger.kernel.org>; Tue, 21 Sep 2021 01:28:13 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id u18so20106006pgf.0
        for <fio@vger.kernel.org>; Tue, 21 Sep 2021 01:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=lqGkHs6MDhUasUKLnXjvGrPIxbRebCEabGU5uOYZU1c=;
        b=T79x36dZuIioAKMkwL8NR6Swypi5LALcEVi0yAY+RmA/ygO1s35w2nFLYyoNAGkuET
         eyof/FtnKrAUPwDg9F/F8AV4iUe5FS3nqBslBNhOqXqGt5JmL1vnKs1HUTy5tDXAvsHi
         uHx5rC8tPb35BBP8fVfWukesRVQ20W43txV8TeseZwDxl5vQQ3A46FSc0ETGP5Dkv8dv
         JFCleqzPDqsxFGrZUirjKlp48ugXzbcxnRMpzS1yUeHXvIibBXRkizQVQ2qGxt2aZiR/
         R3EV2+HiOvH5fZxMU35s21fOkn487e3f55PbtgwE/TrvMi1le41jDXpACeDxqye7mZTl
         h31Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=lqGkHs6MDhUasUKLnXjvGrPIxbRebCEabGU5uOYZU1c=;
        b=Q4X6k7fqXcgwOC1gC7hZ2Rj1CKN48A+HEhk6RKzgnojEvnwx8o+cbnpHJV5jcNDWj5
         Zutsx49wDnTLq5cgvNzrD1pZE6Xg0ZgtbYIecv+xcdxR87ik7rgStgx7ejPD9fGf5vBA
         e0PgYyud2hwp8OhifjB0G3tpZlwvjHmcMGLYdn3YbmkFnvo78nO0spBYnhmffyope+b/
         TSWJ9+j0fJ1MYwIAJC9HYccVD3bHopkssyQCeJJkpmMhqYUE9wJuIaa8yKGelhBhwELU
         BG56yJsIjH76L+ZsLh4jERmm01oP9vWfvJ05xm1B5R2zt5jOOzLURJGskjA1YYAbThDB
         89iQ==
X-Gm-Message-State: AOAM532Cd04a2C96oLqB70ND0hScQlc1aZ8OF7Wb6FHRCI7SoDQ7dTl1
        CScS0yUJ0lxs8CgYikVkvG7wcj1HMf6rAw7t+XspAb2obYw=
X-Google-Smtp-Source: ABdhPJxyvsx78AVd5ZVzIQgm72N+r3UC7DBzOn+aLyiCyb5kmYhQ29cbJnItRXNGZoSJpGgtZolM03C+KK1BVe9FhyA=
X-Received: by 2002:a63:2343:: with SMTP id u3mr27503723pgm.100.1632212892678;
 Tue, 21 Sep 2021 01:28:12 -0700 (PDT)
MIME-Version: 1.0
From:   freoone <freoone@gmail.com>
Date:   Tue, 21 Sep 2021 10:28:01 +0200
Message-ID: <CAASfLOtCaXJccL1TrZwkpRj0kMFOWcvZwVUEC+m7XTv3MaP0HA@mail.gmail.com>
Subject: Single iolog file created when 2 separate files are expected (write_iolog)
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi,

I'm trying to run fio to do some random reads with 2 threads
(numjobs=3D2). I'd like to record iolog for both threads in separate
files.
The manual in the 'write_iolog' section says:
"Specify a separate file for each job, otherwise the iologs will be
interspersed and the file may be corrupt."
and later:
"You can specify a number of files by separating the names with a =E2=80=98=
:=E2=80=99
character."
So I'm running the following command:
./fio  --name=3Dtest2jobs --rw=3Drandread --filename=3Dfile.fio --size=3D10=
M
--numjobs=3D2 --write_iolog=3Dlog1:log2
but instead of two files "log1" and "log2" I get a single file
"log1:log2" containing IOs from both threads.
Is this a bug in fio or is there some misconception on my part?

I'm running Arch Linux 5.13.13-arch1-1, fio-3.28-18-gf3057

Thank you in advance.
