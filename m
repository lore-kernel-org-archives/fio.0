Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qt0-f175.google.com ([209.85.216.175]:32859 "EHLO
        mail-qt0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752399AbdGECaY (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 4 Jul 2017 22:30:24 -0400
Received: by mail-qt0-f175.google.com with SMTP id r30so176251457qtc.0
        for <fio@vger.kernel.org>; Tue, 04 Jul 2017 19:30:24 -0700 (PDT)
MIME-Version: 1.0
From: abhishek koundal <akoundal@gmail.com>
Date: Tue, 4 Jul 2017 19:29:43 -0700
Message-ID: <CAKwzdDr12fxuw8UYPcoaR8a7U0v3k-DgZw26gdE2-xwbwFO9Yw@mail.gmail.com>
Subject: fio sequential workload with zoned distribution
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

All,
I want to look at options of doing zoned access but using "sequential" workload.
Does the below profile achieve that? I want to make sure that using
the random_distribution wont cause the i/o to behave as random.

rw=write
random_distribution= 60/10:30/30:10/60
i.e
60% seq wr = first 10% of drive
30% seq wr = next 30% of drive
10% seq wr = next 60% of drive

-- 
Life is too short for silly things so invest your time in some
productive outputs!!
