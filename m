Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbhEaKBM (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 May 2021 06:01:12 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0202EC061358
        for <fio@vger.kernel.org>; Mon, 31 May 2021 02:59:03 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id dj8so561761edb.6
        for <fio@vger.kernel.org>; Mon, 31 May 2021 02:59:02 -0700 (PDT)
Received: from [192.168.1.19] (77-121-228-123.kra.volia.net. [77.121.228.123])
        by smtp.gmail.com with ESMTPSA id w11sm7181766ede.54.2021.05.31.02.59.00
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 02:59:01 -0700 (PDT)
From: Volodymyr Hoida <volodymyrhoida@gmail.com>
Subject: Web Based frontend for fio
Message-ID: <f9c58495-153f-b7e2-bc26-e4b75da9b28c@gmail.com>
Date: Mon, 31 May 2021 12:59:00 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

I've implemented recently fio as the backend for disk benchmark for the 
w3top project. Integration tests convers big range of supported fio 
versions - from 2.0 to 3.26

GUI is modern web-based single-page app with support for a large range 
of browsers.

Benchmark GUI is simple as Crystal Disk Mark and provides the wizard for 
volume chooser, benchmark options, and progress visualization. Benchmark 
history is also implemented. Missing support of Direct IO for a 
particular volume is auto-detected. Also for read-only volumes, 
preexisting large files are used for the benchmark.

The cross-platform installer (bash script) supports x86_64, ARMv7, and 
AARCH64 architectures. Tested OSes start from RHEL 6 up to the latest 
rolling Linux distributives. One-liner: 
https://github.com/devizer/w3top-bin#reinstallation-of-precompiled-binaries. 


In addition to modern mainstream browsers (Chrome, Firefox, Edge, Opera) 
many years old browsers are also supported:
- Builtin Safari on iOS 9.2+
- Builtin Chrome on Android 5.1+
- IE 11, a builtin browser on Windows Server
- Firefox ESR 52 and Chrome 49, the latest browsers for Windows XP/2003

The w3top project also includes precompiled fio for a matrix of 
architectures and versions. In case then fio is not preinstalled proper 
version of fio is downloaded and checked on app start.

Now only non-destructive write benchmarks are used using --filename option.

Live: http://xeon.devizer.top/disk-benchmark (hdd in google cloud) and 
http://pi.devizer.top/disk-benchmark (ARMv7 board running on Kingston A1 
micro sd card)

Links:
w3top binaries distribution project and installer: 
https://github.com/devizer/w3top-bin
Source Code: https://github.com/devizer/KernelManagementLab


