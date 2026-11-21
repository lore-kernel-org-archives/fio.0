Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=90.155.92.199
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795266015;
	b=X3JWslsdjF/93R3K3+a54oz4xirkHsoHj6iYTaJfpcQRmjYm6mcrp/VBfv3+3WIYI8fN
	 f/3D5Tce43Vw984w6bvpvjrtQ5hdLRjBxSl299rdNnTQvuF4dm4mO4o5YUzOINdujjPm4
	 C5Vm9CLwahJt/MBoYqXdf1yC/UBA3qmAJlS/lh/ZNWmMMX7XmTeSWhW4fQbAlKz+SCgb8
	 xJDjpx2AVLm0HCWnza+Ozn4JEG7/lhVWx1hODnxOm0krp06Q2oHQW3Ca5+TYMDdGOQUko
	 +nFYjgoaV0yAq1L6Qorn7mxjzZ5Fe9u/JKwUqc/UCS2LSrabZ5vIRhiW4dvE7x5EyDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795266015;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Subject:From:To:
	 User-Agent:Date:Message-Id;
	bh=oHLO1Ta54hDR/u43rt8O7dYRy8MnCNbI7hAygw5GjpQ=;
	b=iHvlj0014a6lF7G84PW4VrMcSyN4kfvPRsajsD4hZucSdweYBvBRCPhX0yAWK9THVjqD
	 8qzP7blrCdnpef0kzsBQTLYfRB1ieWctaEsQWiWIn7pQI1DjnS76BVpFFePYoU1YWImb6
	 65M40xqS86oNgZDeC0hOP5vQQ8w7aYWGY0Fj8wWG/za/AAf31cLyZTdC3hA03T0MwTZE/
	 Iw1a35JdZfPkWe8NBX9VDPQxqCpY0XVQ8sqkW2yAFnAPDGb6fA+kqszW5ahgMrnSZn6+t
	 K0+cXfc+tDkgP//Kz++WjjROicl86aEtJeqguHrmjeSKwm09pRgqJddPxV/6BD4AfNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=kernel.dk;
	spf=fail smtp.mailfrom=kernel.dk;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=lFCKHbzP;
	arc=none smtp.remote-ip=90.155.92.199
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06350606A332
	for <fio@vger.kernel.org>; Sat, 21 Nov 2026 13:00:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 06350606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=desiato.20200630 header.b=lFCKHbzP
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Message-Id:Date:To:From:Subject:Sender
	:Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=oHLO1Ta54hDR/u43rt8O7dYRy8MnCNbI7hAygw5GjpQ=; b=lFCKHbzP5cEqzn1iSkZswL2fqX
	jB9rm8ERR0F5gWXM9UNIj0oOzBeL028gCbECujAsD1uVXh45AwIGeun8vB/Xw248rM0yaSRpijxxs
	1JY0Q8OAaLelHmPgwj+oN0cjLmxsfVeLtniyFOqffqNIZOHBZg3cLA0a2eFIajB/xaZs7MX0H4/Yw
	k0I2XPC9VO+Lb1vN0UB5Tr7qGXRWKGKYJT68Vy8CZ1dwaGCObjlJ9piX+y7kz5r6n+g8y+rmzXJGj
	keiPnBqksc1LrlaDBFox9ec4Sl2g36f5poAJHkwdtOOdTpiOoDQbc0fjQfi0DpOpcTtMpuwY2jXu+
	RJIWD8uA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by desiato.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xUkhI-00000001dIx-40np
	for fio@vger.kernel.org;
	Sat, 21 Nov 2026 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 7A7681BC0153; Sat, 21 Nov 2026 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Sat, 21 Nov 2026 06:00:01 -0700
Message-Id: <20261121130001.7A7681BC0153@kernel.dk>
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Post: <mailto:fio@vger.kernel.org>
List-Help: <mailto:fio+help@vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
List-Owner: <mailto:fio+owner@vger.kernel.org>
Precedence: list

The following changes since commit af034f21a61a1e9eb3af281fafdfe93fbf783c36:

  lib/rand: start every seed bucket odd in __fill_random_buf() (2026-11-16 21:42:29 -0500)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b6d1c31bba8a17cb0f0fa3f1b8f5fa5bd20cb57c:

  engines/libcufile: fix clang -Wabsolute-value error (2026-11-20 13:58:44 -0500)

----------------------------------------------------------------
Jiahao Luo (1):
      engines/gpuaccel: enable peer access for configured GPUs

Vincent Fu (3):
      Merge branch 'libcufile-enable-peer-access' of https://github.com/FFizzZZ/fio
      ci: build libcufile ioengine
      engines/libcufile: fix clang -Wabsolute-value error

 HOWTO.rst             |  12 ++++++
 ci/actions-build.sh   |   1 +
 ci/actions-install.sh |   1 +
 engines/gpuaccel.c    | 114 ++++++++++++++++++++++++++++++++++++++++++++++++++
 engines/gpuaccel.h    |   2 +
 engines/libcufile.c   |  50 +++++++++++++++++++++-
 fio.1                 |  11 +++++
 7 files changed, 190 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index 6adea4d7..0421893a 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -3326,6 +3326,18 @@ with the caveat that when used on the command line, they must come after the
 	Specify the GPU IDs to use with CUDA. This is a colon-separated list of
 	int. GPUs are assigned to workers roundrobin. Default is 0.
 
+.. option:: gpu_peer_access=str : [libcufile]
+
+	Configure CUDA peer access in **cufile** mode. Default is **none**.
+	Set this option to **all** to enable access from each worker's assigned
+	GPU to every other GPU in :option:`gpu_dev_ids`, or specify directed
+	peer connections using ``source:peer,peer/source:peer``. For example,
+	``0:1,2/1:0/2:0`` enables access from GPU 0 to GPUs 1 and 2 and from
+	GPUs 1 and 2 to GPU 0. Each entry applies to workers assigned its source
+	GPU. Connections are unidirectional; include both directions when needed.
+	Unsupported connections and peer connection limits cause an initialization
+	error. Values other than **none** are invalid with ``cuda_io=posix``.
+
 .. option:: cuda_io=str : [libcufile]
 
 	Specify the type of I/O to use with CUDA. Default is **cufile**.
diff --git a/ci/actions-build.sh b/ci/actions-build.sh
index 2aecbe85..375b8a49 100755
--- a/ci/actions-build.sh
+++ b/ci/actions-build.sh
@@ -34,6 +34,7 @@ main() {
                 "x86_64")
                     configure_flags+=(
                         "--enable-cuda"
+                        "--enable-libcufile"
                     )
                     ;;
 	    esac
diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index bf2acbe9..fd215266 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -71,6 +71,7 @@ DPKGCFG
 	        # Only for Ubuntu
 		pkgs+=(
 		   nvidia-cuda-dev
+		   libcufile-dev
 		)
 	    fi
             ;;
diff --git a/engines/gpuaccel.c b/engines/gpuaccel.c
index dc8415c5..1b4a9dfb 100644
--- a/engines/gpuaccel.c
+++ b/engines/gpuaccel.c
@@ -11,6 +11,7 @@
 #include <stdlib.h>
 #include <unistd.h>
 #include <errno.h>
+#include <limits.h>
 #include <string.h>
 
 #include "../fio.h"
@@ -72,6 +73,111 @@ static int fio_gpuaccel_find_gpu_id(struct thread_data *td)
 	return gpu_id;
 }
 
+static int fio_gpuaccel_parse_peer_id(const char *text, int *id)
+{
+	char *endptr;
+	long value;
+
+	errno = 0;
+	value = strtol(text, &endptr, 10);
+	if (errno || endptr == text || *endptr != '\0' ||
+	    value < 0 || value > INT_MAX) {
+		log_err("invalid peer GPU ID: %s\n", text);
+		return -1;
+	}
+
+	*id = (int) value;
+	return 0;
+}
+
+static int fio_gpuaccel_enable_selected_peers(struct gpuaccel_options *o)
+{
+	const struct gpuaccel_backend *be = o->backend;
+	char *map, *entries, *entry;
+	int rc = 0;
+
+	entries = map = strdup(o->peer_access);
+	if (!map) {
+		log_err("strdup(gpu_peer_access): err=%d\n", errno);
+		return -1;
+	}
+
+	while ((entry = strsep(&entries, "/"))) {
+		char *peer_ids = strchr(entry, ':');
+		char *peer_id;
+		int gpu_id;
+
+		if (!peer_ids) {
+			log_err("invalid peer connection entry: %s\n", entry);
+			rc = -1;
+			break;
+		}
+		*peer_ids++ = '\0';
+		rc = fio_gpuaccel_parse_peer_id(entry, &gpu_id);
+		if (rc)
+			break;
+
+		while ((peer_id = strsep(&peer_ids, ","))) {
+			int id;
+
+			rc = fio_gpuaccel_parse_peer_id(peer_id, &id);
+			if (rc)
+				break;
+			if (gpu_id != o->my_gpu_id || id == gpu_id)
+				continue;
+
+			rc = be->enable_peer_access(gpu_id, id);
+			if (rc)
+				break;
+		}
+		if (rc)
+			break;
+	}
+
+	free(map);
+	return rc;
+}
+
+static int fio_gpuaccel_enable_peer_access(struct gpuaccel_options *o)
+{
+	const struct gpuaccel_backend *be = o->backend;
+	char *gpu_ids, *peer_ids, *peer_id;
+	int rc = 0;
+
+	if (!o->peer_access || !strcmp(o->peer_access, "none"))
+		return 0;
+	if (!be->enable_peer_access)
+		return 0;
+	if (strcmp(o->peer_access, "all"))
+		return fio_gpuaccel_enable_selected_peers(o);
+	if (!o->gpu_ids)
+		return 0;
+
+	peer_ids = gpu_ids = strdup(o->gpu_ids);
+	if (!gpu_ids) {
+		log_err("strdup(gpu_ids): err=%d\n", errno);
+		return -1;
+	}
+
+	while ((peer_id = strsep(&peer_ids, GPU_ID_SEP))) {
+		int id;
+
+		rc = fio_gpuaccel_parse_peer_id(peer_id, &id);
+		if (rc)
+			break;
+
+		if (id == o->my_gpu_id)
+			continue;
+
+		rc = be->enable_peer_access(o->my_gpu_id, id);
+		if (rc)
+			break;
+	}
+
+	free(gpu_ids);
+	return rc;
+}
+
 int fio_gpuaccel_init(struct thread_data *td)
 {
 	struct gpuaccel_options *o = td->eo;
@@ -93,6 +199,12 @@ int fio_gpuaccel_init(struct thread_data *td)
 	initialized = *be->initialized;
 	pthread_mutex_unlock(be->running_lock);
 
+	if (o->io_mode != IO_DIRECT && o->peer_access &&
+	    strcmp(o->peer_access, "none")) {
+		log_err("gpu_peer_access is only valid with cuda_io=cufile\n");
+		return 1;
+	}
+
 	if (o->io_mode == IO_DIRECT && !initialized)
 		return 1;
 
@@ -103,6 +215,8 @@ int fio_gpuaccel_init(struct thread_data *td)
 	dprint(FD_MEM, "Subjob %d uses GPU %d\n", td->subjob_number, o->my_gpu_id);
 	if (be->set_device(o->my_gpu_id) != 0)
 		return 1;
+	if (o->io_mode == IO_DIRECT && fio_gpuaccel_enable_peer_access(o))
+		return 1;
 
 	return 0;
 }
diff --git a/engines/gpuaccel.h b/engines/gpuaccel.h
index 4ef97827..0839d49c 100644
--- a/engines/gpuaccel.h
+++ b/engines/gpuaccel.h
@@ -36,6 +36,7 @@ struct gpuaccel_backend {
 	void (*driver_close)(void);
 
 	int (*set_device)(int gpu_id);
+	int (*enable_peer_access)(int gpu_id, int peer_gpu_id);
 	int (*malloc)(void **mem, size_t size);
 	int (*free)(void *mem);
 	int (*memset)(void *mem, int value, size_t size);
@@ -65,6 +66,7 @@ struct gpuaccel_options {
 					                           with posix I/O write */
 	int                 my_gpu_id;          /* GPU id to use for this job */
 	unsigned int        io_mode;            /* Type of I/O to use */
+	char               *peer_access;        /* none, all, or directed peer map */
 	size_t              total_mem;          /* size for gpu_mem_ptr and junk_buf */
 	int                 logged;             /* bitmask of log messages that have
 					                           been output, prevent flood */
diff --git a/engines/libcufile.c b/engines/libcufile.c
index c5a1de71..71a7f80e 100644
--- a/engines/libcufile.c
+++ b/engines/libcufile.c
@@ -62,6 +62,16 @@ static struct fio_option options[] = {
 		.category = FIO_OPT_C_ENGINE,
 		.group	  = FIO_OPT_G_LIBCUFILE,
 	},
+	{
+		.name	  = "gpu_peer_access",
+		.lname	  = "CUDA peer connections",
+		.type	  = FIO_OPT_STR_STORE,
+		.off1	  = offsetof(struct gpuaccel_options, peer_access),
+		.def	  = "none",
+		.help	  = "Peer access: none, all, or source:peer,peer/source:peer",
+		.category = FIO_OPT_C_ENGINE,
+		.group	  = FIO_OPT_G_LIBCUFILE,
+	},
 	{
 		.name	 = NULL,
 	},
@@ -83,7 +93,8 @@ static struct fio_option options[] = {
 
 static const char *fio_libcufile_get_cuda_error(CUfileError_t st)
 {
-	if (IS_CUFILE_ERR(st.err))
+	/* cast the error to int to avoid a clang -Wabsolute-value warning */
+	if (IS_CUFILE_ERR((int) st.err))
 		return cufileop_status_error(st.err);
 	return "unknown";
 }
@@ -167,6 +178,42 @@ static int libcufile_stream_sync(void)
 	return rc;
 }
 
+static int libcufile_enable_peer_access(int gpu_id, int peer_gpu_id)
+{
+	cudaError_t status;
+	int can_access_peer, rc;
+
+	check_cudaruntimecall(cudaDeviceCanAccessPeer(&can_access_peer,
+						     gpu_id, peer_gpu_id), rc);
+	if (rc)
+		return rc;
+	if (!can_access_peer) {
+		log_err("GPU %d cannot access peer GPU %d\n", gpu_id,
+			peer_gpu_id);
+		return -1;
+	}
+
+	status = cudaDeviceEnablePeerAccess(peer_gpu_id, 0);
+	if (status == cudaErrorPeerAccessAlreadyEnabled) {
+		/* Clear the non-fatal CUDA runtime error. */
+		cudaGetLastError();
+		return 0;
+	}
+	if (status == cudaErrorTooManyPeers) {
+		log_err("GPU %d peer connection limit reached while enabling "
+			"GPU %d: %s\n", gpu_id, peer_gpu_id,
+			cudaGetErrorName(status));
+		return -1;
+	}
+	if (status != cudaSuccess) {
+		log_err("cudaDeviceEnablePeerAccess(%d): err=%d:%s\n",
+			peer_gpu_id, status, cudaGetErrorName(status));
+		return -1;
+	}
+
+	return 0;
+}
+
 static int libcufile_file_handle_register(int fd, void **handle)
 {
 	struct fio_libcufile_data *fcd;
@@ -249,6 +296,7 @@ static const struct gpuaccel_backend libcufile_backend = {
 	.driver_open = libcufile_driver_open,
 	.driver_close = libcufile_driver_close,
 	.set_device = libcufile_set_device,
+	.enable_peer_access = libcufile_enable_peer_access,
 	.malloc = libcufile_malloc,
 	.free = libcufile_free,
 	.memset = libcufile_memset,
diff --git a/fio.1 b/fio.1
index 6123b8d3..e7a89860 100644
--- a/fio.1
+++ b/fio.1
@@ -3047,6 +3047,17 @@ Example URIs:
 Specify the GPU IDs to use with CUDA. This is a colon-separated list of int.
 GPUs are assigned to workers roundrobin. Default is 0.
 .TP
+.BI (libcufile)gpu_peer_access\fR=\fPstr
+Configure CUDA peer access in \fBcufile\fR mode. Default is \fBnone\fR. Set
+this option to \fBall\fR to enable access from each worker's assigned GPU to
+every other GPU in \fBgpu_dev_ids\fR, or specify directed peer connections
+using \fIsource:peer,peer/source:peer\fR. For example,
+\fI0:1,2/1:0/2:0\fR enables access from GPU 0 to GPUs 1 and 2 and from GPUs 1
+and 2 to GPU 0. Each entry applies to workers assigned its source GPU.
+Connections are unidirectional; include both directions when needed.
+Unsupported connections and peer connection limits cause an initialization
+error. Values other than \fBnone\fR are invalid with \fBcuda_io=posix\fR.
+.TP
 .BI (libcufile)cuda_io\fR=\fPstr
 Specify the type of I/O to use with CUDA. This option
 takes the following values:
