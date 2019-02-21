Return-Path: <prvs=94868c4cd=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2 3/9] sg: Clean up handling of big endian data fields
Date: Thu, 21 Feb 2019 13:11:01 +0900
Message-Id: <20190221041107.8576-4-damien.lemoal@wdc.com>
In-Reply-To: <20190221041107.8576-1-damien.lemoal@wdc.com>
References: <20190221041107.8576-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>, Matias Bjorling <matias.bjorling@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

From: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Getting and setting values in SCSI commands and descriptors,
which are big endian, in SG driver can use a bit of cleanup.
This patch simplifies SG driver code by introducing a set of
accessor functions for reading raw big endian values from SCSI
buffers and another set for properly storing the local values
as big endian byte sequences.

The patch also adds some missing endianness conversion macros
in os.h.

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
---
 engines/sg.c | 108 +++++++++++++++++++++++++--------------------------
 os/os.h      |  24 ++++++++++++
 2 files changed, 77 insertions(+), 55 deletions(-)

diff --git a/engines/sg.c b/engines/sg.c
index 9105c24c..d681ac93 100644
--- a/engines/sg.c
+++ b/engines/sg.c
@@ -137,7 +137,7 @@ struct sgio_cmd {
 };
 
 struct sgio_trim {
-	char *unmap_param;
+	uint8_t *unmap_param;
 	unsigned int unmap_range_count;
 	struct io_u **trim_io_us;
 };
@@ -157,6 +157,42 @@ struct sgio_data {
 #endif
 };
 
+static inline uint16_t sgio_get_be16(uint8_t *buf)
+{
+	return be16_to_cpu(*((uint16_t *) buf));
+}
+
+static inline uint32_t sgio_get_be32(uint8_t *buf)
+{
+	return be32_to_cpu(*((uint32_t *) buf));
+}
+
+static inline uint64_t sgio_get_be64(uint8_t *buf)
+{
+	return be64_to_cpu(*((uint64_t *) buf));
+}
+
+static inline void sgio_set_be16(uint16_t val, uint8_t *buf)
+{
+	uint16_t t = cpu_to_be16(val);
+
+	memcpy(buf, &t, sizeof(uint16_t));
+}
+
+static inline void sgio_set_be32(uint32_t val, uint8_t *buf)
+{
+	uint32_t t = cpu_to_be32(val);
+
+	memcpy(buf, &t, sizeof(uint32_t));
+}
+
+static inline void sgio_set_be64(uint64_t val, uint8_t *buf)
+{
+	uint64_t t = cpu_to_be64(val);
+
+	memcpy(buf, &t, sizeof(uint64_t));
+}
+
 static inline bool sgio_unbuffered(struct thread_data *td)
 {
 	return (td->o.odirect || td->o.sync_io);
@@ -440,25 +476,11 @@ static void fio_sgio_rw_lba(struct sg_io_hdr *hdr, unsigned long long lba,
 			    unsigned long long nr_blocks)
 {
 	if (lba < MAX_10B_LBA) {
-		hdr->cmdp[2] = (unsigned char) ((lba >> 24) & 0xff);
-		hdr->cmdp[3] = (unsigned char) ((lba >> 16) & 0xff);
-		hdr->cmdp[4] = (unsigned char) ((lba >>  8) & 0xff);
-		hdr->cmdp[5] = (unsigned char) (lba & 0xff);
-		hdr->cmdp[7] = (unsigned char) ((nr_blocks >> 8) & 0xff);
-		hdr->cmdp[8] = (unsigned char) (nr_blocks & 0xff);
+		sgio_set_be32((uint32_t) lba, &hdr->cmdp[2]);
+		sgio_set_be16((uint16_t) nr_blocks, &hdr->cmdp[7]);
 	} else {
-		hdr->cmdp[2] = (unsigned char) ((lba >> 56) & 0xff);
-		hdr->cmdp[3] = (unsigned char) ((lba >> 48) & 0xff);
-		hdr->cmdp[4] = (unsigned char) ((lba >> 40) & 0xff);
-		hdr->cmdp[5] = (unsigned char) ((lba >> 32) & 0xff);
-		hdr->cmdp[6] = (unsigned char) ((lba >> 24) & 0xff);
-		hdr->cmdp[7] = (unsigned char) ((lba >> 16) & 0xff);
-		hdr->cmdp[8] = (unsigned char) ((lba >>  8) & 0xff);
-		hdr->cmdp[9] = (unsigned char) (lba & 0xff);
-		hdr->cmdp[10] = (unsigned char) ((nr_blocks >> 32) & 0xff);
-		hdr->cmdp[11] = (unsigned char) ((nr_blocks >> 16) & 0xff);
-		hdr->cmdp[12] = (unsigned char) ((nr_blocks >> 8) & 0xff);
-		hdr->cmdp[13] = (unsigned char) (nr_blocks & 0xff);
+		sgio_set_be64(lba, &hdr->cmdp[2]);
+		sgio_set_be32((uint32_t) nr_blocks, &hdr->cmdp[10]);
 	}
 
 	return;
@@ -552,18 +574,8 @@ static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 #endif
 
 		offset = 8 + 16 * st->unmap_range_count;
-		st->unmap_param[offset] = (unsigned char) ((lba >> 56) & 0xff);
-		st->unmap_param[offset+1] = (unsigned char) ((lba >> 48) & 0xff);
-		st->unmap_param[offset+2] = (unsigned char) ((lba >> 40) & 0xff);
-		st->unmap_param[offset+3] = (unsigned char) ((lba >> 32) & 0xff);
-		st->unmap_param[offset+4] = (unsigned char) ((lba >> 24) & 0xff);
-		st->unmap_param[offset+5] = (unsigned char) ((lba >> 16) & 0xff);
-		st->unmap_param[offset+6] = (unsigned char) ((lba >>  8) & 0xff);
-		st->unmap_param[offset+7] = (unsigned char) (lba & 0xff);
-		st->unmap_param[offset+8] = (unsigned char) ((nr_blocks >> 32) & 0xff);
-		st->unmap_param[offset+9] = (unsigned char) ((nr_blocks >> 16) & 0xff);
-		st->unmap_param[offset+10] = (unsigned char) ((nr_blocks >> 8) & 0xff);
-		st->unmap_param[offset+11] = (unsigned char) (nr_blocks & 0xff);
+		sgio_set_be64(lba, &st->unmap_param[offset]);
+		sgio_set_be32((uint32_t) nr_blocks, &st->unmap_param[offset + 8]);
 
 		st->unmap_range_count++;
 
@@ -582,14 +594,12 @@ static int fio_sgio_prep(struct thread_data *td, struct io_u *io_u)
 
 static void fio_sgio_unmap_setup(struct sg_io_hdr *hdr, struct sgio_trim *st)
 {
-	hdr->dxfer_len = st->unmap_range_count * 16 + 8;
-	hdr->cmdp[7] = (unsigned char) (((st->unmap_range_count * 16 + 8) >> 8) & 0xff);
-	hdr->cmdp[8] = (unsigned char) ((st->unmap_range_count * 16 + 8) & 0xff);
+	uint16_t cnt = st->unmap_range_count * 16;
 
-	st->unmap_param[0] = (unsigned char) (((16 * st->unmap_range_count + 6) >> 8) & 0xff);
-	st->unmap_param[1] = (unsigned char)  ((16 * st->unmap_range_count + 6) & 0xff);
-	st->unmap_param[2] = (unsigned char) (((16 * st->unmap_range_count) >> 8) & 0xff);
-	st->unmap_param[3] = (unsigned char)  ((16 * st->unmap_range_count) & 0xff);
+	hdr->dxfer_len = cnt + 8;
+	sgio_set_be16(cnt + 8, &hdr->cmdp[7]);
+	sgio_set_be16(cnt + 6, st->unmap_param);
+	sgio_set_be16(cnt, &st->unmap_param[2]);
 
 	return;
 }
@@ -765,10 +775,8 @@ static int fio_sgio_read_capacity(struct thread_data *td, unsigned int *bs,
 		/* RCAP(10) might be unsupported by device. Force RCAP(16) */
 		hlba = MAX_10B_LBA;
 	} else {
-		blksz	 = ((unsigned long) buf[4] << 24) | ((unsigned long) buf[5] << 16) |
-			   ((unsigned long) buf[6] << 8) | (unsigned long) buf[7];
-		hlba	 = ((unsigned long) buf[0] << 24) | ((unsigned long) buf[1] << 16) |
-			   ((unsigned long) buf[2] << 8) | (unsigned long) buf[3];
+		blksz = sgio_get_be32(&buf[4]);
+		hlba = sgio_get_be32(buf);
 	}
 
 	/*
@@ -779,10 +787,7 @@ static int fio_sgio_read_capacity(struct thread_data *td, unsigned int *bs,
 		hdr.cmd_len = 16;
 		hdr.cmdp[0] = 0x9e; // service action
 		hdr.cmdp[1] = 0x10; // Read Capacity(16)
-		hdr.cmdp[10] = (unsigned char) ((sizeof(buf) >> 24) & 0xff);
-		hdr.cmdp[11] = (unsigned char) ((sizeof(buf) >> 16) & 0xff);
-		hdr.cmdp[12] = (unsigned char) ((sizeof(buf) >> 8) & 0xff);
-		hdr.cmdp[13] = (unsigned char) (sizeof(buf) & 0xff);
+		sgio_set_be32(sizeof(buf), &hdr.cmdp[10]);
 
 		hdr.dxfer_direction = SG_DXFER_FROM_DEV;
 		hdr.dxferp = buf;
@@ -798,15 +803,8 @@ static int fio_sgio_read_capacity(struct thread_data *td, unsigned int *bs,
 		if (hdr.info & SG_INFO_CHECK)
 			td_verror(td, EIO, "fio_sgio_read_capacity");
 
-		blksz = (buf[8] << 24) | (buf[9] << 16) | (buf[10] << 8) | buf[11];
-		hlba  = ((unsigned long long)buf[0] << 56) |
-			((unsigned long long)buf[1] << 48) |
-			((unsigned long long)buf[2] << 40) |
-			((unsigned long long)buf[3] << 32) |
-			((unsigned long long)buf[4] << 24) |
-			((unsigned long long)buf[5] << 16) |
-			((unsigned long long)buf[6] << 8) |
-			(unsigned long long)buf[7];
+		blksz = sgio_get_be32(&buf[8]);
+		hlba = sgio_get_be64(buf);
 	}
 
 	if (blksz) {
diff --git a/os/os.h b/os/os.h
index 0b182c4a..36b6bb2e 100644
--- a/os/os.h
+++ b/os/os.h
@@ -210,19 +210,27 @@ static inline uint64_t fio_swap64(uint64_t val)
 
 #ifndef FIO_HAVE_BYTEORDER_FUNCS
 #ifdef CONFIG_LITTLE_ENDIAN
+#define __be16_to_cpu(x)		fio_swap16(x)
+#define __be32_to_cpu(x)		fio_swap32(x)
 #define __be64_to_cpu(x)		fio_swap64(x)
 #define __le16_to_cpu(x)		(x)
 #define __le32_to_cpu(x)		(x)
 #define __le64_to_cpu(x)		(x)
+#define __cpu_to_be16(x)		fio_swap16(x)
+#define __cpu_to_be32(x)		fio_swap32(x)
 #define __cpu_to_be64(x)		fio_swap64(x)
 #define __cpu_to_le16(x)		(x)
 #define __cpu_to_le32(x)		(x)
 #define __cpu_to_le64(x)		(x)
 #else
+#define __be16_to_cpu(x)		(x)
+#define __be32_to_cpu(x)		(x)
 #define __be64_to_cpu(x)		(x)
 #define __le16_to_cpu(x)		fio_swap16(x)
 #define __le32_to_cpu(x)		fio_swap32(x)
 #define __le64_to_cpu(x)		fio_swap64(x)
+#define __cpu_to_be16(x)		(x)
+#define __cpu_to_be32(x)		(x)
 #define __cpu_to_be64(x)		(x)
 #define __cpu_to_le16(x)		fio_swap16(x)
 #define __cpu_to_le32(x)		fio_swap32(x)
@@ -231,6 +239,14 @@ static inline uint64_t fio_swap64(uint64_t val)
 #endif /* FIO_HAVE_BYTEORDER_FUNCS */
 
 #ifdef FIO_INTERNAL
+#define be16_to_cpu(val) ({			\
+	typecheck(uint16_t, val);		\
+	__be16_to_cpu(val);			\
+})
+#define be32_to_cpu(val) ({			\
+	typecheck(uint32_t, val);		\
+	__be32_to_cpu(val);			\
+})
 #define be64_to_cpu(val) ({			\
 	typecheck(uint64_t, val);		\
 	__be64_to_cpu(val);			\
@@ -249,6 +265,14 @@ static inline uint64_t fio_swap64(uint64_t val)
 })
 #endif
 
+#define cpu_to_be16(val) ({			\
+	typecheck(uint16_t, val);		\
+	__cpu_to_be16(val);			\
+})
+#define cpu_to_be32(val) ({			\
+	typecheck(uint32_t, val);		\
+	__cpu_to_be32(val);			\
+})
 #define cpu_to_be64(val) ({			\
 	typecheck(uint64_t, val);		\
 	__cpu_to_be64(val);			\
-- 
2.20.1


