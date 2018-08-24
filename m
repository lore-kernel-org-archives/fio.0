Return-Path: <prvs=76726b587=bart.vanassche@wdc.com>
From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 06/11] Add two assert statements in mark_random_map()
Date: Fri, 24 Aug 2018 09:30:41 -0700
Message-Id: <20180824163046.12304-7-bart.vanassche@wdc.com>
In-Reply-To: <20180824163046.12304-1-bart.vanassche@wdc.com>
References: <20180824163046.12304-1-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bart.vanassche@wdc.com>
List-ID: <fio@vger.kernel.org>

Add two assert statements that verify whether mark_random_map() is
used correctly.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
---
 io_u.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/io_u.c b/io_u.c
index eed7d9d91c8d..9b5f203c4733 100644
--- a/io_u.c
+++ b/io_u.c
@@ -41,9 +41,12 @@ static uint64_t mark_random_map(struct thread_data *td, struct io_u *io_u,
 
 	block = (offset - f->file_offset) / (uint64_t) min_bs;
 	nr_blocks = (buflen + min_bs - 1) / min_bs;
+	assert(nr_blocks > 0);
 
-	if (!(io_u->flags & IO_U_F_BUSY_OK))
+	if (!(io_u->flags & IO_U_F_BUSY_OK)) {
 		nr_blocks = axmap_set_nr(f->io_axmap, block, nr_blocks);
+		assert(nr_blocks > 0);
+	}
 
 	if ((nr_blocks * min_bs) < buflen)
 		buflen = nr_blocks * min_bs;
-- 
2.18.0


