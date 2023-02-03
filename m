Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 246A8C61DA4
	for <fio@archiver.kernel.org>; Fri,  3 Feb 2023 21:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbjBCVSJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 3 Feb 2023 16:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbjBCVSI (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 3 Feb 2023 16:18:08 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA72F1CF57
        for <fio@vger.kernel.org>; Fri,  3 Feb 2023 13:18:07 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id a24so6758259vsl.2
        for <fio@vger.kernel.org>; Fri, 03 Feb 2023 13:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TSwnHOpBSblFOIDMcsIaHGzVjOiAqEbkABQJUtnB+Yo=;
        b=BqbTxFv0sL2wgocTh3ToS/8IflggKmI/pJOJs0FAf5wy9m63AVXFslnt4IuaINBFcR
         JUVQGXeO8NN33zNqIzjFCcEww7h7FqVn2GjGrvNyeuOGG5feDc+WdR4kRuJ0SM/+K+OF
         lZbqXfY4uQhpLB8p425w06X1sE3hg6hWZ79zlrh3D9e7kCYobzhesvjdtQGSCFiXKjAl
         LztvMyrB6ElsNXFEz7mwbMZQ5hv9Oc78ajcFZYxFywgJjjGgKaPn0hYRiSADhodAnysg
         jx3albh9vti1ylptO7RwgBwdeIQbA3lAuJssob3Zz4G99X05Pj//ZillSPQInmddqHwp
         kA8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TSwnHOpBSblFOIDMcsIaHGzVjOiAqEbkABQJUtnB+Yo=;
        b=fIQDghplMvgWqbEQOCpn+KtofacG1dGHztIQvLsMinZeyDMwMaD85IKcNGKXJNBuRC
         M5HMTsON1nvf2WnCaGWhTqFJoWC2nUkotKBQG4hg8b+c/aVK342bIafWRkWlNPruDqTF
         1u9Pa3cp3wGpN22ZFWfl58gDK7Du5urWywIzpKMV66VxUQnMrmcIoUvlRJZuL9MAdZUd
         9dgitAriatKdWwhvm11IRvWSBbKBt/NgtB7DREx9LBaTyxLBxqHpGZliPbOurUwUwmoo
         mLM9a7JYv8DPzRroIjuOvlfZIOjrg8UdogsmkHhj70N9j7oBRapEQrFcmF2hDyFQbhjW
         OgiQ==
X-Gm-Message-State: AO0yUKWYNU3iVX3mRJShXFnLTf6tJxyXBYEpwJXwkaeY+qo090sL0/qI
        jx55cNTgjrfu5LZIf1okzVVduElhgUdVxDQE8co=
X-Google-Smtp-Source: AK7set8k91z9kWoMy9opbNThSxbcJM2eHFLpfK7+VbhWLHFoWI/p4PhJ0a/zk7SIvXABgjQDcoomkVz05jaRUSTyYWs=
X-Received: by 2002:a67:ead3:0:b0:3d3:ef73:b726 with SMTP id
 s19-20020a67ead3000000b003d3ef73b726mr2236988vso.22.1675459086845; Fri, 03
 Feb 2023 13:18:06 -0800 (PST)
MIME-Version: 1.0
References: <CAJ3QLKfSFjufUU2htxZQywrJX7iYiEwPGZf2TNdyO7O4u3tVYQ@mail.gmail.com>
 <CAJ3QLKfnvrYz_VqjppaNA-MyyRdEdfeHKb5M6TOPg7n7ZKACXA@mail.gmail.com>
 <CAKi7+wdkKz7-urkzXdWB2OTaC8aYSw3AWAtA7jfzJ1w1xU28cg@mail.gmail.com> <CAJ3QLKf4rUaxDAx8=Ysnp9EhYBsv4oEcRw5EuExOsav-1MP=ow@mail.gmail.com>
In-Reply-To: <CAJ3QLKf4rUaxDAx8=Ysnp9EhYBsv4oEcRw5EuExOsav-1MP=ow@mail.gmail.com>
From:   Jay Han <jayhan258@gmail.com>
Date:   Fri, 3 Feb 2023 14:17:55 -0700
Message-ID: <CAJ3QLKfAH4b_OnKbN-OGxnbnmz2m+UPJwsDLoS3YK0gxsJVnnw@mail.gmail.com>
Subject: Re: Reverse Sequential Read or Write
To:     Ankit Kumar <ankit1455@gmail.com>
Cc:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Thank you Ankit! I captured a trace using the example config file.
What does rw=read:-8k translate to in terms of LBA? I am seeing 4K seq
read in reverse manner. I am not sure what that 8k implies.
Each read is apart by 8. For example, the workload accessed LBAs
1540000, 1539992, 1539984, 1539976, 1539968, and so on.
Each read requested 8 logical blocks and the sector size is 512B which
makes up a 4K read.

Can you elaborate the -8K for me please?


On Fri, Feb 3, 2023 at 1:38 PM Jay Han <jayhan258@gmail.com> wrote:
>
> Thank you Ankit! I captured a trace using the example config file. What does rw=read:-8k translate to in terms of LBA? I am seeing 4K seq read in reverse manner. I am not sure what that 8k implies.
> Each read is apart by 8. For example, the workload accessed LBAs 1540000, 1539992, 1539984, 1539976, 1539968, and so on.
> Each read requested 8 logical blocks and the sector size is 512B which makes up a 4K read.
>
> Can you elaborate the -8K for me please?
>
>
>
> On Fri, Feb 3, 2023 at 11:07 AM Ankit Kumar <ankit1455@gmail.com> wrote:
>>
>> Hey Jan,
>>
>> Replying again as the first one didn't go to the mailing list because
>> of that not being in plain text.
>>
>> Yes, you can read/write in reverse order and there is already an
>> example fio configuration.
>> Check out:
>> https://github.com/axboe/fio/blob/master/examples/backwards-read.fio
>>
>> Regards
>> Ankit
>>
>>
>> On Fri, Feb 3, 2023 at 10:58 PM Jay Han <jayhan258@gmail.com> wrote:
>> >
>> > Hello,
>> > I am trying to configure a sequential read or write pattern that reads
>> > or writes in reverse manner in terms of LBAs. Is this feasible with
>> > the features that are in current build? If so, any guidance would be
>> > greatly appreciated.
>> >
>> > Thank you,
>> > Jay,
