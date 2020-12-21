Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgLUWuD (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 21 Dec 2020 17:50:03 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35842C0613D3
        for <fio@vger.kernel.org>; Mon, 21 Dec 2020 14:49:23 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id n42so4359597ota.12
        for <fio@vger.kernel.org>; Mon, 21 Dec 2020 14:49:23 -0800 (PST)
MIME-Version: 1.0
From: "rickyp999@gmail.com" <rickyp999@gmail.com>
Date: Mon, 21 Dec 2020 14:49:11 -0800
Message-ID: <CACnDUNrKDbee11b0xhSR1sYrkmetO3x0TpuesxrS-GHVe+kfoA@mail.gmail.com>
Subject: Standard test parameters for NAS workloads?
Content-Type: text/plain; charset="UTF-8"
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I'm curious whether there are some standard or at least common test
parameters for benchmarking NAS workloads.

If NAS is too specific, even a general one for HDD/SSD would be
greatly appreciated.  My motivation is to use a common set of
benchmarks to compare how options like RAID levels, network
speed/protocol (through a NFS/SMB mount), and SSD cache affect
performance.

Thank you,

