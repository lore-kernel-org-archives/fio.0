Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:55231 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbaCZMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 26 Mar 2014 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WSmV2-0003WN-Tv
	for fio@vger.kernel.org; Wed, 26 Mar 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140326120003.D1A77400C2@strynoevaenget.dk>
Date: Wed, 26 Mar 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 190b8f0c9c1c1a99ed26fd953f7af9023f9533ee:

  Pass -Wstrict-prototypes -Wold-style-definition, whitespace (2014-03-21 09:28:08 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 43cdea1d0d62fe57c0b1017c55b4700cd95f63b0:

  server: unlink sock file if interrupted early (2014-03-25 15:06:17 -0700)

----------------------------------------------------------------
Jens Axboe (3):
      server: correct comment typo on port being after ':'
      server: dump where we attempted to bind in case of failure
      server: unlink sock file if interrupted early

 server.c |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/server.c b/server.c
index 2f12162..d72835b 100644
--- a/server.c
+++ b/server.c
@@ -1267,6 +1267,8 @@ static int fio_init_server_ip(void)
 {
 	struct sockaddr *addr;
 	socklen_t socklen;
+	char buf[80];
+	const char *str;
 	int sk, opt;
 
 	if (use_ipv6)
@@ -1294,17 +1296,24 @@ static int fio_init_server_ip(void)
 #endif
 
 	if (use_ipv6) {
+		const void *src = &saddr_in6.sin6_addr;
+
 		addr = (struct sockaddr *) &saddr_in6;
 		socklen = sizeof(saddr_in6);
 		saddr_in6.sin6_family = AF_INET6;
+		str = inet_ntop(AF_INET6, src, buf, sizeof(buf));
 	} else {
+		const void *src = &saddr_in.sin_addr;
+
 		addr = (struct sockaddr *) &saddr_in;
 		socklen = sizeof(saddr_in);
 		saddr_in.sin_family = AF_INET;
+		str = inet_ntop(AF_INET, src, buf, sizeof(buf));
 	}
 
 	if (bind(sk, addr, socklen) < 0) {
 		log_err("fio: bind: %s\n", strerror(errno));
+		log_info("fio: failed with IPv%c %s\n", use_ipv6 ? '6' : '4', str);
 		close(sk);
 		return -1;
 	}
@@ -1330,7 +1339,6 @@ static int fio_init_server_sock(void)
 	memset(&addr, 0, sizeof(addr));
 	addr.sun_family = AF_UNIX;
 	strcpy(addr.sun_path, bind_sock);
-	unlink(bind_sock);
 
 	len = sizeof(addr.sun_family) + strlen(bind_sock) + 1;
 
@@ -1485,7 +1493,7 @@ int fio_server_parse_string(const char *str, char **ptr, int *is_sock,
 	}
 
 	/*
-	 * If no port seen yet, check if there's a last ':' at the end
+	 * If no port seen yet, check if there's a last ',' at the end
 	 */
 	if (!lport) {
 		portp = strchr(host, ',');
@@ -1558,6 +1566,22 @@ out:
 	return ret;
 }
 
+static void sig_int(int sig)
+{
+	if (bind_sock)
+		unlink(bind_sock);
+}
+
+static void set_sig_handlers(void)
+{
+	struct sigaction act;
+
+	memset(&act, 0, sizeof(act));
+	act.sa_handler = sig_int;
+	act.sa_flags = SA_RESTART;
+	sigaction(SIGINT, &act, NULL);
+}
+
 static int fio_server(void)
 {
 	int sk, ret;
@@ -1571,6 +1595,8 @@ static int fio_server(void)
 	if (sk < 0)
 		return -1;
 
+	set_sig_handlers();
+
 	ret = accept_loop(sk);
 
 	close(sk);
