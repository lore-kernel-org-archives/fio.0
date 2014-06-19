Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:63803 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343AbaFSUjK (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 19 Jun 2014 16:39:10 -0400
Received: by mail-we0-f178.google.com with SMTP id x48so2917006wes.9
        for <fio@vger.kernel.org>; Thu, 19 Jun 2014 13:39:08 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 19 Jun 2014 13:39:08 -0700
Message-ID: <CACTzACWfzQpXwfrBuneYiDFYR=ERUXXaA3oOOz62oEvXa5xNCA@mail.gmail.com>
Subject: fio execution issue on Android device with MediaTek
From: David N <android.wm.edu@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi all,

I got fio working fine on a device with Qualcomm Snapdragon but
executing that same compiled binary gave me "sh: ./fio: not
executable: magic 7F45" on a MediaTek (MT6572) device.

I tried to recompile both for ARM and x86 but still the same issue.
The binary is executable (did chmod it), so I'm not sure what is
causing this. I'd very much appreciate any input.

Thanks much!
David
