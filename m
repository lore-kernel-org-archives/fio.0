Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:42600 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbcDXMAH (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 24 Apr 2016 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
	id 1auIhn-0006QS-V9
	for fio@vger.kernel.org; Sun, 24 Apr 2016 12:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160424120001.AC9552C18E7@kernel.dk>
Date: Sun, 24 Apr 2016 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 250e878ab5f26b32facbb6e134f3738aa1aa0120:

  include sys/sysmacros.h for major/minor (2016-04-21 07:47:26 -0400)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 603e604eb6d9b3ba9f201a6bff0a18da1a6c0967:

  oslib/getopt_long: allow (unique) short match (2016-04-22 18:14:24 -0400)

----------------------------------------------------------------
Jens Axboe (1):
      oslib/getopt_long: allow (unique) short match

 oslib/getopt_long.c | 36 +++++++++++++++++++++++++++++++-----
 1 file changed, 31 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/oslib/getopt_long.c b/oslib/getopt_long.c
index 11d879a..8ec7741 100644
--- a/oslib/getopt_long.c
+++ b/oslib/getopt_long.c
@@ -26,14 +26,14 @@ static struct getopt_private_state {
 } pvt;
 
 static inline const char *option_matches(const char *arg_str,
-					 const char *opt_name)
+					 const char *opt_name, int smatch)
 {
 	while (*arg_str != '\0' && *arg_str != '=') {
 		if (*arg_str++ != *opt_name++)
 			return NULL;
 	}
 
-	if (*opt_name)
+	if (*opt_name && !smatch)
 		return NULL;
 
 	return arg_str;
@@ -84,11 +84,37 @@ int getopt_long_only(int argc, char *const *argv, const char *optstring,
 		}
 
 		for (lo = longopts; lo->name; lo++) {
-			if ((opt_end = option_matches(carg+2, lo->name)))
+			opt_end = option_matches(carg+2, lo->name, 0);
+			if (opt_end)
 			    break;
 		}
-		if (!opt_end)
-			return '?';
+		/*
+		 * The GNU getopt_long_only() apparently allows a short match,
+		 * if it's unique and if we don't have a full match. Let's
+		 * do the same here, search and see if there is one (and only
+		 * one) short match.
+		 */
+		if (!opt_end) {
+			const struct option *lo_match = NULL;
+
+			for (lo = longopts; lo->name; lo++) {
+				const char *ret;
+
+				ret = option_matches(carg+2, lo->name, 1);
+				if (!ret)
+					continue;
+				if (!opt_end) {
+					opt_end = ret;
+					lo_match = lo;
+				} else {
+					opt_end = NULL;
+					break;
+				}
+			}
+			if (!opt_end)
+				return '?';
+			lo = lo_match;
+		}
 
 		if (longindex)
 			*longindex = lo-longopts;
