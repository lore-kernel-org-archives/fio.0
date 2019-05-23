Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vs1-f49.google.com ([209.85.217.49]:38717 "EHLO
        mail-vs1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfEWEnG (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 23 May 2019 00:43:06 -0400
Received: by mail-vs1-f49.google.com with SMTP id x184so2778760vsb.5
        for <fio@vger.kernel.org>; Wed, 22 May 2019 21:43:06 -0700 (PDT)
MIME-Version: 1.0
From: Left Right <olegsivokon@gmail.com>
Date: Thu, 23 May 2019 04:42:53 +0300
Message-ID: <CAJQBtgk=RDMWMM1=RAR=rYXHOLsJgvMsqaYLT8HPRy7YK-Oouw@mail.gmail.com>
Subject: How does FIO know size of a partition?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello list!

We are working on testing pmem library backed up by a partition on a
device, and there seems to be a discrepancy between how we / pmem /
FIO understand the size of the of partitions.

Could anyone, please, shed a light on how this is done?

Thank you!

Oleg

