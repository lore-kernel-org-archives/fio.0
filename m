Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhBIM27 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Feb 2021 07:28:59 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E242C061788
        for <fio@vger.kernel.org>; Tue,  9 Feb 2021 04:28:19 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id k10so14924589otl.2
        for <fio@vger.kernel.org>; Tue, 09 Feb 2021 04:28:19 -0800 (PST)
MIME-Version: 1.0
From: Michele Pardini <michele.pardini@gmail.com>
Date: Tue, 9 Feb 2021 13:28:07 +0100
Message-ID: <CADRyqkUdkuoN0cfDhXBNuVuy1NaYVW85deBbHF5HDZvXLWNSEQ@mail.gmail.com>
Subject: Control % of compressible write workload
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

I need to test a storage device adjusting the % of the write workload
that can be compressed. I've learnt how to use

buffer_compress_percentage=70
refill_buffers
buffer_pattern

When you set  buffer_compress_percentage to a job, or to global, then
100% of the write workload will be compressed (at 70% rate ,in this
example) .

What I'd like to understand is if there's a way to tune the % of the
write workload that will be compressed. Ideally FIO should send 70%
writes compressible (at 10% compress rate) and 30% not compressible
(or 0% compress rate)

I could create 7 jobs with  buffer_compress_percentage and 3 jobs
without, but I need to have the 70/30 ratio in a single job/thread.

thanks
Michele Pardini

