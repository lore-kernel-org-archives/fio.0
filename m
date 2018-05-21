Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:36421 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753132AbeEUREm (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 21 May 2018 13:04:42 -0400
Received: by mail-lf0-f45.google.com with SMTP id e9-v6so8022797lfb.3
        for <fio@vger.kernel.org>; Mon, 21 May 2018 10:04:41 -0700 (PDT)
MIME-Version: 1.0
From: Konstantin Ruvinsky <konstantin.ruvinsky@gmail.com>
Date: Mon, 21 May 2018 20:04:40 +0300
Message-ID: <CALKvLUnbsqZ8VDW5yKc8vbLU-3Sa4eMu2vb7u2vqm0NFQo+FZQ@mail.gmail.com>
Subject: bssplit option HOWTO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi



In the last HOWTO is written:



http://git.kernel.dk/?p=3Dfio.git;a=3Dblob;f=3DHOWTO;h=3D7680f9c7634a7e5504=
4dba0a8ebdc6928fb3bfc0;hb=3DHEAD#l1429





1429       If you want a workload that has 50% 2k reads and 50% 4k reads, w=
hile

1430         having 90% 4k writes and 10% 8k writes, you would specify::

1431

1432                 bssplit=3D2k/50:4k/50,4k/90,8k/10



Question:

Has it be



bssplit=3D2k/50:4k/50,4k/90:8k/10



,hasn=E2=80=99t it?



Thanks

Konstantin
