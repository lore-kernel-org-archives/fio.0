Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:53886 "EHLO muon.cran.org.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750800AbdA1BGu (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 Jan 2017 20:06:50 -0500
Received: from muon.bluestop.org (localhost [127.0.0.1])
        by muon.cran.org.uk (Postfix) with ESMTP id E54772FE17
        for <fio@vger.kernel.org>; Sat, 28 Jan 2017 01:05:15 +0000 (UTC)
Received: from muon.cran.org.uk ([127.0.0.1])
        by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 4OJEnit5qr3y for <fio@vger.kernel.org>;
        Sat, 28 Jan 2017 01:05:15 +0000 (UTC)
Received: from [192.168.1.19] (c-73-20-20-155.hsd1.ut.comcast.net [73.20.20.155])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by muon.cran.org.uk (Postfix) with ESMTPSA
        for <fio@vger.kernel.org>; Sat, 28 Jan 2017 01:05:15 +0000 (UTC)
From: Rebecca Cran <rebecca@bluestop.org>
Subject: Windows and TRIM support - files, not devices
Message-ID: <99e2bdcb-3067-cb48-90c8-c141191465d5@cran.org.uk>
Date: Fri, 27 Jan 2017 18:05:14 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

I've been looking at the TRIM support in Windows 8 and newer, and have 
come across a potential problem. Other OSes use TRIM on a physical/block 
device, but Windows only provides support for TRIM on files.


Would it still be useful to implement in fio?


-- 

Rebecca

