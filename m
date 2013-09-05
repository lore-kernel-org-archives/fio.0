Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:37931 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab3IEXM4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 5 Sep 2013 19:12:56 -0400
Received: by mail-ie0-f177.google.com with SMTP id e14so5168294iej.22
        for <fio@vger.kernel.org>; Thu, 05 Sep 2013 16:12:55 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 5 Sep 2013 16:12:55 -0700
Message-ID: <CANEJEGs8PRprCWAa_a_kMPqJNCZ8zKRDvab0yy+M6SKMdkqk7g@mail.gmail.com>
Subject: bug in fio file offset tracking
From: Grant Grundler <grundler@chromium.org>
Content-Type: multipart/mixed; boundary=20cf3010ec25e6d79e04e5ab0f40
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: FIO_list <fio@vger.kernel.org>
Cc: Juan Casse <jcasse@chromium.org>

--20cf3010ec25e6d79e04e5ab0f40
Content-Type: text/plain; charset=UTF-8

Juan found a bug in fio verify. On the second iteration of verifying a
file, the position tracking is broken. In the strace output below, the
second lseek is missing after re-opening the test file to verify a
second time.

I suspect the problem is fio is tracking it's position in the file but
didn't clear that position tracking after closing (or opening) the
file. And since fio thinks it's at the right position, no lseek is
issued. Just a guess.

job files attached. Very small test file gets created (64KB).

cheers,
grant

./fio example/juan_write.fio
...
strace -f -e lseek,read,close,open ./fio examples/juan_verify.fio
...
[pid 21828] open("juan_write_file", O_RDONLY) = 3
[pid 21828] lseek(3, 57344, SEEK_SET)   = 57344
[pid 21828] read(3, "\312\254\n\0\0
\0\0\0\0\0\0\0\0\0\0\226\300`\316\377\377\377\377\0\340\0\0\0\0\0\0"...,
8192) = 8192
[pid 21828] lseek(3, 0, SEEK_SET)       = 0
[pid 21828] read(3, "\312\254\n\0\0
\0\0\0\0\0\0\0\0\0\0\226\300`\316\377\377\377\377\0\0\0\0\0\0\0\0"...,
8192) = 8192
[pid 21828] read(3, "\312\254\n\0\0
\0\0\0\0\0\0\0\0\0\0\226\300`\316\377\377\377\377\0 \0\0\0\0\0\0"...,
8192) = 8192
[pid 21828] read(3, "\312\254\n\0\0
\0\0\0\0\0\0\0\0\0\0\226\300`\316\377\377\377\377\0@\0\0\0\0\0\0"...,
8192) = 8192
[pid 21828] read(3, "\312\254\n\0\0
\0\0\0\0\0\0\0\0\0\0\226\300`\316\377\377\377\377\0`\0\0\0\0\0\0"...,
8192) = 8192
[pid 21828] read(3, "\312\254\n\0\0
\0\0\0\0\0\0\0\0\0\0\226\300`\316\377\377\377\377\0\200\0\0\0\0\0\0"...,
8192) = 8192
[pid 21828] read(3, "\312\254\n\0\0
\0\0\0\0\0\0\0\0\0\0\226\300`\316\377\377\377\377\0\240\0\0\0\0\0\0"...,
8192) = 8192
[pid 21828] read(3, "\312\254\n\0\0
\0\0\0\0\0\0\0\0\0\0\226\300`\316\377\377\377\377\0\300\0\0\0\0\0\0"...,
8192) = 8192
[pid 21828] close(3)                    = 0
[pid 21828] open("juan_write_file", O_RDONLY) = 3
[pid 21828] read(3, "\312\254\n\0\0
\0\0\0\0\0\0\0\0\0\0\226\300`\316\377\377\377\377\0\0\0\0\0\0\0\0"...,
8192) = 8192
meta: verify failed at file juan_write_file offset 57344, length 8192
[pid 21828] open("juan_write_file.57344.received",
O_WRONLY|O_CREAT|O_TRUNC, 0644) = 4
[pid 21828] close(4)                    = 0
       received data dumped as juan_write_file.57344.received
[pid 21828] open("juan_write_file.57344.expected",
O_WRONLY|O_CREAT|O_TRUNC, 0644) = 4
[pid 21828] close(4)                    = 0
       expected data dumped as juan_write_file.57344.expected
[pid 21828] lseek(3, 0, SEEK_SET)       = 0
[pid 21828] read(3, "\312\254\n\0\0
\0\0\0\0\0\0\0\0\0\0\226\300`\316\377\377\377\377\0\0\0\0\0\0\0\0"...,
8192) = 8192
[pid 21828] read(3,  <unfinished ...>

--20cf3010ec25e6d79e04e5ab0f40
Content-Type: application/octet-stream; name="juan_write.fio"
Content-Disposition: attachment; filename="juan_write.fio"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hl8l7olf0

W2p1YW5fd3JpdGVdCnJlYWR3cml0ZT1yYW5kd3JpdGUKcmFuZHJlcGVhdD0xCnNpemU9NjRrCmJz
PThrCmlvZW5naW5lPXN5bmMKZmlsZW5hbWU9anVhbl93cml0ZV9maWxlCm5vcmFuZG9tbWFwCmxv
b3BzPTIKdmVyaWZ5PW1ldGEKdmVyaWZ5X3BhdHRlcm49MHhmZmZmZmZmZmZmZmZmZmZmCnZlcmlm
eV9kdW1wPTEKY29udGludWVfb25fZXJyb3I9dmVyaWZ5CnJhbmRvbV9nZW5lcmF0b3I9bGZzcgo=
--20cf3010ec25e6d79e04e5ab0f40
Content-Type: application/octet-stream; name="juan_verify.fio"
Content-Disposition: attachment; filename="juan_verify.fio"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hl8l7xkg1

W2p1YW5fdmVyaWZ5XQpyZWFkd3JpdGU9cmFuZHJlYWQKcmFuZHJlcGVhdD0xCnNpemU9NjRrCmJz
PThrCmlvZW5naW5lPXN5bmMKbm9yYW5kb21tYXAKZmlsZW5hbWU9anVhbl93cml0ZV9maWxlCmxv
b3BzPTIKdmVyaWZ5PW1ldGEKdmVyaWZ5X3BhdHRlcm49MHhmZmZmZmZmZmZmZmZmZmZmCnZlcmlm
eV9kdW1wPTEKY29udGludWVfb25fZXJyb3I9dmVyaWZ5CnJhbmRvbV9nZW5lcmF0b3I9bGZzcgo=
--20cf3010ec25e6d79e04e5ab0f40--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


