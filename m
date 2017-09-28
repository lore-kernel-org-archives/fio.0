Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yw0-f174.google.com ([209.85.161.174]:48294 "EHLO
        mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752520AbdI1BFW (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 27 Sep 2017 21:05:22 -0400
Received: by mail-yw0-f174.google.com with SMTP id u205so13382ywa.5
        for <fio@vger.kernel.org>; Wed, 27 Sep 2017 18:05:21 -0700 (PDT)
MIME-Version: 1.0
From: abhishek koundal <akoundal@gmail.com>
Date: Wed, 27 Sep 2017 18:04:40 -0700
Message-ID: <CAKwzdDpb-vEKnC6r0PoAVo0_OdNJY-Ou7x1aZrpmX+-xS1Z_TQ@mail.gmail.com>
Subject: json+ max latency logging for bins
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Can someone confirm if json+ format is used the latency reported in
the bins (~1200) are mid-point not the max?

 Does the --status-interval=1sec makes reporting average value in bins.

Does adding the log_max_value=1 , will ensure that always max is
recorded in the latency bin? I have used this for the non-json format
but then average latency reporting per interval is lost.

Appreciate your response .

-- 
Life is too short for silly things so invest your time in some
productive outputs!!
