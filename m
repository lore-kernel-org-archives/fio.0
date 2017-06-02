Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:34772 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750918AbdFBTar (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 2 Jun 2017 15:30:47 -0400
Received: by mail-qk0-f175.google.com with SMTP id d14so67168924qkb.1
        for <fio@vger.kernel.org>; Fri, 02 Jun 2017 12:30:47 -0700 (PDT)
MIME-Version: 1.0
From: Brantley West <cbwest@gmail.com>
Date: Fri, 2 Jun 2017 15:30:46 -0400
Message-ID: <CANKF+jinANtsmA0XEP_dZ9F-sLxq+QE5zH-i2urEPotm+6W3WQ@mail.gmail.com>
Subject: unit testing for fio?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

I'm looking to adopt fio for some storage testing in the near future
and have noticed a few issues (#377, #378) that seem to be
math-related.  Assuming these issues get fixed, it seems like unit
testing would help ensure they stay fixed.  Additionally, fio has a
lot of useful configuration options, and unit tests seem like a good
way to test for expected operation when multiple configuration
parameters are present.

Is a unit test framework something that is worth considering for fio?
If so, are there any preferences?  It seems there are multiple options
(check, cunit, unity, etc).

-bw

C. Brantley West, III
cbwest@gmail.com
