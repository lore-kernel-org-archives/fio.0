Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:45730 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752008AbeCDVfw (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 4 Mar 2018 16:35:52 -0500
Received: by mail-io0-f174.google.com with SMTP id m22so15838576iob.12
        for <fio@vger.kernel.org>; Sun, 04 Mar 2018 13:35:52 -0800 (PST)
MIME-Version: 1.0
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Mon, 5 Mar 2018 00:35:31 +0300
Message-ID: <CANvN+emXGM9D5Pv3xdx_=nqbzJ_rG8FqGNYJxxCkA38xK7EARQ@mail.gmail.com>
Subject: Size and time-based jobs under the same config file
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I see a run of the subj resulting in the second, time-based job (which
is stonewalled to start after the size-based one) ending prematurely,
with its lifetime apparently consumed by the size-based job. This used
to work just a couple of years back ;). Am I missing something?

Regards,
Andrey
