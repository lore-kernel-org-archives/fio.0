Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C3BC61DA4
	for <fio@archiver.kernel.org>; Fri,  3 Feb 2023 12:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjBCMrH (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 3 Feb 2023 07:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbjBCMrG (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Feb 2023 07:47:06 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FF49AFF5
        for <fio@vger.kernel.org>; Fri,  3 Feb 2023 04:47:05 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id b5so5107186plz.5
        for <fio@vger.kernel.org>; Fri, 03 Feb 2023 04:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gm8lZyG0hfYqIVnN2+IqcI0ksO3jai030RhBZHCJxEg=;
        b=RUPX0MWftlLJ6qxiZLs87DVP1tHx05Q39ZeoOXP0AKxMhmt6jPkjs0sdmMtv8mSsir
         nXuOWpLtBGtN5YB8Dt7+8eMLTzu0KvN3HlO2vgYPcHAOIaxzGyRgXk69ePMmX36uEmQX
         SCxNizlkmebvAmRRDWPmp87jtV8Le7i81susE7acc/3ZcJl6qOSqYw9EQC2fiDfOh/2T
         dqHK/+2ii/U8garltzsv2M5qnTObsqgZSc+TXnzqMYj9s2npIAz3+AXITSAVhLhCi41R
         7Nper7ThpgG2t5dPQmW3JpBUny27mcSmOGVWJcRfarMSYnDKuFY53mb/86xJBO5k+SPw
         kuSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gm8lZyG0hfYqIVnN2+IqcI0ksO3jai030RhBZHCJxEg=;
        b=dPzTo3AM/9krbL3qenIBgCnKgcq/dAwL2PD321MkZsH0D+55KFhCW5ghd10zlGw6p0
         5GH3QsniHyw7w/JeC4To+JNDa2W8+ukECJKX2ytZIaF63zgNcytH2dcErnW0MGIoZ7eT
         TxOhlXrHUSh0xup7pcs6q8w0jh9l274t7wx8/de7+L/VQBt8GQkKeu76zInxPl27yA87
         27DBWJdwTe5OAPCyirGpmQnql0tMlMfo/Xn39mo9wCo8E8G+tG648ri42T3T2I3Q/Mo8
         lfpGYo/5dE6OjGKeegeK0pjPnVLB8g0VgnkUn2NNkVoZh26/UmJQeEpE2fOOcrlyXAHe
         jEhw==
X-Gm-Message-State: AO0yUKUQMdG5qhkUOtyhzlPAE027gh047qwe2QnObvbaPMXkuz6T9J7k
        y92HZyz8ZrU9YN2dCdaS+kbY9hPJbBww9MLT
X-Google-Smtp-Source: AK7set9IX+6Aw1WAMjFSPh6YKuaJyIBiW5BMYS7aDyV02NGCccdon9rZEZv6ka29I4zwoE1xR7IQfw==
X-Received: by 2002:a05:6a20:8e08:b0:bc:f665:8659 with SMTP id y8-20020a056a208e0800b000bcf6658659mr12912982pzj.3.1675428424826;
        Fri, 03 Feb 2023 04:47:04 -0800 (PST)
Received: from smtpclient.apple ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c124-20020a633582000000b004e63aa44474sm1458912pga.33.2023.02.03.04.47.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 04:47:04 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Jens Axboe <axboe@kernel.dk>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] filesetup: do not ask O_RDWR for read-only workload
Date:   Fri, 3 Feb 2023 05:46:53 -0700
Message-Id: <5B11C29F-19ED-4ADF-A900-F430608CC46C@kernel.dk>
References: <20230203123421.126720-1-joshi.k@samsung.com>
Cc:     fio@vger.kernel.org, vincent.fu@samsung.com
In-Reply-To: <20230203123421.126720-1-joshi.k@samsung.com>
To:     Kanchan Joshi <joshi.k@samsung.com>
X-Mailer: iPhone Mail (20D47)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Feb 3, 2023, at 5:35 AM, Kanchan Joshi <joshi.k@samsung.com> wrote:
>=20
> =EF=BB=BFUse O_RDONLY flag when read is requested on char-type files.
>=20
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>=20
> Before this patch: unexpected permission-denial for unprivileged-user.
>=20
> $ ls -l /dev/ng0n1
> cr--r--r-- 1 root root 242, 0 Feb  3 16:30 /dev/ng0n1
>=20
> $ ./fio -iodepth=3D1 -rw=3Drandread -ioengine=3Dio_uring_cmd -bs=3D4k -num=
jobs=3D1
> -size=3D4k -cmd_type=3Dnvme -filename=3D/dev/ng0n1 -name=3Dt
> t: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T)
> 4096B-4096B, ioengine=3Dio_uring_cmd, iodepth=3D1
> fio-3.33-71-g7d7a
> Starting 1 process
> fio: pid=3D131312, err=3D13/file:filesetup.c:805, func=3Dopen(/dev/ng0n1),=

> error=3DPermission denied
>=20
> filesetup.c | 5 +----
> 1 file changed, 1 insertion(+), 4 deletions(-)
>=20
> diff --git a/filesetup.c b/filesetup.c
> index 1d3cc5ad..d77b8ba4 100644
> --- a/filesetup.c
> +++ b/filesetup.c
> @@ -768,10 +768,7 @@ open_again:
>        else
>            from_hash =3D file_lookup_open(f, flags);
>    } else if (td_read(td)) {
> -        if (f->filetype =3D=3D FIO_TYPE_CHAR && !read_only)
> -            flags |=3D O_RDWR;
> -        else
> -            flags |=3D O_RDONLY;
> +        flags |=3D O_RDONLY;

This will break sg like interfaces, where a read is done by writing the comm=
and to the char device.=20

=E2=80=94=20
Jens Axboe

