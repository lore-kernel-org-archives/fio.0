Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:37292 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752041AbeFGXQR (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 7 Jun 2018 19:16:17 -0400
Received: by mail-qt0-f177.google.com with SMTP id q13-v6so11713864qtp.4
        for <fio@vger.kernel.org>; Thu, 07 Jun 2018 16:16:16 -0700 (PDT)
MIME-Version: 1.0
From: abhishek koundal <akoundal@gmail.com>
Date: Thu, 7 Jun 2018 16:15:35 -0700
Message-ID: <CAKwzdDqCd5kBP2RwkT473X5DfzdXDjbS=d02iNA_QSuzHhqM_Q@mail.gmail.com>
Subject: ramp_data logging in json+ format question
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

All,
Is there a way to collect all the fio data with the json+ logs in the
way it only calculates the values after the ramp_time?
e.g.
ramp_time=10s (still collect all data in some file but not use for calculations)
runtime = 60s (actual data for the calculations).

This will help to track the workloads transition analysis.

-- 
Life is too short for silly things so invest your time in some
productive outputs!!
