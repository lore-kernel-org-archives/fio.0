Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:32833 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751170AbeCNVHv (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 14 Mar 2018 17:07:51 -0400
Received: by mail-io0-f175.google.com with SMTP id f1so6048033iob.0
        for <fio@vger.kernel.org>; Wed, 14 Mar 2018 14:07:51 -0700 (PDT)
MIME-Version: 1.0
From: abhishek koundal <akoundal@gmail.com>
Date: Wed, 14 Mar 2018 14:07:09 -0700
Message-ID: <CAKwzdDrOufV5HjdN3=+Hvr1vbnUrgM8U5G=9Wuk1Lh_kjAiFCw@mail.gmail.com>
Subject: FIO latency bin midpoint vs upper limit capture
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

All,
Currently the FIO latency  bins does the i/o count and but then as per
Lower bound, midpoint (rounded off), upper limit

The reported latency is the based on the "midpoint".
Is there a way to report it based on the "upper limit"? e.g. compile
fio with some switch etc.

Appreciate your support always :).

-- 
Life is too short for silly things so invest your time in some
productive outputs!!
