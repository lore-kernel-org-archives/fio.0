Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:36812 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752223AbdGCHIv (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 3 Jul 2017 03:08:51 -0400
Received: by mail-qk0-f176.google.com with SMTP id p21so139192192qke.3
        for <fio@vger.kernel.org>; Mon, 03 Jul 2017 00:08:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFOWsvt5joru9mNN3VM65spn77VQDvCQp-OPwAXrtfi4SSbEJA@mail.gmail.com>
References: <CAFOWsvt5joru9mNN3VM65spn77VQDvCQp-OPwAXrtfi4SSbEJA@mail.gmail.com>
From: Keith Owens <kaos.ocs@gmail.com>
Date: Mon, 3 Jul 2017 17:08:49 +1000
Message-ID: <CAFOWsvuubBs4YOb9BKmpZPRwHo1cV+HGscGWv3TGqKFLis=-Aw@mail.gmail.com>
Subject: Re: Inverted test in fio ipo_bytes_align()
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Ignore that, fixed in February - Debian/Ubuntu have not picked up the fix.

On 3 July 2017 at 16:39, Keith Owens <kaos.ocs@gmail.com> wrote:
> ipo_bytes_align() does nothing when replay_align is set, when
> replay_align is 0 it incorrectly masks all replay offsets to 0. The
> test is inverted.
