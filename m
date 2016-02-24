Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2]: Let I/O engine provide methods to allocate/free I/O
 memory.
References: <CANvN+emV7MN2HXt-Lzm_AhdiFgV34z_v2kWbvsbW0q2o7N3vdA@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56CDDDEF.9050207@kernel.dk>
Date: Wed, 24 Feb 2016 09:44:31 -0700
MIME-Version: 1.0
In-Reply-To: <CANvN+emV7MN2HXt-Lzm_AhdiFgV34z_v2kWbvsbW0q2o7N3vdA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060103010404000409000405"
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------060103010404000409000405
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 02/24/2016 09:32 AM, Andrey Kuzmin wrote:
> The patch has been revised to add 'mem=ioengine' option and respective
> sanity checks.

I kind of like the suggestion I made yesterday, where we don't add the 
new option type, but error out if the IO engine has alloc/free hooks AND 
the user has asked for a different backing than the default. Something 
like the attached - untested.

-- 
Jens Axboe


--------------060103010404000409000405
Content-Type: text/x-patch;
 name="fio-engine-alloc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fio-engine-alloc.patch"

diff --git a/ioengine.h b/ioengine.h
index 6734c7bb95df..161acf595caa 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -16,7 +16,7 @@
 #include <guasi.h>
 #endif
 
-#define FIO_IOOPS_VERSION	22
+#define FIO_IOOPS_VERSION	23
 
 enum {
 	IO_U_F_FREE		= 1 << 0,
@@ -157,6 +157,8 @@ struct ioengine_ops {
 	int (*unlink_file)(struct thread_data *, struct fio_file *);
 	int (*get_file_size)(struct thread_data *, struct fio_file *);
 	void (*terminate)(struct thread_data *);
+	int (*iomem_alloc)(struct thread_data *, size_t);
+	void (*iomem_free)(struct thread_data *);
 	int (*io_u_init)(struct thread_data *, struct io_u *);
 	void (*io_u_free)(struct thread_data *, struct io_u *);
 	int option_struct_size;
diff --git a/memory.c b/memory.c
index 50602239a41c..c04d7dfa6cf4 100644
--- a/memory.c
+++ b/memory.c
@@ -229,7 +229,17 @@ int allocate_io_mem(struct thread_data *td)
 
 	dprint(FD_MEM, "Alloc %llu for buffers\n", (unsigned long long) total_mem);
 
-	if (td->o.mem_type == MEM_MALLOC)
+	/*
+	 * If the IO engine has hooks to allocate/free memory, use those. But
+	 * error out if the user explicitly asked for something else.
+	 */
+	if (td->io_ops->iomem_alloc) {
+		if (fio_option_is_set(&td->o, mem_type)) {
+			log_err("fio: option 'mem/iomem' conflicts with specified IO engine\n");
+			ret = 1;
+		} else
+			ret = td->io_ops->iomem_alloc(td, total_mem);
+	} else if (td->o.mem_type == MEM_MALLOC)
 		ret = alloc_mem_malloc(td, total_mem);
 	else if (td->o.mem_type == MEM_SHM || td->o.mem_type == MEM_SHMHUGE)
 		ret = alloc_mem_shm(td, total_mem);
@@ -255,7 +265,10 @@ void free_io_mem(struct thread_data *td)
 	if (td->o.odirect || td->o.oatomic)
 		total_mem += page_mask;
 
-	if (td->o.mem_type == MEM_MALLOC)
+	if (td->io_ops->iomem_alloc) {
+		if (td->io_ops->iomem_free)
+			td->io_ops->iomem_free(td);
+	} else if (td->o.mem_type == MEM_MALLOC)
 		free_mem_malloc(td);
 	else if (td->o.mem_type == MEM_SHM || td->o.mem_type == MEM_SHMHUGE)
 		free_mem_shm(td);

--------------060103010404000409000405--

