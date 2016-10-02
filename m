Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:36579 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751002AbcJBTi7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 2 Oct 2016 15:38:59 -0400
Received: by mail-io0-f181.google.com with SMTP id j37so8906549ioo.3
        for <fio@vger.kernel.org>; Sun, 02 Oct 2016 12:38:59 -0700 (PDT)
Received: from [10.150.131.243] ([128.135.100.110])
        by smtp.gmail.com with ESMTPSA id m206sm6254603ita.13.2016.10.02.12.38.58
        for <fio@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Oct 2016 12:38:58 -0700 (PDT)
From: Huaicheng Li <lhcwhu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 10.0 \(3226\))
Subject: IOPS log per second and Latency log per-I/O
Message-Id: <9FA6E809-3D3B-4976-BC96-8254DA512BDB@gmail.com>
Date: Sun, 2 Oct 2016 14:38:57 -0500
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi all,

I want to ask if it=E2=80=99s possible to =E2=80=9Cwrite_iops_log=E2=80=9D=
 each second and in the meanwhile =E2=80=9Cwrite_lat_log=E2=80=9D =
each-IO.
According to the manual, IOPS log uses min(iopsavgtime, log_avg_msec), =
Latency log uses log_avg_msec
as their log interval respectively. Then it would seem impossible to =
achieve my goal. Any suggestion how to
do this?

Thanks.

Best,
Huaicheng=20=
