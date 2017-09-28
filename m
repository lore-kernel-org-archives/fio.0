Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:49524 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdI1Qzg (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 28 Sep 2017 12:55:36 -0400
Received: by mail-ua0-f175.google.com with SMTP id 97so1304202uai.6
        for <fio@vger.kernel.org>; Thu, 28 Sep 2017 09:55:36 -0700 (PDT)
MIME-Version: 1.0
From: Andrzej Jakowski <andrzej.jakowski@gmail.com>
Date: Thu, 28 Sep 2017 09:55:35 -0700
Message-ID: <CAOmo8DYM7JGSqFVB1tyicUMUk=HxfMFTAAZfRAz_PoQMPZd6JQ@mail.gmail.com>
Subject: Question on source code
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I'm checking source code for percentile calculation:
There is a descrption, showing there is 19 groups:
https://github.com/axboe/fio/blob/master/stat.h#L89

Below it there is macro showing group number to be 29.
#define FIO_IO_U_PLAT_GROUP_NR 29
https://github.com/axboe/fio/blob/master/stat.h#L112

I'm wondering if the original intent for setting
FIO_IO_U_PLAT_GROUP_NR was to 19 and what I see there is just a typo.
Please let me know.

Thx,
Andrzej
