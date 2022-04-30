Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D95F7C433F5
	for <fio@archiver.kernel.org>; Sat, 30 Apr 2022 03:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbiD3D27 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 29 Apr 2022 23:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238873AbiD3D2u (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 29 Apr 2022 23:28:50 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5222C10B
        for <fio@vger.kernel.org>; Fri, 29 Apr 2022 20:25:26 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
        by gnuweeb.org (Postfix) with ESMTPSA id 2F6F77E7CE
        for <fio@vger.kernel.org>; Sat, 30 Apr 2022 03:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1651289126;
        bh=3xLMZVLa8UFJCvyXrA7AoPHQ+PnvXWSp3dI+1rkPI1s=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Z5s61q3aho3KTKPOPozR2K/yhTmmBL2JRZ2zCJu5CEepeTZVlh4YAcP0uvPYNeP1H
         B3IRpIHFgQqXvHhrADOyYur/vEioXHj5gW2UA7/OJdql2h+DM0AcbYJ68V0D1K1hRE
         Bz1jtsPPagBEa9WJDBkm+n3YpqRD5FjxfZGO9kw1gQ1iBlbwCvXOk1pFJjrJWqH2FR
         3qpevUE2JwuUTh5qcbsmcydOemHb85jf8og3wmzeQnjFj02Jh4p7v2mppOAuDCo0MR
         NaRrkGRAx5SE5q+Ms2WYLPzEgZPkv81/bLLsc2ex1c7eaSGqRIHf54KOxPwZttduAJ
         vNRQRoDbCqsJQ==
Received: by mail-lj1-f173.google.com with SMTP id 16so12506481lju.13
        for <fio@vger.kernel.org>; Fri, 29 Apr 2022 20:25:26 -0700 (PDT)
X-Gm-Message-State: AOAM530GVA8heQJZ7JU2tjYJpiOyb8tnZLcJHk0fWeF6IazuzA9ECRFz
        xRXeiaVA1FX4NOpVrVvq6vWk0j9D1ccB3UUQr1s=
X-Google-Smtp-Source: ABdhPJwzYjBtqlYifTp1h4A4d2uj4BglJ/yS4iRFAq9zhNQvIJrTaORq57kMEZWPcl7pXBl7PGtbK0cHGx0bhR84xQc=
X-Received: by 2002:a2e:9d48:0:b0:24f:1528:52a1 with SMTP id
 y8-20020a2e9d48000000b0024f152852a1mr1353974ljj.393.1651289124171; Fri, 29
 Apr 2022 20:25:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220429004705.260034-1-ammarfaizi2@gnuweeb.org> <20220429004705.260034-2-ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220429004705.260034-2-ammarfaizi2@gnuweeb.org>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Sat, 30 Apr 2022 10:25:12 +0700
X-Gmail-Original-Message-ID: <CAOG64qOKPt_+wESiZC-8HKcYeRrTSXR3Vc1LEbvYx5vZ6aTJ7w@mail.gmail.com>
Message-ID: <CAOG64qOKPt_+wESiZC-8HKcYeRrTSXR3Vc1LEbvYx5vZ6aTJ7w@mail.gmail.com>
Subject: Re: [PATCH v1 1/8] cgroup: Add ENOMEM handling on a `malloc()` call
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        fio Mailing List <fio@vger.kernel.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Apr 29, 2022 at 7:46 AM Ammar Faizi <ammarfaizi2@gnuweeb.org> wrote:
>
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
>
> Avoid a NULL pointer dereference bug when `ENOMEM`.
>
> Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> ---
>  cgroup.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/cgroup.c b/cgroup.c
> index 77e31a4d..b559b70f 100644
> --- a/cgroup.c
> +++ b/cgroup.c
> @@ -114,6 +114,8 @@ void cgroup_kill(struct flist_head *clist)
>  static char *get_cgroup_root(struct thread_data *td, struct cgroup_mnt *mnt)
>  {
>         char *str = malloc(64);
> +       if (!str)
> +               return NULL;
>
>         if (td->o.cgroup)
>                 sprintf(str, "%s/%s", mnt->path, td->o.cgroup);
> @@ -178,6 +180,8 @@ int cgroup_setup(struct thread_data *td, struct flist_head *clist, struct cgroup
>          * Create container, if it doesn't exist
>          */
>         root = get_cgroup_root(td, *mnt);
> +       if (!root)
> +               return 1;
>         if (mkdir(root, 0755) < 0) {
>                 int __e = errno;
>

Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>

tq

-- Viro
