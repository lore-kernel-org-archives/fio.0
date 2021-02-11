Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhBKVw4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 11 Feb 2021 16:52:56 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7CAEC061574
        for <fio@vger.kernel.org>; Thu, 11 Feb 2021 13:52:16 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id n10so5235368wmq.0
        for <fio@vger.kernel.org>; Thu, 11 Feb 2021 13:52:16 -0800 (PST)
MIME-Version: 1.0
References: <CAA4OwwVJuUWCkA_ZRJC+izsqx-4Mv2BG+vvR=JCv2A7kOr343Q@mail.gmail.com>
In-Reply-To: <CAA4OwwVJuUWCkA_ZRJC+izsqx-4Mv2BG+vvR=JCv2A7kOr343Q@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 11 Feb 2021 21:51:49 +0000
Message-ID: <CALjAwxg-NDqixYgxEPVDFf8_CTWpO5UEQhM9byPZwicazGoAzw@mail.gmail.com>
Subject: Re: how to put FIO stat into file and check that periodically while
 FIO is running
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: Robert Balogh <ethrbh@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On Wed, 10 Feb 2021 at 13:26, Robert Balogh <ethrbh@gmail.com> wrote:
>
> What I would like to do is now, to start FIO, keep running it, and
> "instruct/ask" FIO for putting the measurement statistic at every X
> sec into the given stat file. Is it possible to do?

The information in https://www.spinics.net/lists/fio/msg09025.html
("Re: Getting eta-status-line to the output file?") may be what you're
looking for. If you are just after a specific stat the write_*_log
options - https://fio.readthedocs.io/en/latest/fio_doc.html#measurements-and-reporting
may be more useful to you.

--
Sitsofe

