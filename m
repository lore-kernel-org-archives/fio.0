Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:34488 "EHLO
        mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753480AbdHUCcU (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 20 Aug 2017 22:32:20 -0400
Received: by mail-yw0-f173.google.com with SMTP id s143so84388248ywg.1
        for <fio@vger.kernel.org>; Sun, 20 Aug 2017 19:32:20 -0700 (PDT)
MIME-Version: 1.0
From: siha lawrence <sihaj33@gmail.com>
Date: Mon, 21 Aug 2017 10:32:19 +0800
Message-ID: <CAAEM5qL7Ze0fwDrohz7Mn-kjWzV3G3BKST0BvYFRpW+2bB38Ag@mail.gmail.com>
Subject: exitall_on_error option with stats
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I'm using fio version 2.20 with the option exitall_on_error. On error,
it exits and reports all stats as zero.
How can this be modified so that we can get partial stats and not zeros?

Thank you.
