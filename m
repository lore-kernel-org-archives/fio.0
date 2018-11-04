Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vs1-f43.google.com ([209.85.217.43]:43684 "EHLO
        mail-vs1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728915AbeKDT7Y (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 4 Nov 2018 14:59:24 -0500
Received: by mail-vs1-f43.google.com with SMTP id k14so3477543vsm.10
        for <fio@vger.kernel.org>; Sun, 04 Nov 2018 02:44:53 -0800 (PST)
MIME-Version: 1.0
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 4 Nov 2018 10:44:26 +0000
Message-ID: <CALjAwxjW8=DniS12hBvPXmd1Cp0NjEm9RewHAO8rHerDQg=eDQ@mail.gmail.com>
Subject: Mention of fio by Apple
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Looks like someone is referencing an fio benchmark result on Apple's
Mac Mini page and whoever did it took care to respect the Moral
License (https://fio.readthedocs.io/en/latest/fio_doc.html#moral-license
). From https://www.apple.com/mac-mini/ :

"4. Testing conducted by Apple in October 2018 using preproduction
3.2GHz 6-core Intel Core i7-based Mac mini systems with 64GB of RAM
and 1TB SSD, and shipping 3.0GHz dual-core Intel Core i7-based Mac
mini systems with 16GB of RAM and 1TB SSD. Tested with FIO 3.8, 1024KB
request size, 150GB test file and IO depth=8. Performance tests are
conducted using specific computer systems and reflect the approximate
performance of Mac mini."

My only question is: as the depth was 8 were they using the posixaio engine?

-- 
Sitsofe | http://sucs.org/~sits/

