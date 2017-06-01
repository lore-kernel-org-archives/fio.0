Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:36322 "EHLO
        mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbdFATQ3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 1 Jun 2017 15:16:29 -0400
Received: by mail-vk0-f45.google.com with SMTP id p85so29920924vkd.3
        for <fio@vger.kernel.org>; Thu, 01 Jun 2017 12:16:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAEM5qL=tDUS66n-G-y8d4-gFGLCwRtRw_O2vr7d-PeZw_Fung@mail.gmail.com>
References: <CAAEM5qL=tDUS66n-G-y8d4-gFGLCwRtRw_O2vr7d-PeZw_Fung@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 1 Jun 2017 20:15:57 +0100
Message-ID: <CALjAwxiDVks+KYx0yTUQX7mUGJ56x44w1=ABcj0R3_x-ocM99w@mail.gmail.com>
Subject: Re: exitall_on_error - Unrecognised option
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: siha lawrence <sihaj33@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Please don't send fio mail to me directly- send it to the fio mailing
list (see https://github.com/axboe/fio/blob/fio-2.20/README#L58 for
details). You'll most likely get a faster/better reply and it will
also be in the archives so people using web searches will see the
answer too...

On 1 June 2017 at 16:19, siha lawrence <sihaj33@gmail.com> wrote:
>
> I'm getting unrecognised option when using the exitall_on_error option in
> fio version 2.2.8.

That option wasn't introduced until fio 2.2.13 - see
https://github.com/axboe/fio/commit/f9cafb12834f84aeff4f255e8c9e5c5d6b5e3bf5
. I'd strongly recommend upgrading - we're up to fio 2.20 at the time
of writing!


-- 
Sitsofe | http://sucs.org/~sits/
