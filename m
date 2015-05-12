Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:33462 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbbELQuD (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 12 May 2015 12:50:03 -0400
Received: by qcvo8 with SMTP id o8so7779912qcv.0
        for <fio@vger.kernel.org>; Tue, 12 May 2015 09:50:02 -0700 (PDT)
MIME-Version: 1.0
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Tue, 12 May 2015 11:49:21 -0500
Message-ID: <CAB-428kCfA3PZdu+3jOUAxQH4jL2fScEUAKctxy4NhXUfbz3rA@mail.gmail.com>
Subject: Write Pattern and Verify in separate run instance ?
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

I want to do following experiment with FIO but now sure FIO have this
capability in place:

1. Run FIO and write a random content pattern on a RAW device or a File.
2. Run FIO and verify the contents that has been written is correct.

Based on my understanding, FIO do the verification phase at the same
run instance. However, I want the verification phase happen in a
separate stand alone run instance that may happen later.

Would you please kindly let me know if this capability is available ?
If not, I will appreciate your input so I can expand the toolset.

Thanks
