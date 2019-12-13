Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-oi1-f178.google.com ([209.85.167.178]:35483 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728032AbfLMQ3O (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 13 Dec 2019 11:29:14 -0500
Received: by mail-oi1-f178.google.com with SMTP id k196so1381272oib.2
        for <fio@vger.kernel.org>; Fri, 13 Dec 2019 08:29:13 -0800 (PST)
MIME-Version: 1.0
From: Mike Kingsbury <mike.kingsbury@cacheio.com>
Date: Fri, 13 Dec 2019 11:29:02 -0500
Message-ID: <CANbyPNfpV0dazkiyviWs1yZtnGkjC-3zYBZt6QCr2wGgnGv1jw@mail.gmail.com>
Subject: Running FIO until DUT leaves steadystate
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Reading through the docs and looked at some examples, its not clear if
its possible to accomplish this. In our case, we're attempting to
evaluate SSDs and determine when they start internal garbage
collection and how much performance drops.  Is there a way to detect
steadystate, and then exit when the DUT performance leaves that
steadystate?

thanks
-mike

