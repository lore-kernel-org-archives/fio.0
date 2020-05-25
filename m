Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-eopbgr690098.outbound.protection.outlook.com ([40.107.69.98]:61696
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388621AbgEYRpJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 25 May 2020 13:45:09 -0400
From: Hamilton Tobon Mosquera <htobonm@eafit.edu.co>
Subject: [io_uring] Problems using io_uring engine
Message-ID: <4f70c99f-e5c8-08f7-ebe9-1bbdea73305d@eafit.edu.co>
Date: Mon, 25 May 2020 13:45:03 -0400
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi there,

I'm trying to run sequential and random reads/writes in parallel using 
the io_uring engine with the HIPRI flag activated to enable polling. The 
file size is 200G, the number of fio threads is 4. The --size flags is 
set to 200/4, and the --offset_increment is set to 25%. I could 
effectively do it with pvsync2 engine but when I switch to io_uring the 
workloads immediately (they do not even work for 1 sec) fail with these 
errors:

fio: io_u error on file /path/to/file: Operation not supported: write 
offset=3238043648, buflen=4096
fio: io_u error on file /path/to/file: Operation not supported: write 
offset=88715874304, buflen=4096
fio: io_u error on file /path/to/file: Operation not supported: write 
offset=174739943424, buflen=4096
fio: io_u error on file /path/to/file: Operation not supported: write 
offset=112642154496, buflen=4096


The offsets are under 200G, I don't understand why it's returning those 
errors. Can someone help please?.

Thank you in advance.

Hamilton.



