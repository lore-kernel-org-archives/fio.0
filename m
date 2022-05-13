Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D75C3C433EF
	for <fio@archiver.kernel.org>; Fri, 13 May 2022 11:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379784AbiEMLGf (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 13 May 2022 07:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379766AbiEMLGc (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 13 May 2022 07:06:32 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A391286FE
        for <fio@vger.kernel.org>; Fri, 13 May 2022 04:06:27 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id j4so13869732lfh.8
        for <fio@vger.kernel.org>; Fri, 13 May 2022 04:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dKv7DEduIOvuAX8F3WXYFlAOjQqWaFbPIfthQ52NzQ8=;
        b=F+OmFI4FxCw952h1akEGm3tBZhetl2bdrQdGImQxdkvozWW9gB/qSdGyrKPdH4GNJR
         EETxiR0QcogiYOwdxlp23Ul9uotgmLXpBzISaNVkLv/tcf/ZCf0qQx9BxsVGEC2UxMUw
         6KcJy1HnRA1fRDstYijz8T4mKHL65MrnJDRf2kytdFHfJQscNbBH8mPKkujrV8gXeZNE
         zQ68tJyHxr1HViZKMuSQPPfLtP4j30SppbdUYNvZYfNrFVhnmkZ5FZUR67w2qC1qbPwQ
         uVWgDefhM12vxpSSW7XuFMWJHnPt+5t7JZDi3Pcd8ZMxUlJyV4sn5P1FLGIAiHxaP+jM
         96OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dKv7DEduIOvuAX8F3WXYFlAOjQqWaFbPIfthQ52NzQ8=;
        b=oQtHNZFtj/o61PYem62vsRWFNlw4TskjTi+CCOE7fWHmxQKkTgrzulXVAgkUkYvf0J
         w8HUeGa11X2WSk9Yp1LK5FVg3sWmbqLbNRl8xeOwoRs8BcXTmLp8iGd2IYrpKIRtPMCS
         ExHjMSSxalrkTBhS5FuBL3q10Sfh4+UkQ/yRLS2sjX+5qcDUiZOV8aNg2U/MUzomqqzT
         9v5lSPSq/81uhacHRok2MXRQMdPrdR+zCpVvLI8w+xW+pJkOR5zr+4CqTdkAqaLP2Cop
         gM9cKvayRB4Wl8f6jqSgTUPx1MKrdCrKQvIcupyXIjuwpVfJBNOdhlWgBuqLnbXr7v36
         2QoA==
X-Gm-Message-State: AOAM532B6uM6IIaFr67ikTXB7VsstMwohcxc+Gcty3rmGU1IohmjfFh/
        FOs1g9fWdPn4+Qqpi8BDOEmh2lGnf6Pym7i1M58=
X-Google-Smtp-Source: ABdhPJyUhn0r9MfGhDpljdhLMesWPOsUBDp4H8U9gEUjvGcfCXKqlJvwlJEhaJ3QBiuzBObbBaVqGS6R5J6gQVduwlw=
X-Received: by 2002:a05:6512:c22:b0:473:c64b:1cf5 with SMTP id
 z34-20020a0565120c2200b00473c64b1cf5mr3077546lfu.427.1652439985668; Fri, 13
 May 2022 04:06:25 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20220511163552epcas5p4c2e1b204a47a543c24f84da89ef0c89a@epcas5p4.samsung.com>
 <20220511163019.5608-1-ankit.kumar@samsung.com> <698673c0-0fc4-671c-15da-0fb7a053da41@kernel.dk>
 <CAKi7+wew31=A5ZF+t2b479-zkrObRs+ze+-o0MVKX6kcfWP9UA@mail.gmail.com> <cf9dbc97-0847-6887-3d8f-320432bf5176@kernel.dk>
In-Reply-To: <cf9dbc97-0847-6887-3d8f-320432bf5176@kernel.dk>
From:   Ankit Kumar <ankit1455@gmail.com>
Date:   Fri, 13 May 2022 16:36:16 +0530
Message-ID: <CAKi7+weGb3AsfGKkHEiPNFDxQEKTDn68nb6cbfJNzM=+p+=3LA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] fio: add xnvme engine
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ankit Kumar <ankit.kumar@samsung.com>, fio@vger.kernel.org,
        krish.reddy@samsung.com, simon.lund@samsung.com,
        joshiiitr@gmail.com, anuj1072538@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Thanks a lot for applying the xnvme engine changes. Yes we are adding
passthrough support in io_uring by having a separate ioengine_ops. The
changes will be ready shortly.

On Thu, May 12, 2022 at 5:58 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 5/12/22 12:28 AM, Ankit Kumar wrote:
> > Yes we are using xnvme on various platforms, and it would be great if
> > it gets included as part of FIO.
> > For supporting io_uring engine with passthrough, yes we also have a
> > plan in place to clean up the code and send it for review.
>
> Sounds good. I've applied the xvnme engine, would appreciate if we can
> do the passthrough one shortly too. I'm wondering if that one is best
> done as a separate engine too - it could still be in engines/io_uring.c
> but have a separate ioengine_ops to keep the code nicely separated while
> still being able to use the same helpers in there.
>
> --
> Jens Axboe
>
