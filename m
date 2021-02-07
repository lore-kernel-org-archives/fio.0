Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhBGQuS (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 7 Feb 2021 11:50:18 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 276E2C06174A
        for <fio@vger.kernel.org>; Sun,  7 Feb 2021 08:49:38 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id 190so10509141wmz.0
        for <fio@vger.kernel.org>; Sun, 07 Feb 2021 08:49:38 -0800 (PST)
MIME-Version: 1.0
References: <CANtcVJ3dXKnEz74G9Sh4LzvjdgWe_V4mxwXOEOwGtpYL0LN3fg@mail.gmail.com>
In-Reply-To: <CANtcVJ3dXKnEz74G9Sh4LzvjdgWe_V4mxwXOEOwGtpYL0LN3fg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 7 Feb 2021 16:49:10 +0000
Message-ID: <CALjAwxj2YJdwhdZLd96p-4WnOjJw+-WnTv30XCAHqVev8U03jw@mail.gmail.com>
Subject: Re: HTTP Engine of fio
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: Marcel Bielcik <bielcik1995@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On Thu, 4 Feb 2021 at 16:05, Marcel Bielcik <bielcik1995@gmail.com> wrote:
>
> I wanted to execute some S3 performance tests on my storage. If I am
> execute fio with the HTTP engine, I always receive the following
> output:
>
>
> fio: engine http not loadable
>
> fio: failed to load engine

^^^ The fio you are running was compiled without the HTTP ioengine
enabled (so anything to do with it won't be available to you). You
would either have to go to whoever provided you that binary and ask
them to build you an fio with that ioengine enabled or you have to
compile an fio of your own with the necessary packages installed that
allow that ioengine to be built like the user over in
https://github.com/axboe/fio/issues/1178#issuecomment-774471547 did.

-- 
Sitsofe

