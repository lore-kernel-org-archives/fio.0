Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:42986 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389120AbeHGUa7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Aug 2018 16:30:59 -0400
Received: by mail-qt0-f180.google.com with SMTP id z8-v6so18948583qto.9
        for <fio@vger.kernel.org>; Tue, 07 Aug 2018 11:15:25 -0700 (PDT)
MIME-Version: 1.0
From: abhishek koundal <akoundal@gmail.com>
Date: Tue, 7 Aug 2018 11:14:48 -0700
Message-ID: <CAKwzdDqhaYynLHNQeoKGrdEo-0TZq7+dJiTkpoKV7jmhz51cjA@mail.gmail.com>
Subject: fio percentage_random query
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Does the below syntax means that writes will be random 45% with 55%
sequential rites?
rw=randwrite
percentage_random=0,45,0

-- 
Life is too short for silly things so invest your time in some
productive outputs!!
