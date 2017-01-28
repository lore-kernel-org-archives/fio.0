Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:36764 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750814AbdA1KfP (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 28 Jan 2017 05:35:15 -0500
Received: by mail-vk0-f47.google.com with SMTP id t8so190509911vke.3
        for <fio@vger.kernel.org>; Sat, 28 Jan 2017 02:35:15 -0800 (PST)
MIME-Version: 1.0
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 28 Jan 2017 10:34:44 +0000
Message-ID: <CALjAwxjcvwzzFnFdSG_ni+2QuHxozfJACeXqfNqqwPVAi3BNWA@mail.gmail.com>
Subject: rw=readwrite and verify interaction
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hi,

How do verify and rw=readwrite/rw=randrw interact - I can't see
anything about it in the HOWTO?

I see https://github.com/axboe/fio/blob/fio-2.17/backend.c#L928 but
I'm not sure I fully understand it. Are I/Os only actually verified if
at the point they are read they come from the write pass (otherwise
they are read but not verified)? Does a "write phase complete"
verification pass still take place? Also is behaviour different when
the read and write block sizes differ e.g. --rw=randwrite --verify=md5
--bs=4K,32K ?

Thanks.

-- 
Sitsofe | http://sucs.org/~sits/
