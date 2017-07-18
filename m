Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:35586 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751340AbdGRIDo (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 18 Jul 2017 04:03:44 -0400
Received: by mail-wr0-f174.google.com with SMTP id w4so16991391wrb.2
        for <fio@vger.kernel.org>; Tue, 18 Jul 2017 01:03:43 -0700 (PDT)
Received: from [192.168.0.62] ([185.14.8.15])
        by smtp.gmail.com with ESMTPSA id i67sm753060wri.61.2017.07.18.01.03.42
        for <fio@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 18 Jul 2017 01:03:42 -0700 (PDT)
From: Paolo Valente <paolo.valente@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: random-time I/O with fio
Message-Id: <787DD20D-DCFE-4E01-8F6E-A84853E89F12@linaro.org>
Date: Tue, 18 Jul 2017 10:03:41 +0200
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,
by chance, is there a (possibly indirect) way to generate I/Os
occurring at random times with fio?  Even a minimum variation with
respect to periodic I/O, such as rate-limited I/O I guess, would be
perfect.

Thanks,
Paolo
