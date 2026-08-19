Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7243471D18
	for <fio@vger.kernel.org>; Wed, 19 Aug 2026 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787140817; cv=none; b=YrYi1GOWwffaprSzp1dvt97glLMJpo0K4/3Lb6GXUgnGVPGA12Fq3uknSikNC0BmGa5Eb+SeE+JPZuN1726bpoj4xygIfCagtVkb3tHD5jK3FCMOhUw7zmXIw61v7KwxUrfeXLq//FKZrC8LfAHYRQrQe0F4mBEHlpow9HG9or4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787140817; c=relaxed/simple;
	bh=1zfjNvyHUxHs053eC/j4Aa+P9NP/z/Gp+2r7DdBWlzw=;
	h=Subject:From:To:Date:Message-Id; b=e40Ue4LGbUHKWQKEolOALmcbtDQ1ICZDBx8TMtZh47kHhdSr/OdcByzJvjWnpk8SGB63WaqbI2fzvT1Hw/WNMnyZL/8o5KPl4UpOZs6INioQGxUautjoTw9BnOVGuB/4ugRQnS7FrIwT/EP3Enulr/qSXd+FuJFefvydc3GWywU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Fzl7K3PT; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fzl7K3PT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=n32HhY3oWEo4jI1UreBIEOCAJjDUrnWPlyzDUkU5qEI=; b=Fzl7K3PTlacqnTbVRkDqnVVdGY
	dkQpEODamFn5I7xnVkS67lMLX7+20zUzDABPXdHU31PyE01xuUFnNATehN3sXajt88L2GIndXxCeL
	cJUmwoDatadareJyIVb2Eq2E/0FwBHO8O8iJU4/pUUoajsxIgSka1TYqtVbGGm+Q1AU5Gdzq8yv0G
	t+g2LWDil4OGWvvjCYJ9dKj2/LmXXn1X/7UMbiS+36QUtpme1aL1Yo2Gr+6icr9bkA7Lt0GAFWrs0
	Y1feS4P3l0XXXhx8AfeSAZj7+DFL1VkMeteXpkGVfQtQ/nKZsKEhpfdhL7+RgIT5j7vXarS8mEt+F
	JN1MWSdw==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wwexg-00000002MED-2EfN
	for fio@vger.kernel.org;
	Wed, 19 Aug 2026 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 4DC301BC015A; Wed, 19 Aug 2026 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Wed, 19 Aug 2026 06:00:01 -0600
Message-Id: <20260819120001.4DC301BC015A@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit 1de4a3dc5d10a0107b51c496dc96a07f58bdc5c9:

  Merge branch 'add_copyright' of https://github.com/ljw8161/fio (2026-08-07 11:09:43 -0400)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b27fdbac98125f24c7e78ae439245c6989a4a718:

  fio: move example job file to examples directory (2026-08-18 12:24:18 -0400)

----------------------------------------------------------------
Vincent Fu (2):
      Merge branch 'feat/hipfile-upstream-rebase' of https://github.com/sbates130272/fio
      fio: move example job file to examples directory

zbyrne (4):
      engines: refactor libcufile.c into a shared gpuaccel layer
      engines/gpuaccel: add per-backend sync flags and backend-scoped state
      engines/libhipfile: add ROCm hipFile engine
      examples/doc: add libhipfile example job files and documentation

 HOWTO.rst                                          |  33 ++
 Makefile                                           |   8 +
 configure                                          |  38 ++
 engines/gpuaccel.c                                 | 536 +++++++++++++++++++
 engines/gpuaccel.h                                 |  82 +++
 engines/libcufile.c                                | 595 +++++----------------
 engines/libhipfile.c                               | 272 ++++++++++
 .../example_latency_steadystate.fio                |   0
 examples/libhipfile-hipfile.fio                    |  44 ++
 examples/libhipfile-posix.fio                      |  41 ++
 fio.1                                              |  37 ++
 optgroup.c                                         |   4 +
 optgroup.h                                         |   2 +
 13 files changed, 1229 insertions(+), 463 deletions(-)
 create mode 100644 engines/gpuaccel.c
 create mode 100644 engines/gpuaccel.h
 create mode 100644 engines/libhipfile.c
 rename example_latency_steadystate.fio => examples/example_latency_steadystate.fio (100%)
 create mode 100644 examples/libhipfile-hipfile.fio
 create mode 100644 examples/libhipfile-posix.fio

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index ece92563..162115d0 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2366,6 +2366,17 @@ I/O engine
 			:option:`iomem` must not be `cudamalloc`. This ioengine defines
 			engine specific options.
 
+		**libhipfile**
+			I/O engine supporting synchronous access to a GPUDirect Storage-supported
+			filesystem from AMD GPUs via the ROCm hipFile API. This engine performs
+			I/O without transferring buffers between user-space and the kernel,
+			unless :option:`verify` is set or :option:`rocm_io` is `posix`.
+			:option:`iomem` must not be `cudamalloc`. This ioengine defines
+			engine specific options. See `ROCm hipFile API`_ for information on
+			ROCm hipFile and how to install the ROCm stack.
+
+			.. _ROCm hipFile API: https://rocm.docs.amd.com/projects/hip/en/latest/reference/hip_runtime_api/modules/file_apis.html
+
 		**dfs**
 			I/O engine supporting asynchronous read and write operations to the
 			DAOS File System (DFS) via libdfs.
@@ -3264,6 +3275,28 @@ with the caveat that when used on the command line, they must come after the
 		GPU to RAM before a write and copied from RAM to GPU after a
 		read. :option:`verify` does not affect use of cudaMemcpy.
 
+.. option:: gpu_dev_ids=str : [libhipfile]
+
+	Specify the GPU IDs to use with ROCm. This is a colon-separated list of
+	int. GPUs are assigned to workers roundrobin. Default is 0.
+
+.. option:: rocm_io=str : [libhipfile]
+
+	Specify the type of I/O to use with ROCm. Default is **hipfile**.
+
+	**hipfile**
+		Use the ROCm hipFile API. This option performs I/O directly
+		between a GPUDirect Storage filesystem and GPU buffers,
+		avoiding use of a bounce buffer. If :option:`verify` is set,
+		hipMemcpy is used to copy verification data between RAM and GPU.
+		Verification data is copied from RAM to GPU before a write
+		and from GPU to RAM after a read. :option:`direct` must be 1.
+	**posix**
+		Use POSIX to perform I/O with a RAM buffer, and use hipMemcpy
+		to transfer data between RAM and the GPUs. Data is copied from
+		GPU to RAM before a write and copied from RAM to GPU after a
+		read. :option:`verify` does not affect use of hipMemcpy.
+
 .. option:: nfs_url=str : [nfs]
 
 	URL in libnfs format, eg nfs://<server|ipv4|ipv6>/path[?arg=val[&arg=val]*]
diff --git a/Makefile b/Makefile
index 4f87adba..20db1a7d 100644
--- a/Makefile
+++ b/Makefile
@@ -120,6 +120,14 @@ ifdef CONFIG_LINUX_EXT4_MOVE_EXTENT
 endif
 ifdef CONFIG_LIBCUFILE
   SOURCE += engines/libcufile.c
+  SHARED_GPUACCEL_SOURCE = 1
+endif
+ifdef CONFIG_LIBHIPFILE
+  SOURCE += engines/libhipfile.c
+  SHARED_GPUACCEL_SOURCE = 1
+endif
+ifdef SHARED_GPUACCEL_SOURCE
+  SOURCE += engines/gpuaccel.c
 endif
 ifdef CONFIG_LINUX_SPLICE
   SOURCE += engines/splice.c
diff --git a/configure b/configure
index cdfefa59..804db167 100755
--- a/configure
+++ b/configure
@@ -182,6 +182,7 @@ pmem="no"
 cuda="no"
 cuda13="no"
 libcufile="no"
+libhipfile="no"
 disable_lex=""
 disable_pmem="no"
 disable_native="no"
@@ -255,6 +256,8 @@ for opt do
   ;;
   --enable-libcufile) libcufile="yes"
   ;;
+  --enable-libhipfile) libhipfile="yes"
+  ;;
   --disable-native) disable_native="yes"
   ;;
   --with-ime=*) ime_path="$optarg"
@@ -326,6 +329,7 @@ if test "$show_help" = "yes" ; then
   echo "--disable-optimizations Don't enable compiler optimizations"
   echo "--enable-cuda           Enable GPUDirect RDMA support"
   echo "--enable-libcufile      Enable GPUDirect Storage cuFile support"
+  echo "--enable-libhipfile     Enable ROCm hipFile support"
   echo "--disable-native        Don't build for native host"
   echo "--with-ime=             Install path for DDN's Infinite Memory Engine"
   echo "--enable-libiscsi       Enable iscsi support"
@@ -2872,6 +2876,37 @@ EOF
 fi
 print_config "libcufile" "$libcufile"
 
+
+##########################################
+# libhipfile probe
+if test "$libhipfile" != "no" ; then
+cat > $TMPC << EOF
+#include <hipfile.h>
+#include <hip/hip_runtime.h>
+
+int main(int argc, char* argv[]) {
+  void *buf = NULL;
+  hipMalloc(&buf, 0);
+  hipFileBufRegister(NULL, 0, 0);
+  return 0;
+}
+EOF
+  ROCM_PATH="${ROCM_PATH:-/opt/rocm}"
+  HIPFILE_CFLAGS="-D__HIP_PLATFORM_AMD__ -I${ROCM_PATH}/include"
+  HIPFILE_LIBS="-L${ROCM_PATH}/lib -Wl,-rpath,${ROCM_PATH}/lib -lamdhip64 -lhipfile"
+  if compile_prog "$HIPFILE_CFLAGS" "$HIPFILE_LIBS" "libhipfile"; then
+    libhipfile="yes"
+    CFLAGS="$HIPFILE_CFLAGS $CFLAGS"
+    LIBS="$HIPFILE_LIBS $LIBS"
+  else
+    if test "$libhipfile" = "yes" ; then
+      feature_not_found "libhipfile" ""
+    fi
+    libhipfile="no"
+  fi
+fi
+print_config "libhipfile" "$libhipfile"
+
 ##########################################
 # cuda 13 probe
 if test "$cuda" != "no" || test "$libcufile" != "no"; then
@@ -3390,6 +3425,9 @@ fi
 if test "$libcufile" = "yes" ; then
   output_sym "CONFIG_LIBCUFILE"
 fi
+if test "$libhipfile" = "yes" ; then
+  output_sym "CONFIG_LIBHIPFILE"
+fi
 if test "$cuda13" = "yes" ; then
   output_sym "CONFIG_CUDA13"
 fi
diff --git a/engines/gpuaccel.c b/engines/gpuaccel.c
new file mode 100644
index 00000000..75e89ac7
--- /dev/null
+++ b/engines/gpuaccel.c
@@ -0,0 +1,536 @@
+/*
+ * License: GPLv2, see COPYING.
+ *
+ * gpuaccel engine
+ *
+ * Abstract engine for GPU-accelerated I/O engines. See libcufile.c for
+ * an example implementation.
+ */
+
+
+#include <stdlib.h>
+#include <unistd.h>
+#include <errno.h>
+#include <string.h>
+
+#include "../fio.h"
+#include "gpuaccel.h"
+
+#define ALIGNED_4KB(v) (((v) & 0x0fff) == 0)
+
+#define LOGGED_BUFLEN_NOT_ALIGNED     0x01
+#define LOGGED_GPU_OFFSET_NOT_ALIGNED 0x02
+
+/*
+ * Assign GPU to subjob roundrobin, similar to how multiple
+ * entries in 'directory' are handled by fio.
+ */
+static int fio_gpuaccel_find_gpu_id(struct thread_data *td)
+{
+	struct gpuaccel_options *o = td->eo;
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
+		if (cur) {
+			char *endptr;
+
+			errno = 0;
+			gpu_id = strtol(cur, &endptr, 10);
+			if (errno != 0 || endptr == cur || *endptr != '\0') {
+				log_err("invalid GPU ID: %s\n", cur);
+				free(gpu_ids);
+				return -1;
+			}
+		}
+
+		free(gpu_ids);
+	}
+
+	return gpu_id;
+}
+
+int fio_gpuaccel_init(struct thread_data *td)
+{
+	struct gpuaccel_options *o = td->eo;
+	const struct gpuaccel_backend *be = o->backend;
+	int initialized;
+
+	pthread_mutex_lock(be->running_lock);
+	if (!*be->running) {
+		assert(!*be->initialized);
+		if (o->io_mode == IO_DIRECT) {
+			/* only open the driver if this is the first worker thread */
+			if (be->driver_open() != 0)
+				log_err("%s driver_open failed\n", be->name);
+			else
+				*be->initialized = 1;
+		}
+	}
+	(*be->running)++;
+	initialized = *be->initialized;
+	pthread_mutex_unlock(be->running_lock);
+
+	if (o->io_mode == IO_DIRECT && !initialized)
+		return 1;
+
+	o->my_gpu_id = fio_gpuaccel_find_gpu_id(td);
+	if (o->my_gpu_id < 0)
+		return 1;
+
+	dprint(FD_MEM, "Subjob %d uses GPU %d\n", td->subjob_number, o->my_gpu_id);
+	if (be->set_device(o->my_gpu_id) != 0)
+		return 1;
+
+	return 0;
+}
+
+static inline int fio_gpuaccel_pre_write(struct thread_data *td,
+					  struct gpuaccel_options *o,
+					  struct io_u *io_u,
+					  size_t gpu_offset)
+{
+	int rc = 0;
+	const struct gpuaccel_backend *be = o->backend;
+
+	if (o->io_mode == IO_DIRECT) {
+		if (td->o.verify) {
+			/*
+			 * Data is being verified, copy the io_u buffer to GPU memory.
+			 * This isn't done in the non-verify case because the data would
+			 * already be in GPU memory in a normal direct io application.
+			 */
+			rc = be->memcpy(((char*) o->gpu_mem_ptr) + gpu_offset,
+					io_u->xfer_buf,
+					io_u->xfer_buflen, MEMCPY_DIRECTION_H2D);
+			if (rc != 0) {
+				log_err("DDIR_WRITE %s memcpy H2D failed\n", be->name);
+				io_u->error = EIO;
+			}
+		}
+	} else if (o->io_mode == IO_POSIX) {
+
+		/*
+		 * POSIX I/O is being used, the data has to be copied out of the
+		 * GPU into a CPU buffer. GPU memory doesn't contain the actual
+		 * data to write, copy the data to the junk buffer. The purpose
+		 * of this is to add the overhead of memcpy() that would be
+		 * present in a POSIX I/O GPU application.
+		 */
+		rc = be->memcpy(o->junk_buf + gpu_offset,
+				((char*) o->gpu_mem_ptr) + gpu_offset,
+				io_u->xfer_buflen, MEMCPY_DIRECTION_D2H);
+		if (rc != 0) {
+			log_err("DDIR_WRITE %s memcpy D2H failed\n", be->name);
+			io_u->error = EIO;
+		}
+		if (be->sync_after_posix_write_copy) {
+			rc = be->stream_sync();
+			if (rc) {
+				log_err("DDIR_WRITE stream synchronize failed\n");
+				io_u->error = EIO;
+			}
+		}
+	} else {
+		log_err("Illegal %s IO type: %d\n", be->name, o->io_mode);
+		assert(0);
+		rc = -EINVAL;
+	}
+
+	return rc;
+}
+
+static inline int fio_gpuaccel_post_read(struct thread_data *td,
+					  struct gpuaccel_options *o,
+					  struct io_u *io_u,
+					  size_t gpu_offset)
+{
+	int rc = 0;
+	const struct gpuaccel_backend *be = o->backend;
+
+	if (o->io_mode == IO_DIRECT) {
+		if (td->o.verify) {
+			/* Copy GPU memory to CPU buffer for verify */
+			rc = be->memcpy(io_u->xfer_buf,
+							 ((char*) o->gpu_mem_ptr) + gpu_offset,
+							 io_u->xfer_buflen,
+							 MEMCPY_DIRECTION_D2H);
+			if (rc != 0) {
+				log_err("DDIR_READ %s memcpy D2H failed\n", be->name);
+				io_u->error = EIO;
+			}
+		}
+	} else if (o->io_mode == IO_POSIX) {
+		/* POSIX I/O read, copy the CPU buffer to GPU memory */
+		rc = be->memcpy(((char*) o->gpu_mem_ptr) + gpu_offset,
+						 io_u->xfer_buf,
+						 io_u->xfer_buflen,
+						 MEMCPY_DIRECTION_H2D);
+		if (rc != 0) {
+			log_err("DDIR_READ %s memcpy H2D failed\n", be->name);
+			io_u->error = EIO;
+		}
+		if (be->sync_after_verify_read_copy) {
+			rc = be->stream_sync();
+			if (rc) {
+				log_err("DDIR_READ stream synchronize failed\n");
+				io_u->error = EIO;
+			}
+		}
+	} else {
+		log_err("Illegal %s IO type: %d\n", be->name, o->io_mode);
+		assert(0);
+		rc = -EINVAL;
+	}
+
+	return rc;
+}
+
+enum fio_q_status fio_gpuaccel_queue(struct thread_data *td,
+					     struct io_u *io_u)
+{
+	struct gpuaccel_options *o = td->eo;
+	const struct gpuaccel_backend *be = o->backend;
+	void *file_handle = FILE_ENG_DATA(io_u->file);
+	unsigned long long io_offset;
+	ssize_t sz;
+	ssize_t remaining;
+	size_t xfered;
+	size_t gpu_offset;
+	int rc;
+
+	if (o->io_mode == IO_DIRECT && file_handle == NULL) {
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
+		 * There may be a better way to calculate gpu_offset. The intent is
+		 * that gpu_offset equals the difference between io_u->xfer_buf and
+		 * the page-aligned base address for io_u buffers.
+		 */
+		gpu_offset = io_u->index * io_u->xfer_buflen;
+		io_offset = io_u->offset;
+		remaining = io_u->xfer_buflen;
+
+		xfered = 0;
+		sz = 0;
+
+		assert(gpu_offset + io_u->xfer_buflen <= o->total_mem);
+
+		if (o->io_mode == IO_DIRECT) {
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
+			rc = fio_gpuaccel_pre_write(td, o, io_u, gpu_offset);
+
+		if (io_u->error != 0)
+			break;
+
+		while (remaining > 0) {
+			assert(gpu_offset + xfered <= o->total_mem);
+			if (io_u->ddir == DDIR_READ) {
+				if (o->io_mode == IO_DIRECT) {
+					sz = be->read(file_handle, o->gpu_mem_ptr, remaining,
+							io_offset + xfered, gpu_offset + xfered);
+					if (sz == -1) {
+						io_u->error = errno;
+						log_err("%s Read: err=%d\n", be->name, errno);
+					} else if (sz == 0) {
+						io_u->error = EIO;
+						log_err("%s Read: unexpected EOF\n", be->name);
+					} else if (sz < 0) {
+						io_u->error = EIO;
+						log_err("%s Read: err=%ld:%s\n", be->name, sz,
+							be->op_error_string(-sz));
+					}
+				} else if (o->io_mode == IO_POSIX) {
+					sz = pread(io_u->file->fd, ((char*) io_u->xfer_buf) + xfered,
+						   remaining, io_offset + xfered);
+					if (sz < 0) {
+						io_u->error = errno;
+						log_err("pread: err=%d\n", errno);
+					} else if (sz == 0) {
+						io_u->error = EIO;
+						log_err("pread: unexpected EOF\n");
+					}
+				} else {
+					log_err("Illegal %s IO type: %d\n", be->name, o->io_mode);
+					io_u->error = -1;
+					assert(0);
+				}
+			} else if (io_u->ddir == DDIR_WRITE) {
+				if (o->io_mode == IO_DIRECT) {
+					sz = be->write(file_handle, o->gpu_mem_ptr, remaining,
+							 io_offset + xfered, gpu_offset + xfered);
+					if (sz == -1) {
+						io_u->error = errno;
+						log_err("%s Write: err=%d\n", be->name, errno);
+					} else if (sz == 0) {
+						io_u->error = EIO;
+						log_err("%s Write: unexpected EOF\n", be->name);
+					} else if (sz < 0) {
+						io_u->error = EIO;
+						log_err("%s Write: err=%ld:%s\n", be->name, sz,
+							be->op_error_string(-sz));
+					}
+				} else if (o->io_mode == IO_POSIX) {
+					sz = pwrite(io_u->file->fd,
+						    ((char*) io_u->xfer_buf) + xfered,
+						    remaining, io_offset + xfered);
+					if (sz < 0) {
+						io_u->error = errno;
+						log_err("pwrite: err=%d\n", errno);
+					} else if (sz == 0) {
+						io_u->error = EIO;
+						log_err("pwrite: unexpected EOF\n");
+					}
+				} else {
+					log_err("Illegal %s IO type: %d\n", be->name, o->io_mode);
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
+			rc = fio_gpuaccel_post_read(td, o, io_u, gpu_offset);
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
+int fio_gpuaccel_open_file(struct thread_data *td, struct fio_file *f)
+{
+	struct gpuaccel_options *o = td->eo;
+	const struct gpuaccel_backend *be = o->backend;
+	void *handle = NULL;
+	int rc;
+
+	rc = generic_open_file(td, f);
+	if (rc)
+		return rc;
+
+	if (o->io_mode == IO_DIRECT) {
+		rc = be->file_handle_register(f->fd, &handle);
+		if (rc != 0) {
+			goto exit_err;
+		}
+	}
+
+	FILE_SET_ENG_DATA(f, handle);
+	return 0;
+
+exit_err:
+	if (handle) {
+		free(handle);
+		handle = NULL;
+	}
+	if (f) {
+		int rc2 = generic_close_file(td, f);
+		if (rc2)
+			log_err("generic_close_file: err=%d\n", rc2);
+	}
+	return rc;
+}
+
+int fio_gpuaccel_close_file(struct thread_data *td, struct fio_file *f)
+{
+	void *handle = FILE_ENG_DATA(f);
+	int rc;
+	struct gpuaccel_options *o = td->eo;
+	const struct gpuaccel_backend *be = o->backend;
+
+	if (handle != NULL) {
+		be->file_handle_deregister(handle);
+		FILE_SET_ENG_DATA(f, NULL);
+	}
+
+	rc = generic_close_file(td, f);
+
+	return rc;
+}
+
+int fio_gpuaccel_iomem_alloc(struct thread_data *td, size_t total_mem)
+{
+	struct gpuaccel_options *o = td->eo;
+	const struct gpuaccel_backend *be = o->backend;
+	int rc;
+
+	o->total_mem = total_mem;
+	o->logged = 0;
+	o->gpu_mem_ptr = NULL;
+	o->junk_buf = NULL;
+	td->orig_buffer = calloc(1, total_mem);
+	if (!td->orig_buffer) {
+		log_err("orig_buffer calloc failed: err=%d\n", errno);
+		goto exit_error;
+	}
+
+	if (o->io_mode == IO_POSIX) {
+		o->junk_buf = calloc(1, total_mem);
+		if (o->junk_buf == NULL) {
+			log_err("junk_buf calloc failed: err=%d\n", errno);
+			goto exit_error;
+		}
+	}
+
+	dprint(FD_MEM, "Alloc %zu for GPU %d\n", total_mem, o->my_gpu_id);
+	rc = be->malloc(&o->gpu_mem_ptr, total_mem);
+	if (rc != 0)
+		goto exit_error;
+	rc = be->memset(o->gpu_mem_ptr, 0xab, total_mem);
+	if (rc != 0)
+		goto exit_error;
+	if (be->sync_after_memset) {
+		rc = be->stream_sync();
+		if (rc != 0)
+			goto exit_error;
+	}
+	if (o->io_mode == IO_DIRECT) {
+		rc = be->buf_register(o->gpu_mem_ptr, total_mem);
+		if (rc != 0)
+			goto exit_error;
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
+	if (o->gpu_mem_ptr) {
+		be->free(o->gpu_mem_ptr);
+		o->gpu_mem_ptr = NULL;
+	}
+	return 1;
+}
+
+void fio_gpuaccel_iomem_free(struct thread_data *td)
+{
+	struct gpuaccel_options *o = td->eo;
+	const struct gpuaccel_backend *be = o->backend;
+
+	if (o->junk_buf) {
+		free(o->junk_buf);
+		o->junk_buf = NULL;
+	}
+	if (o->gpu_mem_ptr) {
+		if (o->io_mode == IO_DIRECT)
+			be->buf_deregister(o->gpu_mem_ptr);
+		be->free(o->gpu_mem_ptr);
+		o->gpu_mem_ptr = NULL;
+	}
+	if (td->orig_buffer) {
+		free(td->orig_buffer);
+		td->orig_buffer = NULL;
+	}
+}
+
+void fio_gpuaccel_cleanup(struct thread_data *td)
+{
+	struct gpuaccel_options *o = td->eo;
+	const struct gpuaccel_backend *be = o->backend;
+
+	pthread_mutex_lock(be->running_lock);
+	(*be->running)--;
+	assert(*be->running >= 0);
+	if (!*be->running) {
+		/*
+		 * Only close the driver if initialized and
+		 * this is the last worker thread.
+		 */
+		if (o->io_mode == IO_DIRECT && *be->initialized)
+			be->driver_close();
+		*be->initialized = 0;
+	}
+	pthread_mutex_unlock(be->running_lock);
+}
diff --git a/engines/gpuaccel.h b/engines/gpuaccel.h
new file mode 100644
index 00000000..4ef97827
--- /dev/null
+++ b/engines/gpuaccel.h
@@ -0,0 +1,82 @@
+#ifndef FIO_GPUACCEL_H
+#define FIO_GPUACCEL_H
+
+#include <pthread.h>
+#include <unistd.h>
+
+#define GPU_ID_SEP ":"
+
+enum fio_q_status;
+struct thread_data;
+struct io_u;
+struct fio_file;
+
+enum {
+	IO_DIRECT    = 1,
+	IO_POSIX     = 2
+};
+
+enum {
+	MEMCPY_DIRECTION_H2D = 1,
+	MEMCPY_DIRECTION_D2H = 2
+};
+
+struct gpuaccel_backend {
+	const char *name;
+
+	int sync_after_posix_write_copy;
+	int sync_after_verify_read_copy;
+	int sync_after_memset;
+
+	int *running;
+	int *initialized;
+	pthread_mutex_t *running_lock;
+
+	int (*driver_open)(void);
+	void (*driver_close)(void);
+
+	int (*set_device)(int gpu_id);
+	int (*malloc)(void **mem, size_t size);
+	int (*free)(void *mem);
+	int (*memset)(void *mem, int value, size_t size);
+	int (*memcpy)(void *dst, const void *src, size_t size, int direction);
+	int (*stream_sync)(void);
+
+	int (*file_handle_register)(int fd, void **handle);
+	void (*file_handle_deregister)(void *handle);
+
+	int (*buf_register)(void *mem, size_t size);
+	void (*buf_deregister)(void *mem);
+
+	ssize_t (*read)(void *handle, void *mem, size_t size,
+			      unsigned long long file_offset, size_t mem_offset);
+	ssize_t (*write)(void *handle, const void *mem, size_t size,
+			       unsigned long long file_offset, size_t mem_offset);
+
+	const char *(*op_error_string)(int error_code);
+};
+
+struct gpuaccel_options {
+	struct thread_data *td;
+	char               *gpu_ids;            /* colon-separated list of GPU ids,
+					                           one per job */
+	void               *gpu_mem_ptr;        /* GPU memory */
+	void               *junk_buf;           /* buffer to simulate cudaMemcpy
+					                           with posix I/O write */
+	int                 my_gpu_id;          /* GPU id to use for this job */
+	unsigned int        io_mode;            /* Type of I/O to use */
+	size_t              total_mem;          /* size for gpu_mem_ptr and junk_buf */
+	int                 logged;             /* bitmask of log messages that have
+					                           been output, prevent flood */
+	const struct gpuaccel_backend *backend; /* GPU accelerator backend vtable */
+};
+
+int fio_gpuaccel_init(struct thread_data *td);
+void fio_gpuaccel_cleanup(struct thread_data *td);
+enum fio_q_status fio_gpuaccel_queue(struct thread_data *td, struct io_u *io_u);
+int fio_gpuaccel_open_file(struct thread_data *td, struct fio_file *f);
+int fio_gpuaccel_close_file(struct thread_data *td, struct fio_file *f);
+int fio_gpuaccel_iomem_alloc(struct thread_data *td, size_t total_mem);
+void fio_gpuaccel_iomem_free(struct thread_data *td);
+
+#endif
diff --git a/engines/libcufile.c b/engines/libcufile.c
index 2bedf261..c5a1de71 100644
--- a/engines/libcufile.c
+++ b/engines/libcufile.c
@@ -25,31 +25,7 @@
 #include "../lib/pow2.h"
 #include "../optgroup.h"
 #include "../lib/memalign.h"
-
-#define ALIGNED_4KB(v) (((v) & 0x0fff) == 0)
-
-#define LOGGED_BUFLEN_NOT_ALIGNED     0x01
-#define LOGGED_GPU_OFFSET_NOT_ALIGNED 0x02
-#define GPU_ID_SEP ":"
-
-enum {
-	IO_CUFILE    = 1,
-	IO_POSIX     = 2
-};
-
-struct libcufile_options {
-	struct thread_data *td;
-	char               *gpu_ids;       /* colon-separated list of GPU ids,
-					      one per job */
-	void               *cu_mem_ptr;    /* GPU memory */
-	void               *junk_buf;      /* buffer to simulate cudaMemcpy with
-					      posix I/O write */
-	int                 my_gpu_id;     /* GPU id to use for this job */
-	unsigned int        cuda_io;       /* Type of I/O to use with CUDA */
-	size_t              total_mem;     /* size for cu_mem_ptr and junk_buf */
-	int                 logged;        /* bitmask of log messages that have
-					      been output, prevent flood */
-};
+#include "gpuaccel.h"
 
 struct fio_libcufile_data {
 	CUfileDescr_t  cf_descr;
@@ -61,21 +37,21 @@ static struct fio_option options[] = {
 		.name	  = "gpu_dev_ids",
 		.lname	  = "libcufile engine gpu dev ids",
 		.type	  = FIO_OPT_STR_STORE,
-		.off1	  = offsetof(struct libcufile_options, gpu_ids),
+		.off1	  = offsetof(struct gpuaccel_options, gpu_ids),
 		.help	  = "GPU IDs, one per subjob, separated by " GPU_ID_SEP,
 		.category = FIO_OPT_C_ENGINE,
 		.group	  = FIO_OPT_G_LIBCUFILE,
 	},
 	{
 		.name	  = "cuda_io",
-		.lname	  = "libcufile cuda io",
+		.lname	  = "libcufile io mode",
 		.type	  = FIO_OPT_STR,
-		.off1	  = offsetof(struct libcufile_options, cuda_io),
+		.off1	  = offsetof(struct gpuaccel_options, io_mode),
 		.help	  = "Type of I/O to use with CUDA",
 		.def      = "cufile",
 		.posval   = {
 			    { .ival = "cufile",
-			      .oval = IO_CUFILE,
+			      .oval = IO_DIRECT,
 			      .help = "libcufile nvidia-fs"
 			    },
 			    { .ival = "posix",
@@ -91,9 +67,7 @@ static struct fio_option options[] = {
 	},
 };
 
-static int running = 0;
-static int cufile_initialized = 0;
-static pthread_mutex_t running_lock = PTHREAD_MUTEX_INITIALIZER;
+
 
 #define check_cudaruntimecall(fn, rc)                                               \
 	do {                                                                        \
@@ -114,507 +88,202 @@ static const char *fio_libcufile_get_cuda_error(CUfileError_t st)
 	return "unknown";
 }
 
-/*
- * Assign GPU to subjob roundrobin, similar to how multiple
- * entries in 'directory' are handled by fio.
- */
-static int fio_libcufile_find_gpu_id(struct thread_data *td)
+static int libcufile_driver_open(void)
 {
-	struct libcufile_options *o = td->eo;
-	int gpu_id = 0;
-
-	if (o->gpu_ids != NULL) {
-		char *gpu_ids, *pos, *cur;
-		int i, id_count, gpu_idx;
-
-		for (id_count = 0, cur = o->gpu_ids; cur != NULL; id_count++) {
-			cur = strchr(cur, GPU_ID_SEP[0]);
-			if (cur != NULL)
-				cur++;
-		}
-
-		gpu_idx = td->subjob_number % id_count;
-
-		pos = gpu_ids = strdup(o->gpu_ids);
-		if (gpu_ids == NULL) {
-			log_err("strdup(gpu_ids): err=%d\n", errno);
-			return -1;
-		}
-
-		i = 0;
-		while (pos != NULL && i <= gpu_idx) {
-			i++;
-			cur = strsep(&pos, GPU_ID_SEP);
-		}
-
-		if (cur)
-			gpu_id = atoi(cur);
+	CUfileError_t status;
 
-		free(gpu_ids);
+	status = cuFileDriverOpen();
+	if (status.err != CU_FILE_SUCCESS) {
+		log_err("cuFileDriverOpen: err=%d:%s\n", status.err,
+			fio_libcufile_get_cuda_error(status));
+		return -1;
 	}
 
-	return gpu_id;
+	return 0;
 }
 
-static int fio_libcufile_init(struct thread_data *td)
+static void libcufile_driver_close(void)
 {
-	struct libcufile_options *o = td->eo;
-	CUfileError_t status;
-	int initialized;
-	int rc;
-
-	pthread_mutex_lock(&running_lock);
-	if (running == 0) {
-		assert(cufile_initialized == 0);
-		if (o->cuda_io == IO_CUFILE) {
-			/* only open the driver if this is the first worker thread */
-			status = cuFileDriverOpen();
-			if (status.err != CU_FILE_SUCCESS)
-				log_err("cuFileDriverOpen: err=%d:%s\n", status.err,
-					fio_libcufile_get_cuda_error(status));
-			else
-				cufile_initialized = 1;
-		}
-	}
-	running++;
-	initialized = cufile_initialized;
-	pthread_mutex_unlock(&running_lock);
-
-	if (o->cuda_io == IO_CUFILE && !initialized)
-		return 1;
-
-	o->my_gpu_id = fio_libcufile_find_gpu_id(td);
-	if (o->my_gpu_id < 0)
-		return 1;
+	cuFileDriverClose();
+}
 
-	dprint(FD_MEM, "Subjob %d uses GPU %d\n", td->subjob_number, o->my_gpu_id);
-	check_cudaruntimecall(cudaSetDevice(o->my_gpu_id), rc);
-	if (rc != 0)
-		return 1;
+static int libcufile_set_device(int gpu_id)
+{
+	int rc;
 
-	return 0;
+	check_cudaruntimecall(cudaSetDevice(gpu_id), rc);
+	return rc;
 }
 
-static inline int fio_libcufile_pre_write(struct thread_data *td,
-					  struct libcufile_options *o,
-					  struct io_u *io_u,
-					  size_t gpu_offset)
+static int libcufile_malloc(void **mem, size_t size)
 {
-	int rc = 0;
-
-	if (o->cuda_io == IO_CUFILE) {
-		if (td->o.verify) {
-			/*
-			  Data is being verified, copy the io_u buffer to GPU memory.
-			  This isn't done in the non-verify case because the data would
-			  already be in GPU memory in a normal cuFile application.
-			*/
-			check_cudaruntimecall(cudaMemcpy(((char*) o->cu_mem_ptr) + gpu_offset,
-							 io_u->xfer_buf,
-							 io_u->xfer_buflen,
-							 cudaMemcpyHostToDevice), rc);
-			if (rc != 0) {
-				log_err("DDIR_WRITE cudaMemcpy H2D failed\n");
-				io_u->error = EIO;
-			}
-		}
-	} else if (o->cuda_io == IO_POSIX) {
-
-		/*
-		  POSIX I/O is being used, the data has to be copied out of the
-		  GPU into a CPU buffer. GPU memory doesn't contain the actual
-		  data to write, copy the data to the junk buffer. The purpose
-		  of this is to add the overhead of cudaMemcpy() that would be
-		  present in a POSIX I/O CUDA application.
-		*/
-		check_cudaruntimecall(cudaMemcpy(o->junk_buf + gpu_offset,
-						 ((char*) o->cu_mem_ptr) + gpu_offset,
-						 io_u->xfer_buflen,
-						 cudaMemcpyDeviceToHost), rc);
-		if (rc != 0) {
-			log_err("DDIR_WRITE cudaMemcpy D2H failed\n");
-			io_u->error = EIO;
-		}
-	} else {
-		log_err("Illegal CUDA IO type: %d\n", o->cuda_io);
-		assert(0);
-		rc = EINVAL;
-	}
+	int rc;
 
+	check_cudaruntimecall(cudaMalloc(mem, size), rc);
 	return rc;
 }
 
-static inline int fio_libcufile_post_read(struct thread_data *td,
-					  struct libcufile_options *o,
-					  struct io_u *io_u,
-					  size_t gpu_offset)
+static int libcufile_free(void *mem)
 {
-	int rc = 0;
-
-	if (o->cuda_io == IO_CUFILE) {
-		if (td->o.verify) {
-			/* Copy GPU memory to CPU buffer for verify */
-			check_cudaruntimecall(cudaMemcpy(io_u->xfer_buf,
-							 ((char*) o->cu_mem_ptr) + gpu_offset,
-							 io_u->xfer_buflen,
-							 cudaMemcpyDeviceToHost), rc);
-			if (rc != 0) {
-				log_err("DDIR_READ cudaMemcpy D2H failed\n");
-				io_u->error = EIO;
-			}
-		}
-	} else if (o->cuda_io == IO_POSIX) {
-		/* POSIX I/O read, copy the CPU buffer to GPU memory */
-		check_cudaruntimecall(cudaMemcpy(((char*) o->cu_mem_ptr) + gpu_offset,
-						 io_u->xfer_buf,
-						 io_u->xfer_buflen,
-						 cudaMemcpyHostToDevice), rc);
-		if (rc != 0) {
-			log_err("DDIR_READ cudaMemcpy H2D failed\n");
-			io_u->error = EIO;
-		}
-	} else {
-		log_err("Illegal CUDA IO type: %d\n", o->cuda_io);
-		assert(0);
-		rc = EINVAL;
-	}
+	int rc;
 
+	check_cudaruntimecall(cudaFree(mem), rc);
 	return rc;
 }
 
-static enum fio_q_status fio_libcufile_queue(struct thread_data *td,
-					     struct io_u *io_u)
+static int libcufile_memset(void *mem, int value, size_t size)
 {
-	struct libcufile_options *o = td->eo;
-	struct fio_libcufile_data *fcd = FILE_ENG_DATA(io_u->file);
-	unsigned long long io_offset;
-	ssize_t sz;
-	ssize_t remaining;
-	size_t xfered;
-	size_t gpu_offset;
 	int rc;
 
-	if (o->cuda_io == IO_CUFILE && fcd == NULL) {
-		io_u->error = EINVAL;
-		td_verror(td, EINVAL, "xfer");
-		return FIO_Q_COMPLETED;
-	}
-
-	fio_ro_check(td, io_u);
+	check_cudaruntimecall(cudaMemset(mem, value, size), rc);
+	return rc;
+}
 
-	switch(io_u->ddir) {
-	case DDIR_SYNC:
-		rc = fsync(io_u->file->fd);
-		if (rc != 0) {
-			io_u->error = errno;
-			log_err("fsync: err=%d\n", errno);
-		}
-		break;
+static int libcufile_memcpy(void *dst, const void *src, size_t size, int direction)
+{
+	int rc;
+	enum cudaMemcpyKind kind;
 
-	case DDIR_DATASYNC:
-		rc = fdatasync(io_u->file->fd);
-		if (rc != 0) {
-			io_u->error = errno;
-			log_err("fdatasync: err=%d\n", errno);
-		}
+	switch (direction) {
+	case MEMCPY_DIRECTION_H2D:
+		kind = cudaMemcpyHostToDevice;
 		break;
-
-	case DDIR_READ:
-	case DDIR_WRITE:
-		/*
-		  There may be a better way to calculate gpu_offset. The intent is
-		  that gpu_offset equals the the difference between io_u->xfer_buf and
-		  the page-aligned base address for io_u buffers.
-		*/
-		gpu_offset = io_u->index * io_u->xfer_buflen;
-		io_offset = io_u->offset;
-		remaining = io_u->xfer_buflen;
-
-		xfered = 0;
-		sz = 0;
-
-		assert(gpu_offset + io_u->xfer_buflen <= o->total_mem);
-
-		if (o->cuda_io == IO_CUFILE) {
-			if (!(ALIGNED_4KB(io_u->xfer_buflen) ||
-			      (o->logged & LOGGED_BUFLEN_NOT_ALIGNED))) {
-				log_err("buflen not 4KB-aligned: %llu\n", io_u->xfer_buflen);
-				o->logged |= LOGGED_BUFLEN_NOT_ALIGNED;
-			}
-
-			if (!(ALIGNED_4KB(gpu_offset) ||
-			      (o->logged & LOGGED_GPU_OFFSET_NOT_ALIGNED))) {
-				log_err("gpu_offset not 4KB-aligned: %lu\n", gpu_offset);
-				o->logged |= LOGGED_GPU_OFFSET_NOT_ALIGNED;
-			}
-		}
-
-		if (io_u->ddir == DDIR_WRITE)
-			rc = fio_libcufile_pre_write(td, o, io_u, gpu_offset);
-
-		if (io_u->error != 0)
-			break;
-
-		while (remaining > 0) {
-			assert(gpu_offset + xfered <= o->total_mem);
-			if (io_u->ddir == DDIR_READ) {
-				if (o->cuda_io == IO_CUFILE) {
-					sz = cuFileRead(fcd->cf_handle, o->cu_mem_ptr, remaining,
-							io_offset + xfered, gpu_offset + xfered);
-					if (sz == -1) {
-						io_u->error = errno;
-						log_err("cuFileRead: err=%d\n", errno);
-					} else if (sz < 0) {
-						io_u->error = EIO;
-						log_err("cuFileRead: err=%ld:%s\n", sz,
-							cufileop_status_error(-sz));
-					}
-				} else if (o->cuda_io == IO_POSIX) {
-					sz = pread(io_u->file->fd, ((char*) io_u->xfer_buf) + xfered,
-						   remaining, io_offset + xfered);
-					if (sz < 0) {
-						io_u->error = errno;
-						log_err("pread: err=%d\n", errno);
-					}
-				} else {
-					log_err("Illegal CUDA IO type: %d\n", o->cuda_io);
-					io_u->error = -1;
-					assert(0);
-				}
-			} else if (io_u->ddir == DDIR_WRITE) {
-				if (o->cuda_io == IO_CUFILE) {
-					sz = cuFileWrite(fcd->cf_handle, o->cu_mem_ptr, remaining,
-							 io_offset + xfered, gpu_offset + xfered);
-					if (sz == -1) {
-						io_u->error = errno;
-						log_err("cuFileWrite: err=%d\n", errno);
-					} else if (sz < 0) {
-						io_u->error = EIO;
-						log_err("cuFileWrite: err=%ld:%s\n", sz,
-							cufileop_status_error(-sz));
-					}
-				} else if (o->cuda_io == IO_POSIX) {
-					sz = pwrite(io_u->file->fd,
-						    ((char*) io_u->xfer_buf) + xfered,
-						    remaining, io_offset + xfered);
-					if (sz < 0) {
-						io_u->error = errno;
-						log_err("pwrite: err=%d\n", errno);
-					}
-				} else {
-					log_err("Illegal CUDA IO type: %d\n", o->cuda_io);
-					io_u->error = -1;
-					assert(0);
-				}
-			} else {
-				log_err("not DDIR_READ or DDIR_WRITE: %d\n", io_u->ddir);
-				io_u->error = -1;
-				assert(0);
-				break;
-			}
-
-			if (io_u->error != 0)
-				break;
-
-			remaining -= sz;
-			xfered += sz;
-
-			if (remaining != 0)
-				log_info("Incomplete %s: %ld bytes remaining\n",
-					 io_u->ddir == DDIR_READ? "read" : "write", remaining);
-		}
-
-		if (io_u->error != 0)
-			break;
-
-		if (io_u->ddir == DDIR_READ)
-			rc = fio_libcufile_post_read(td, o, io_u, gpu_offset);
+	case MEMCPY_DIRECTION_D2H:
+		kind = cudaMemcpyDeviceToHost;
 		break;
-
 	default:
-		io_u->error = EINVAL;
-		break;
+		return -1;
 	}
 
-	if (io_u->error != 0) {
-		log_err("IO failed\n");
-		td_verror(td, io_u->error, "xfer");
-	}
-
-	return FIO_Q_COMPLETED;
+	check_cudaruntimecall(cudaMemcpy(dst, src, size, kind), rc);
+	return rc;
 }
 
-static int fio_libcufile_open_file(struct thread_data *td, struct fio_file *f)
+static int libcufile_stream_sync(void)
 {
-	struct libcufile_options *o = td->eo;
-	struct fio_libcufile_data *fcd = NULL;
 	int rc;
-	CUfileError_t status;
-
-	rc = generic_open_file(td, f);
-	if (rc)
-		return rc;
-
-	if (o->cuda_io == IO_CUFILE) {
-		fcd = calloc(1, sizeof(*fcd));
-		if (fcd == NULL) {
-			rc = ENOMEM;
-			goto exit_err;
-		}
-
-		fcd->cf_descr.handle.fd = f->fd;
-		fcd->cf_descr.type = CU_FILE_HANDLE_TYPE_OPAQUE_FD;
-		status = cuFileHandleRegister(&fcd->cf_handle, &fcd->cf_descr);
-		if (status.err != CU_FILE_SUCCESS) {
-			log_err("cufile register: err=%d:%s\n", status.err,
-				fio_libcufile_get_cuda_error(status));
-			rc = EINVAL;
-			goto exit_err;
-		}
-	}
 
-	FILE_SET_ENG_DATA(f, fcd);
-	return 0;
-
-exit_err:
-	if (fcd) {
-		free(fcd);
-		fcd = NULL;
-	}
-	if (f) {
-		int rc2 = generic_close_file(td, f);
-		if (rc2)
-			log_err("generic_close_file: err=%d\n", rc2);
-	}
+	check_cudaruntimecall(cudaStreamSynchronize(NULL), rc);
 	return rc;
 }
 
-static int fio_libcufile_close_file(struct thread_data *td, struct fio_file *f)
+static int libcufile_file_handle_register(int fd, void **handle)
 {
-	struct fio_libcufile_data *fcd = FILE_ENG_DATA(f);
-	int rc;
+	struct fio_libcufile_data *fcd;
+	CUfileError_t status;
+
+	fcd = calloc(1, sizeof(*fcd));
+	if (fcd == NULL)
+		return ENOMEM;
 
-	if (fcd != NULL) {
-		cuFileHandleDeregister(fcd->cf_handle);
-		FILE_SET_ENG_DATA(f, NULL);
+	fcd->cf_descr.handle.fd = fd;
+	fcd->cf_descr.type = CU_FILE_HANDLE_TYPE_OPAQUE_FD;
+	status = cuFileHandleRegister(&fcd->cf_handle, &fcd->cf_descr);
+	if (status.err != CU_FILE_SUCCESS) {
+		log_err("cufile register: err=%d:%s\n", status.err,
+			fio_libcufile_get_cuda_error(status));
 		free(fcd);
+		return EINVAL;
 	}
 
-	rc = generic_close_file(td, f);
-
-	return rc;
+	*handle = fcd;
+	return 0;
 }
 
-static int fio_libcufile_iomem_alloc(struct thread_data *td, size_t total_mem)
+static void libcufile_file_handle_deregister(void *handle)
 {
-	struct libcufile_options *o = td->eo;
-	int rc;
-	CUfileError_t status;
+	struct fio_libcufile_data *fcd = handle;
 
-	o->total_mem = total_mem;
-	o->logged = 0;
-	o->cu_mem_ptr = NULL;
-	o->junk_buf = NULL;
-	td->orig_buffer = calloc(1, total_mem);
-	if (!td->orig_buffer) {
-		log_err("orig_buffer calloc failed: err=%d\n", errno);
-		goto exit_error;
-	}
+	cuFileHandleDeregister(fcd->cf_handle);
+	free(fcd);
+}
 
-	if (o->cuda_io == IO_POSIX) {
-		o->junk_buf = calloc(1, total_mem);
-		if (o->junk_buf == NULL) {
-			log_err("junk_buf calloc failed: err=%d\n", errno);
-			goto exit_error;
-		}
-	}
+static int libcufile_buf_register(void *mem, size_t size)
+{
+	CUfileError_t status;
 
-	dprint(FD_MEM, "Alloc %zu for GPU %d\n", total_mem, o->my_gpu_id);
-	check_cudaruntimecall(cudaMalloc(&o->cu_mem_ptr, total_mem), rc);
-	if (rc != 0)
-		goto exit_error;
-	check_cudaruntimecall(cudaMemset(o->cu_mem_ptr, 0xab, total_mem), rc);
-	if (rc != 0)
-		goto exit_error;
-
-	if (o->cuda_io == IO_CUFILE) {
-		status = cuFileBufRegister(o->cu_mem_ptr, total_mem, 0);
-		if (status.err != CU_FILE_SUCCESS) {
-			log_err("cuFileBufRegister: err=%d:%s\n", status.err,
-				fio_libcufile_get_cuda_error(status));
-			goto exit_error;
-		}
+	status = cuFileBufRegister(mem, size, 0);
+	if (status.err != CU_FILE_SUCCESS) {
+		log_err("cuFileBufRegister: err=%d:%s\n", status.err,
+			fio_libcufile_get_cuda_error(status));
+		return -1;
 	}
 
 	return 0;
+}
 
-exit_error:
-	if (td->orig_buffer) {
-		free(td->orig_buffer);
-		td->orig_buffer = NULL;
-	}
-	if (o->junk_buf) {
-		free(o->junk_buf);
-		o->junk_buf = NULL;
-	}
-	if (o->cu_mem_ptr) {
-		cudaFree(o->cu_mem_ptr);
-		o->cu_mem_ptr = NULL;
-	}
-	return 1;
+static void libcufile_buf_deregister(void *mem)
+{
+	cuFileBufDeregister(mem);
 }
 
-static void fio_libcufile_iomem_free(struct thread_data *td)
+static ssize_t libcufile_read(void *handle, void *mem, size_t size, unsigned long long offset, size_t mem_offset)
 {
-	struct libcufile_options *o = td->eo;
+	struct fio_libcufile_data *fcd = handle;
+	return cuFileRead(fcd->cf_handle, mem, size, offset, mem_offset);
+}
 
-	if (o->junk_buf) {
-		free(o->junk_buf);
-		o->junk_buf = NULL;
-	}
-	if (o->cu_mem_ptr) {
-		if (o->cuda_io == IO_CUFILE)
-			cuFileBufDeregister(o->cu_mem_ptr);
-		cudaFree(o->cu_mem_ptr);
-		o->cu_mem_ptr = NULL;
-	}
-	if (td->orig_buffer) {
-		free(td->orig_buffer);
-		td->orig_buffer = NULL;
-	}
+static ssize_t libcufile_write(void *handle, const void *mem, size_t size, unsigned long long offset, size_t mem_offset)
+{
+	struct fio_libcufile_data *fcd = handle;
+	return cuFileWrite(fcd->cf_handle, mem, size, offset, mem_offset);
 }
 
-static void fio_libcufile_cleanup(struct thread_data *td)
+static const char *libcufile_op_error_string(int error_code)
 {
-	struct libcufile_options *o = td->eo;
-
-	pthread_mutex_lock(&running_lock);
-	running--;
-	assert(running >= 0);
-	if (running == 0) {
-		/* only close the driver if initialized and
-		   this is the last worker thread */
-		if (o->cuda_io == IO_CUFILE && cufile_initialized)
-			cuFileDriverClose();
-		cufile_initialized = 0;
-	}
-	pthread_mutex_unlock(&running_lock);
+	return cufileop_status_error(error_code);
+}
+
+static int running = 0;
+static int initialized = 0;
+static pthread_mutex_t running_lock = PTHREAD_MUTEX_INITIALIZER;
+
+static const struct gpuaccel_backend libcufile_backend = {
+	.name = "cufile",
+	.sync_after_posix_write_copy = 0,
+	.sync_after_verify_read_copy = 0,
+	.sync_after_memset = 0,
+	.running = &running,
+	.initialized = &initialized,
+	.running_lock = &running_lock,
+	.driver_open = libcufile_driver_open,
+	.driver_close = libcufile_driver_close,
+	.set_device = libcufile_set_device,
+	.malloc = libcufile_malloc,
+	.free = libcufile_free,
+	.memset = libcufile_memset,
+	.memcpy = libcufile_memcpy,
+	.stream_sync = libcufile_stream_sync,
+	.file_handle_register = libcufile_file_handle_register,
+	.file_handle_deregister = libcufile_file_handle_deregister,
+	.buf_register = libcufile_buf_register,
+	.buf_deregister = libcufile_buf_deregister,
+	.read = libcufile_read,
+	.write = libcufile_write,
+	.op_error_string = libcufile_op_error_string
+};
+
+static int fio_libcufile_init(struct thread_data *td)
+{
+	struct gpuaccel_options *o = td->eo;
+	o->backend = &libcufile_backend;
+	return fio_gpuaccel_init(td);
 }
 
 FIO_STATIC struct ioengine_ops ioengine = {
 	.name                = "libcufile",
 	.version             = FIO_IOOPS_VERSION,
 	.init                = fio_libcufile_init,
-	.queue               = fio_libcufile_queue,
+	.queue               = fio_gpuaccel_queue,
 	.get_file_size       = generic_get_file_size,
-	.open_file           = fio_libcufile_open_file,
-	.close_file          = fio_libcufile_close_file,
-	.iomem_alloc         = fio_libcufile_iomem_alloc,
-	.iomem_free          = fio_libcufile_iomem_free,
-	.cleanup             = fio_libcufile_cleanup,
+	.open_file           = fio_gpuaccel_open_file,
+	.close_file          = fio_gpuaccel_close_file,
+	.iomem_alloc         = fio_gpuaccel_iomem_alloc,
+	.iomem_free          = fio_gpuaccel_iomem_free,
+	.cleanup             = fio_gpuaccel_cleanup,
 	.flags               = FIO_SYNCIO,
 	.options             = options,
-	.option_struct_size  = sizeof(struct libcufile_options)
+	.option_struct_size  = sizeof(struct gpuaccel_options)
 };
 
 void fio_init fio_libcufile_register(void)
diff --git a/engines/libhipfile.c b/engines/libhipfile.c
new file mode 100644
index 00000000..0b1ea2b5
--- /dev/null
+++ b/engines/libhipfile.c
@@ -0,0 +1,272 @@
+/* Copyright (c) Advanced Micro Devices, Inc. All rights reserved.
+ * mailto: hipfile-maintainer@amd.com
+ *
+ * License: GPLv2, see COPYING.
+ *
+ * libhipfile engine
+ *
+ * FIO gpuaccel engine implementation for AMD ROCm hipfile API.
+ */
+
+#include <stdlib.h>
+#include <unistd.h>
+#include <errno.h>
+#include <string.h>
+#include <hipfile.h>
+#include <hip/hip_runtime.h>
+
+#include "../fio.h"
+#include "../optgroup.h"
+#include "gpuaccel.h"
+
+struct libhipfile_file_data {
+	hipFileDescr_t hf_descr;
+	hipFileHandle_t hf_handle;
+};
+
+static struct fio_option options[] = {
+	{
+		.name	  = "gpu_dev_ids",
+		.lname	  = "libhipfile engine gpu dev ids",
+		.type	  = FIO_OPT_STR_STORE,
+		.off1	  = offsetof(struct gpuaccel_options, gpu_ids),
+		.help	  = "GPU IDs, one per subjob, separated by " GPU_ID_SEP,
+		.category = FIO_OPT_C_ENGINE,
+		.group	  = FIO_OPT_G_LIBHIPFILE,
+	},
+	{
+		.name	  = "rocm_io",
+		.lname	  = "libhipfile rocm io",
+		.type	  = FIO_OPT_STR,
+		.off1	  = offsetof(struct gpuaccel_options, io_mode),
+		.help	  = "Type of I/O to use with ROCm",
+		.def      = "hipfile",
+		.posval   = {
+			    { .ival = "hipfile",
+			      .oval = IO_DIRECT,
+			      .help = "libhipfile"
+			    },
+			    { .ival = "posix",
+			      .oval = IO_POSIX,
+			      .help = "POSIX I/O"
+			    }
+		},
+		.category = FIO_OPT_C_ENGINE,
+		.group	  = FIO_OPT_G_LIBHIPFILE,
+	},
+	{
+		.name	 = NULL,
+	},
+};
+
+static const char *fio_libhipfile_get_hip_error(hipFileError_t st)
+{
+	if (st.err > HIPFILE_BASE_ERR)
+		return hipFileGetOpErrorString(st.err);
+	return "unknown";
+}
+
+static int libhipfile_check_runtime(hipError_t res, const char *fn)
+{
+	if (res != hipSuccess) {
+		const char *str = hipGetErrorName(res);
+		log_err("hip runtime api call failed %s : err=%d:%s\n", fn, res, str);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int libhipfile_driver_open(void)
+{
+	hipFileError_t status = hipFileDriverOpen();
+
+	if (status.err != hipFileSuccess) {
+		log_err("hipFileDriverOpen: err=%d:%s\n", status.err,
+			fio_libhipfile_get_hip_error(status));
+		return -1;
+	}
+
+	return 0;
+}
+
+static void libhipfile_driver_close(void)
+{
+	hipFileDriverClose();
+}
+
+static int libhipfile_set_device(int gpu_id)
+{
+	return libhipfile_check_runtime(hipSetDevice(gpu_id), "hipSetDevice");
+}
+
+static int libhipfile_malloc(void **mem, size_t size)
+{
+	return libhipfile_check_runtime(hipMalloc(mem, size), "hipMalloc");
+}
+
+static int libhipfile_free(void *mem)
+{
+	return libhipfile_check_runtime(hipFree(mem), "hipFree");
+}
+
+static int libhipfile_memset(void *mem, int value, size_t size)
+{
+	return libhipfile_check_runtime(hipMemset(mem, value, size), "hipMemset");
+}
+
+static int libhipfile_memcpy(void *dst, const void *src, size_t size, int direction)
+{
+	enum hipMemcpyKind kind;
+
+	switch (direction) {
+	case MEMCPY_DIRECTION_H2D:
+		kind = hipMemcpyHostToDevice;
+		break;
+	case MEMCPY_DIRECTION_D2H:
+		kind = hipMemcpyDeviceToHost;
+		break;
+	default:
+		return -1;
+	}
+
+	return libhipfile_check_runtime(hipMemcpy(dst, src, size, kind), "hipMemcpy");
+}
+
+static int libhipfile_stream_sync(void)
+{
+	return libhipfile_check_runtime(hipStreamSynchronize(NULL),
+				       "hipStreamSynchronize");
+}
+
+static int libhipfile_file_handle_register(int fd, void **handle)
+{
+	struct libhipfile_file_data *fhd;
+	hipFileError_t status;
+
+	fhd = calloc(1, sizeof(*fhd));
+	if (!fhd)
+		return ENOMEM;
+
+	fhd->hf_descr.handle.fd = fd;
+	fhd->hf_descr.type = hipFileHandleTypeOpaqueFD;
+	status = hipFileHandleRegister(&fhd->hf_handle, &fhd->hf_descr);
+	if (status.err != hipFileSuccess) {
+		log_err("hipFileHandleRegister: err=%d:%s\n", status.err,
+			fio_libhipfile_get_hip_error(status));
+		free(fhd);
+		return EINVAL;
+	}
+
+	*handle = fhd;
+	return 0;
+}
+
+static void libhipfile_file_handle_deregister(void *handle)
+{
+	struct libhipfile_file_data *fhd = handle;
+
+	hipFileHandleDeregister(fhd->hf_handle);
+	free(fhd);
+}
+
+static int libhipfile_buf_register(void *mem, size_t size)
+{
+	hipFileError_t status = hipFileBufRegister(mem, size, 0);
+
+	if (status.err != hipFileSuccess) {
+		log_err("hipFileBufRegister: err=%d:%s\n", status.err,
+			fio_libhipfile_get_hip_error(status));
+		return -1;
+	}
+
+	return 0;
+}
+
+static void libhipfile_buf_deregister(void *mem)
+{
+	hipFileBufDeregister(mem);
+}
+
+static ssize_t libhipfile_read(void *handle, void *mem, size_t size,
+				      unsigned long long file_offset, size_t mem_offset)
+{
+	struct libhipfile_file_data *fhd = handle;
+
+	return hipFileRead(fhd->hf_handle, mem, size, file_offset, mem_offset);
+}
+
+static ssize_t libhipfile_write(void *handle, const void *mem, size_t size,
+				       unsigned long long file_offset, size_t mem_offset)
+{
+	struct libhipfile_file_data *fhd = handle;
+
+	return hipFileWrite(fhd->hf_handle, mem, size, file_offset, mem_offset);
+}
+
+static const char *libhipfile_op_error_string(int error_code)
+{
+	return hipFileGetOpErrorString(error_code);
+}
+
+static int running = 0;
+static int initialized = 0;
+static pthread_mutex_t running_lock = PTHREAD_MUTEX_INITIALIZER;
+
+static const struct gpuaccel_backend libhipfile_backend = {
+	.name = "hipfile",
+	.sync_after_posix_write_copy = 1,
+	.sync_after_verify_read_copy = 1,
+	.sync_after_memset = 1,
+	.running = &running,
+	.initialized = &initialized,
+	.running_lock = &running_lock,
+	.driver_open = libhipfile_driver_open,
+	.driver_close = libhipfile_driver_close,
+	.set_device = libhipfile_set_device,
+	.malloc = libhipfile_malloc,
+	.free = libhipfile_free,
+	.memset = libhipfile_memset,
+	.memcpy = libhipfile_memcpy,
+	.stream_sync = libhipfile_stream_sync,
+	.file_handle_register = libhipfile_file_handle_register,
+	.file_handle_deregister = libhipfile_file_handle_deregister,
+	.buf_register = libhipfile_buf_register,
+	.buf_deregister = libhipfile_buf_deregister,
+	.read = libhipfile_read,
+	.write = libhipfile_write,
+	.op_error_string = libhipfile_op_error_string,
+};
+
+static int fio_libhipfile_init(struct thread_data *td)
+{
+	struct gpuaccel_options *o = td->eo;
+	o->backend = &libhipfile_backend;
+	return fio_gpuaccel_init(td);
+}
+
+FIO_STATIC struct ioengine_ops ioengine = {
+	.name               = "libhipfile",
+	.version            = FIO_IOOPS_VERSION,
+	.init               = fio_libhipfile_init,
+	.queue              = fio_gpuaccel_queue,
+	.get_file_size      = generic_get_file_size,
+	.open_file          = fio_gpuaccel_open_file,
+	.close_file         = fio_gpuaccel_close_file,
+	.iomem_alloc        = fio_gpuaccel_iomem_alloc,
+	.iomem_free         = fio_gpuaccel_iomem_free,
+	.cleanup            = fio_gpuaccel_cleanup,
+	.flags              = FIO_SYNCIO,
+	.options            = options,
+	.option_struct_size = sizeof(struct gpuaccel_options),
+};
+
+void fio_init fio_libhipfile_register(void)
+{
+	register_ioengine(&ioengine);
+}
+
+void fio_exit fio_libhipfile_unregister(void)
+{
+	unregister_ioengine(&ioengine);
+}
diff --git a/example_latency_steadystate.fio b/examples/example_latency_steadystate.fio
similarity index 100%
rename from example_latency_steadystate.fio
rename to examples/example_latency_steadystate.fio
diff --git a/examples/libhipfile-hipfile.fio b/examples/libhipfile-hipfile.fio
new file mode 100644
index 00000000..e8807f6c
--- /dev/null
+++ b/examples/libhipfile-hipfile.fio
@@ -0,0 +1,44 @@
+# Example hipFile job, using hipFile I/O
+#
+# Required environment variables:
+#     GPU_DEV_IDS : refer to option 'gpu_dev_ids'
+#     FIO_DIR     : 'directory'. This job uses rocm_io=hipfile, so path(s) must
+#                   point to hipFile supported filesystem(s)
+#
+
+[global]
+ioengine=libhipfile
+directory=${FIO_DIR}
+gpu_dev_ids=${GPU_DEV_IDS}
+rocm_io=hipfile
+# 'direct' must be 1 when using rocm_io=hipfile
+direct=1
+# Performance is negatively affected if 'bs' is not a multiple of 4k.
+# Refer to ROCm hipFile documentation.
+bs=1m
+size=1m
+numjobs=16
+# hipMalloc fails if too many processes attach to the GPU, use threads.
+thread
+# group_reporting to merge all thread results
+group_reporting=1
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
diff --git a/examples/libhipfile-posix.fio b/examples/libhipfile-posix.fio
new file mode 100644
index 00000000..e34df979
--- /dev/null
+++ b/examples/libhipfile-posix.fio
@@ -0,0 +1,41 @@
+# Example hipFile job, using POSIX I/O
+#
+# Required environment variables:
+#     GPU_DEV_IDS : refer to option 'gpu_dev_ids'
+#     FIO_DIR     : 'directory'. rocm_io=posix, so the path(s) may point
+#                   to any POSIX filesystem(s)
+#
+
+[global]
+ioengine=libhipfile
+directory=${FIO_DIR}
+gpu_dev_ids=${GPU_DEV_IDS}
+rocm_io=posix
+# 'direct' may be 1 or 0 when using rocm_io=posix
+direct=0
+# there are no unusual requirements for 'bs' when rocm_io=posix
+bs=1m
+size=1G
+numjobs=16
+# hipMalloc fails if too many processes attach to the GPU, use threads
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
index fa281caa..993762f2 100644
--- a/fio.1
+++ b/fio.1
@@ -2163,6 +2163,15 @@ I/O without transferring buffers between user-space and the kernel,
 unless \fBverify\fR is set or \fBcuda_io\fR is \fBposix\fR. \fBiomem\fR must
 not be \fBcudamalloc\fR. This ioengine defines engine specific options.
 .TP
+.B libhipfile
+I/O engine supporting synchronous access to a GPUDirect Storage-supported
+filesystem from AMD GPUs via the ROCm hipFile API. This engine performs
+I/O without transferring buffers between user-space and the kernel,
+unless \fBverify\fR is set or \fBrocm_io\fR is \fBposix\fR. \fBiomem\fR must
+not be \fBcudamalloc\fR. This ioengine defines engine specific options.
+(See \fIhttps://rocm.docs.amd.com\fR for information on ROCm hipFile
+and how to install the ROCm stack.)
+.TP
 .B dfs
 I/O engine supporting asynchronous read and write operations to the DAOS File
 System (DFS) via libdfs.
@@ -2993,6 +3002,34 @@ the use of cudaMemcpy.
 .RE
 .RE
 .TP
+.BI (libhipfile)gpu_dev_ids\fR=\fPstr
+Specify the GPU IDs to use with ROCm. This is a colon-separated list of int.
+GPUs are assigned to workers roundrobin. Default is 0.
+.TP
+.BI (libhipfile)rocm_io\fR=\fPstr
+Specify the type of I/O to use with ROCm. This option
+takes the following values:
+.RS
+.RS
+.TP
+.B hipfile (default)
+Use the ROCm hipFile API. This option performs I/O directly
+between a GPUDirect Storage filesystem and GPU buffers,
+avoiding use of a bounce buffer. If \fBverify\fR is set,
+hipMemcpy is used to copy verification data between RAM and GPU(s).
+Verification data is copied from RAM to GPU before a write
+and from GPU to RAM after a read.
+\fBdirect\fR must be 1.
+.TP
+.BI posix
+Use POSIX to perform I/O with a RAM buffer, and use
+hipMemcpy to transfer data between RAM and the GPU(s).
+Data is copied from GPU to RAM before a write and copied
+from RAM to GPU after a read. \fBverify\fR does not affect
+the use of hipMemcpy.
+.RE
+.RE
+.TP
 .BI (dfs)pool
 Specify the label or UUID of the DAOS pool to connect to.
 .TP
diff --git a/optgroup.c b/optgroup.c
index f6acf88f..fdcce075 100644
--- a/optgroup.c
+++ b/optgroup.c
@@ -185,6 +185,10 @@ static const struct opt_group fio_opt_cat_groups[] = {
 		.name	= "NFS I/O engine", /* nfs */
 		.mask	= FIO_OPT_G_NFS,
 	},
+	{
+		.name	= "libhipfile I/O engine", /* libhipfile */
+		.mask	= FIO_OPT_G_LIBHIPFILE,
+	},
 	{
 		.name	= NULL,
 	},
diff --git a/optgroup.h b/optgroup.h
index eb5e6f35..72aeee97 100644
--- a/optgroup.h
+++ b/optgroup.h
@@ -73,6 +73,7 @@ enum opt_category_group {
 	__FIO_OPT_G_WINDOWSAIO,
 	__FIO_OPT_G_XNVME,
 	__FIO_OPT_G_LIBBLKIO,
+	__FIO_OPT_G_LIBHIPFILE,
 
 	FIO_OPT_G_RATE		= (1ULL << __FIO_OPT_G_RATE),
 	FIO_OPT_G_ZONE		= (1ULL << __FIO_OPT_G_ZONE),
@@ -120,6 +121,7 @@ enum opt_category_group {
 	FIO_OPT_G_WINDOWSAIO	= (1ULL << __FIO_OPT_G_WINDOWSAIO),
 	FIO_OPT_G_XNVME         = (1ULL << __FIO_OPT_G_XNVME),
 	FIO_OPT_G_LIBBLKIO	= (1ULL << __FIO_OPT_G_LIBBLKIO),
+	FIO_OPT_G_LIBHIPFILE	= (1ULL << __FIO_OPT_G_LIBHIPFILE),
 };
 
 extern const struct opt_group *opt_group_from_mask(uint64_t *mask);
