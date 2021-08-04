Return-Path: <vincent.fu@samsung.com>
From: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 2/2] ioengines: fix crash with --enghelp option
Date: Wed, 4 Aug 2021 18:29:05 +0000
Message-ID: <20210804182841.8780-3-vincent.fu@samsung.com>
In-Reply-To: <20210804182841.8780-1-vincent.fu@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
References: <20210804182841.8780-1-vincent.fu@samsung.com>
	<CGME20210804182905uscas1p2593bfafae6dcfa01c47c43290325888c@uscas1p2.samsung.com>
To: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Vincent Fu <vincent.fu@samsung.com>
List-ID: <fio@vger.kernel.org>

Since f6931a1dd35896433c8cc2e10de51372a2c496c4 commands like the
following segfault:

fio --enghelp=3Dsg
fio --enghelp=3Dsg,sg_write_mode

This is because free_ioengine() assumes that td->io_ops is not NULL.
Make this true when free_ioengine() is called by
fio_show_ioengine_help() to avoid the crash.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 ioengines.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/ioengines.c b/ioengines.c
index dd61af07..d08a511a 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -692,17 +692,17 @@ int fio_show_ioengine_help(const char *engine)
 	}
=20
 	td.o.ioengine =3D (char *)engine;
-	io_ops =3D load_ioengine(&td);
+	td.io_ops =3D load_ioengine(&td);
=20
-	if (!io_ops) {
+	if (!td.io_ops) {
 		log_info("IO engine %s not found\n", engine);
 		return 1;
 	}
=20
-	if (io_ops->options)
-		ret =3D show_cmd_help(io_ops->options, sep);
+	if (td.io_ops->options)
+		ret =3D show_cmd_help(td.io_ops->options, sep);
 	else
-		log_info("IO engine %s has no options\n", io_ops->name);
+		log_info("IO engine %s has no options\n", td.io_ops->name);
=20
 	free_ioengine(&td);
 	return ret;
--=20
2.25.1

