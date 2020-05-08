Return-Path: <prvs=390c41bd8=damien.lemoal@wdc.com>
From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2 1/7] iolog: Fix write_iolog_close()
Date: Fri,  8 May 2020 16:56:39 +0900
Message-Id: <20200508075645.543890-2-damien.lemoal@wdc.com>
In-Reply-To: <20200508075645.543890-1-damien.lemoal@wdc.com>
References: <20200508075645.543890-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: fio@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

If the init_iolog() call from backend.c thread_main() fails (e.g. wrong
file path given), td->iolog_f is not set but write_iolog_close() is
still called from thread_main() error processing. This causes a seg
fault and unclean termination of fio. Fix this by changing
write_iolog_close() to do nothing if td->iolog_f is NULL.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 iolog.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/iolog.c b/iolog.c
index 917a446c..4a79fc46 100644
--- a/iolog.c
+++ b/iolog.c
@@ -342,6 +342,9 @@ void trim_io_piece(const struct io_u *io_u)
 
 void write_iolog_close(struct thread_data *td)
 {
+	if (!td->iolog_f)
+		return;
+
 	fflush(td->iolog_f);
 	fclose(td->iolog_f);
 	free(td->iolog_buf);
-- 
2.25.4


