Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:36279 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbdFNGd5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 14 Jun 2017 02:33:57 -0400
Received: by mail-ua0-f176.google.com with SMTP id h39so88881056uaa.3
        for <fio@vger.kernel.org>; Tue, 13 Jun 2017 23:33:56 -0700 (PDT)
MIME-Version: 1.0
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Wed, 14 Jun 2017 07:33:25 +0100
Message-ID: <CALjAwxj+KoD2ipRH5=+08Xb9KyKonX9NX-QAPvBkwvHSRux2Hw@mail.gmail.com>
Subject: systemd-udevd triggered?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Tarek <cashew250@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 31 March 2017 at 18:34, Tarek <cashew250@gmail.com> wrote:
> As an aside to the thread I have going about 0 clat min
>
> Why am I seeing udev events in the BTT summary? Why is systemd-udevd
> generating anything when fio is ran?
>
> Q2C           MIN           AVG           MAX           N
> --------------- ------------- ------------- ------------- -----------
> fio               0.000017381   0.000018851   0.000077907      436012
> systemd-udevd     0.000012019   0.000150024   0.000481010          76

Ulp, you dropped the CC to the mailing list so this disappeared into a
different mailbox that I didn't see until now. Please send fio
questions to the fio mailing list rather than only me directly.
Thanks!

I'm not sure but perhaps you "inserted" the disk afresh or changed the
sectors where a partition table lives? It could be the case this can
trigger other tools to initiate a rescan to see if new partitions have
arrived and other tasks in turn need to be triggered...

-- 
Sitsofe | http://sucs.org/~sits/
