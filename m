Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 691F9C6FD1C
	for <fio@archiver.kernel.org>; Sun, 26 Mar 2023 09:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjCZJAX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 26 Mar 2023 05:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCZJAV (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 26 Mar 2023 05:00:21 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F7D8A60;
        Sun, 26 Mar 2023 02:00:21 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id i6so7003810ybu.8;
        Sun, 26 Mar 2023 02:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679821220;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9L1qvx9IgBNWkT3oSW2IRUquDA1JUkSi7nYbfMgfHu4=;
        b=kblaMMl44LJjBijIQxFV8GXYe9pZgBFJeYg9s3NixVpPqF0uP2rAbW9574Yad1Ba2i
         AFPF8qjPORK5ehOmm6BwsSzuJyM7OjUIlGQ7JChOhU+5PgA66TWuoRJydPxjf86Q3fua
         aHNGetV7gize4m0I65HDHAAZpssNJXhcjTPQLbeE3JH1EDW8EcAX3PlpoCbseuVM2jPL
         yZvrcp7BfuroLNT3scuXvonq64iNHnkWXcsSfXzUDtjYPvFkYWEGM/SNor9dA9Rwkj7o
         SZH2GfdRsauF/I7yQVoVLoAlRfhdtgGSHPWX7+/oc2upg31SiXxY/JVoa4OOKiifQecp
         2BTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679821220;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9L1qvx9IgBNWkT3oSW2IRUquDA1JUkSi7nYbfMgfHu4=;
        b=aW0T8Kso198R5wBu2V0w8RSbAsHxvt1iuamx7mP0Pzp8slefrDmgDfyxWthOQBdsx/
         UBh75kyM1PHgxAN/nu9KAeUy5BN6vs8h/IyVKPKlKnw48Hhc8WoyNAWAHJTHTC4lEJVw
         YlQ3igZMTvS2fBDgNqHhkFb2imypI9LYHBR48n+zW08W6K2acsZibJogMIn/wLA1fvZm
         DuPHpzors4dana6D6x4qEer0MwhtMBPyfXrPKc5DKY1DVmRf8t8/5kmOXEOGhNLQtOcQ
         d84jkSpX9mLvz7G3SgDyLC2Yx9X4VYuVyFrWXghuTCsYBOWy5ijeTuUfVrBTvFfY7E0Z
         eafg==
X-Gm-Message-State: AAQBX9e0LubtpC1r+DurUa1C7NVkIP1O+N/F7NnWskdTHNi+XRC4lUT5
        dIrZEKJauQ12iOuW4oo57dM73kGMZKYbiZ/YkakJAsid+ZI=
X-Google-Smtp-Source: AKy350b3GMYWPGtPT3kPeA44W3hQTnTWppFyICWs9WZT027UqEK+uG+ZUGa9iQyYlz1tFZ6r5mROOMuj2Ulmclfe2v8=
X-Received: by 2002:a05:6902:10c3:b0:b79:4826:e8e3 with SMTP id
 w3-20020a05690210c300b00b794826e8e3mr1508353ybu.1.1679821220196; Sun, 26 Mar
 2023 02:00:20 -0700 (PDT)
MIME-Version: 1.0
From:   pooja visakh <poojacbabu3025@gmail.com>
Date:   Sun, 26 Mar 2023 14:30:10 +0530
Message-ID: <CAKRUZ75VReCg4=q=wz9QywrLD5A_9=RzmLH_gPWccF=9+V1oxg@mail.gmail.com>
Subject: Doubt on fio
To:     majordomo@vger.kernel.org, fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Respected sir,

I have doubt about source code of fio, kindly please clear my doubts
     1.Fio read and write pattern.(flow)
     2.working flow of fio by sending a file and how it verify read
data and write data without using verify parameter.
     3.Which is the main file of fio?
 sir kindly please reply back so that i will be great help to me for
my project it is very urgent please reply back to me.

Thanking you
pooja
