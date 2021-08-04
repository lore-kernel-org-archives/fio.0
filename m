Return-Path: <vincent.fu@samsung.com>
From: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 0/2] two small patches
Date: Wed, 4 Aug 2021 18:29:02 +0000
Message-ID: <20210804182841.8780-1-vincent.fu@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
References: <CGME20210804182903uscas1p164abe67510e8fa693dbd5d999ecdf24f@uscas1p1.samsung.com>
To: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Vincent Fu <vincent.fu@samsung.com>
List-ID: <fio@vger.kernel.org>

Hello Jens,

Please consider these two small patches that (1) clarify an error
message and (2) fix a segfault.

Vincent

Vincent Fu (2):
  backend: clarify io scheduler setting error message
  ioengines: fix crash with --enghelp option

 backend.c   |  2 +-
 ioengines.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

--=20
2.25.1

