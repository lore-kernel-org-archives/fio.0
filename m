Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pl0-f41.google.com ([209.85.160.41]:42073 "EHLO
        mail-pl0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbeGPJdZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 16 Jul 2018 05:33:25 -0400
Received: by mail-pl0-f41.google.com with SMTP id f4-v6so10788426plb.9
        for <fio@vger.kernel.org>; Mon, 16 Jul 2018 02:07:00 -0700 (PDT)
Received: from Madaari.domain.name ([139.167.56.25])
        by smtp.gmail.com with ESMTPSA id 5-v6sm67129661pgc.86.2018.07.16.02.06.57
        for <fio@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 16 Jul 2018 02:06:58 -0700 (PDT)
From: dev.madaari@gmail.com
Subject: [PATCH] Fio's initial RTEMS port 
Date: Mon, 16 Jul 2018 14:36:45 +0530
Message-Id: <1531732006-11136-1-git-send-email-dev.madaari@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Following IOengines are currently working on RTEMS:
 - psync, sync, vsync, filecreate, ftruncate, null

I've attached the patch in my following mail, please have a look.

Here's the corresponding ticket:https://devel.rtems.org/ticket/3429
Please note that i have also sent the patch to devel@rtems.org, for their
review of rtems-specific part. 
