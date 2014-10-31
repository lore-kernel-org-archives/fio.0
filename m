Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49371 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757934AbaJaMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 31 Oct 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XkAs9-0002C9-3g
	for fio@vger.kernel.org; Fri, 31 Oct 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141031120003.8A72F400A6@lyth.info>
Date: Fri, 31 Oct 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit a1f871c72971efe84cd42670d5df4c4dc56dbd3f:

  engines: rename option specific pad from 'td' to 'pad' (2014-10-29 08:30:07 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d904145c8b93f35e8a71d12d29a96a11f96f75e1:

  Merge branch 'master' of ssh://git.kernel.dk/data/git/fio (2014-10-30 17:16:32 -0600)

----------------------------------------------------------------

Jens Axboe (4):
      mmap: set 'fd' to -1
      configure: disable lex/yacc on Solaris
      Merge branch 'master' of ssh://git.kernel.dk/data/git/fio
      Merge branch 'master' of ssh://git.kernel.dk/data/git/fio

 configure |    3 ++-
 memory.c  |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index de0fc89..eefe28e 100755
--- a/configure
+++ b/configure
@@ -1356,6 +1356,7 @@ yacc="no"
 yacc_is_bison="no"
 lex="no"
 arith="no"
+if test "$targetos" != "SunOS" ; then
 LEX=$(which lex 2> /dev/null)
 if test -x "$LEX" ; then
   lex="yes"
@@ -1384,13 +1385,13 @@ int main(int argc, char **argv)
   return 0;
 }
 EOF
-
 if compile_prog "" "-ll" "lex"; then
   LIBS="-ll $LIBS"
 else
   arith="no"
 fi
 fi
+fi
 
 echo "lex/yacc for arithmetic       $arith"
 
diff --git a/memory.c b/memory.c
index 8c06d94..76da8a8 100644
--- a/memory.c
+++ b/memory.c
@@ -119,7 +119,7 @@ static int alloc_mem_mmap(struct thread_data *td, size_t total_mem)
 {
 	int flags = 0;
 
-	td->mmapfd = 1;
+	td->mmapfd = -1;
 
 	if (td->o.mem_type == MEM_MMAPHUGE) {
 		unsigned long mask = td->o.hugepage_size - 1;
@@ -176,7 +176,8 @@ static void free_mem_mmap(struct thread_data *td, size_t total_mem)
 						td->orig_buffer);
 	munmap(td->orig_buffer, td->orig_buffer_size);
 	if (td->o.mmapfile) {
-		close(td->mmapfd);
+		if (td->mmapfd != -1)
+			close(td->mmapfd);
 		unlink(td->o.mmapfile);
 		free(td->o.mmapfile);
 	}
