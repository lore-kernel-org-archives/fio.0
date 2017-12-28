Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:41476 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751293AbdL1XRP (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Dec 2017 18:17:15 -0500
Received: by mail-wm0-f53.google.com with SMTP id g75so46315545wme.0
        for <fio@vger.kernel.org>; Thu, 28 Dec 2017 15:17:15 -0800 (PST)
MIME-Version: 1.0
From: Gnana Sekhar <kgsgnana2020@gmail.com>
Date: Thu, 28 Dec 2017 16:17:14 -0700
Message-ID: <CAPSTwmSgrDt1i2m0hzHpAh9ncM1vWWSQmjcOY6mkpik-c-vwxg@mail.gmail.com>
Subject: LBA selection in FIO
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I am looking to see if FIO has options to pass LBA count and data
pattern as CLI arguments.
Data pattern means same pattern to the specified LBA range i.e.,
either all 1's or 0's etc.,
Also will FIO be able to write to specified number of LBAs
irrespective of the LBA size

Thanks in advance

Regards,
Gnana
