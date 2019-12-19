Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f43.google.com ([209.85.221.43]:44310 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbfLSDdo (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 18 Dec 2019 22:33:44 -0500
Received: by mail-wr1-f43.google.com with SMTP id q10so4446780wrm.11
        for <fio@vger.kernel.org>; Wed, 18 Dec 2019 19:33:43 -0800 (PST)
MIME-Version: 1.0
References: <CACDtTTE-nixBkdVL_NiAviYkAfFxA6yEBb1Ey0HwvWficcMtpw@mail.gmail.com>
In-Reply-To: <CACDtTTE-nixBkdVL_NiAviYkAfFxA6yEBb1Ey0HwvWficcMtpw@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 19 Dec 2019 03:33:16 +0000
Message-ID: <CALjAwxhh+5dUyVnyOAyzLzKR7geT8F3U+_iH=Q5JLcp1c6WcbA@mail.gmail.com>
Subject: Re: Question regarding load/save_verify state
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Roy Shterman <roys@lightbitslabs.com>
Cc: fio <fio@vger.kernel.org>, Ronen Weiss <ronen@lightbitslabs.com>, Sagi Grimberg <sagi@lightbitslabs.com>

Hi,

On Sun, 1 Dec 2019 at 13:16, Roy Shterman <roys@lightbitslabs.com> wrote:
>
> Hi,
>
> I'm running fio job with trigger, and using load/save_verify_state to
> run verify phase afterwards.
> Both write and read have the same offsets and sizes and both are using
> non random patterns.
> From time to time I see that the fio read verify actually reads
> offsets bigger than the latest offset in the file saved during write
> phase.
>
> Both workloads are running with iodepth of 300, I wonder if the
> iodepth affect somehow the end offset during read phase?
>
> Could it be that fio during read is reading from last_sector_written + iodepth?

Do you have a simple job that can demonstrate this issue? A depth of
300 is extremely high so anything you can do to demonstrate the issue
with smaller depths would be great!

-- 
Sitsofe | http://sucs.org/~sits/

