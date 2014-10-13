Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:33493 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaJMMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 13 Oct 2014 08:00:07 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XdeIH-0005yN-Km
	for fio@vger.kernel.org; Mon, 13 Oct 2014 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141013120003.83A5C4017D@lyth.info>
Date: Mon, 13 Oct 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit aa7bc282868ab33ea59b28827041626ef6545c95:

  Makefile: don't install test binaries (2014-10-11 10:19:42 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 91c0e7c5de1b4413c5fab8f5746272d1aee10f78:

  Set genesis time when running only network clients (2014-10-12 13:11:35 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Set genesis time when running only network clients

 fio.c |    2 ++
 1 file changed, 2 insertions(+)

---

Diff of recent changes:

diff --git a/fio.c b/fio.c
index 7e6b06d..9adc29a 100644
--- a/fio.c
+++ b/fio.c
@@ -43,6 +43,8 @@ int main(int argc, char *argv[], char *envp[])
 	fio_time_init();
 
 	if (nr_clients) {
+		set_genesis_time();
+
 		if (fio_start_all_clients())
 			return 1;
 		return fio_handle_clients(&fio_client_ops);
