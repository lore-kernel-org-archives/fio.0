Return-Path: <prvs=774f89111=jeff.furlong@wdc.com>
From: Jeff Furlong <jeff.furlong@wdc.com>
Subject: [PATCH] client: fix nr_samples
Date: Fri, 31 Aug 2018 18:26:05 +0000
Message-ID: 
 <MWHPR04MB0320E9310CC7A95563EB30698F0F0@MWHPR04MB0320.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

In convert_iolog_gz() a 32 bit variable is created to store struct cmd_iolo=
g_pdu's 64 bit member.


diff --git a/client.c b/client.c
index a868e3a..31c7c64 100644
--- a/client.c
+++ b/client.c
@@ -1539,7 +1539,7 @@ static struct cmd_iolog_pdu *convert_iolog_gz(struct =
fio_net_cmd *cmd,
 #ifdef CONFIG_ZLIB
 	struct cmd_iolog_pdu *ret;
 	z_stream stream;
-	uint32_t nr_samples;
+	uint64_t nr_samples;
 	size_t total;
 	char *p;


Regards,
Jeff


