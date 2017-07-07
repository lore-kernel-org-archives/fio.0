Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:35418 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751001AbdGGVot (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 7 Jul 2017 17:44:49 -0400
Received: by mail-qt0-f193.google.com with SMTP id w12so5853009qta.2
        for <fio@vger.kernel.org>; Fri, 07 Jul 2017 14:44:48 -0700 (PDT)
MIME-Version: 1.0
From: abhishek koundal <akoundal@gmail.com>
Date: Fri, 7 Jul 2017 14:44:07 -0700
Message-ID: <CAKwzdDqKXE3VF=q-Ms3UwLLMjCUpnVZ_cgBwaY3W4sEx4r-X7Q@mail.gmail.com>
Subject: Mixed seq+random worload thread
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

All,
Is there an easy way in FIO to have a mix workload which can do below
config in single operation mode:

90% SEQ_WR
10% RND_RD

-- 
Life is too short for silly things so invest your time in some
productive outputs!!
