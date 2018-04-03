Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:39702 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752752AbeDCSSq (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 3 Apr 2018 14:18:46 -0400
Received: by mail-ua0-f172.google.com with SMTP id m47so11615036uae.6
        for <fio@vger.kernel.org>; Tue, 03 Apr 2018 11:18:46 -0700 (PDT)
MIME-Version: 1.0
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Tue, 3 Apr 2018 13:18:05 -0500
Message-ID: <CAB-428nGSovor98bWztkQK3C0veSCK_ECey-yeBk2SahVXWFsA@mail.gmail.com>
Subject: Terse output header ?
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Is there any way that we can get the full header with Terse output?

Without a header, it prints a long line which is very hard to count
and match the column with the definitions of columns in the howto
guide. Moreover, some columns that are defined in the howto might be
missing in my output and therefore, it makes the script development to
use the terse output very hard.


--
Alireza
