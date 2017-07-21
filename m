Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:35494 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754106AbdGURti (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Jul 2017 13:49:38 -0400
Received: by mail-qk0-f171.google.com with SMTP id d145so19127554qkc.2
        for <fio@vger.kernel.org>; Fri, 21 Jul 2017 10:49:38 -0700 (PDT)
MIME-Version: 1.0
From: Yogi Wannabe <yogi43222@gmail.com>
Date: Fri, 21 Jul 2017 10:49:36 -0700
Message-ID: <CAGSHeY2B1AqeKMNq-nfPik9S-XqUx5_Vj3yaZ8X0XX1MGq6t1w@mail.gmail.com>
Subject: Fio IOPS reported incorrectly in some cases
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

When I run fio like this: fio <config filename>

it reports the correct IOPS from beginning of the test. But when I run
fio like this,

fio --minimal --status-interval=1 <config filename>

the IOPS reported is about 150K lower than expected but gradually
ramps up and shows the correct value just before the test ends. Is
this a known issue? Is there a work around for this?

Thanks
Yogi
