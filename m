Return-Path: <prvs=77166e16d=Niklas.Cassel@wdc.com>
From: Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 1/2] zbd: add missing client/server support for option
 max_open_zones
Date: Mon, 24 May 2021 14:41:20 +0000
Message-ID: <20210524144109.12127-1-Niklas.Cassel@wdc.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, Niklas Cassel <Niklas.Cassel@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Niklas Cassel <niklas.cassel@wdc.com>

Ensure that we convert the max_open_zones option for client/server.

Use __cpu_to_le32()/__le32_to_cpu() rather than
cpu_to_le32()/le32_to_cpu(), since max_open_zones is defined
as int rather than unsigned int in thread_options.h.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
Changes since V1:
- New patch.

 cconv.c          | 2 ++
 server.h         | 2 +-
 thread_options.h | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/cconv.c b/cconv.c
index aa06e3ea..d4dfb81b 100644
--- a/cconv.c
+++ b/cconv.c
@@ -231,6 +231,7 @@ void convert_thread_options_to_cpu(struct thread_option=
s *o,
 	o->zone_capacity =3D le64_to_cpu(top->zone_capacity);
 	o->zone_skip =3D le64_to_cpu(top->zone_skip);
 	o->zone_mode =3D le32_to_cpu(top->zone_mode);
+	o->max_open_zones =3D __le32_to_cpu(top->max_open_zones);
 	o->lockmem =3D le64_to_cpu(top->lockmem);
 	o->offset_increment_percent =3D le32_to_cpu(top->offset_increment_percent=
);
 	o->offset_increment =3D le64_to_cpu(top->offset_increment);
@@ -573,6 +574,7 @@ void convert_thread_options_to_net(struct thread_option=
s_pack *top,
 	top->zone_capacity =3D __cpu_to_le64(o->zone_capacity);
 	top->zone_skip =3D __cpu_to_le64(o->zone_skip);
 	top->zone_mode =3D __cpu_to_le32(o->zone_mode);
+	top->max_open_zones =3D __cpu_to_le32(o->max_open_zones);
 	top->lockmem =3D __cpu_to_le64(o->lockmem);
 	top->ddir_seq_add =3D __cpu_to_le64(o->ddir_seq_add);
 	top->file_size_low =3D __cpu_to_le64(o->file_size_low);
diff --git a/server.h b/server.h
index b45b319b..8cf3a60b 100644
--- a/server.h
+++ b/server.h
@@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
 };
=20
 enum {
-	FIO_SERVER_VER			=3D 89,
+	FIO_SERVER_VER			=3D 90,
=20
 	FIO_SERVER_MAX_FRAGMENT_PDU	=3D 1024,
 	FIO_SERVER_MAX_CMD_MB		=3D 2048,
diff --git a/thread_options.h b/thread_options.h
index 5ecc72d7..4d48e462 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -656,6 +656,7 @@ struct thread_options_pack {
 	uint32_t allow_mounted_write;
=20
 	uint32_t zone_mode;
+	int32_t max_open_zones;
 } __attribute__((packed));
=20
 extern void convert_thread_options_to_cpu(struct thread_options *o, struct=
 thread_options_pack *top);
--=20
2.25.1

