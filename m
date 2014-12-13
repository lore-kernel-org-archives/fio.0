Return-Path: <axboe@kernel.dk>
Message-ID: <548CC380.4070100@kernel.dk>
Date: Sat, 13 Dec 2014 15:53:52 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Sequential Commands are essentially random when in mixed sequential/random
 workloads
References: <89470388ACB8A24491F3E64F24385FD75A4DC251@wdscexmb03>
In-Reply-To: <89470388ACB8A24491F3E64F24385FD75A4DC251@wdscexmb03>
Content-Type: multipart/mixed;
 boundary="------------010505080009010304080104"
To: Stephen Nichols <Stephen.Nichols@wdc.com>, "'fio@vger.kernel.org'" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010505080009010304080104
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 12/12/2014 05:23 PM, Stephen Nichols wrote:
> Hi all,
> 
> When using fio configuration below..
> 
> [global]
> ioengine=libaio
> direct=1
> runtime=600
> bs=32k
> iodepth=8
> rw=randrw
> rwmixread=80
> percentage_random=100,0
> 
> [drive1]
> filename=/dev/sda
> 
> 
> I am expecting to see 80% reads, 20% writes where all reads are random and all writes are sequential. I captured a bus trace of traffic to the disk and the bus trace reflected as much with one issue. The write commands are essentially random. Each write begins at a new random LBA. If 2 or more writes occur in a row, the LBA's are sequential based on the block size BUT I feel the heart of this feature would be to emulate a large file write during random access. With that in mind would it be possible for sequential reads or writes within mixed sequential/random workload to remember the last LBA accessed? In this scenario the writes would still only take up 20% of the workload but when a write did occur it should be the next sequential step from the last write.
> 
> 
> Snippet from the bus trace for reference
> 
> Command                                           LBA
> Read FPDMA Queued:                  19F3F818
> Read FPDMA Queued:                  1CBE2740
> Write FPDMA Queued:                 24E35198
> Write FPDMA Queued:                 24E351A0
> Read FPDMA Queued:                  115A9E10
> Write FPDMA Queued:                 A3C1968
> Read FPDMA Queued:                  20B89488
> Write FPDMA Queued:                 336EE0D0
> Write FPDMA Queued:                 336EE0D8
> 
> 
> 
> Let me know what you think, this feature may be working as intended but it seemed off to me.

Would be easy enough to fix, we just need to track last offset per data
direction. Does the attached work for you? Totally untested, will test
on Monday.

-- 
Jens Axboe


--------------010505080009010304080104
Content-Type: text/x-patch;
 name="last-rwdir-pos.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="last-rwdir-pos.patch"

diff --git a/file.h b/file.h
index add77730fdb4..70e4c48c2093 100644
--- a/file.h
+++ b/file.h
@@ -88,8 +88,8 @@ struct fio_file {
 	uint64_t file_offset;
 	uint64_t io_size;
 
-	uint64_t last_pos;
-	uint64_t last_start;
+	uint64_t last_pos[DDIR_RWDIR_CNT];
+	uint64_t last_start[DDIR_RWDIR_CNT];
 
 	uint64_t first_write;
 	uint64_t last_write;
diff --git a/filesetup.c b/filesetup.c
index cc6d44091736..a918234fb77f 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1536,8 +1536,13 @@ void free_release_files(struct thread_data *td)
 
 void fio_file_reset(struct thread_data *td, struct fio_file *f)
 {
-	f->last_pos = f->file_offset;
-	f->last_start = -1ULL;
+	int i;
+
+	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
+		f->last_pos[i] = f->file_offset;
+		f->last_start[i] = -1ULL;
+	}
+
 	if (f->io_axmap)
 		axmap_reset(f->io_axmap);
 	if (td->o.random_generator == FIO_RAND_GEN_LFSR)
diff --git a/io_u.c b/io_u.c
index f13590835286..efbcea9eb15b 100644
--- a/io_u.c
+++ b/io_u.c
@@ -249,7 +249,7 @@ static int get_next_rand_block(struct thread_data *td, struct fio_file *f,
 	}
 
 	dprint(FD_IO, "%s: rand offset failed, last=%llu, size=%llu\n",
-			f->file_name, (unsigned long long) f->last_pos,
+			f->file_name, (unsigned long long) f->last_pos[ddir],
 			(unsigned long long) f->real_file_size);
 	return 1;
 }
@@ -261,17 +261,17 @@ static int get_next_seq_offset(struct thread_data *td, struct fio_file *f,
 
 	assert(ddir_rw(ddir));
 
-	if (f->last_pos >= f->io_size + get_start_offset(td, f) &&
+	if (f->last_pos[ddir] >= f->io_size + get_start_offset(td, f) &&
 	    o->time_based)
-		f->last_pos = f->last_pos - f->io_size;
+		f->last_pos[ddir] = f->last_pos[ddir] - f->io_size;
 
-	if (f->last_pos < f->real_file_size) {
+	if (f->last_pos[ddir] < f->real_file_size) {
 		uint64_t pos;
 
-		if (f->last_pos == f->file_offset && o->ddir_seq_add < 0)
-			f->last_pos = f->real_file_size;
+		if (f->last_pos[ddir] == f->file_offset && o->ddir_seq_add < 0)
+			f->last_pos[ddir] = f->real_file_size;
 
-		pos = f->last_pos - f->file_offset;
+		pos = f->last_pos[ddir] - f->file_offset;
 		if (pos && o->ddir_seq_add) {
 			pos += o->ddir_seq_add;
 
@@ -330,8 +330,8 @@ static int get_next_block(struct thread_data *td, struct io_u *io_u,
 				*is_random = 0;
 			}
 		} else if (td->o.rw_seq == RW_SEQ_IDENT) {
-			if (f->last_start != -1ULL)
-				offset = f->last_start - f->file_offset;
+			if (f->last_start[ddir] != -1ULL)
+				offset = f->last_start[ddir] - f->file_offset;
 			else
 				offset = 0;
 			ret = 0;
@@ -743,7 +743,7 @@ static int fill_io_u(struct thread_data *td, struct io_u *io_u)
 		 */
 		if (f->file_offset >= f->real_file_size)
 			f->file_offset = f->real_file_size - f->file_offset;
-		f->last_pos = f->file_offset;
+		f->last_pos[io_u->ddir] = f->file_offset;
 		td->io_skip_bytes += td->o.zone_skip;
 	}
 
@@ -1471,8 +1471,8 @@ struct io_u *get_io_u(struct thread_data *td)
 			goto err_put;
 		}
 
-		f->last_start = io_u->offset;
-		f->last_pos = io_u->offset + io_u->buflen;
+		f->last_start[io_u->ddir] = io_u->offset;
+		f->last_pos[io_u->ddir] = io_u->offset + io_u->buflen;
 
 		if (io_u->ddir == DDIR_WRITE) {
 			if (td->flags & TD_F_REFILL_BUFFERS) {

--------------010505080009010304080104--

