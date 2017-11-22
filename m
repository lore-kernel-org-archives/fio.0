Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:45127 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752325AbdKVMhJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 22 Nov 2017 07:37:09 -0500
Received: by mail-wm0-f54.google.com with SMTP id 9so10018642wme.4
        for <fio@vger.kernel.org>; Wed, 22 Nov 2017 04:37:08 -0800 (PST)
Received: from [172.19.42.161] (static-186-95-145-212.ipcom.comunitel.net. [212.145.95.186])
        by smtp.gmail.com with ESMTPSA id m7sm12712443eda.91.2017.11.22.04.37.06
        for <fio@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 22 Nov 2017 04:37:06 -0800 (PST)
From: Paolo Valente <paolo.valente@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Subject: apparent read bandwidth mismatch
Message-Id: <DE427767-B386-4D12-9976-28C2646A9AC0@linaro.org>
Date: Wed, 22 Nov 2017 13:37:04 +0100
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,
I've noticed that the read mean bandwidth field (field 45), in fio
minimal output, is systematically higher than the bandwidth field (7).
In addition, field 45 is higher than the ratio "total I/O (field 6)" /
"runtime (field 9)", while field 7 is equal to this ratio.
Is there a reason for that?

Thanks,
Paolo
