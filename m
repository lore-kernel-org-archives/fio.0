Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:65451 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2CaAGQ (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 30 Mar 2012 20:06:16 -0400
Received: by vbbff1 with SMTP id ff1so732222vbb.19
        for <fio@vger.kernel.org>; Fri, 30 Mar 2012 17:06:15 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 30 Mar 2012 17:06:15 -0700
Message-ID: <CAKa9NmtSnSj=mOx7E7rwBpHW1xPThd+K0RnsGXcDA8QX2qgkJw@mail.gmail.com>
Subject: Verify with mixed read/write
From: Vikram Seth <seth.vik@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

Does the verify option work with mixed read/write case, like rw or randrw  ?

It's not clear from the help text (pasted below).

                This option can be used for repeated burn-in tests of a
                system to make sure that the written data is also
                correctly read back. If the data direction given is
                a read or random read, fio will assume that it should
                verify a previously written file. If the data direction
                includes any form of write, the verify will be of the
                newly written data.

Thanks,

Vikram.
