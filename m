Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:36195 "EHLO
	mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235AbcCaQoM (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 31 Mar 2016 12:44:12 -0400
Received: by mail-vk0-f45.google.com with SMTP id z68so110556861vkg.3
        for <fio@vger.kernel.org>; Thu, 31 Mar 2016 09:44:12 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 31 Mar 2016 10:44:11 -0600
Message-ID: <CAANLjFrvQhEt02+7csMxnBg_fvLyJ8DWWxnAWf1MExSQTqCpMw@mail.gmail.com>
Subject: fio: rdma_create_event_channel fail
From: Robert LeBlanc <robert@leblancnet.us>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

When trying to use the RDMA engine and the example job for the server
with the port set to an arbitrary value I get:

# /home/rleblanc/fio/fio /home/rleblanc/fio/examples/rdmaio-server.fio
receiver: (g=0): rw=read, bs=1M-1M/1M-1M/1M-1M, ioengine=rdma, iodepth=16
fio-2.8-14-g23a8
Starting 1 process
fio: rdma_create_event_channel fail
fio: io engine init failed. Perhaps try reducing io depth?
fio: pid=18588, err=1/

Setting I/O depth=1 only removed the corresponding message from the output.
# uname -r
4.1.15.bs.ufd

# rpm -qa | grep -E "ibverbs|rdmacm"
libibverbs-devel-1.1.8-8.el7.x86_64
librdmacm-1.0.21-1.el7.x86_64
libibverbs-1.1.8-8.el7.x86_64
librdmacm-devel-1.0.21-1.el7.x86_64

I'm not sure what is wrong as this is the first time I've tried using
the RDMA engine.
- ----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
-----BEGIN PGP SIGNATURE-----
Version: Mailvelope v1.3.6
Comment: https://www.mailvelope.com

wsFcBAEBCAAQBQJW/VPPCRDmVDuy+mK58QAAPKMQAJF8B3y8pk9l2emtsrGm
2Rt7ufstv6c4XtuCk2wsc6ocZe8yNfAM1BNkW6pTF96orHZuLTt/QDvbDlnN
q6N0vPkGJbDVbm7YNDzFc4qOU1pbrn8a66eck5BKuHPPogXCsJJTu+rdfAd9
TNUGD4b9MzogTCzI8Zs6YRdWLIeaJRsPaHqJGYsD5G83rxGFagjx0qoOPuF+
CNcFVYXZeU3+/YzsTDfuvNtiSDDJTUe3Shjw6fSu8ZFNabucAbbGOflovIIL
kGjFmprrFgqOLiTnw7muF6tSXcc205YMGbCgOiEye4i9Ajd/ITiEQ3QlbQZ1
WDz5WPSukDR8KqJoREKcksWVL7zVciulE5/+ZlJajD02JfOTz7j9QydLAPJ/
sQM1g7Ft5HZK8TB9IgVKBernHCpahNQ5dU2OadDgpe0rxjzjrVcxegYOqLPd
iUVFT2/UUFwzxaVnxHXTDNGO5A4JSyctvPTQ4uKLFFox9p6L5pFgrz9o86Fs
lbW/72IjJD/8AEC64cqJp6JuC/sSEmz2hPpOvKdbpWPlVijzPB0OnpkMB4cC
DATo4afT5uDRDe7IS8Ypi/WcriVLA+O9jRsigARri1F4FFc1QR/FDtXQnKYE
SKB8sOE6sAv8qsyNLDqyD3rAzjRJ267zweNcWficcrHD3pYljXCLK1oaZgHD
EcOB
=f1X7
-----END PGP SIGNATURE-----
