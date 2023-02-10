Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E57D7C05027
	for <fio@archiver.kernel.org>; Fri, 10 Feb 2023 11:57:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbjBJL56 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 10 Feb 2023 06:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbjBJL55 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Feb 2023 06:57:57 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F5D34035
        for <fio@vger.kernel.org>; Fri, 10 Feb 2023 03:57:56 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id q9so6083852ybk.2
        for <fio@vger.kernel.org>; Fri, 10 Feb 2023 03:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FnforvsmGAqGxMVNWzWUtR46tPvuwhgmzL+FyYWknKI=;
        b=H4Q22YJ8gQm8SaY+Xopg2SlOUGUtY4ir9PkvqDuhaYS3+DpchhbQT6n+Fwf/yFtRnF
         04/oan25W/aQqGI9vvG4tJ03m0v/fG8mr9W22aGyq/g0kwiTdBW2XPc1YhJ5bo/ppk5N
         UNDlaDqhIxpJ/hA1u5EuMPeuLaQCdlCGC3Bk/GyNsBsWk8/OtXrV0uWezwXFPqafCuHo
         OOaBIumIFTgwv/2iiQG1c3WItduKOfh32hD30kstjZEgXEuUDHkDtU+uz5UYe6KaUrA1
         8S8wBaO1qFQz09QTxEPbaU7ijbTIU/QwAO/XlwuqWW/eseYCarEkdPODTUS9r6hdqDZm
         wcTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FnforvsmGAqGxMVNWzWUtR46tPvuwhgmzL+FyYWknKI=;
        b=UiWLKHPgYZ7EGocN8j2MGnH6VtOKA2KoUs0IakRA/GJ0ydgxzYZ6aHz+U1bhH41SeP
         dBWg9xa3vAR49NiqgEsxkyePga++1V+mAniCbcCnNsBj4/JZjHZ2bfgojdXjtYcJyESN
         CqWeAMHRbWhGmmTmelvQmnwlCeH48avX2c0RSaSoYSoI4b3ZQPLEPCwUmk30mn5E6mNP
         XusEeUSmUhhQx/+VFTvUMrtn19+fhyBM3xhG5lUfhQzyZEOZvo4FbBmUA0UWvzX9DO9H
         9MSD1RjFfWYYKUQN4tKQnKyrJ5DjJylp6pgZbLIA/UqKN+8dyQgPtuWiOSoWKXnO/BC7
         KeaQ==
X-Gm-Message-State: AO0yUKUOeS8ZFww1tdllC/w5y6AdMX/TI3dAM53GMWkVzflc7PICATFa
        1LvlV+dStAlY9Q1R5ZzBkL1IPo6+/6rpKKuB3WoNOwNv
X-Google-Smtp-Source: AK7set8f4hQN5gpG7Zf/PZgWfilNf+/ToW5/AqLNwO/ATuZgtGG5H4bxJ5bgp8ISXLQbT7dZQtLrr1vrNFi3/zxQUvc=
X-Received: by 2002:a5b:cc9:0:b0:8a7:4685:a263 with SMTP id
 e9-20020a5b0cc9000000b008a74685a263mr1573560ybr.125.1676030275785; Fri, 10
 Feb 2023 03:57:55 -0800 (PST)
MIME-Version: 1.0
References: <CGME20230209144042epcas5p4ede6ce94dee46af4d4452cfd3ce7e6e6@epcas5p4.samsung.com>
 <20230209144004.15298-1-ankit.kumar@samsung.com>
In-Reply-To: <20230209144004.15298-1-ankit.kumar@samsung.com>
From:   Ankit Kumar <ankit1455@gmail.com>
Date:   Fri, 10 Feb 2023 17:27:03 +0530
Message-ID: <CAKi7+wfN_5KqFvPuxWY8Y-Z23R5GQQipeKfetfwo_GBy2Lx5Gg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] fdp support in fio
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     axboe@kernel.dk, kbusch@kernel.org, fio@vger.kernel.org,
        vincentfu@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Kindly ignore this, will send incremental change once the existing
series from Keith gets merged.

Regards
Ankit Kumar


On Fri, Feb 10, 2023 at 10:19 AM Ankit Kumar <ankit.kumar@samsung.com> wrote:
>
> NVMe TP4146 creates a new feature called Flexible Data Placement. This
> feature allows a host to tell the device how to group write data through
> the use of "Placement Identifiers" in write commands.
>
> Add support for using placement identifiers in write commands. The user
> can enabled this with the new "fdp=1" parameter for fio's io_uring_cmd
> ioengine. By default, the fio jobs will cycle through all the namespace's
> available placement identifiers for write commands. The user can limit
> which placement identifiers can be used with additional parameter,
> "fdp_pli=<list,>", which can be used to separate write intensive jobs
> from less intenstive ones.
>
> Setting up your namespace for FDP is outside the scope of 'fio', so this
> assumes the namespace is already properly configured for the mode.
>
> v2 -> v1
> 1. Enhance fdp support check. Check if get feature fdp has fdp
> configuration enabled. Use the fdp config index to determine the
> reclaim unit size. This will be handy when we update the fdp backend
> to write in different fashion.
> 2. fetch ruhs info, can even work for more than 1024 reclaim unit
> handle descripotors. We just need to query io mangement recv command
> twice.
> 3. Add the missing fdp backend.
> 4. Update man page for the new options.
>
> Note: I have purposefully left out Signed-off-by tag (Keith's and mine).
> Feedback is appreciated.
>
> Ankit Kumar (3):
>   fio/fdp: add fdp support to fio
>   engines/io_uring: add fdp support for io_uring_cmd engine
>   example: add fdp example for uring_cmd engine
>
>  HOWTO.rst                  |  14 +++
>  Makefile                   |   2 +-
>  engines/io_uring.c         |  15 +++
>  engines/nvme.c             | 224 ++++++++++++++++++++++++++++++++++++-
>  engines/nvme.h             |  74 ++++++++++++
>  examples/uring-cmd-fdp.fio |  37 ++++++
>  fdp.c                      | 219 ++++++++++++++++++++++++++++++++++++
>  fdp.h                      |  25 +++++
>  file.h                     |   3 +
>  filesetup.c                |   7 ++
>  fio.1                      |  12 ++
>  fio.h                      |   2 +
>  init.c                     |   1 +
>  io_u.c                     |   3 +
>  io_u.h                     |   3 +
>  ioengines.h                |   7 +-
>  options.c                  |  49 ++++++++
>  thread_options.h           |   8 ++
>  18 files changed, 702 insertions(+), 3 deletions(-)
>  create mode 100644 examples/uring-cmd-fdp.fio
>  create mode 100644 fdp.c
>  create mode 100644 fdp.h
>
> --
> 2.17.1
>
