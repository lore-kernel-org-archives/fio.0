Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727696AbgLFNBI (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 6 Dec 2020 08:01:08 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D27C0613D0
        for <fio@vger.kernel.org>; Sun,  6 Dec 2020 05:00:22 -0800 (PST)
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1klte4-0004Ie-VG
        for fio@vger.kernel.org; Sun, 06 Dec 2020 13:00:19 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20201206130002.1727A1BC0137@kernel.dk>
Date: Sun,  6 Dec 2020 06:00:02 -0700 (MST)
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit fd80924b22fef6ce0d5580724d91490347445f90:

  Fio 3.25 (2020-12-04 11:47:42 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a210654b03dbd04f17984d1cf791b1fd56862f1b:

  Merge branch 'cufile' of https://github.com/SystemFabricWorks/fio (2020-12-05 14:45:16 -0700)

----------------------------------------------------------------
Brian T. Smith (1):
      ioengine: Add libcufile I/O engine

Jens Axboe (1):
      Merge branch 'cufile' of https://github.com/SystemFabricWorks/fio

 HOWTO                         |  30 ++
 Makefile                      |   3 +
 configure                     |  30 ++
 engines/libcufile.c           | 627 ++++++++++++++++++++++++++++++++++++++++++
 examples/libcufile-cufile.fio |  42 +++
 examples/libcufile-posix.fio  |  41 +++
 fio.1                         |  38 ++-
 optgroup.c                    |   4 +
 optgroup.h                    |   2 +
 9 files changed, 816 insertions(+), 1 deletion(-)
 create mode 100644 engines/libcufile.c
 create mode 100644 examples/libcufile-cufile.fio
 create mode 100644 examples/libcufile-posix.fio

---

Diff of recent changes:

diff --git a/HOWTO b/HOWTO
index 386fd12a..7e46cee0 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2048,6 +2048,14 @@ I/O engine
 		**nbd**
 			Read and write a Network Block Device (NBD).
 
+		**libcufile**
+			I/O engine supporting libcufile synchronous access to nvidia-fs and a
+			GPUDirect Storage-supported filesystem. This engine performs
+			I/O without transferring buffers between user-space and the kernel,
+			unless :option:`verify` is set or :option:`cuda_io` is `posix`.
+			:option:`iomem` must not be `cudamalloc`. This ioengine defines
+			engine specific options.
+
 I/O engine specific parameters
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
@@ -2398,6 +2406,28 @@ with the caveat that when used on the command line, they must come after the
 	nbd+unix:///?socket=/tmp/socket
 	nbds://tlshost/exportname
 
+.. option:: gpu_dev_ids=str : [libcufile]
+
+	Specify the GPU IDs to use with CUDA. This is a colon-separated list of
+	int. GPUs are assigned to workers roundrobin. Default is 0.
+
+.. option:: cuda_io=str : [libcufile]
+
+	Specify the type of I/O to use with CUDA. Default is **cufile**.
+
+	**cufile**
+		Use libcufile and nvidia-fs. This option performs I/O directly
+		between a GPUDirect Storage filesystem and GPU buffers,
+		avoiding use of a bounce buffer. If :option:`verify` is set,
+		cudaMemcpy is used to copy verificaton data between RAM and GPU.
+		Verification data is copied from RAM to GPU before a write
+		and from GPU to RAM after a read. :option:`direct` must be 1.
+	**posix**
+		Use POSIX to perform I/O with a RAM buffer, and use cudaMemcpy
+		to transfer data between RAM and the GPUs. Data is copied from
+		GPU to RAM before a write and copied from RAM to GPU after a
+		read. :option:`verify` does not affect use of cudaMemcpy.
+
 I/O depth
 ~~~~~~~~~
 
diff --git a/Makefile b/Makefile
index ecfaa3e0..a838af9a 100644
--- a/Makefile
+++ b/Makefile
@@ -103,6 +103,9 @@ endif
 ifdef CONFIG_LINUX_EXT4_MOVE_EXTENT
   SOURCE += engines/e4defrag.c
 endif
+ifdef CONFIG_LIBCUFILE
+  SOURCE += engines/libcufile.c
+endif
 ifdef CONFIG_LINUX_SPLICE
   SOURCE += engines/splice.c
 endif
diff --git a/configure b/configure
index d2ca8934..d247a041 100755
--- a/configure
+++ b/configure
@@ -162,6 +162,7 @@ pmemblk="no"
 devdax="no"
 pmem="no"
 cuda="no"
+libcufile="no"
 disable_lex=""
 disable_pmem="no"
 disable_native="no"
@@ -224,6 +225,8 @@ for opt do
   ;;
   --enable-cuda) cuda="yes"
   ;;
+  --enable-libcufile) libcufile="yes"
+  ;;
   --disable-native) disable_native="yes"
   ;;
   --with-ime=*) ime_path="$optarg"
@@ -272,6 +275,7 @@ if test "$show_help" = "yes" ; then
   echo "--disable-shm           Disable SHM support"
   echo "--disable-optimizations Don't enable compiler optimizations"
   echo "--enable-cuda           Enable GPUDirect RDMA support"
+  echo "--enable-libcufile      Enable GPUDirect Storage cuFile support"
   echo "--disable-native        Don't build for native host"
   echo "--with-ime=             Install path for DDN's Infinite Memory Engine"
   echo "--enable-libiscsi       Enable iscsi support"
@@ -2495,6 +2499,29 @@ EOF
 fi
 print_config "cuda" "$cuda"
 
+##########################################
+# libcufile probe
+if test "$libcufile" != "no" ; then
+cat > $TMPC << EOF
+#include <cufile.h>
+
+int main(int argc, char* argv[]) {
+   cuFileDriverOpen();
+   return 0;
+}
+EOF
+  if compile_prog "" "-lcuda -lcudart -lcufile" "libcufile"; then
+    libcufile="yes"
+    LIBS="-lcuda -lcudart -lcufile $LIBS"
+  else
+    if test "$libcufile" = "yes" ; then
+      feature_not_found "libcufile" ""
+    fi
+    libcufile="no"
+  fi
+fi
+print_config "libcufile" "$libcufile"
+
 ##########################################
 # check for cc -march=native
 build_native="no"
@@ -2966,6 +2993,9 @@ fi
 if test "$cuda" = "yes" ; then
   output_sym "CONFIG_CUDA"
 fi
+if test "$libcufile" = "yes" ; then
+  output_sym "CONFIG_LIBCUFILE"
+fi
 if test "$march_set" = "no" && test "$build_native" = "yes" ; then
   output_sym "CONFIG_BUILD_NATIVE"
 fi
diff --git a/engines/libcufile.c b/engines/libcufile.c
new file mode 100644
index 00000000..e575b786
--- /dev/null
+++ b/engines/libcufile.c
@@ -0,0 +1,627 @@
+/*
+ * Copyright (c)2020 System Fabric Works, Inc. All Rights Reserved.
+ * mailto:info@systemfabricworks.com
+ *
+ * License: GPLv2, see COPYING.
+ *
+ * libcufile engine
+ *
+ * fio I/O engine using the NVIDIA cuFile API.
+ *
+ */
+
+#include <stdlib.h>
+#include <unistd.h>
+#include <errno.h>
+#include <string.h>
+#include <sys/time.h>
+#include <sys/resource.h>
+#include <cufile.h>
+#include <cuda.h>
+#include <cuda_runtime.h>
+#include <pthread.h>
+
+#include "../fio.h"
+#include "../lib/pow2.h"
+#include "../optgroup.h"
+#include "../lib/memalign.h"
+
+#define ALIGNED_4KB(v) (((v) & 0x0fff) == 0)
+
+#define LOGGED_BUFLEN_NOT_ALIGNED     0x01
+#define LOGGED_GPU_OFFSET_NOT_ALIGNED 0x02
+#define GPU_ID_SEP ":"
+
+enum {
+	IO_CUFILE    = 1,
+	IO_POSIX     = 2
+};
+
+struct libcufile_options {
+	struct thread_data *td;
+	char               *gpu_ids;       /* colon-separated list of GPU ids,
+					      one per job */
+	void               *cu_mem_ptr;    /* GPU memory */
+	void               *junk_buf;      /* buffer to simulate cudaMemcpy with
+					      posix I/O write */
+	int                 my_gpu_id;     /* GPU id to use for this job */
+	unsigned int        cuda_io;       /* Type of I/O to use with CUDA */
+	size_t              total_mem;     /* size for cu_mem_ptr and junk_buf */
+	int                 logged;        /* bitmask of log messages that have
+					      been output, prevent flood */
+};
+
+struct fio_libcufile_data {
+	CUfileDescr_t  cf_descr;
+	CUfileHandle_t cf_handle;
+};
+
+static struct fio_option options[] = {
+	{
+		.name	  = "gpu_dev_ids",
+		.lname	  = "libcufile engine gpu dev ids",
+		.type	  = FIO_OPT_STR_STORE,
+		.off1	  = offsetof(struct libcufile_options, gpu_ids),
+		.help	  = "GPU IDs, one per subjob, separated by " GPU_ID_SEP,
+		.category = FIO_OPT_C_ENGINE,
+		.group	  = FIO_OPT_G_LIBCUFILE,
+	},
+	{
+		.name	  = "cuda_io",
+		.lname	  = "libcufile cuda io",
+		.type	  = FIO_OPT_STR,
+		.off1	  = offsetof(struct libcufile_options, cuda_io),
+		.help	  = "Type of I/O to use with CUDA",
+		.def      = "cufile",
+		.posval   = {
+			    { .ival = "cufile",
+			      .oval = IO_CUFILE,
+			      .help = "libcufile nvidia-fs"
+			    },
+			    { .ival = "posix",
+			      .oval = IO_POSIX,
+			      .help = "POSIX I/O"
+			    }
+		},
+		.category = FIO_OPT_C_ENGINE,
+		.group	  = FIO_OPT_G_LIBCUFILE,
+	},
+	{
+		.name	 = NULL,
+	},
+};
+
+static int running = 0;
+static int cufile_initialized = 0;
+static pthread_mutex_t running_lock = PTHREAD_MUTEX_INITIALIZER;
+
+#define check_cudaruntimecall(fn, rc)                                               \
+	do {                                                                        \
+		cudaError_t res = fn;                                               \
+		if (res != cudaSuccess) {                                           \
+			const char *str = cudaGetErrorName(res);                    \
+			log_err("cuda runtime api call failed %s:%d : err=%d:%s\n", \
+				#fn, __LINE__, res, str);                           \
+			rc = -1;                                                    \
+		} else                                                              \
+			rc = 0;                                                     \
+	} while(0)
+
+static const char *fio_libcufile_get_cuda_error(CUfileError_t st)
+{
+	if (IS_CUFILE_ERR(st.err))
+		return cufileop_status_error(st.err);
+	return "unknown";
+}
+
+/*
+ * Assign GPU to subjob roundrobin, similar to how multiple
+ * entries in 'directory' are handled by fio.
+ */
+static int fio_libcufile_find_gpu_id(struct thread_data *td)
+{
+	struct libcufile_options *o = td->eo;
+	int gpu_id = 0;
+
+	if (o->gpu_ids != NULL) {
+		char *gpu_ids, *pos, *cur;
+		int i, id_count, gpu_idx;
+
+		for (id_count = 0, cur = o->gpu_ids; cur != NULL; id_count++) {
+			cur = strchr(cur, GPU_ID_SEP[0]);
+			if (cur != NULL)
+				cur++;
+		}
+
+		gpu_idx = td->subjob_number % id_count;
+
+		pos = gpu_ids = strdup(o->gpu_ids);
+		if (gpu_ids == NULL) {
+			log_err("strdup(gpu_ids): err=%d\n", errno);
+			return -1;
+		}
+
+		i = 0;
+		while (pos != NULL && i <= gpu_idx) {
+			i++;
+			cur = strsep(&pos, GPU_ID_SEP);
+		}
+
+		if (cur)
+			gpu_id = atoi(cur);
+
+		free(gpu_ids);
+	}
+
+	return gpu_id;
+}
+
+static int fio_libcufile_init(struct thread_data *td)
+{
+	struct libcufile_options *o = td->eo;
+	CUfileError_t status;
+	int initialized;
+	int rc;
+
+	pthread_mutex_lock(&running_lock);
+	if (running == 0) {
+		assert(cufile_initialized == 0);
+		if (o->cuda_io == IO_CUFILE) {
+			/* only open the driver if this is the first worker thread */
+			status = cuFileDriverOpen();
+			if (status.err != CU_FILE_SUCCESS)
+				log_err("cuFileDriverOpen: err=%d:%s\n", status.err,
+					fio_libcufile_get_cuda_error(status));
+			else
+				cufile_initialized = 1;
+		}
+	}
+	running++;
+	initialized = cufile_initialized;
+	pthread_mutex_unlock(&running_lock);
+
+	if (o->cuda_io == IO_CUFILE && !initialized)
+		return 1;
+
+	o->my_gpu_id = fio_libcufile_find_gpu_id(td);
+	if (o->my_gpu_id < 0)
+		return 1;
+
+	dprint(FD_MEM, "Subjob %d uses GPU %d\n", td->subjob_number, o->my_gpu_id);
+	check_cudaruntimecall(cudaSetDevice(o->my_gpu_id), rc);
+	if (rc != 0)
+		return 1;
+
+	return 0;
+}
+
+static inline int fio_libcufile_pre_write(struct thread_data *td,
+					  struct libcufile_options *o,
+					  struct io_u *io_u,
+					  size_t gpu_offset)
+{
+	int rc = 0;
+
+	if (o->cuda_io == IO_CUFILE) {
+		if (td->o.verify) {
+			/*
+			  Data is being verified, copy the io_u buffer to GPU memory.
+			  This isn't done in the non-verify case because the data would
+			  already be in GPU memory in a normal cuFile application.
+			*/
+			check_cudaruntimecall(cudaMemcpy(((char*) o->cu_mem_ptr) + gpu_offset,
+							 io_u->xfer_buf,
+							 io_u->xfer_buflen,
+							 cudaMemcpyHostToDevice), rc);
+			if (rc != 0) {
+				log_err("DDIR_WRITE cudaMemcpy H2D failed\n");
+				io_u->error = EIO;
+			}
+		}
+	} else if (o->cuda_io == IO_POSIX) {
+
+		/*
+		  POSIX I/O is being used, the data has to be copied out of the
+		  GPU into a CPU buffer. GPU memory doesn't contain the actual
+		  data to write, copy the data to the junk buffer. The purpose
+		  of this is to add the overhead of cudaMemcpy() that would be
+		  present in a POSIX I/O CUDA application.
+		*/
+		check_cudaruntimecall(cudaMemcpy(o->junk_buf + gpu_offset,
+						 ((char*) o->cu_mem_ptr) + gpu_offset,
+						 io_u->xfer_buflen,
+						 cudaMemcpyDeviceToHost), rc);
+		if (rc != 0) {
+			log_err("DDIR_WRITE cudaMemcpy D2H failed\n");
+			io_u->error = EIO;
+		}
+	} else {
+		log_err("Illegal CUDA IO type: %d\n", o->cuda_io);
+		assert(0);
+		rc = EINVAL;
+	}
+
+	return rc;
+}
+
+static inline int fio_libcufile_post_read(struct thread_data *td,
+					  struct libcufile_options *o,
+					  struct io_u *io_u,
+					  size_t gpu_offset)
+{
+	int rc = 0;
+
+	if (o->cuda_io == IO_CUFILE) {
+		if (td->o.verify) {
+			/* Copy GPU memory to CPU buffer for verify */
+			check_cudaruntimecall(cudaMemcpy(io_u->xfer_buf,
+							 ((char*) o->cu_mem_ptr) + gpu_offset,
+							 io_u->xfer_buflen,
+							 cudaMemcpyDeviceToHost), rc);
+			if (rc != 0) {
+				log_err("DDIR_READ cudaMemcpy D2H failed\n");
+				io_u->error = EIO;
+			}
+		}
+	} else if (o->cuda_io == IO_POSIX) {
+		/* POSIX I/O read, copy the CPU buffer to GPU memory */
+		check_cudaruntimecall(cudaMemcpy(((char*) o->cu_mem_ptr) + gpu_offset,
+						 io_u->xfer_buf,
+						 io_u->xfer_buflen,
+						 cudaMemcpyHostToDevice), rc);
+		if (rc != 0) {
+			log_err("DDIR_READ cudaMemcpy H2D failed\n");
+			io_u->error = EIO;
+		}
+	} else {
+		log_err("Illegal CUDA IO type: %d\n", o->cuda_io);
+		assert(0);
+		rc = EINVAL;
+	}
+
+	return rc;
+}
+
+static enum fio_q_status fio_libcufile_queue(struct thread_data *td,
+					     struct io_u *io_u)
+{
+	struct libcufile_options *o = td->eo;
+	struct fio_libcufile_data *fcd = FILE_ENG_DATA(io_u->file);
+	unsigned long long io_offset;
+	ssize_t sz;
+	ssize_t remaining;
+	size_t xfered;
+	size_t gpu_offset;
+	int rc;
+
+	if (o->cuda_io == IO_CUFILE && fcd == NULL) {
+		io_u->error = EINVAL;
+		td_verror(td, EINVAL, "xfer");
+		return FIO_Q_COMPLETED;
+	}
+
+	fio_ro_check(td, io_u);
+
+	switch(io_u->ddir) {
+	case DDIR_SYNC:
+		rc = fsync(io_u->file->fd);
+		if (rc != 0) {
+			io_u->error = errno;
+			log_err("fsync: err=%d\n", errno);
+		}
+		break;
+
+	case DDIR_DATASYNC:
+		rc = fdatasync(io_u->file->fd);
+		if (rc != 0) {
+			io_u->error = errno;
+			log_err("fdatasync: err=%d\n", errno);
+		}
+		break;
+
+	case DDIR_READ:
+	case DDIR_WRITE:
+		/*
+		  There may be a better way to calculate gpu_offset. The intent is
+		  that gpu_offset equals the the difference between io_u->xfer_buf and
+		  the page-aligned base address for io_u buffers.
+		*/
+		gpu_offset = io_u->index * io_u->xfer_buflen;
+		io_offset = io_u->offset;
+		remaining = io_u->xfer_buflen;
+
+		xfered = 0;
+		sz = 0;
+
+		assert(gpu_offset + io_u->xfer_buflen <= o->total_mem);
+
+		if (o->cuda_io == IO_CUFILE) {
+			if (!(ALIGNED_4KB(io_u->xfer_buflen) ||
+			      (o->logged & LOGGED_BUFLEN_NOT_ALIGNED))) {
+				log_err("buflen not 4KB-aligned: %llu\n", io_u->xfer_buflen);
+				o->logged |= LOGGED_BUFLEN_NOT_ALIGNED;
+			}
+
+			if (!(ALIGNED_4KB(gpu_offset) ||
+			      (o->logged & LOGGED_GPU_OFFSET_NOT_ALIGNED))) {
+				log_err("gpu_offset not 4KB-aligned: %lu\n", gpu_offset);
+				o->logged |= LOGGED_GPU_OFFSET_NOT_ALIGNED;
+			}
+		}
+
+		if (io_u->ddir == DDIR_WRITE)
+			rc = fio_libcufile_pre_write(td, o, io_u, gpu_offset);
+
+		if (io_u->error != 0)
+			break;
+
+		while (remaining > 0) {
+			assert(gpu_offset + xfered <= o->total_mem);
+			if (io_u->ddir == DDIR_READ) {
+				if (o->cuda_io == IO_CUFILE) {
+					sz = cuFileRead(fcd->cf_handle, o->cu_mem_ptr, remaining,
+							io_offset + xfered, gpu_offset + xfered);
+					if (sz == -1) {
+						io_u->error = errno;
+						log_err("cuFileRead: err=%d\n", errno);
+					} else if (sz < 0) {
+						io_u->error = EIO;
+						log_err("cuFileRead: err=%ld:%s\n", sz,
+							cufileop_status_error(-sz));
+					}
+				} else if (o->cuda_io == IO_POSIX) {
+					sz = pread(io_u->file->fd, ((char*) io_u->xfer_buf) + xfered,
+						   remaining, io_offset + xfered);
+					if (sz < 0) {
+						io_u->error = errno;
+						log_err("pread: err=%d\n", errno);
+					}
+				} else {
+					log_err("Illegal CUDA IO type: %d\n", o->cuda_io);
+					io_u->error = -1;
+					assert(0);
+				}
+			} else if (io_u->ddir == DDIR_WRITE) {
+				if (o->cuda_io == IO_CUFILE) {
+					sz = cuFileWrite(fcd->cf_handle, o->cu_mem_ptr, remaining,
+							 io_offset + xfered, gpu_offset + xfered);
+					if (sz == -1) {
+						io_u->error = errno;
+						log_err("cuFileWrite: err=%d\n", errno);
+					} else if (sz < 0) {
+						io_u->error = EIO;
+						log_err("cuFileWrite: err=%ld:%s\n", sz,
+							cufileop_status_error(-sz));
+					}
+				} else if (o->cuda_io == IO_POSIX) {
+					sz = pwrite(io_u->file->fd,
+						    ((char*) io_u->xfer_buf) + xfered,
+						    remaining, io_offset + xfered);
+					if (sz < 0) {
+						io_u->error = errno;
+						log_err("pwrite: err=%d\n", errno);
+					}
+				} else {
+					log_err("Illegal CUDA IO type: %d\n", o->cuda_io);
+					io_u->error = -1;
+					assert(0);
+				}
+			} else {
+				log_err("not DDIR_READ or DDIR_WRITE: %d\n", io_u->ddir);
+				io_u->error = -1;
+				assert(0);
+				break;
+			}
+
+			if (io_u->error != 0)
+				break;
+
+			remaining -= sz;
+			xfered += sz;
+
+			if (remaining != 0)
+				log_info("Incomplete %s: %ld bytes remaining\n",
+					 io_u->ddir == DDIR_READ? "read" : "write", remaining);
+		}
+
+		if (io_u->error != 0)
+			break;
+
+		if (io_u->ddir == DDIR_READ)
+			rc = fio_libcufile_post_read(td, o, io_u, gpu_offset);
+		break;
+
+	default:
+		io_u->error = EINVAL;
+		break;
+	}
+
+	if (io_u->error != 0) {
+		log_err("IO failed\n");
+		td_verror(td, io_u->error, "xfer");
+	}
+
+	return FIO_Q_COMPLETED;
+}
+
+static int fio_libcufile_open_file(struct thread_data *td, struct fio_file *f)
+{
+	struct libcufile_options *o = td->eo;
+	struct fio_libcufile_data *fcd = NULL;
+	int rc;
+	CUfileError_t status;
+
+	rc = generic_open_file(td, f);
+	if (rc)
+		return rc;
+
+	if (o->cuda_io == IO_CUFILE) {
+		fcd = calloc(1, sizeof(*fcd));
+		if (fcd == NULL) {
+			rc = ENOMEM;
+			goto exit_err;
+		}
+
+		fcd->cf_descr.handle.fd = f->fd;
+		fcd->cf_descr.type = CU_FILE_HANDLE_TYPE_OPAQUE_FD;
+		status = cuFileHandleRegister(&fcd->cf_handle, &fcd->cf_descr);
+		if (status.err != CU_FILE_SUCCESS) {
+			log_err("cufile register: err=%d:%s\n", status.err,
+				fio_libcufile_get_cuda_error(status));
+			rc = EINVAL;
+			goto exit_err;
+		}
+	}
+
+	FILE_SET_ENG_DATA(f, fcd);
+	return 0;
+
+exit_err:
+	if (fcd) {
+		free(fcd);
+		fcd = NULL;
+	}
+	if (f) {
+		int rc2 = generic_close_file(td, f);
+		if (rc2)
+			log_err("generic_close_file: err=%d\n", rc2);
+	}
+	return rc;
+}
+
+static int fio_libcufile_close_file(struct thread_data *td, struct fio_file *f)
+{
+	struct fio_libcufile_data *fcd = FILE_ENG_DATA(f);
+	int rc;
+
+	if (fcd != NULL) {
+		cuFileHandleDeregister(fcd->cf_handle);
+		FILE_SET_ENG_DATA(f, NULL);
+		free(fcd);
+	}
+
+	rc = generic_close_file(td, f);
+
+	return rc;
+}
+
+static int fio_libcufile_iomem_alloc(struct thread_data *td, size_t total_mem)
+{
+	struct libcufile_options *o = td->eo;
+	int rc;
+	CUfileError_t status;
+
+	o->total_mem = total_mem;
+	o->logged = 0;
+	o->cu_mem_ptr = NULL;
+	o->junk_buf = NULL;
+	td->orig_buffer = calloc(1, total_mem);
+	if (!td->orig_buffer) {
+		log_err("orig_buffer calloc failed: err=%d\n", errno);
+		goto exit_error;
+	}
+
+	if (o->cuda_io == IO_POSIX) {
+		o->junk_buf = calloc(1, total_mem);
+		if (o->junk_buf == NULL) {
+			log_err("junk_buf calloc failed: err=%d\n", errno);
+			goto exit_error;
+		}
+	}
+
+	dprint(FD_MEM, "Alloc %zu for GPU %d\n", total_mem, o->my_gpu_id);
+	check_cudaruntimecall(cudaMalloc(&o->cu_mem_ptr, total_mem), rc);
+	if (rc != 0)
+		goto exit_error;
+	check_cudaruntimecall(cudaMemset(o->cu_mem_ptr, 0xab, total_mem), rc);
+	if (rc != 0)
+		goto exit_error;
+
+	if (o->cuda_io == IO_CUFILE) {
+		status = cuFileBufRegister(o->cu_mem_ptr, total_mem, 0);
+		if (status.err != CU_FILE_SUCCESS) {
+			log_err("cuFileBufRegister: err=%d:%s\n", status.err,
+				fio_libcufile_get_cuda_error(status));
+			goto exit_error;
+		}
+	}
+
+	return 0;
+
+exit_error:
+	if (td->orig_buffer) {
+		free(td->orig_buffer);
+		td->orig_buffer = NULL;
+	}
+	if (o->junk_buf) {
+		free(o->junk_buf);
+		o->junk_buf = NULL;
+	}
+	if (o->cu_mem_ptr) {
+		cudaFree(o->cu_mem_ptr);
+		o->cu_mem_ptr = NULL;
+	}
+	return 1;
+}
+
+static void fio_libcufile_iomem_free(struct thread_data *td)
+{
+	struct libcufile_options *o = td->eo;
+
+	if (o->junk_buf) {
+		free(o->junk_buf);
+		o->junk_buf = NULL;
+	}
+	if (o->cu_mem_ptr) {
+		if (o->cuda_io == IO_CUFILE)
+			cuFileBufDeregister(o->cu_mem_ptr);
+		cudaFree(o->cu_mem_ptr);
+		o->cu_mem_ptr = NULL;
+	}
+	if (td->orig_buffer) {
+		free(td->orig_buffer);
+		td->orig_buffer = NULL;
+	}
+}
+
+static void fio_libcufile_cleanup(struct thread_data *td)
+{
+	struct libcufile_options *o = td->eo;
+
+	pthread_mutex_lock(&running_lock);
+	running--;
+	assert(running >= 0);
+	if (running == 0) {
+		/* only close the driver if initialized and
+		   this is the last worker thread */
+		if (o->cuda_io == IO_CUFILE && cufile_initialized)
+			cuFileDriverClose();
+		cufile_initialized = 0;
+	}
+	pthread_mutex_unlock(&running_lock);
+}
+
+FIO_STATIC struct ioengine_ops ioengine = {
+	.name                = "libcufile",
+	.version             = FIO_IOOPS_VERSION,
+	.init                = fio_libcufile_init,
+	.queue               = fio_libcufile_queue,
+	.open_file           = fio_libcufile_open_file,
+	.close_file          = fio_libcufile_close_file,
+	.iomem_alloc         = fio_libcufile_iomem_alloc,
+	.iomem_free          = fio_libcufile_iomem_free,
+	.cleanup             = fio_libcufile_cleanup,
+	.flags               = FIO_SYNCIO,
+	.options             = options,
+	.option_struct_size  = sizeof(struct libcufile_options)
+};
+
+void fio_init fio_libcufile_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+void fio_exit fio_libcufile_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/examples/libcufile-cufile.fio b/examples/libcufile-cufile.fio
new file mode 100644
index 00000000..94a64b5a
--- /dev/null
+++ b/examples/libcufile-cufile.fio
@@ -0,0 +1,42 @@
+# Example libcufile job, using cufile I/O
+#
+# Required environment variables:
+#     GPU_DEV_IDS : refer to option 'gpu_dev_ids'
+#     FIO_DIR     : 'directory'. This job uses cuda_io=cufile, so path(s) must
+#                   point to GPUDirect Storage filesystem(s)
+#
+
+[global]
+ioengine=libcufile
+directory=${FIO_DIR}
+gpu_dev_ids=${GPU_DEV_IDS}
+cuda_io=cufile
+# 'direct' must be 1 when using cuda_io=cufile
+direct=1
+# Performance is negatively affected if 'bs' is not a multiple of 4k.
+# Refer to GDS cuFile documentation.
+bs=1m
+size=1m
+numjobs=16
+# cudaMalloc fails if too many processes attach to the GPU, use threads.
+thread
+
+[read]
+rw=read
+
+[write]
+rw=write
+
+[randread]
+rw=randread
+
+[randwrite]
+rw=randwrite
+
+[verify]
+rw=write
+verify=md5
+
+[randverify]
+rw=randwrite
+verify=md5
diff --git a/examples/libcufile-posix.fio b/examples/libcufile-posix.fio
new file mode 100644
index 00000000..2bce22e6
--- /dev/null
+++ b/examples/libcufile-posix.fio
@@ -0,0 +1,41 @@
+# Example libcufile job, using POSIX I/O
+#
+# Required environment variables:
+#     GPU_DEV_IDS : refer to option 'gpu_dev_ids'
+#     FIO_DIR     : 'directory'. cuda_io=posix, so the path(s) may point
+#                   to any POSIX filesystem(s)
+#
+
+[global]
+ioengine=libcufile
+directory=${FIO_DIR}
+gpu_dev_ids=${GPU_DEV_IDS}
+cuda_io=posix
+# 'direct' may be 1 or 0 when using cuda_io=posix
+direct=0
+# there are no unusual requirements for 'bs' when cuda_io=posix
+bs=1m
+size=1G
+numjobs=16
+# cudaMalloc fails if too many processes attach to the GPU, use threads
+thread
+
+[read]
+rw=read
+
+[write]
+rw=write
+
+[randread]
+rw=randread
+
+[randwrite]
+rw=randwrite
+
+[verify]
+rw=write
+verify=md5
+
+[randverify]
+rw=randwrite
+verify=md5
diff --git a/fio.1 b/fio.1
index 48119325..45ec8d43 100644
--- a/fio.1
+++ b/fio.1
@@ -1826,6 +1826,13 @@ Read and write iscsi lun with libiscsi.
 .TP
 .B nbd
 Synchronous read and write a Network Block Device (NBD).
+.TP
+.B libcufile
+I/O engine supporting libcufile synchronous access to nvidia-fs and a
+GPUDirect Storage-supported filesystem. This engine performs
+I/O without transferring buffers between user-space and the kernel,
+unless \fBverify\fR is set or \fBcuda_io\fR is \fBposix\fR. \fBiomem\fR must
+not be \fBcudamalloc\fR. This ioengine defines engine specific options.
 .SS "I/O engine specific parameters"
 In addition, there are some parameters which are only valid when a specific
 \fBioengine\fR is in use. These are used identically to normal parameters,
@@ -2139,7 +2146,36 @@ Example URIs:
 \fInbd+unix:///?socket=/tmp/socket\fR
 .TP
 \fInbds://tlshost/exportname\fR
-
+.RE
+.RE
+.TP
+.BI (libcufile)gpu_dev_ids\fR=\fPstr
+Specify the GPU IDs to use with CUDA. This is a colon-separated list of int.
+GPUs are assigned to workers roundrobin. Default is 0.
+.TP
+.BI (libcufile)cuda_io\fR=\fPstr
+Specify the type of I/O to use with CUDA. This option
+takes the following values:
+.RS
+.RS
+.TP
+.B cufile (default)
+Use libcufile and nvidia-fs. This option performs I/O directly
+between a GPUDirect Storage filesystem and GPU buffers,
+avoiding use of a bounce buffer. If \fBverify\fR is set,
+cudaMemcpy is used to copy verification data between RAM and GPU(s).
+Verification data is copied from RAM to GPU before a write
+and from GPU to RAM after a read.
+\fBdirect\fR must be 1.
+.TP
+.BI posix
+Use POSIX to perform I/O with a RAM buffer, and use
+cudaMemcpy to transfer data between RAM and the GPU(s).
+Data is copied from GPU to RAM before a write and copied
+from RAM to GPU after a read. \fBverify\fR does not affect
+the use of cudaMemcpy.
+.RE
+.RE
 .SS "I/O depth"
 .TP
 .BI iodepth \fR=\fPint
diff --git a/optgroup.c b/optgroup.c
index c228ff29..64774896 100644
--- a/optgroup.c
+++ b/optgroup.c
@@ -173,6 +173,10 @@ static const struct opt_group fio_opt_cat_groups[] = {
 		.name	= "NBD I/O engine", /* NBD */
 		.mask	= FIO_OPT_G_NBD,
 	},
+	{
+		.name	= "libcufile I/O engine", /* libcufile */
+		.mask	= FIO_OPT_G_LIBCUFILE,
+	},
 	{
 		.name	= NULL,
 	},
diff --git a/optgroup.h b/optgroup.h
index 5789afd3..d2f1ceb3 100644
--- a/optgroup.h
+++ b/optgroup.h
@@ -67,6 +67,7 @@ enum opt_category_group {
 	__FIO_OPT_G_IOURING,
 	__FIO_OPT_G_FILESTAT,
 	__FIO_OPT_G_NR,
+	__FIO_OPT_G_LIBCUFILE,
 
 	FIO_OPT_G_RATE		= (1ULL << __FIO_OPT_G_RATE),
 	FIO_OPT_G_ZONE		= (1ULL << __FIO_OPT_G_ZONE),
@@ -108,6 +109,7 @@ enum opt_category_group {
 	FIO_OPT_G_NBD		= (1ULL << __FIO_OPT_G_NBD),
 	FIO_OPT_G_IOURING	= (1ULL << __FIO_OPT_G_IOURING),
 	FIO_OPT_G_FILESTAT	= (1ULL << __FIO_OPT_G_FILESTAT),
+	FIO_OPT_G_LIBCUFILE	= (1ULL << __FIO_OPT_G_LIBCUFILE),
 };
 
 extern const struct opt_group *opt_group_from_mask(uint64_t *mask);

