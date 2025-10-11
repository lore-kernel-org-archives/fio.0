Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1779E26CE37
	for <fio@vger.kernel.org>; Sat, 11 Oct 2025 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760184017; cv=none; b=XkWgiv1TBt9xIsqrm6Wz014rNbTOU3SctmvMIMc8/zb+ow41fwR+YxeINURvrDMgLOaUvg6jWtszhvTOPcPjrs0Cpa8Z9h6gxhn/z8oxroLDE0etDIKjJZLJDjwgCAJCqlf+bxTZr3I3Kr7v8e2Cgb33iIQPPvSwLy7QZXWwswY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760184017; c=relaxed/simple;
	bh=nS+5ft1RiNuGJ3CLZAe9bL54S6c5TnQSCwfZdKiVdMc=;
	h=Subject:From:To:Date:Message-Id; b=iUdG1Wpt5BKSjlkLqcWrZDM2SmSPJGrdbJi4TtQVLTDr7OY0ETxWlhJmKR+EdkC8D78OZ/1OY1qZAuTORsmwg27e+G5w1tCl2qo8cGBN+PO9yhhxwqE8GZk7HvpLshObrqcMn8+BbxKlpy9kSG+3AQkgXAl//Dzl5EkPpjfCo8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=fail smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=j5pNMsR4; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j5pNMsR4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Message-Id:Date:To:From:Subject:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=wRrVTO6mGcnNBGb97eimLOqLo8XyapKjrv0tvdi8lzg=; b=j5pNMsR4xXazOFhi2Y2qbuh/du
	XV0EUPrR5Ii/lZMQFipVflH4HwNV0dA2kKaZ4VZP4p3xHX2YliASiHgXDexi0LjvkaEdmIhAEgIQO
	e9JHy7emktc4jYvy55ojjuI/dVtgYy0oqROCN/gVaEVx6gcHZ4Gp1FTTfwYYyVyl/aXl1p97JRtaF
	26egARwgacdASeQZ9KJlQkr9CR+KGPRC4KmMdbc0zL/R5fIejXB3QlwSHVS9ATht6Eck3uwO1Uh/D
	dI03/GRQgycELVgDjJjE4H31wp8pFC6nVZTKoBx5vDmtQ0NrfsMEyNqvb7CvWWJ7RCziOxePl0ggR
	cHVmYJwA==;
Received: from [96.43.243.2] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v7YGZ-0000000CwUD-2zvx
	for fio@vger.kernel.org;
	Sat, 11 Oct 2025 12:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
	id 49FDB1BC014B; Sat, 11 Oct 2025 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
To: <fio@vger.kernel.org>
User-Agent: mail (GNU Mailutils 3.17)
Date: Sat, 11 Oct 2025 06:00:01 -0600
Message-Id: <20251011120001.49FDB1BC014B@kernel.dk>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>

The following changes since commit b9b306b542afb8a3059c2035fb2034a89e4660d1:

  stat: report zone reset count in json output format (2025-10-09 13:16:51 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ae3475defe994e855f912d4b8dadf69c479b9ca2:

  memory: fix typo in cuda < 13 cuCtxCreate() (2025-10-10 14:56:44 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'new-cuda-ctx-params' of https://github.com/maxime-peim/fio
      memory: fix typo in cuda < 13 cuCtxCreate()

Maxime Peim (1):
      memory: add cuda 13 support

 configure | 24 ++++++++++++++++++++++++
 memory.c  |  7 +++++++
 2 files changed, 31 insertions(+)

---

Diff of recent changes:

diff --git a/configure b/configure
index 3209e225..43e20ca9 100755
--- a/configure
+++ b/configure
@@ -180,6 +180,7 @@ libhdfs="no"
 devdax="no"
 pmem="no"
 cuda="no"
+cuda13="no"
 libcufile="no"
 disable_lex=""
 disable_pmem="no"
@@ -2810,6 +2811,26 @@ EOF
 fi
 print_config "libcufile" "$libcufile"
 
+##########################################
+# cuda 13 probe
+if test "$cuda" != "no" || test "$libcufile" != "no"; then
+cat > $TMPC << EOF
+#include <cuda.h>
+
+int main(int argc, char **argv)
+{
+  cuCtxCreate(NULL, NULL, 0, NULL);
+  return 0;
+}
+EOF
+  if compile_prog "" "-lcuda" "cuda13"; then
+    cuda13="yes"
+  else
+    cuda13="no"
+  fi
+  print_config "cuda>=13" "$cuda13"
+fi
+
 ##########################################
 # check for cc -march=native
 build_native="no"
@@ -3305,6 +3326,9 @@ fi
 if test "$libcufile" = "yes" ; then
   output_sym "CONFIG_LIBCUFILE"
 fi
+if test "$cuda13" = "yes" ; then
+  output_sym "CONFIG_CUDA13"
+fi
 if test "$dfs" = "yes" ; then
   output_sym "CONFIG_DFS"
 fi
diff --git a/memory.c b/memory.c
index 2fdca657..29d93930 100644
--- a/memory.c
+++ b/memory.c
@@ -215,6 +215,9 @@ static int alloc_mem_cudamalloc(struct thread_data *td, size_t total_mem)
 #ifdef CONFIG_CUDA
 	CUresult ret;
 	char name[128];
+#ifdef CONFIG_CUDA13
+	CUctxCreateParams ctx_params = {};
+#endif
 
 	ret = cuInit(0);
 	if (ret != CUDA_SUCCESS) {
@@ -250,7 +253,11 @@ static int alloc_mem_cudamalloc(struct thread_data *td, size_t total_mem)
 	dprint(FD_MEM, "dev_id = [%d], device name = [%s]\n", \
 	       td->gpu_dev_id, name);
 
+#ifdef CONFIG_CUDA13
+	ret = cuCtxCreate(&td->cu_ctx, &ctx_params, CU_CTX_MAP_HOST, td->cu_dev);
+#else
 	ret = cuCtxCreate(&td->cu_ctx, CU_CTX_MAP_HOST, td->cu_dev);
+#endif
 	if (ret != CUDA_SUCCESS) {
 		log_err("fio: failed to create cuda context: %d\n", ret);
 		return 1;
