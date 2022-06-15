Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ECE1C433EF
	for <fio@archiver.kernel.org>; Wed, 15 Jun 2022 15:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352413AbiFOP1s (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 15 Jun 2022 11:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352520AbiFOP1K (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Jun 2022 11:27:10 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C2242EC4
        for <fio@vger.kernel.org>; Wed, 15 Jun 2022 08:27:00 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id j8so8382548qtn.13
        for <fio@vger.kernel.org>; Wed, 15 Jun 2022 08:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iVROesLOiKEQgYTy36lv2gcU93bC3xfVxxFgf1JtuW4=;
        b=gdV/Gnbr6g5QyJyJEUIhQeLFUzzCS3eS9JLhqUnmoq7cPhVHZoSiT9DPekK+Dbg3Gs
         XTBeso+WwoW3a1BUq0QaO1SZjUJh3ALlwwpbI/KUFsXD4DIqE0Z4UqATKVsunG2IJQVS
         XLn5xKVO9kxyorq233A6IZcU9WrN7rtid97eE1HsuMDBKPDMujoieTTalJbeYAJMuGBd
         c7MZ2NJ8G7xiARqg2NjLJFh7KCFd0mDp0FhBWPSQgWYMJKGf5mjW8ZacbjaBJG0YOQoQ
         xy8qPhbt3fR9OQNnwkfl5bPifFtGMuCk9yAf5aIwpBIw8mchATcHd8iWzjjAmOERHqVp
         9eQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iVROesLOiKEQgYTy36lv2gcU93bC3xfVxxFgf1JtuW4=;
        b=CjpOwn7tfvh3lKNm2vznCYxro+0JNxHcOER7pMNPCAI6QxWAWXGKQZEkMbJutC/Bhh
         7X3lvIU/nUaDZL6y1afM7ufGeOdM/YrIq0mzkoK/rwv6j/xfEgkUgeGRcxKl3580aGAq
         UUx2MOS6mPoGQxxvsHshlnxrJviwvHBgfxvbAN6siol8Ssnf3DNh1Fkd0ZvV8ssg4UFR
         CYVbfaeWjP5B0Zm5as+9KCZHl7cjzEPaR3J9JJFIR/QLz5ZfBUCBiTSjRCNCZMiC8iFT
         buljfU8lpAed4zWTPmo+MFKaONw8beOGf8b1aKESOQce4ixRgmvvr3pZYYW4mMG9csjQ
         XjbQ==
X-Gm-Message-State: AJIora+alDEE52Zumfwp0NJokGgtBNpX78n6qZZel1uDz7Pf2qGzRY09
        Av5KTs16+Mt+7Q2ITr8DaImSbvSp6dPE1/c+8sZ+RCwsaBk=
X-Google-Smtp-Source: AGRyM1udFnyXU0WcdTYTSrnuIV+3p18nSf1lZkwi0rmS/paVilEhklSG5Af6SZ4Yz+YEH8t8/wcF2jYY2szh6yR+rN0=
X-Received: by 2002:ac8:7e8a:0:b0:306:69a7:8a9f with SMTP id
 w10-20020ac87e8a000000b0030669a78a9fmr68270qtj.220.1655306819479; Wed, 15 Jun
 2022 08:26:59 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20220614155830uscas1p15aaa5d3bc8eec3da42c78a48520c6dd9@uscas1p1.samsung.com>
 <20220614155822.307771-1-vincent.fu@samsung.com> <20220614155822.307771-3-vincent.fu@samsung.com>
In-Reply-To: <20220614155822.307771-3-vincent.fu@samsung.com>
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Wed, 15 Jun 2022 10:26:48 -0500
Message-ID: <CADqNVTpODU3u5siLtvDT8jCBGUZtprMSVi2eqaM9VRbWJ_DuCw@mail.gmail.com>
Subject: Re: [PATCH 2/5] ioengines: don't record issue_time if ioengines
 already do it
To:     Vincent Fu <vincent.fu@samsung.com>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, Jun 14, 2022 at 10:59 AM Vincent Fu <vincent.fu@samsung.com> wrote:
>
> io_uring, io_uring_cmd, and libaio record issue_time inside the ioengine
> code when their commit functions are called. So we don't need to record
> issue_time again for these ioengines in td_io_queue.
>
> If we do fill issue_time twice, then mean(slat) + mean(clat) !=
> mean(lat):

I'm a little bit confused though why not recording issue_time again in
td_io_queue is considered the right fix. By having some ioengines that
record issue_time in their commit functions, and others that do not
(and thus have it recorded in td_io_queue), comparing clat between two
different engines isn't an apples-to-apples comparison. An ioengine
that does not record issue_time in its commit gets a "discount" of
sorts in its measured clat, since its issue_time is not recorded until
later. Does that make sense, or am I missing something? (Has been a
few months since I've been in the code in detail, so that's possible.)
