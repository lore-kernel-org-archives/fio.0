Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:34843 "EHLO
        mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754002AbeCFTDK (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 6 Mar 2018 14:03:10 -0500
Received: by mail-ua0-f178.google.com with SMTP id c40so5257994uae.2
        for <fio@vger.kernel.org>; Tue, 06 Mar 2018 11:03:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKwzdDrG3vgzMzttpZm4HgbziXUNsXiOgNP_PAty+KRasQ7szg@mail.gmail.com>
References: <CAKwzdDrG3vgzMzttpZm4HgbziXUNsXiOgNP_PAty+KRasQ7szg@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 6 Mar 2018 19:02:39 +0000
Message-ID: <CALjAwxgH-QB_AUErVOu_zwWGLV-Zn1y1poOHXj0qQce_3tyCHw@mail.gmail.com>
Subject: Re: FIO size parameter feedback
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: abhishek koundal <akoundal@gmail.com>
Cc: fio <fio@vger.kernel.org>

Hi,

On 6 March 2018 at 18:52, abhishek koundal <akoundal@gmail.com> wrote:
> All
> If the size parameter is not given for the runs, how does the tool
> decide what % (LBA span) needs to be written on the drive?

It will query the disk/file for its size (but this depends on the
ioengine being able to do that and not all do/can).

> Reason I am asking as I see different data for the same workloads when
> size=100% and no size parameter used.

Hmm this sounds like it might be due to a rounding issue - what size
is your disk and what job were you running?

-- 
Sitsofe | http://sucs.org/~sits/
