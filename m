Return-Path: <fio-owner@vger.kernel.org>
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:45204 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725961AbfE3RrW (ORCPT
        <rfc822;fio@vger.kernel.org>); Thu, 30 May 2019 13:47:22 -0400
Received: from pps.filterd (m0134423.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4UHklZe015637
        for <fio@vger.kernel.org>; Thu, 30 May 2019 17:47:21 GMT
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
        by mx0b-002e3701.pphosted.com with ESMTP id 2sth5f435s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <fio@vger.kernel.org>; Thu, 30 May 2019 17:47:21 +0000
Received: from G1W8106.americas.hpqcorp.net (g1w8106.austin.hp.com [16.193.72.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g2t2352.austin.hpe.com (Postfix) with ESMTPS id 24658B2
        for <fio@vger.kernel.org>; Thu, 30 May 2019 17:47:20 +0000 (UTC)
From: "Elliott, Robert (Servers)" <elliott@hpe.com>
Subject: gcc 9.1.1 warnings
Date: Thu, 30 May 2019 17:47:04 +0000
Message-ID: <DF4PR8401MB1180C0B2E0EB17690FB82DCEAB180@DF4PR8401MB1180.NAMPRD84.PROD.OUTLOOK.COM>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

As with gcc 8:

> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf Of Jens Axboe
> Sent: Tuesday, June 5, 2018 9:54 AM
> To: fio@vger.kernel.org
> Subject: gcc 8/8.1 warnings
> 
> Hi,
> 
> If someone is looking for a little project, compiling fio with
> gcc 8/8.1 triggers a new set of overflow warnings. I've included
> them below.

gcc 9.1.1, included in Fedora 30, triggers some new warnings on x86:

$ gcc --version
gcc (GCC) 9.1.1 20190503 (Red Hat 9.1.1-1)

$ make
    CC engines/mmap.o
eta.c: In function 'calc_thread_status':
eta.c:510:7: warning: taking address of packed member of 'struct jobs_eta' may result in an unaligned pointer value [-Waddress-of-packed-member]
  510 |     je->rate);
      |     ~~^~~~~~
eta.c:522:66: warning: taking address of packed member of 'struct jobs_eta' may result in an unaligned pointer value [-Waddress-of-packed-member]
  522 |  calc_rate(unified_rw_rep, disp_time, io_bytes, disp_io_bytes, je->rate);
      |                                                                ~~^~~~~~
eta.c:523:64: warning: taking address of packed member of 'struct jobs_eta' may result in an unaligned pointer value [-Waddress-of-packed-member]
  523 |  calc_iops(unified_rw_rep, disp_time, io_iops, disp_io_iops, je->iops);
      |                                                              ~~^~~~~~

...

    CC profiles/act.o
In file included from /usr/include/string.h:494,
                 from filesetup.c:3:
In function 'strncpy',
    inlined from 'get_fs_free_counts' at filesetup.c:832:3:
/usr/include/bits/string_fortified.h:106:10: warning: '__builtin_strncpy' output may be truncated copying 255 bytes from a string of length 255 [-Wstringop-truncation]
  106 |   return __builtin___strncpy_chk (__dest, __src, __len, __bos (__dest));
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

...
    CC blktrace.o
In file included from /usr/include/string.h:494,
                 from /usr/include/sys/un.h:37,
                 from server.c:10:
In function 'strncpy',
    inlined from 'fio_server_send_ts' at server.c:1473:2:
/usr/include/bits/string_fortified.h:106:10: warning: '__builtin_strncpy' output may be truncated copying 127 bytes from a string of length 127 [-Wstringop-truncation]
  106 |   return __builtin___strncpy_chk (__dest, __src, __len, __bos (__dest));
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function 'strncpy',
    inlined from 'fio_server_send_ts' at server.c:1474:2:
/usr/include/bits/string_fortified.h:106:10: warning: '__builtin_strncpy' output may be truncated copying 127 bytes from a string of length 127 [-Wstringop-truncation]
  106 |   return __builtin___strncpy_chk (__dest, __src, __len, __bos (__dest));
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function 'strncpy',
    inlined from 'fio_server_send_ts' at server.c:1475:2:
/usr/include/bits/string_fortified.h:106:10: warning: '__builtin_strncpy' output may be truncated copying 255 bytes from a string of length 255 [-Wstringop-truncation]
  106 |   return __builtin___strncpy_chk (__dest, __src, __len, __bos (__dest));
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from /usr/include/string.h:494,
                 from init.c:8:
In function 'strncpy',
    inlined from 'make_filename' at init.c:1356:4,
    inlined from 'add_job' at init.c:1478:18:
/usr/include/bits/string_fortified.h:106:10: warning: '__builtin_strncpy' output may be truncated copying 4095 bytes from a string of length 4095 [-Wstringop-truncation]
  106 |   return __builtin___strncpy_chk (__dest, __src, __len, __bos (__dest));
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

...
  LINK t/fio-verify-state
In function 'strncpy',
    inlined from '__parse_jobs_ini' at init.c:2042:6:
/usr/include/bits/string_fortified.h:106:10: warning: '__builtin_strncpy' output truncated before terminating nul copying as many bytes from a string as its length [-Wstringop-truncation]
  106 |   return __builtin___strncpy_chk (__dest, __src, __len, __bos (__dest));
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
init.c: In function '__parse_jobs_ini':
init.c:2042:6: note: length computed here
 2042 |      strncpy(full_fn + (ts - file) + 1,
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 2043 |       filename, strlen(filename));
      |       ~~~~~~~~~~~~~~~~~~~~~~~~~~~

...
  LINK t/lfsr-test
In file included from /usr/include/string.h:494,
                 from y.tab.c:87:
In function 'strncpy',
    inlined from 'setup_to_parse_string' at y.tab.c:1708:2,
    inlined from 'evaluate_arithmetic_expression' at y.tab.c:1720:2:
/usr/include/bits/string_fortified.h:106:10: warning: '__builtin___strncpy_chk' specified bound depends on the length of the source argument [-Wstringop-overflow=]
  106 |   return __builtin___strncpy_chk (__dest, __src, __len, __bos (__dest));
      |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
y.tab.c: In function 'evaluate_arithmetic_expression':
y.tab.c:1704:8: note: length computed here
 1704 |  len = strlen(string);
      |        ^~~~~~~~~~~~~~


---
Robert Elliott, HPE Persistent Memory


